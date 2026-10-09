import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { PortableSession } from "../engine/portable-session.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
const inside = (x, y, r) =>
  x >= r[0] && y >= r[1] && x < r[0] + r[2] && y < r[1] + r[3];
function checkPixels(s) {
  let count = 0;
  for (const [kind, list] of Object.entries(s.presentation.alleyDetails))
    for (const o of list) {
      const [x, y, w, h] = o.rect;
      for (let yy = 0; yy < h; yy++)
        for (let xx = 0; xx < w; xx++) {
          const color =
            (s.cpu.m8(0x10100 + o.source + (yy * w) / 4 + (xx >> 2)) >>
              (6 - 2 * (xx & 3))) &
            3;
          if (
            !(kind === "holes"
              ? color === 2
              : kind === "glyphs"
                ? color === 0
                : color !== 2)
          )
            continue;
          if (!o.clips.some((r) => inside(x + xx, y + yy, r))) continue;
          const actual =
            (s.cpu.m8(
              0xb8000 +
                ((y + yy) & 1) * 8192 +
                ((y + yy) >> 1) * 80 +
                ((x + xx) >> 2),
            ) >>
              (6 - 2 * ((x + xx) & 3))) &
            3;
          assert.equal(
            actual,
            color,
            `${kind} ${o.source.toString(16)} at ${x + xx},${y + yy}`,
          );
          count++;
        }
    }
  return count;
}
// Explicit isolated display-routine fixtures; no injected gameplay outcomes.
function call(s, ip) {
  const c = s.cpu;
  c.ip = ip;
  c.push(0xff00);
  c.runUntil((c) => c.ip === 0xff00);
}
function scoreGlyphs(s, high = false) {
  const x = high ? 40 : 240,
    y = high ? 120 : 128;
  return [0, 8, 16, 32, 40, 48, 56]
    .map(
      (dx) =>
        s.presentation.alleyDetails.glyphs.find(
          (g) => g.rect[0] === x + dx && g.rect[1] === y,
        )?.text,
    )
    .join("");
}
test("original decoration choices, positions and opaque overlap match CGA at all menu difficulties and both speeds", () => {
  const litter = new Set(),
    holes = new Set();
  let pixels = 0;
  for (const cycles of [1500, 3000])
    for (const difficulty of [0, 1, 2, 3]) {
      const s = new PortableSession(exe, pages, boundaries, {
          cycles,
          difficulty,
        }),
        d = s.frame.alleyDetails;
      assert.equal(d.holes.length, 41);
      assert.equal(d.glyphs.length, 39);
      assert.equal(d.litter.length, difficulty + 2);
      assert.equal(
        d.glyphs.find((g) => g.rect[0] === 8 && g.rect[1] === 160).text,
        "KHTA"[difficulty],
      );
      for (const o of d.litter) litter.add(o.pose);
      for (const o of d.holes) holes.add(o.pose);
      assert.ok(
        d.holes.some((o) => o.clips.length === 0),
        "opaque later blits must cover some earlier holes",
      );
      pixels += checkPixels(s);
    }
  assert.equal(litter.size, 6);
  assert.equal(holes.size, 5);
  console.log(
    `Compared ${pixels} visible original decoration pixels including opaque occlusion`,
  );
});
test("current score, high score and lives change only when their original glyphs are drawn", () => {
  const s = new PortableSession(exe, pages, boundaries),
    c = s.cpu;
  c.mem.set([1, 2, 3, 4, 5, 6, 7], 0x12082);
  assert.equal(scoreGlyphs(s), "0000000");
  call(s, 0x26fc);
  assert.equal(scoreGlyphs(s), "1234567");
  assert.equal(scoreGlyphs(s, true), "0000000");
  call(s, 0x2690);
  assert.equal(
    scoreGlyphs(s, true),
    "0000000",
    "high-score memory update does not redraw the fence",
  );
  call(s, 0x26f2);
  assert.equal(scoreGlyphs(s, true), "1234567");
  c.mem.set([8, 9, 0, 1, 2, 3, 4], 0x12082);
  call(s, 0x26fc);
  assert.equal(scoreGlyphs(s), "8901234");
  for (const n of [3, 2, 1, 0, 9]) {
    c.w8(0x12080, n);
    call(s, 0x26b3);
    assert.equal(
      s.presentation.alleyDetails.glyphs.find(
        (g) => g.rect[0] === 256 && g.rect[1] === 116,
      ).text,
      String(n),
    );
    checkPixels(s);
  }
  assert.equal(
    s.presentation.alleyDetails.glyphs.length,
    40,
    "updates replace glyphs rather than stacking old numbers",
  );
});
test("snapshot and alley redraw preserve the original decoration layout without duplication", () => {
  const s = new PortableSession(exe, pages, boundaries),
    saved = s.save(),
    original = structuredClone(s.presentation.alleyDetails);
  for (let i = 0; i < 40; i++) s.advance();
  s.load(saved);
  assert.deepEqual(s.presentation.alleyDetails, original);
  call(s, 0x2a00);
  assert.equal(s.presentation.alleyDetails.holes.length, 41);
  assert.equal(s.presentation.alleyDetails.litter.length, 0);
  call(s, 0x5400);
  assert.equal(s.presentation.alleyDetails.litter.length, 2);
  assert.notDeepEqual(
    s.presentation.alleyDetails.holes,
    original.holes,
    "original RNG chooses a fresh arrangement on scene redraw",
  );
});
