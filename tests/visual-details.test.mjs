import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { PortableSession } from "../engine/portable-session.js";
import { Presentation, ink } from "../engine/presentation.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
const fixture = (scene) => {
  const s = new PortableSession(exe, pages, boundaries, { practice: scene }),
    data = s.cpu.mem.slice(0x10100, 0x20100),
    video = s.cpu.mem.subarray(0xb8000, 0xbc000),
    p = new Presentation();
  const w = (a, v) => {
    data[a] = v & 255;
    data[a + 1] = v >> 8;
  };
  const frame = () => p.state(data, video, 100, 0);
  const draw = (ip, source, address, dimensions) => {
    const r = new Uint16Array(12);
    r[6] = source;
    r[7] = address;
    r[1] = dimensions;
    p.observe(ip, data, r);
  };
  return { s, data, video, p, w, frame, draw };
};
test("broom and fishbowl use the actual selected sprite, including asymmetric visible bounds", () => {
  for (const [scene, kind, ip, sources, address, dimensions, neutral] of [
    [
      1,
      "broom",
      0x3360,
      [0x2ea0, 0x2f18, 0x2f90, 0x3008, 0x3080, 0x30f8, 0x3170],
      0x3282,
      0x1e02,
      0,
    ],
    [1, "fishbowl", 0x3880, [0x3530, 0x3558, 0x3580, 0x35a8], 0x35c2, 0xa02, 2],
  ]) {
    const f = fixture(scene);
    // Controlled presentation fixture: addresses describe the observed original draw.
    f.w(address, 0x500);
    if (kind === "broom") f.data[0x3286] = 0;
    for (const [pose, source] of sources.entries()) {
      f.draw(
        ip,
        source,
        kind === "fishbowl" ? 69 * 80 + 57 : 0x500,
        dimensions,
      );
      const o = f.frame().objects.find((o) => o.kind === kind);
      assert.ok(o, kind);
      assert.equal(o.source, source);
      assert.equal(o.pose, pose);
      assert.deepEqual(o.inkRect, ink(f.data, source, o.rect, neutral));
    }
  }
});
test("cheese transfer composites erase the cat completely instead of leaving a faded ghost", () => {
  const f = fixture(4);
  f.data[0x39e1] = 10;
  f.w(0x39e2, 0x500);
  for (const source of [0x39ea, 0x3a2a, 0x3a6a, 0x3aaa, 0x3b12, 0x3b92]) {
    f.draw(0x3f7e, source, 0x500, 0x1002);
    const o = f.frame().objects.find((o) => o.kind === "transfercat");
    assert.equal(o.source, source);
    if ([0x3b12, 0x3b92].includes(source))
      assert.equal(o.inkRect[2] * o.inkRect[3], 0);
    else assert.ok(o.inkRect[2] * o.inkRect[3] > 0);
  }
});
test("cheese mice retain full size through clipped emergence and collected trophies remain visible", () => {
  const f = fixture(4);
  f.data[0x3eb2] = 0;
  f.data[0x3eae] = 0;
  f.w(0x3ea6, 0x500);
  for (const [source, shift] of [
    [0x3d20, 0],
    [0x3d50, 0],
    [0x3d80, -6],
    [0x3db0, -9],
  ]) {
    f.draw(0x4250, source, 0x500, 0xc02);
    const o = f.frame().objects.find((o) => o.kind === "mouse" && !o.trophy);
    assert.equal(o.source, source);
    assert.equal(o.fullInkRect[3], 9);
    assert.equal(
      o.fullInkRect[1],
      o.rect[1] + (source === 0x3d20 ? 1 : 3) + shift,
    );
  }
  for (let remaining = 4; remaining >= 0; remaining--) {
    f.data[0x3ed8] = remaining;
    const trophies = f.frame().objects.filter((o) => o.trophy);
    assert.equal(trophies.length, 4 - remaining);
    assert.deepEqual(
      trophies.map((o) => o.rect),
      [20, 36, 52, 68].slice(0, 4 - remaining).map((x) => [x, 2, 16, 12]),
    );
  }
});
test("temporary effects follow original draw/restore and survive a presentation snapshot", () => {
  for (const [draw, erase, source, dimensions] of [
    [0x1194, 0x11cd, 0x1679, 0x1205],
    [0x25e1, 0x2609, 0x1d70, 0x806],
  ]) {
    const f = fixture(0);
    f.draw(draw, source, 0x500, dimensions);
    const state = f.frame();
    assert.equal(state.effects.length, 1);
    assert.equal(state.effects[0].source, source);
    const saved = f.p.save(),
      restored = new Presentation();
    restored.load(saved);
    assert.deepEqual(restored.save(), saved);
    f.draw(erase, 0, 0, 0);
    assert.deepEqual(f.frame().effects, []);
    f.p.load(saved);
    f.draw(0x2790, 0, 0, 0);
    assert.deepEqual(f.frame().effects, []);
  }
});
test("courtship border comes from all 24 original table placements", () => {
  const f = fixture(7),
    cupids = f.frame().objects.filter((o) => o.kind === "cupid");
  assert.equal(cupids.length, 24);
  assert.ok(
    cupids.every((o) => o.scenery && o.rect[2] === 32 && o.rect[3] === 24),
  );
  assert.equal(cupids.filter((o) => o.rect[1] === 0).length, 10);
  assert.ok(cupids.some((o) => o.flip) && cupids.some((o) => !o.flip));
});
test("bird flight and spider legs follow source frames rather than an inferred animation counter", () => {
  const bird = fixture(5);
  bird.data[0x40aa] = 164;
  bird.data[0x40b9] = 0;
  bird.w(0x40ba, 0x500);
  for (const [i, source] of [
    0x3ef0, 0x3efa, 0x3f04, 0x3f0e, 0x3f18, 0x3f22,
  ].entries()) {
    bird.draw(0x44e3, source, 0x500, 0x501);
    assert.equal(
      bird.frame().objects.find((o) => o.kind === "bird").pose,
      i % 3,
    );
  }
  const spider = fixture(3);
  spider.w(0x3964, 80);
  spider.data[0x3966] = 40;
  spider.data[0x396a] = 0;
  for (const [pose, source] of [0x38bc, 0x3910].entries()) {
    spider.draw(0x3e34, source, 1620, 0xe03);
    assert.equal(
      spider.frame().objects.find((o) => o.kind === "spider").pose,
      pose,
    );
  }
});
