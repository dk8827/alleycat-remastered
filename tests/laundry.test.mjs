import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { PortableSession } from "../engine/portable-session.js";
import { pages, boundaries } from "../build/generated/translated.js";
import { LAUNDRY_TILES, laundryFromCga } from "../renderer/laundry.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
function compareRow(s, y) {
  const expected = new Uint8Array(320 * 16);
  for (const o of s.presentation.laundry.filter((o) => o.y === y)) {
    const t = LAUNDRY_TILES.find((t) => t.name === o.kind);
    for (let yy = 0; yy < t.height; yy++)
      for (let xx = 0; xx < t.width; xx++)
        if (
          o.x + xx >= 0 &&
          o.x + xx < 320 &&
          ((t.bytes[(yy * t.width + xx) >> 2] >> (6 - 2 * (xx & 3))) & 3) === 3
        )
          expected[yy * 320 + o.x + xx] = 1;
  }
  for (let yy = 0; yy < 16; yy++)
    for (let x = 0; x < 320; x++) {
      const py = y + yy,
        p =
          (s.cpu.m8(0xb8000 + (py & 1) * 8192 + (py >> 1) * 80 + (x >> 2)) >>
            (6 - 2 * (x & 3))) &
          3;
      assert.equal(
        expected[yy * 320 + x],
        p === 3 ? 1 : 0,
        `CGA mismatch at ${x},${py}, tick ${s.cpu.tick}`,
      );
    }
}
test("garment identity, size and scrolling reproduce original CGA ink at both speeds and all starting difficulties", () => {
  let checks = 0;
  const phases = new Set(),
    kinds = new Set();
  for (const cycles of [1500, 3000])
    for (const difficulty of [0, 1, 2, 3]) {
      const s = new PortableSession(exe, pages, boundaries, {
        cycles,
        difficulty,
      });
      // Constants are checked against original data, not another hand-built fixture.
      for (const t of LAUNDRY_TILES)
        assert.deepEqual(
          [
            ...s.cpu.mem.subarray(
              0x10100 + t.source,
              0x10100 + t.source + t.bytes.length,
            ),
          ],
          t.bytes,
        );
      for (const y of [8, 40, 72]) compareRow(s, y);
      const observe = s.cpu.observe;
      s.cpu.observe = (ip, c) => {
        observe(ip, c);
        if (ip !== 0x0632) return;
        const row = c.m16(0x1062f);
        compareRow(s, [8, 40, 72][row]);
        phases.add(`${row}:${c.m8(0x10625)}`);
        for (const o of s.presentation.laundry) kinds.add(o.kind);
        checks++;
      };
      for (let i = 0; i < 1000 && !s.ended; i++) s.advance();
    }
  assert.equal(phases.size, 12, "all four phases of all three rows");
  assert.equal(kinds.size, 5, "all original garment shapes");
  assert.ok(checks > 500);
  console.log(
    `Compared ${checks} complete strip scrolls with original CGA pixels`,
  );
});
test("laundry snapshot restores exact garment identity and incoming offscreen fragments", () => {
  const s = new PortableSession(exe, pages, boundaries);
  for (let i = 0; i < 31; i++) s.advance();
  const saved = s.save(),
    frames = [];
  for (let i = 0; i < 70; i++) frames.push(s.advance().frame);
  s.load(saved);
  for (let i = 0; i < 70; i++) assert.deepEqual(s.advance().frame, frames[i]);
});
test("legacy CGA decoder recognizes all five shapes and full wide pieces instead of support cells", () => {
  const s = new PortableSession(exe, pages, boundaries);
  const got = laundryFromCga(s.cpu.mem.subarray(0xb8000, 0xbc000));
  const order = (a, b) => a.y - b.y || a.x - b.x;
  assert.deepEqual(got, [...s.frame.laundry].sort(order));
  const supportCount = s.frame.supports.reduce(
    (n, b) => n + [...b.toString(2)].filter((x) => x === "1").length,
    0,
  );
  assert.ok(
    supportCount > got.length,
    "support bits must not become individual clothes",
  );
});
