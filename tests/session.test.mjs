import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { PortableSession, KEY_INDICES } from "../engine/portable-session.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
const make = (o) => new PortableSession(exe, pages, boundaries, o);
test("all rooms, four menu difficulties and both live clock profiles run through the same engine as the browser", () => {
  let count = 0;
  for (const cycles of [1500, 3000])
    for (let difficulty = 0; difficulty < 4; difficulty++)
      for (let practice = 0; practice < 8; practice++) {
        const s = make({ cycles, difficulty, practice });
        assert.equal(s.frame.scene, practice);
        assert.equal(s.frame.difficulty, difficulty);
        if (practice !== 0)
          assert.equal(
            s.cpu.m8(0x10658),
            0,
            "practice must finish alley entrance",
          );
        const start = s.cpu.seconds;
        for (let i = 0; i < 100; i++) {
          s.cpu.keys(i < 30 ? [1, 2] : i < 60 ? [0] : [4]);
          const { frame, pcm } = s.advance();
          assert.ok(frame.scene >= 0 && frame.scene <= 7);
          assert.equal(Buffer.from(frame.cga, "base64").length, 16384);
          assert.ok(pcm.every(Number.isFinite));
        }
        assert.ok(s.cpu.seconds > start + 0.99);
        count++;
      }
  console.log(`Passed ${count} live room/difficulty/speed sessions`);
});
test("session save/restore reproduces presentation and sound while jumping", () => {
  const s = make({ practice: 4 });
  s.cpu.keys([1, 2]);
  for (let i = 0; i < 20; i++) s.advance();
  const saved = s.save(),
    frames = [];
  for (let i = 0; i < 30; i++) frames.push(s.advance());
  s.load(saved);
  for (let i = 0; i < 30; i++) assert.deepEqual(s.advance(), frames[i]);
});
test("actual outcome transitions finish, update lives, and never leave the comparison frozen", () => {
  for (const failed of [false, true])
    for (let scene = 2; scene < 8; scene++) {
      const s = make({ practice: scene });
      // Explicit transition fixture. Objective collision contracts are verified
      // separately against original CPU execution, not faked by this test.
      // Courtship exits through 0551, not the lethal-room failure flag 0552.
      // Its unsuccessful exit deliberately preserves the life count.
      s.cpu.w8(0x10652, failed && scene !== 7 ? 1 : 0);
      s.cpu.w8(0x10651, failed && scene === 7 ? 1 : 0);
      s.cpu.w8(0x10653, failed ? 0 : 1);
      const before = s.frame;
      let interludes = 0,
        changed = 0,
        last = s.frame.cga;
      for (let i = 0; i < 3000; i++) {
        const { frame } = s.advance();
        if (frame.originalInterlude) interludes++;
        if (frame.cga !== last) {
          changed++;
          last = frame.cga;
        }
        if (frame.scene === 0 && !frame.originalInterlude) break;
      }
      assert.equal(s.frame.scene, 0, `scene ${scene}, failed ${failed}`);
      assert.ok(changed > 2, "CGA must show the transition");
      assert.ok(interludes > 0, "long interludes must stay visible");
      assert.equal(
        s.frame.lives,
        failed ? (scene === 7 ? 3 : 2) : scene === 7 ? 4 : 3,
      );
      if (!failed) assert.notEqual(s.frame.score, before.score);
    }
});
test("diagonal and action controls map to the original decoded keyboard table", () => {
  const s = make();
  for (const [key, x, y] of [
    ["PageUp", 1, 255],
    ["PageDown", 1, 1],
    ["End", 255, 1],
    ["Home", 255, 255],
  ]) {
    const c = s.cpu;
    c.keys([KEY_INDICES[key]]);
    c.ip = 0x12c1;
    c.push(0xff00);
    c.runUntil((c) => c.ip === 0xff00);
    assert.equal(c.m8(0x10798), x);
    assert.equal(c.m8(0x10799), y);
  }
  assert.equal(KEY_INDICES.AltLeft, KEY_INDICES.Space);
});
test("an untouched campaign loses its lives naturally, reaches game over, and restores into playable execution", () => {
  const s = make(),
    saved = s.save(),
    seen = new Set([s.frame.lives]);
  for (let i = 0; i < 12000 && !s.ended; i++) {
    s.advance();
    seen.add(s.frame.lives);
  }
  assert.ok(s.ended, "idle campaign must reach the original game-over menu");
  assert.equal(s.frame.lives, 0);
  assert.deepEqual([...seen], [3, 2, 1, 0]);
  assert.deepEqual(
    s.frame.laundry,
    [],
    "return to title must not retain gameplay clotheslines",
  );
  assert.equal(s.frame.objects.filter((o) => o.kind === "bin").length, 5);
  assert.ok(s.frame.cinematic.publisherSource);
  s.load(saved);
  assert.equal(s.ended, false);
  assert.equal(s.frame.lives, 3);
  s.cpu.keys([1, 2]);
  for (let i = 0; i < 100; i++) s.advance();
  assert.ok(
    s.cpu.seconds >
      saved.machine.elapsedCycles / saved.machine.cyclesPerSecond + 0.99,
  );
  assert.equal(s.ended, false);
});
