import { readFixture } from "./helpers/fixtures.mjs";
import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { createHash } from "node:crypto";
import { CPU } from "../engine/cpu.js";
import { geometry } from "../engine/presentation.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url)),
  read = readFixture;
const hash = (b) => createHash("sha256").update(b).digest("hex");
test("all-room geometry matches 64 independent Python fixtures", () => {
  for (const f of read("geometry-fixtures.json"))
    assert.deepEqual(
      geometry(Buffer.from(f.data, "base64"), f.scene),
      f.objects,
    );
});
test("static translation matches original CPU at 165 controlled-clock checkpoints", () => {
  const c = new CPU(exe, pages, boundaries),
    expected = read("translation-oracle.json");
  let i = 0;
  const check = () => {
    assert.deepEqual(
      {
        blocks: c.blocks,
        ip: c.ip,
        tick: c.tick,
        r: [...c.r],
        data: hash(c.mem.subarray(0x10100, 0x17230)),
        cga: hash(c.mem.subarray(0xb8000, 0xbc000)),
      },
      (({ raw, ...rest }) => rest)(expected[i]),
      `checkpoint ${i}`,
    );
    i++;
  };
  for (const [ip, keys] of [
    [0x5d71, [11]],
    [0x5ef7, [11]],
    [0x5f29, [12]],
    [0x5faa, [2]],
    [0x15f, []],
  ]) {
    c.runUntil((x) => x.ip === ip);
    check();
    c.keys(keys, true);
  }
  for (let n = 0; n < 160; n++) {
    if ([10, 50, 70, 100, 120].includes(n))
      c.keys({ 10: [0], 50: [0, 2], 70: [1, 2], 100: [], 120: [0, 2] }[n]);
    c.frame();
    check();
  }
});
test("portable save/load deterministically replays state and graphics", () => {
  const c = new CPU(exe, pages, boundaries);
  c.start();
  for (let i = 0; i < 30; i++) c.frame();
  const s = c.save();
  for (let i = 0; i < 80; i++) {
    c.keys(i % 20 < 10 ? [0, 2] : [1]);
    c.frame();
  }
  const end = c.save();
  c.load(s);
  for (let i = 0; i < 80; i++) {
    c.keys(i % 20 < 10 ? [0, 2] : [1]);
    c.frame();
  }
  assert.deepEqual(c.save(), end);
});

test("portable translation matches 640 original-CPU checkpoints across all eight rooms", () => {
  for (const room of read("room-oracles.json")) {
    const c = new CPU(exe, pages, boundaries);
    c.load({ ...room.initial, mem: Buffer.from(room.initial.mem, "base64") });
    for (let n = 0; n < room.checks.length; n++) {
      if ([0, 20, 40, 60].includes(n))
        c.keys({ 0: [2], 20: [1, 2], 40: [0], 60: [4, 1] }[n], true);
      c.frame();
      const got = {
        blocks: c.blocks,
        ip: c.ip,
        tick: c.tick,
        r: [...c.r],
        data: hash(c.mem.subarray(0x10100, 0x17230)),
        cga: hash(c.mem.subarray(0xb8000, 0xbc000)),
      };
      assert.deepEqual(
        got,
        room.checks[n],
        `room ${room.scene}, checkpoint ${n}`,
      );
    }
  }
});
