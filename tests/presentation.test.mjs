import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { PortableSession } from "../engine/portable-session.js";
import { Cinematics } from "../engine/cinematics.js";
import { ink } from "../engine/presentation.js";
import { windowPatches, chairPatches } from "../renderer/registration.js";
import { playerArtwork } from "../renderer/renderer.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
const make = (o) => new PortableSession(exe, pages, boundaries, o);
const pixel = (c, x, y) =>
  (c.m8(0xb8000 + (y & 1) * 8192 + (y >> 1) * 80 + (x >> 2)) >>
    (6 - 2 * (x & 3))) &
  3;

test("spreading reward hearts retain their original un-erased stamps across all three sizes", () => {
  const s = make({ practice: 7, difficulty: 1 }),
    c = s.cpu,
    old = c.observe;
  c.w8(0x10653, 1);
  c.w8(0x10651, 0);
  const sources = new Set();
  let stages = 0,
    largest = 0;
  c.observe = (ip, c) => {
    if (ip === 0x519b) stages++;
    old(ip, c);
    if (ip === 0x5202) sources.add(c.r[6]);
  };
  let retained = [];
  for (let i = 0; i < 3500; i++) {
    s.advance();
    const e = s.frame.cinematic;
    if (e?.kind === "hearts") {
      const now = new Set(e.particles.map((r) => r.join()));
      assert.ok(
        retained.every((r) => now.has(r)),
        "previous stamps must survive later positions and size stages",
      );
      retained = [...now];
      largest = Math.max(largest, retained.length);
      const restored = new Cinematics();
      restored.load(s.cinematics.save());
      assert.deepEqual(
        restored.frame().particles,
        s.cinematics.frame().particles,
      );
    }
    if (e?.kind === "wipe" && sources.size === 3) break;
  }
  assert.deepEqual([...sources], [0x4aea, 0x4b0a, 0x4b8a]);
  assert.equal(stages, 3);
  assert.ok(largest > 80, `expected original trails, got ${largest} stamps`);
});

test("interior curtain rail respects six blank original rows and the exact 32x16 opening", () => {
  const s = make({ practice: 1 }),
    c = s.cpu;
  // Original bitmap evidence, independent of the HD registration constants.
  for (let y = 80; y < 86; y++)
    for (let x = 128; x < 192; x++) assert.equal(pixel(c, x, y), 2);
  for (let y = 88; y < 104; y++)
    for (let x = 144; x < 176; x++) assert.equal(pixel(c, x, y), 0);
  const patches = windowPatches([128, 80, 64, 32]);
  assert.equal(Math.min(...patches.map((p) => p.world[1])), 86);
  assert.deepEqual(patches.at(-1).world, [144, 88, 32, 16]);
  const right = chairPatches([136, 128, 32, 52], true);
  assert.equal(
    right[0].world[2],
    24,
    "right chair back is 24 pixels; left back is 20",
  );
});

test("wipe coverage follows every completed original scanline, including partial next rectangles", () => {
  for (const [x, y] of [
    [152, 95],
    [300, 170],
    [0, 0],
  ]) {
    const s = make({ practice: 1 }),
      c = s.cpu,
      v = new Cinematics();
    c.mem.fill(0xaa, 0xb8000, 0xbc000);
    c.w16(0x10679, x);
    c.w8(0x1067b, y);
    c.w16(0x11939, 0);
    c.r[8] = 0xb800;
    c.f &= ~1024;
    c.ip = 0x1c67;
    c.push(0xff00);
    v.observe(0x1c1e, c, null);
    let rows = 0,
      checks = 0;
    const compare = () => {
      const spans = v.frame().spans;
      for (let yy = 0; yy < 200; yy++)
        for (let xx = 0; xx < 320; xx++) {
          const covered = spans.some(
            ([a, b, w, h]) => xx >= a && xx < a + w && yy >= b && yy < b + h,
          );
          assert.equal(
            pixel(c, xx, yy),
            covered ? 0 : 2,
            `wipe at ${xx},${yy} after ${rows} rows`,
          );
        }
      checks++;
    };
    c.observe = (ip, c) => {
      if (ip === 0x1caf) {
        v.observe(ip, c, null);
        rows++;
        if ([10, 50, 200, 700].includes(rows)) compare();
      }
      if (ip === 0x1cce) v.observe(ip, c, null);
    };
    c.runUntil((c) => c.ip === 0xff00, 2000000);
    compare();
    assert.ok(checks >= 4);
    assert.deepEqual(v.frame().spans, [[0, 0, 320, 200]]);
    const restored = new Cinematics();
    restored.load(v.save());
    assert.deepEqual(restored.frame(), v.frame());
  }
});

test("idle head and tail are retained as independent original draw sources and exact ink", () => {
  const s = make({ practice: 1 }),
    c = s.cpu,
    seen = new Set(),
    old = c.observe;
  c.observe = (ip, c) => {
    old(ip, c);
    if (ip !== 0x10d7) return;
    const state = s.presentation.state(
        c.mem.subarray(0x10100, 0x20100),
        c.mem.subarray(0xb8000, 0xbc000),
        c.tick,
        c.ip,
      ),
      parts = state.playerIdleParts;
    assert.equal(parts.length, 2);
    assert.equal(parts[0].head, true);
    assert.equal(parts[1].head, false);
    for (const p of parts)
      assert.deepEqual(
        p.inkRect,
        ink(c.mem.subarray(0x10100, 0x20100), p.source, p.rect, 3),
      );
    assert.equal(parts[1].rect[1], parts[0].rect[1] + 6);
    seen.add(parts.map((p) => p.source).join(":"));
  };
  for (let i = 0; i < 1800; i++) s.advance();
  assert.ok(
    seen.size >= 3,
    "natural idle uses independent head/tail combinations",
  );
  const restored = make({ practice: 1 });
  restored.load(s.save());
  assert.deepEqual(restored.frame.playerIdleParts, s.frame.playerIdleParts);
});

test("walking and chasing sprites keep their drawn phase when animation counters change", () => {
  const sources = [
    0xbd2, 0xc14, 0xc98, 0xc56, 0xcda, 0xd1c, 0xd5e, 0xda0, 0xe24, 0xde2, 0xe66,
    0xea8,
  ];
  for (const [i, source] of sources.entries())
    assert.deepEqual(
      playerArtwork({
        scene: 0,
        playerSource: source,
        hd: 0,
        vd: 1,
        walkFrame: 5,
      }),
      ["cat", [0, 1, 2, 3, 2, 1][i % 6], i >= 6],
    );
  const s = make({}),
    c = s.cpu,
    old = c.observe;
  let draws = 0;
  c.observe = (ip, c) => {
    old(ip, c);
    if (ip !== 0x20bd) return;
    const o = s.presentation.enemyDraw;
    if (!o) return;
    const source = [0x13e8, 0x1460, 0x14d8, 0x1550].indexOf(o.source);
    assert.ok(source >= 0);
    assert.equal(o.pose, source % 2);
    draws++;
  };
  for (let i = 0; i < 2200 && !s.ended; i++) s.advance();
  assert.ok(draws > 10);
});
