import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { PortableSession } from "../engine/portable-session.js";
import { Presentation } from "../engine/presentation.js";
import { playerArtwork } from "../renderer/renderer.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
test("input-only jump and clothesline catch choose rear artwork from actual original draw calls", () => {
  const route = JSON.parse(
      fs.readFileSync(
        new URL("./routes/clothesline-hold.json", import.meta.url),
      ),
    ),
    s = new PortableSession(exe, pages, boundaries);
  const seen = new Set();
  const old = s.cpu.observe;
  s.cpu.observe = (ip, c) => {
    old(ip, c);
    if (ip !== 0x1165) return;
    const pd = s.presentation.player,
      source = pd?.fullSource ?? pd?.sprite;
    if (![0xa2e, 0x9da, 0xa7c].includes(source)) return;
    const f = s.presentation.state(
      c.mem.subarray(0x10100, 0x20100),
      c.mem.subarray(0xb8000, 0xbc000),
      c.tick,
      c.ip,
    );
    assert.equal(f.playerSource, source);
    assert.deepEqual(playerArtwork(f), [
      "cat-vertical-v1",
      source === 0xa2e ? 0 : source === 0x9da ? 1 : 2,
      false,
    ]);
    seen.add(source);
  };
  for (const a of route.route) {
    s.cpu.keys(a.keys);
    const target = s.cpu.elapsedCycles + a.cycles;
    s.cpu.runUntil((c) => c.elapsedCycles >= target, 20000000);
  }
  assert.ok(seen.has(0xa2e));
  assert.ok(seen.has(0x9da));
  assert.equal(s.capture().playerSource, 0x9da);
  const saved = s.save();
  for (let i = 0; i < 20; i++) s.advance();
  s.load(saved);
  assert.equal(s.frame.playerSource, 0x9da);
  assert.deepEqual(playerArtwork(s.frame), ["cat-vertical-v1", 1, false]);
});
test("top clipping retains the full sprite identity instead of interpreting a source-row offset as a different pose", () => {
  const s = new PortableSession(exe, pages, boundaries),
    data = s.cpu.mem.slice(0x10100, 0x20100),
    p = new Presentation();
  const word = (a, v) => {
    data[a] = v & 255;
    data[a + 1] = v >> 8;
  };
  word(0x569, 0xa2e);
  word(0x567, 0xd03);
  data[0x57c] = 45;
  const r = new Uint16Array(12);
  r[6] = 0xa2e + 5 * 6;
  r[7] = 8;
  r[1] = 0x803;
  p.observe(0x1162, data, r);
  const f = p.state(data, s.cpu.mem.subarray(0xb8000, 0xbc000), 100, 0x1165);
  assert.equal(p.player.sprite, 0xa2e + 30);
  assert.equal(f.playerSource, 0xa2e);
  assert.equal(f.playerFullInkRect[1], -5);
  assert.deepEqual(playerArtwork(f), ["cat-vertical-v1", 0, false]);
});
test("drawn source outranks changing velocities, with side-view diagonals and separate swimming/eating", () => {
  const base = {
    scene: 0,
    playerIdle: false,
    hd: 255,
    vd: 255,
    walkFrame: 0,
    y: 80,
  };
  for (const hd of [0, 1, 255])
    for (const vd of [0, 1, 255]) {
      assert.deepEqual(
        playerArtwork({ ...base, hd, vd, playerSource: 0x9da }),
        ["cat-vertical-v1", 1, false],
      );
      assert.deepEqual(
        playerArtwork({ ...base, hd, vd, playerSource: 0xa2e }),
        ["cat-vertical-v1", 0, false],
      );
    }
  assert.deepEqual(playerArtwork({ ...base, playerSource: 0xb12 }), [
    "cat",
    5,
    true,
  ]);
  assert.deepEqual(playerArtwork({ ...base, playerSource: 0xaca }), [
    "cat",
    5,
    false,
  ]);
  assert.deepEqual(playerArtwork({ ...base, playerSource: 0xa7c }), [
    "cat-vertical-v1",
    2,
    false,
  ]);
  assert.equal(
    playerArtwork({ ...base, playerIdle: true, playerSource: 0x9da })[0],
    "cat",
  );
  assert.equal(
    playerArtwork({ ...base, scene: 2, playerSource: 0xa2e })[0],
    "swim-cat",
  );
  assert.equal(
    playerArtwork({
      ...base,
      playerEating: true,
      playerSource: 0x9da,
      eatFrame: 1,
      eatFlip: false,
    })[0],
    "eating-contact-v3",
  );
});
