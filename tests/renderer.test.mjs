import { readFixture } from "./helpers/fixtures.mjs";
import { test } from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import {
  ALLEY_ART,
  BIN_ART,
  INTERIOR_ART,
  binPatches,
  chairPatches,
} from "../renderer/registration.js";
import { Painter, projectRect } from "../renderer/renderer.js";
const atlas = JSON.parse(
  fs.readFileSync(new URL("../assets/atlas.json", import.meta.url)),
);
const cases = readFixture("render-states.json");
function context() {
  const calls = [];
  const g = {
    calls,
    createImageData: (w, h) => ({ data: new Uint8ClampedArray(w * h * 4) }),
    measureText: () => ({
      actualBoundingBoxLeft: 0,
      actualBoundingBoxRight: 40,
      actualBoundingBoxAscent: 48,
      actualBoundingBoxDescent: 0,
    }),
  };
  for (const name of [
    "save",
    "restore",
    "translate",
    "transform",
    "scale",
    "drawImage",
    "putImageData",
    "clearRect",
    "fillRect",
    "strokeRect",
    "fillText",
    "beginPath",
    "rect",
    "moveTo",
    "lineTo",
    "quadraticCurveTo",
    "closePath",
    "clip",
    "stroke",
    "ellipse",
    "fill",
  ])
    g[name] = (...args) => {
      for (const a of args)
        if (typeof a === "number")
          assert.ok(Number.isFinite(a), name + " nonfinite coordinate");
      if (name === "drawImage") {
        assert.ok(args[0], "missing image");
        if (args.length === 9) {
          assert.ok(
            args[1] >= 0 &&
              args[2] >= 0 &&
              args[1] + args[3] <= args[0].width + 0.001 &&
              args[2] + args[4] <= args[0].height + 0.001,
            "source crop outside image " + args[0].name,
          );
        }
      }
      calls.push([name, ...args]);
    };
  return g;
}
function painter() {
  globalThis.document = {
    createElement: () => ({ getContext: () => context() }),
  };
  const canvas = { getContext: () => context() },
    p = new Painter(canvas);
  p.atlas = atlas;
  const files = {
    ...Object.fromEntries(Object.entries(atlas).map(([k, v]) => [k, v.file])),
    wall: ALLEY_ART.file,
    interior: INTERIOR_ART,
    room2: "assets/room-2.png",
    room7: "assets/room-7.png",
    menu: "assets/backdrop.png",
    "bin-contact": BIN_ART.file,
    "chair-contact": "assets/chair-contact-v3.png",
  };
  for (const [name, file] of Object.entries(files)) {
    const png = fs.readFileSync(new URL("../" + file, import.meta.url));
    p.images[name] = {
      name,
      width: png.readUInt32BE(16),
      height: png.readUInt32BE(20),
    };
  }
  return p;
}
test("one affine scale across every room, including cheese boundary", () => {
  assert.deepEqual(projectRect([0, 0, 320, 200]), [0, 0, 1440, 1080]);
  const p = painter();
  for (let scene = 0; scene < 8; scene++) {
    p.current = { scene };
    assert.equal(p.y(100, 224), 540);
    assert.equal(p.y(100, 225), 540);
  }
});
test("every saved render state renders finite geometry and is independent of wall clock", () => {
  for (const c of cases) {
    const p = painter();
    p.update(c.state);
    p.g.calls.length = 0;
    p.draw(100, false);
    const first = JSON.stringify(p.g.calls);
    p.g.calls.length = 0;
    p.draw(100000, true);
    assert.equal(JSON.stringify(p.g.calls), first, c.name);
  }
});
test("no cat is painted before original room draw or after original erase", () => {
  const p = painter(),
    s = { ...cases[0].state, playerVisible: false };
  p.update(s);
  p.g.calls.length = 0;
  p.draw(0);
  assert.equal(
    p.g.calls.filter((c) => c[0] === "drawImage" && c[1] === p.images.cat)
      .length,
    0,
  );
});
test("all twelve alley windows are painted, with no opening overlay initially", () => {
  const p = painter();
  p.update(cases[0].state);
  p.g.calls.length = 0;
  p.draw(0);
  assert.equal(
    p.g.calls.filter(
      (c) => c[0] === "drawImage" && c[1] === p.images["window-v2"],
    ).length,
    12,
  );
});

test("can art preserves padded area and identical landing geometry in both heights", () => {
  const short = binPatches([24, 148, 40, 39]),
    tall = binPatches([64, 140, 40, 47]);
  assert.deepEqual(short[0].world, [27, 149, 30, 5]);
  assert.deepEqual(short[1].world, [27, 154, 30, 6]);
  assert.equal(tall[1].world[1], 146);
  assert.equal(short[2].world[2], 27);
  assert.equal(short[2].world[3], 16);
  assert.equal(tall[2].world[3], 24);
  for (const a of [short, tall])
    assert.equal(a.at(-1).world[1] + a.at(-1).world[3], 187);
});
test("chair seat and back landmarks match original standing-foot levels", () => {
  for (const [rect, right] of [
    [[24, 128, 36, 53], false],
    [[136, 128, 32, 52], true],
  ]) {
    const patches = chairPatches(rect, right);
    assert.ok(patches.some((p) => p.world[1] === 132));
    assert.ok(patches.some((p) => p.world[1] === 164));
  }
});

test("top-edge jump clips a full-height cat instead of flattening it", () => {
  const state = cases.find((c) => c.state.playerFullInkRect)?.state;
  assert.ok(state, "comparison fixture must exercise original top clipping");
  const p = painter();
  p.update(state);
  p.g.calls.length = 0;
  p.draw(0);
  assert.ok(
    p.g.calls.some(
      (c) =>
        c[0] === "rect" &&
        JSON.stringify(c.slice(1)) ===
          JSON.stringify(projectRect(state.playerRect)),
    ),
  );
  const draw = p.g.calls
    .filter((c) => c[0] === "drawImage" && c[1] === p.images.cat)
    .at(-1);
  assert.ok(draw, "clipped player remains visible");
  assert.equal(draw.at(-1), state.playerFullInkRect[3] * 5.4);
  assert.ok(draw.at(-1) > state.playerRect[3] * 5.4);
});

test("fight poses preserve full dimensions while clipping at either screen edge, and freeze on pause", () => {
  for (const pose of [0, 1, 2])
    for (const side of ["full", "left", "right"]) {
      const r =
        side === "left"
          ? [0, 177, 8, 15]
          : side === "right"
            ? [312, 177, 8, 15]
            : [80, 177, 32, 15];
      const full = [side === "left" ? -24 : r[0], 177, 32, 15];
      const p = painter();
      p.update({
        ...cases[0].state,
        playerVisible: false,
        objects: [{ kind: "fight", pose, rect: r, fullInkRect: full }],
      });
      p.g.calls.length = 0;
      p.draw(0);
      const first = JSON.stringify(p.g.calls);
      const draw = p.g.calls.find(
        (c) => c[0] === "drawImage" && c[1] === p.images["fight-v1"],
      );
      assert.ok(draw, "fight artwork must be drawn");
      assert.deepEqual(
        draw.slice(-2),
        [144, 81],
        "edge fragment must not squash the full cloud",
      );
      assert.deepEqual(draw.slice(2, 6), atlas["fight-v1"].frames[pose]);
      assert.ok(
        p.g.calls.some(
          (c) =>
            c[0] === "rect" &&
            JSON.stringify(c.slice(1)) === JSON.stringify(projectRect(r)),
        ),
      );
      assert.ok(
        !p.g.calls.some((c) => c[0] === "drawImage" && c[1] === p.images.dog),
      );
      p.g.calls.length = 0;
      p.draw(99999, true);
      assert.equal(JSON.stringify(p.g.calls), first);
    }
});

test("all alley detail assets render within registered bounds, beneath actors and above the cans", () => {
  const p = painter(),
    rect = [184, 180, 24, 8],
    hole = [60, 124, 8, 5];
  p.update({
    ...cases[0].state,
    alleyDetails: {
      litter: Array.from({ length: 6 }, (_, pose) => ({
        pose,
        rect,
        inkRect: rect,
        clips: [rect],
      })),
      holes: Array.from({ length: 5 }, (_, pose) => ({
        pose,
        rect: hole,
        inkRect: hole,
        clips: [[60, 124, 4, 5]],
      })),
      glyphs: [
        {
          source: 0x27a0,
          text: "8",
          rect: [256, 116, 8, 8],
          inkRect: [257, 116, 6, 8],
          clips: [[257, 116, 6, 8]],
        },
      ],
    },
  });
  p.g.calls.length = 0;
  p.draw(0);
  const calls = p.g.calls;
  assert.equal(
    calls.filter(
      (c) => c[0] === "drawImage" && c[1] === p.images["alley-litter-v1"],
    ).length,
    6,
  );
  assert.equal(
    calls.filter(
      (c) => c[0] === "drawImage" && c[1] === p.images["fence-holes-v1"],
    ).length,
    5,
  );
  assert.ok(calls.some((c) => c[0] === "quadraticCurveTo"));
  assert.ok(
    calls.some((c) => c[0] === "fill" && c[1] === "evenodd"),
    "traced lettering preserves open counters",
  );
  const firstLitter = calls.findIndex(
    (c) => c[0] === "drawImage" && c[1] === p.images["alley-litter-v1"],
  );
  const lastCan = calls.findLastIndex(
    (c) => c[0] === "drawImage" && c[1] === p.images["bin-contact"],
  );
  assert.ok(firstLitter > lastCan);
  const first = JSON.stringify(calls);
  p.g.calls.length = 0;
  p.draw(99999, true);
  assert.equal(JSON.stringify(p.g.calls), first);
});

test("rear jump and hanging artwork uses original ink bounds and preserves top clipping", () => {
  for (const [playerSource, pose] of [
    [0xa2e, 0],
    [0x9da, 1],
    [0xa7c, 2],
  ]) {
    const p = painter(),
      ink = [40, -5, 18, 13],
      clipped = [40, 0, 24, 8];
    p.update({
      ...cases[0].state,
      scene: 0,
      playerVisible: true,
      playerIdle: false,
      playerEating: false,
      transfer: 0,
      entry: 0,
      playerSource,
      playerInkRect: [40, 0, 18, 8],
      playerRect: clipped,
      playerFullInkRect: ink,
    });
    p.g.calls.length = 0;
    p.draw(0);
    const draw = p.g.calls.find(
      (c) => c[0] === "drawImage" && c[1] === p.images["cat-vertical-v1"],
    );
    assert.ok(draw);
    assert.deepEqual(draw.slice(2, 6), atlas["cat-vertical-v1"].frames[pose]);
    assert.deepEqual(draw.slice(-2), [81, 70.2]);
    assert.ok(
      p.g.calls.some(
        (c) =>
          c[0] === "rect" &&
          JSON.stringify(c.slice(1)) === JSON.stringify(projectRect(clipped)),
      ),
    );
    const first = JSON.stringify(p.g.calls);
    p.g.calls.length = 0;
    p.draw(99999, true);
    assert.equal(JSON.stringify(p.g.calls), first);
  }
});

test("interior perspective maps every measured source corner exactly, including the raised dog-room floor", async () => {
  const { interiorTriangles, triangleTransform } = await import(
    "../renderer/registration.js"
  );
  for (const scene of [1, 3, 4, 5, 6]) {
    const patches = interiorTriangles(scene),
      shift = scene === 6 ? 40 : 0;
    assert.equal(patches.length, 18);
    assert.ok(
      patches.some((p) =>
        p.world.some(([x, y]) => x === 16 && y === 56 - shift),
      ),
    );
    assert.ok(
      patches.some((p) =>
        p.world.some(([x, y]) => x === 304 && y === 152 - shift),
      ),
    );
    for (const p of patches) {
      const [a, b, c, d, e, f] = triangleTransform(p.source, p.world);
      for (let i = 0; i < 3; i++) {
        const [x, y] = p.source[i],
          [u, v] = p.world[i];
        assert.ok(Math.abs(a * x + c * y + e - u) < 1e-9);
        assert.ok(Math.abs(b * x + d * y + f - v) < 1e-9);
      }
    }
  }
});

test("clipped cheese mice preserve full size and absent transfer cats draw no residual sprite", () => {
  const p = painter(),
    base = structuredClone(cases.find((c) => c.state.scene === 4).state);
  base.objects = [
    {
      kind: "mouse",
      cheese: true,
      pose: 1,
      rect: [40, 60, 16, 12],
      inkRect: [43, 60, 10, 3],
      fullInkRect: [43, 54, 10, 9],
    },
  ];
  base.playerVisible = false;
  p.update(base);
  p.g.calls.length = 0;
  p.draw(0);
  const draw = p.g.calls.find(
    (c) => c[0] === "drawImage" && c[1].name === "cheese-actors-v1",
  );
  assert.ok(draw);
  assert.deepEqual(draw.slice(-2), [45, 48.6]);
  assert.ok(
    p.g.calls.some(
      (c) =>
        c[0] === "rect" &&
        c.slice(1).join() === projectRect([40, 60, 16, 12]).join(),
    ),
  );
  base.objects = [
    {
      kind: "transfercat",
      source: 0x3b12,
      rect: [40, 60, 16, 16],
      inkRect: [40, 60, 0, 0],
      phase: 7,
    },
  ];
  p.update(base);
  p.g.calls.length = 0;
  p.draw(0);
  assert.equal(
    p.g.calls.some(
      (c) => c[0] === "drawImage" && c[1].name === "cheese-actors-v1",
    ),
    false,
  );
});
test("sleeping dog warning stages keep the same registered resting body bounds", () => {
  const p = painter(),
    base = structuredClone(cases.find((c) => c.state.scene === 6).state);
  base.playerVisible = false;
  for (const flip of [false, true])
    for (let alert = 0; alert < 3; alert++) {
      base.objects = [
        {
          kind: "sleepingdog",
          rect: [80, 136, 40, 13],
          inkRect: [80, 136, 40, 12],
          alert,
          flip,
        },
      ];
      p.update(base);
      p.g.calls.length = 0;
      p.draw(0);
      const draw = p.g.calls.find(
        (c) => c[0] === "drawImage" && c[1].name === "sleeping-dogs-v1",
      );
      assert.ok(draw);
      assert.deepEqual(
        draw.slice(2, 6),
        atlas["sleeping-dogs-v1"].frames[alert],
      );
      assert.deepEqual(draw.slice(-2), [180, 64.80000000000001]);
    }
});

test("new food portions, hole transfers and all thirteen courtship sources retain their original ink bounds", () => {
  const p = painter(),
    base = structuredClone(cases[0].state);
  base.playerVisible = false;
  const samples = [
    ...[1, 2, 3, 4].map((portions) => ({
      kind: "food",
      portions,
      art: "result-scenes-v1",
      pose: 3 + portions,
    })),
    ...[0x39ea, 0x3a2a, 0x3a6a, 0x3aaa].map((source, pose) => ({
      kind: "transfercat",
      source,
      pose,
      art: "cheese-transfer-v2",
    })),
    { kind: "romancecat", source: 0x4500, pose: 0, art: "courtship-cycle-v2" },
    ...[0x4700, 0x48b0].flatMap((start) =>
      Array.from({ length: 6 }, (_, n) => ({
        kind: "romancecat",
        source: start + 72 * n,
        pose: n + 1,
        art: "courtship-cycle-v2",
      })),
    ),
  ];
  for (const o of samples) {
    const ink = [82, 93, 14, 9];
    p.update({
      ...base,
      objects: [{ ...o, rect: [80, 92, 24, 12], inkRect: ink }],
    });
    p.g.calls.length = 0;
    p.draw(0);
    const draw = p.g.calls.find(
      (c) => c[0] === "drawImage" && c[1] === p.images[o.art],
    );
    assert.ok(draw, JSON.stringify(o));
    assert.deepEqual(draw.slice(2, 6), atlas[o.art].frames[o.pose]);
    assert.deepEqual(draw.slice(-2), projectRect(ink).slice(-2));
  }
});

test("original-driven result sequences render fully in HD, remain deterministic and do not mutate game state", async () => {
  const { PortableSession } = await import("../engine/portable-session.js");
  const { pages, boundaries } = await import(
    "../build/generated/translated.js"
  );
  const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
  const p = painter(),
    seen = new Set();
  for (const [practice, difficulty, outcome] of [
    [3, 0, 1],
    [3, 0, -1],
    [7, 1, 1],
    [7, 1, -1],
    [3, 1, 0xdd],
  ]) {
    const s = new PortableSession(exe, pages, boundaries, {
      practice,
      difficulty,
    });
    s.cpu.w8(0x10653, outcome === 1 ? 1 : 0);
    s.cpu.w8(
      practice === 7 ? 0x10651 : 0x10652,
      outcome === 1 ? 0 : outcome === 0xdd ? 0xdd : 1,
    );
    for (let i = 0; i < 3000; i++) {
      s.advance();
      const e = s.frame.cinematic;
      if (
        e &&
        !seen.has(e.kind) &&
        ((e.kind === "bonus" && e.value) ||
          (e.kind === "wipe" && e.rect?.[2] > 0) ||
          (e.kind === "failure" && e.mask) ||
          (e.kind === "romance" && e.couple) ||
          (e.kind === "hearts" && e.particles.length) ||
          (e.kind === "dance" && e.particles.length) ||
          (e.kind === "rejection" && e.rect) ||
          (e.kind === "beckon" && e.rect))
      ) {
        seen.add(e.kind);
        const before = JSON.stringify(s.frame);
        p.update(s.frame);
        p.g.calls.length = 0;
        p.draw(0);
        const first = JSON.stringify(p.g.calls);
        assert.ok(
          !p.g.calls.some((c) => c[0] === "drawImage" && c[1] === p.cga),
          "HD must not fall back to CGA",
        );
        p.g.calls.length = 0;
        p.draw(999999, true);
        assert.equal(JSON.stringify(p.g.calls), first);
        assert.equal(JSON.stringify(s.frame), before);
      }
      if (s.frame.scene === 0 && !e && !s.frame.originalInterlude) break;
    }
  }
  assert.deepEqual([...seen].sort(), [
    "beckon",
    "bonus",
    "dance",
    "failure",
    "hearts",
    "rejection",
    "romance",
    "wipe",
  ]);
});

test("idle head and tail stay independently registered for every original source combination", () => {
  const p = painter();
  for (const [h, head] of [0xeea, 0xf02, 0xf1a].entries())
    for (const [b, body] of [0xf32, 0xf4a, 0xf62].entries()) {
      const headInk = [14, 179, 10, 6],
        bodyInk = [9, 185, 15, 6];
      const state = {
        playerVisible: true,
        playerIdle: true,
        playerIdleParts: [
          { head: true, source: head, inkRect: headInk },
          { head: false, source: body, inkRect: bodyInk },
        ],
      };
      const before = JSON.stringify(state);
      p.g.calls.length = 0;
      p.paintPlayer(state);
      const draws = p.g.calls.filter((c) => c[0] === "drawImage");
      assert.equal(draws.length, 2);
      for (const [i, pose, ink] of [
        [0, h, headInk],
        [1, b + 3, bodyInk],
      ]) {
        assert.equal(draws[i][1], p.images["idle-cat-v1"]);
        assert.deepEqual(
          draws[i].slice(2, 6),
          atlas["idle-cat-v1"].frames[pose],
        );
        assert.deepEqual(draws[i].slice(-2), projectRect(ink).slice(-2));
      }
      assert.equal(JSON.stringify(state), before);
    }
});

test("title draws the live cat once and result hearts use the opaque replacement asset", async () => {
  const { paintCinematic } = await import("../renderer/cinematics.js");
  const p = painter(),
    state = structuredClone(cases[0].state);
  let cats = 0;
  p.paintPlayer = (s) => {
    if (s.playerVisible) cats++;
  };
  paintCinematic(p, {
    ...state,
    playerVisible: true,
    cinematic: { kind: "intro" },
  });
  assert.equal(cats, 1);
  p.g.calls.length = 0;
  paintCinematic(p, {
    ...state,
    cinematic: {
      kind: "hearts",
      elements: [{ pose: 0, rect: [120, 60, 80, 80] }],
      particles: [[30, 40, 16, 16]],
    },
  });
  const draws = p.g.calls.filter((c) => c[0] === "drawImage");
  assert.equal(draws.length, 2);
  assert.ok(draws.every((c) => c[1] === p.images["solid-heart-v1"]));
});
