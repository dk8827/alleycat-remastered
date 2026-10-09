import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { PortableSession } from "../engine/portable-session.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
const dir = new URL("./routes/", import.meta.url);
// These routes are discovered by branch search and independently replayed here.
// Campaign routes begin at original startup. Four explicitly labeled practice
// routes begin at the public room fixture, then use only decoded controls.
// After initialization no position, objective, timer, RNG or outcome is patched.
for (const file of fs.readdirSync(dir).filter((f) => f.endsWith(".json"))) {
  test(`live controls route: ${file}`, () => {
    const r = JSON.parse(fs.readFileSync(new URL(file, dir)));
    const s = new PortableSession(exe, pages, boundaries, {
      cycles: r.cycles,
      difficulty: r.difficulty,
      practice: r.practice ?? null,
    });
    const route = [...r.route];
    if (r.tailCycles)
      route.push({ keys: route.at(-1).keys, cycles: r.tailCycles });
    for (const a of route) {
      assert.ok(a.keys.every((k) => Number.isInteger(k) && k >= 0 && k <= 8));
      assert.ok(Number.isInteger(a.cycles) && a.cycles > 0);
      const c = s.cpu;
      c.keys(a.keys);
      const target = c.elapsedCycles + a.cycles;
      c.runUntil((c) => c.elapsedCycles >= target, 20000000);
      assert.equal(s.ended, false);
      s.sound.advance(c.seconds);
      s.sound.take();
    }
    const frame = s.capture();
    for (const key of ["scene", "x", "y", "lives", "score"])
      if (key in r.final)
        assert.equal(frame[key], r.final[key], `${file}: ${key}`);
    if (file === "courtship-win.json") {
      assert.equal(frame.difficulty, 1, "courtship advances the difficulty");
      assert.equal(
        s.cpu.m16(0x10514),
        0,
        "courtship resets the completed-room count",
      );
      assert.equal(frame.lives, 4);
      assert.equal(frame.score, "0014444");
    }
  });
}
