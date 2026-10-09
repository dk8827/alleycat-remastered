import { readFixture } from "./helpers/fixtures.mjs";
import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { inflateSync } from "node:zlib";
import { createHash } from "node:crypto";
import { CPU } from "../engine/cpu.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
const hash = (b) => createHash("sha256").update(b).digest("hex");
test("portable instructions match original objective, collision, progression and restart contracts", () => {
  const fixtures = readFixture("contracts-oracle.json");
  let index = 0;
  for (const f of fixtures.records) {
    const memory = inflateSync(Buffer.from(fixtures.memory, "base64"));
    for (const [offset, bytes] of f.initial.patches)
      memory.set(Buffer.from(bytes, "base64"), offset);
    const c = new CPU(exe, pages, new Set());
    c.load({
      ...f.initial,
      mem: memory,
    });
    let event = 0;
    const take = (type, port) => {
      const e = f.events[event++];
      assert.equal(e?.[0], type, `fixture ${index}, event ${event}`);
      assert.equal(e[1], port, `fixture ${index}, event ${event}`);
      return e;
    };
    c.input = (p) => take("in", p)[2];
    c.output = (p, v) =>
      assert.equal(v, take("out", p)[2], `fixture ${index}, output`);
    c.interrupt = (n) => {
      const e = take("int", n);
      c.tick = e[2];
      c.r.set(e[3]);
    };
    let hits = 0;
    // run_to counts the initial target visit; a near-call return is an exit sentinel.
    for (let steps = 0; ; steps++) {
      if (c.ip === f.stop && ++hits >= f.visits) break;
      if (steps >= 20000000)
        throw Error(`fixture ${index}: did not reach ${f.stop.toString(16)}`);
      c.step();
    }
    const got = {
      r: [...c.r],
      ip: c.ip,
      data: hash(c.mem.subarray(0x10100, 0x17230)),
      cga: hash(c.mem.subarray(0xb8000, 0xbc000)),
    };
    assert.deepEqual(
      got,
      f.expected,
      `fixture ${index}, entry ${f.initial.ip.toString(16)}, target ${f.stop.toString(16)}`,
    );
    assert.equal(
      event,
      f.events.length,
      `fixture ${index}: all device events consumed`,
    );
    index++;
  }
  console.log(`Compared ${index} original execution fixtures`);
});
