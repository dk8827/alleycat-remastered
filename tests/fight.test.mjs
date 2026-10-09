import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { PortableSession } from "../engine/portable-session.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
const sources = [0x12f8, 0x1280, 0x1370];
const pixel = (c, p, x, y, stride) =>
  (c.m8(p + y * stride + (x >> 2)) >> (6 - 2 * (x & 3))) & 3;

test("natural captures use the original four phases, exact CGA footprint and both exit edges at both speeds", () => {
  const phases = new Set(),
    clips = new Set(),
    rooms = new Set();
  let draws = 0;
  for (const [cycles, practice, walk] of [
    [1500, null, false],
    [3000, null, false],
    [1500, 4, false],
    [3000, 4, false],
    [1500, 5, false],
    [3000, 3, false],
    [1500, 1, false],
    [1500, 6, true],
    [3000, 6, false],
  ]) {
    const s = new PortableSession(exe, pages, boundaries, { cycles, practice });
    const old = s.cpu.observe;
    let local = 0;
    s.cpu.observe = (ip, c) => {
      old(ip, c);
      if (ip !== 0x20e0) return; // raw fight blit has finished; read actual video RAM
      const o = s.presentation.enemyDraw;
      assert.equal(o?.kind, "fight");
      rooms.add(o.scene);
      const [x, y, w, h] = o.rect,
        offset = x === 0 ? 32 - w : 0;
      assert.equal(o.source, sources[o.pose]);
      assert.equal(o.pose, [0, 1, 2, 1][o.phase]);
      phases.add(o.phase);
      if (w < 32) clips.add(`${x === 0 ? "left" : "right"}:${w}`);
      for (let yy = 0; yy < h; yy++)
        for (let xx = 0; xx < w; xx++) {
          const expected = pixel(
            c,
            0x10100 + sources[o.pose],
            xx + offset,
            yy,
            8,
          );
          const actual =
            (c.m8(
              0xb8000 +
                ((y + yy) & 1) * 8192 +
                ((y + yy) >> 1) * 80 +
                ((x + xx) >> 2),
            ) >>
              (6 - 2 * ((x + xx) & 3))) &
            3;
          assert.equal(
            actual,
            expected,
            `original cloud ${o.phase} at ${x + xx},${y + yy}`,
          );
        }
      const state = s.presentation.state(
        c.mem.subarray(0x10100, 0x20100),
        c.mem.subarray(0xb8000, 0xbc000),
        c.tick,
        c.ip,
      );
      assert.equal(state.objects.filter((o) => o.kind === "fight").length, 1);
      assert.equal(state.objects.filter((o) => o.kind === "dog").length, 0);
      draws++;
      local++;
    };
    for (let i = 0; i < 4500 && s.frame.lives === 3; i++) {
      // Parlor: briefly walk right off the chair, then let the actual dog catch us.
      s.cpu.keys(
        practice === 1
          ? i < 70
            ? [2]
            : []
          : walk && i < 200
            ? [4]
            : walk && practice === 6
              ? [0]
              : [],
      );
      s.advance();
    }
    assert.ok(local > 8, `capture in scene ${practice ?? 0}, ${cycles} cycles`);
    assert.equal(s.frame.lives, 2);
    if (practice === null) {
      assert.equal(
        s.frame.objects.some((o) => o.kind === "fight"),
        false,
        "cloud erased after life loss",
      );
    }
  }
  assert.equal(phases.size, 4);
  assert.deepEqual([...rooms].sort(), [0, 1, 3, 4, 5, 6]);
  assert.deepEqual([...clips].sort(), [
    "left:16",
    "left:24",
    "left:8",
    "right:16",
    "right:24",
    "right:8",
  ]);
  console.log(
    `Compared ${draws} completed fight draws directly against original sprite pixels`,
  );
});

test("save/restore during the fight reproduces every subsequent frame and sound sample", () => {
  const s = new PortableSession(exe, pages, boundaries);
  for (
    let i = 0;
    i < 2000 && !s.frame.objects.some((o) => o.kind === "fight");
    i++
  )
    s.advance();
  assert.ok(s.frame.objects.some((o) => o.kind === "fight"));
  const saved = s.save(),
    results = [];
  for (let i = 0; i < 300; i++) results.push(s.advance());
  s.load(saved);
  for (let i = 0; i < results.length; i++)
    assert.deepEqual(s.advance(), results[i]);
  assert.equal(
    s.frame.objects.some((o) => o.kind === "fight"),
    false,
  );
});
