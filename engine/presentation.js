// One read-only presentation contract for all three execution architectures.
// Addresses and rectangles are from tools/remaster_geometry.py / remaster_runtime.py.
export const xy = (v) => [
  ((v & 8191) % 80) * 4,
  Math.floor((v & 8191) / 80) * 2 + (v & 8192 ? 1 : 0),
];
export const rect = (v, d) => [...xy(v), (d & 255) * 8, d >>> 8];
export const INK = new Map([
  [0x3f7e, [1, 2, 3]], // cat ink only inside cheese transfer composites
  [0x3360, 0], // shared broom OR draw, before CX is repurposed
  [0x4f46, 0], // courtship cat's custom 24x12 OR draw
  [0x37bd, 1],
  [0x379b, 1], // aquarium fish and electric hazards
  [0x191e, 0],
  [0x20ba, 0],
  [0x22d8, 0],
  [0x2549, 3],
  [0x3e34, 0],
  [0x3880, 2],
  [0x4174, 3],
  [0x4250, 3],
  [0x44e3, 0],
  [0x4725, 3],
  [0x476f, 3],
  [0x6227, 0],
]);
export const WATCH = new Set([
  0x1194,
  0x11cd,
  0x25e1,
  0x2609, // temporary YOW / SQUEEK overlays and their restores
  0x2c05,
  0x2c33, // randomized fence holes / lower-edge notches
  0x2b40,
  0x2a7c, // fixed graffiti / selected difficulty glyph
  0x26d6,
  0x2763, // actual lives / score digit draws
  0x543e, // difficulty-dependent randomized floor litter
  0x2c5a,
  0x2c6d,
  0x2c80, // opaque can sections cover earlier fence details
  0x20dd, // capture cloud: raw CGA copy, not the normal transparent dog blit
  0x20f4, // chasing-enemy background restored
  0x1e40, // chasing-enemy initialization
  0x2af1, // generated 16x16 laundry block, before original CGA blit
  0x0632, // completed four-pixel laundry strip scroll
  0x2790,
  0x2a00,
  0x2a30, // title enters the fence-only initializer
  0x11f3,
  0x1162,
  0x10b6,
  0x10d4,
  0x4b43,
  0x4b19,
  ...INK.keys(),
]);
export const reader = (data) => ({
  b: (p) => data[p & 65535],
  w: (p) => data[p & 65535] | (data[(p + 1) & 65535] << 8),
});
export function ink(data, source, [x, y, w, h], neutral) {
  const visible = Array.isArray(neutral)
    ? (p) => !neutral.includes(p)
    : (p) => p !== neutral;
  let l = w,
    t = h,
    r = -1,
    b = -1;
  if (w <= 0 || h <= 0) return [x, y, w, h];
  for (let yy = 0; yy < h; yy++)
    for (let xx = 0; xx < w; xx++)
      if (
        visible(
          (data[(source + (yy * w) / 4 + (xx >> 2)) & 65535] >>>
            (6 - 2 * (xx & 3))) &
            3,
        )
      ) {
        l = Math.min(l, xx);
        r = Math.max(r, xx);
        t = Math.min(t, yy);
        b = Math.max(b, yy);
      }
  return r < 0 ? [x, y, 0, 0] : [x + l, y + t, r - l + 1, b - t + 1];
}
const union = (a, b) => {
  const x = Math.min(a[0], b[0]),
    y = Math.min(a[1], b[1]);
  return [
    x,
    y,
    Math.max(a[0] + a[2], b[0] + b[2]) - x,
    Math.max(a[1] + a[3], b[1] + b[3]) - y,
  ];
};
// Preserve opaque original blit order without painting rectangular CGA
// backgrounds into HD art. Later writes remove these portions of earlier ink.
function coverAlleyDetails(details, [x, y, w, h]) {
  for (const list of Object.values(details))
    for (const o of list)
      o.clips = o.clips.flatMap(([a, b, c, d]) => {
        const l = Math.max(a, x),
          t = Math.max(b, y),
          r = Math.min(a + c, x + w),
          bottom = Math.min(b + d, y + h);
        if (l >= r || t >= bottom) return [[a, b, c, d]];
        return [
          [a, b, c, t - b],
          [a, bottom, c, b + d - bottom],
          [a, t, l - a, bottom - t],
          [r, t, a + c - r, bottom - t],
        ].filter((rect) => rect[2] > 0 && rect[3] > 0);
      });
}
const FURNITURE = {
  1: [
    ["window", 128, 80, 64, 32],
    ["chair", 24, 128, 36, 53],
    ["chair-r", 136, 128, 32, 52],
    ["table", 64, 144, 56, 36],
    ["pedestal", 216, 144, 44, 37],
    ["lamp", 272, 112, 24, 64],
  ],
  3: [
    ["window", 64, 80, 64, 32],
    ["chair", 48, 128, 36, 53],
    ["chair-r", 96, 128, 32, 52],
    ["lamp", 16, 112, 24, 64],
    ["lamp", 136, 112, 24, 64],
    ["bookshelf", 168, 40, 128, 128],
  ],
  4: [
    ["window", 232, 80, 64, 32],
    ["chair", 228, 128, 36, 53],
    ["pedestal", 256, 144, 44, 37],
    ["cheese", 24, 32, 200, 136],
  ],
  5: [
    ["window", 216, 80, 64, 32],
    ["chair", 56, 128, 36, 53],
    ["chair-r", 208, 128, 32, 52],
    ["chair-r", 248, 128, 32, 52],
    ["table", 128, 144, 56, 36],
    ["lamp", 16, 112, 24, 64],
    ["picture", 88, 88, 16, 16],
  ],
  6: [
    ["window", 40, 40, 64, 32],
    ["chair", 72, 88, 36, 53],
    ["chair-r", 216, 88, 32, 52],
    ["lamp", 272, 72, 24, 64],
    ["picture", 248, 40, 16, 16],
  ],
};
export function geometry(data, scene) {
  const { b, w } = reader(data),
    out = [];
  const add = (kind, x, y, width, height, extra = {}) =>
    out.push({ kind, x, y, rect: [x, y, width, height], ...extra });
  const at = (kind, p, d, extra) => add(kind, ...rect(w(p), d), extra);
  for (const f of FURNITURE[scene] || []) add(...f, { scenery: true });
  if (scene === 0) {
    for (let row = 0; row < 3; row++)
      for (let col = 0; col < 4; col++) {
        const x = w(0x1658 + 2 * col),
          y = b(0x1660 + row),
          phase = x === w(0x1666) && y === b(0x1668) ? b(0x1665) : 0,
          top = phase >= 15 ? phase - 14 : 15 - phase;
        add("windowpane", x - 4, y, 40, 16, {
          id: row * 4 + col,
          phase,
          opening: [x, y + top, 32, Math.max(0, 15 - top)],
          pending: !!b(0x418),
        });
      }
    const index = b(0x1006 + Math.min(7, w(8)));
    for (let i = 0; i < 16; i++) {
      const v = b(0xff0 + index + i);
      if (!v) break;
      const y = v & 128 ? 140 : 148;
      add("bin", (v & 127) * 4, y, 40, 187 - y, { tall: !!(v & 128), id: i });
    }
    if (b(0x1d59)) at("popup", 0x1d62, w(0x1d64), { fullHeight: 13 });
    for (let i = 0; i < 3; i++)
      if (!b(0x1f50 + i) && !b(0x1f48 + i))
        at("mouse", 0x1f42 + 2 * i, 0x802, {
          d: b(0x1f3c + i),
          pose: b(0x1f4d + i) & 1,
          id: i,
        });
    if (b(0x1673)) {
      let variant = 0;
      for (let i = 0; i < 4; i++)
        if (w(0x17c9 + 2 * i) === w(0x17dd)) {
          variant = i;
          break;
        }
      at("projectile", 0x17e5, w(0x17e3), { variant });
    }
  }
  if (![2, 7].includes(scene) && b(0x1cbf))
    at("dog", 0x1cbd, w(0x1cc4), { d: b(0x1cd0), pose: b(0x1ccf) % 3 });
  if ([1, 3, 4, 5, 6].includes(scene)) {
    if (!b(0x3286)) at("broom", 0x3282, 0x1e02, { d: b(0x3280) });
    for (let i = 0; i < 40; i++)
      if (b(0x328e + i))
        add("floor-mark", i * 8, 192, 8, 5, { count: b(0x328e + i), id: i });
  }
  if (scene === 1) add("fishbowl", 228, 138, 16, 10);
  if (scene === 2)
    for (let i = 0; i < 24; i++)
      if (!b(0x34a7 + i) && !b(0x348f + i))
        at(i < 12 ? "fish" : "eel", 0x34bf + 2 * i, i < 12 ? 0x601 : 0x202, {
          d: b(0x3417 + i),
          id: i,
        });
  if (scene === 3) {
    for (let i = 0; i < 3; i++)
      if (w(0x37b0 + 2 * i))
        add("vase", w(0x37a3 + 2 * i), 24, 16, 16, { id: i });
    if (!b(0x396a)) add("spider", w(0x3964) & ~3, b(0x3966), 24, 14);
  }
  if (scene === 4) {
    const dim = w(0x3c56);
    for (let i = 0; i < 100; i++) {
      const p = 0x3c58 + i * 4;
      if (w(p) === 65535) break;
      const r = [...xy(w(p + 2)), (dim & 255) * 4, dim >>> 8];
      add("hole", ...r, {
        inkRect: i < 3 ? [r[0], r[1] + 4, 16, 10] : [r[0], r[1], 16, 15],
        id: i,
      });
    }
    for (let i = 0; i < 4; i++)
      if (!b(0x3eb2 + i) && !b(0x3eae + i))
        at("mouse", 0x3ea6 + 2 * i, 0xc02, { d: 0, pose: 3, id: i });
    if (b(0x39e1))
      at("transfercat", b(0x39e1) >= 8 ? 0x39e2 : 0x39e6, 0x1002, {
        phase: b(0x39e1),
      });
  }
  if (scene === 5) {
    const open = b(0x40aa) >= 164;
    at("cage", open ? 0x40a6 : 0x40ab, open ? 0x1104 : 0x1003, { open });
    if (open && !b(0x40b9))
      at("bird", 0x40ba, 0x501, {
        d: b(0x40b7),
        pose: Math.floor(w(0x40be) / 2) % 2,
      });
  }
  if (scene === 6)
    for (let i = 0; i < 12; i++) {
      const r = [w(0x4481 + 2 * i), b(0x4499 + i), 16, 8];
      add("food", ...r, {
        inkRect: ink(data, 0x41fc + 32 * b(0x44c4 + i), r, 2),
        portions: b(0x44c4 + i),
        id: i,
      });
      if (w(0x4441 + 2 * i)) {
        const d = rect(w(0x4411 + 2 * i), 0xd05);
        add("sleepingdog", ...d, {
          inkRect: ink(data, w(0x4429 + 2 * i), d, 2),
          alert: w(0x4459 + 2 * i),
          flip: w(0x4429 + 2 * i) === 0x429c,
          id: i,
        });
      }
    }
  if (scene === 7) {
    for (let row = 0; row < 7; row++)
      for (let col = 0; col < 16; col++) {
        const broken = b(0x2be2 + 18 * row + col) !== 0,
          r = [32 + 16 * col, b(0x2bd4 + row) + 15, 16, 8];
        add("heart", ...r, {
          inkRect: ink(data, broken ? 0x2e00 : 0x2de0, r, 1),
          broken,
          id: row * 18 + col,
        });
      }
    for (let i = 0; i < 7; i++) {
      const p = 0x4554 + i * 12;
      if (!b(p + 6))
        at("romancecat", p + 4, 0xc03, {
          d: b(p + 2),
          goal: i === 6,
          pose: Math.floor(w(p + 9) / 2),
          id: i,
        });
    }
    if (b(0x70f2) && !b(0x70f7))
      add("arrow", w(0x70f3) & ~3, b(0x70f5), 16, 8, { d: b(0x70f6) });
    for (let i = 0; i < 8; i++)
      if (b(0x2b72 + i))
        add("gift", w(0x2b5a + 2 * i), b(0x2b6a + i), 24, 15, { id: i });
  }
  return out;
}
export function cgaPalette(color = 48, control = 0) {
  const rgb = [
      [0, 0, 0],
      [0, 0, 170],
      [0, 170, 0],
      [0, 170, 170],
      [170, 0, 0],
      [170, 0, 170],
      [170, 85, 0],
      [170, 170, 170],
      [85, 85, 85],
      [85, 85, 255],
      [85, 255, 85],
      [85, 255, 255],
      [255, 85, 85],
      [255, 85, 255],
      [255, 255, 85],
      [255, 255, 255],
    ],
    colors = control & 4 ? [3, 4, 7] : color & 32 ? [3, 5, 7] : [2, 4, 6];
  return [color & 15, ...colors.map((i) => i + (color & 16 ? 8 : 0))].map(
    (i) => rgb[i],
  );
}
const base64 = (bytes) => {
  let s = "";
  for (let i = 0; i < bytes.length; i += 8192)
    s += String.fromCharCode(...bytes.subarray(i, i + 8192));
  return btoa(s);
};
// Decode the original generated block, not its coarser support bitmap.
function generatedLaundry(data, x, y) {
  const matches = (source, width, height, half = 0) => {
    for (let row = 0; row < height; row++)
      for (let col = 0; col < width / 4; col++)
        if (
          data[0x4d7 + row * 4 + half + col] !==
          data[source + (row * width) / 4 + col]
        )
          return false;
    return true;
  };
  if (matches(0x490, 16, 16)) return [{ kind: "long", x, y }];
  if (matches(0x460, 16, 8)) return [{ kind: "wide", x, y }];
  const out = [];
  for (const half of [0, 2])
    for (const [kind, source] of [
      ["small", 0x480],
      ["sock-left", 0x440],
      ["sock-right", 0x450],
    ])
      if (matches(source, 8, 8, half)) {
        out.push({ kind, x: x + half * 4, y });
        break;
      }
  return out;
}
export class Presentation {
  constructor() {
    this.player = null;
    this.inks = new Map();
    this.laundry = null;
    this.enemyDraw = undefined; // undefined permits older observation packets
    this.alleyDetails = null;
    this.binDraws = undefined;
    this.drawSprites = new Map();
    this.effects = [];
  }
  observe(ip, data, r) {
    const { b, w } = reader(data);
    if (ip === 0x2a30) {
      this.alleyDetails = { holes: [], glyphs: [], litter: [] };
      this.binDraws = [];
      this.laundry = [];
      return;
    }
    if (ip === 0x2c5a && this.binDraws) {
      const [x, y] = xy(r[7]);
      this.binDraws.push({
        kind: "bin",
        rect: [x, y, 40, 187 - y],
        tall: y === 140,
        id: this.binDraws.length,
      });
    }
    if (ip === 0x1194 || ip === 0x25e1) {
      this.effects = [
        { kind: "original-effect", source: r[6], rect: rect(r[7], r[1]) },
      ];
      return;
    }
    if (ip === 0x11cd || ip === 0x2609) {
      this.effects = [];
      return;
    }
    if (
      [
        0x2c05, 0x2c33, 0x2b40, 0x2a7c, 0x26d6, 0x2763, 0x543e, 0x2c5a, 0x2c6d,
        0x2c80,
      ].includes(ip)
    ) {
      if (!this.alleyDetails) return;
      const source = r[6];
      // The table blitter counts BYTES per row, unlike the word-copy calls.
      const drawRect =
        ip === 0x2b40
          ? [...xy(r[7]), (r[1] & 255) * 4, r[1] >>> 8]
          : rect(r[7], r[1]);
      coverAlleyDetails(this.alleyDetails, drawRect);
      if (ip === 0x2c05 || ip === 0x2c33) {
        const inkRect = ink(data, source, drawRect, [0, 1, 3]);
        this.alleyDetails.holes.push({
          source,
          pose: (source - 0x2944) / 10,
          rect: drawRect,
          inkRect,
          clips: [inkRect],
        });
      } else if (ip === 0x543e) {
        const pose = Array.from({ length: 6 }, (_, i) =>
          w(0x584c + i * 2),
        ).indexOf(source);
        const inkRect = ink(data, source, drawRect, 2);
        if (pose >= 0)
          this.alleyDetails.litter.push({
            source,
            pose,
            rect: drawRect,
            inkRect,
            clips: [inkRect],
          });
      } else {
        let text =
          source >= 0x2720 && source < 0x27c0
            ? String((source - 0x2720) / 16)
            : {
                0x27c0: "I",
                0x27d0: "!",
                0x27e0: "H",
                0x27f0: "-",
                0x2800: "C",
                0x2810: "A",
                0x2820: "T",
                0x2830: "L",
                0x2840: "V",
                0x2850: "E",
                0x2860: "M",
                0x2870: "U",
                0x2880: "S",
                0x2890: "K",
              }[source];
        if (ip === 0x2b40 && source === 0x2720) text = "O";
        if (text !== undefined) {
          const inkRect = ink(data, source, drawRect, [1, 2, 3]);
          const glyph = {
            source,
            text,
            rect: drawRect,
            inkRect,
            clips: [inkRect],
          };
          const key = drawRect.join(),
            index = this.alleyDetails.glyphs.findIndex(
              (o) => o.rect.join() === key,
            );
          if (index < 0) this.alleyDetails.glyphs.push(glyph);
          else this.alleyDetails.glyphs[index] = glyph;
        }
      }
      return;
    }
    if (ip === 0x1e40 || ip === 0x20f4) {
      this.enemyDraw = null;
      return;
    }
    if ((ip === 0x20ba && this.enemyDraw !== undefined) || ip === 0x20dd) {
      const fight = ip === 0x20dd,
        drawRect = rect(r[7], r[1]);
      const phase = (b(0x1ccf) & 6) >>> 1;
      const tableIndex = fight
        ? 4 + phase
        : ((b(0x1ccf) & 2) >>> 1) + (b(0x1cd0) === 1 ? 2 : 0);
      // Entry/exit copies a slice into DS:000e. Register the full sprite first,
      // then clip it: never squeeze a whole cloud into an eight-pixel fragment.
      const source = r[6] === 0x000e ? w(0x15c8 + tableIndex * 2) : r[6];
      const fullRect = [
        drawRect[0] === 0 ? drawRect[2] - 32 : drawRect[0],
        drawRect[1],
        32,
        15,
      ];
      this.enemyDraw = {
        kind: fight ? "fight" : "dog",
        scene: w(4),
        x: drawRect[0],
        y: drawRect[1],
        rect: drawRect,
        inkRect: ink(data, r[6], drawRect, fight ? 2 : 0),
        fullInkRect: ink(data, source, fullRect, fight ? 2 : 0),
        d: b(0x1cd0),
        pose: fight ? [0, 1, 2, 1][phase] : (b(0x1ccf) & 2) >>> 1,
        source,
        ...(fight ? { phase } : {}),
      };
      return;
    }
    if (ip === 0x2af1) {
      this.laundry ??= [];
      this.laundry.push(...generatedLaundry(data, ...xy(r[7])));
      return;
    }
    if (ip === 0x0632) {
      if (this.laundry === null) return;
      const row = w(0x52f),
        y = [8, 40, 72][row],
        dx = row === 1 ? -4 : 4;
      this.laundry = this.laundry
        .map((o) => (o.y === y ? { ...o, x: o.x + dx } : o))
        .filter(
          (o) =>
            o.y !== y ||
            (dx > 0
              ? o.x < 320
              : o.x + (o.kind === "long" || o.kind === "wide" ? 16 : 8) > 0),
        );
      // A new 16-pixel block enters one four-pixel column at a time.
      if (b(0x525) === (row === 1 ? 0 : 3))
        this.laundry.push(...generatedLaundry(data, row === 1 ? 316 : -12, y));
      return;
    }
    if ([0x2790, 0x2a00, 0x11f3, 0x4b19].includes(ip)) {
      this.player = null;
      if (ip === 0x2a00) {
        this.laundry = null;
        this.binDraws = [];
      }
      if (ip === 0x2a00)
        this.alleyDetails = { holes: [], glyphs: [], litter: [] };
      if (ip === 0x2790) this.alleyDetails = null;
      if ((ip === 0x2790 || ip === 0x2a00) && this.enemyDraw !== undefined)
        this.enemyDraw = null;
      if (ip === 0x2790 || ip === 0x2a00) {
        this.inks.clear();
        this.drawSprites.clear();
        this.effects = [];
      }
      return;
    }
    const drawRect = rect(r[7], ip === 0x4f46 ? 0xc03 : r[1]);
    if (INK.has(ip)) {
      this.inks.set(drawRect.join(), ink(data, r[6], drawRect, INK.get(ip)));
      this.drawSprites.set(drawRect.join(), r[6]);
      while (this.inks.size > 256)
        this.inks.delete(this.inks.keys().next().value);
      while (this.drawSprites.size > 256)
        this.drawSprites.delete(this.drawSprites.keys().next().value);
      return;
    }
    if (!WATCH.has(ip)) return;
    const idle = ip === 0x10b6 || ip === 0x10d4;
    let drawInk = ink(data, r[6], drawRect, 3);
    if (ip === 0x10d4 && this.player?.idle)
      drawInk = union(this.player.ink, drawInk);
    const idleParts = idle
      ? ip === 0x10d4 && this.player?.idle
        ? [...(this.player.parts ?? [])]
        : []
      : null;
    if (idle)
      idleParts.push({
        source: r[6],
        rect: drawRect,
        inkRect: ink(data, r[6], drawRect, 3),
        head: ip === 0x10b6,
      });
    this.player = {
      parts: idleParts,
      rect: idle ? rect(w(0x55f), 0xc02) : drawRect,
      ink: drawInk,
      sprite: r[6],
      idle,
      eating: ip === 0x4b43,
      walk: b(0x56b),
    };
    const skipped = 50 - b(0x57c),
      full = w(0x567),
      source = w(0x569);
    if (
      ip === 0x1162 &&
      drawRect[1] === 0 &&
      skipped > 0 &&
      skipped < 32 &&
      full >>> 8 === drawRect[3] + skipped &&
      (full & 255) * 8 === drawRect[2] &&
      r[6] === source + (skipped * drawRect[2]) / 4
    ) {
      this.player.fullInk = ink(
        data,
        source,
        [drawRect[0], -skipped, drawRect[2], full >>> 8],
        3,
      );
      this.player.fullSource = source;
    }
  }
  packet(p) {
    for (const e of p.events || []) this.observe(e.ip, e.data, e.r);
    return this.state(
      p.data,
      p.cga,
      p.tick,
      p.ip,
      cgaPalette(p.color, p.control),
    );
  }
  state(
    data,
    cga,
    tick,
    ip,
    palette = [
      [0, 0, 0],
      [85, 255, 255],
      [255, 85, 255],
      [255, 255, 255],
    ],
  ) {
    const { b, w } = reader(data),
      scene = w(4),
      difficulty = Math.min(7, w(8)),
      pd = this.player,
      gameover =
        b(0x1f80) === 0 || [0x5d71, 0x5ef7, 0x5f29, 0x5faa].includes(ip);
    let objects = geometry(data, scene).filter(
      (o) => o.kind !== "fishbowl" || this.inks.has(o.rect.join()),
    );
    for (const o of objects)
      if (
        [
          "mouse",
          "dog",
          "projectile",
          "popup",
          "spider",
          "cage",
          "bird",
          "arrow",
          "fishbowl",
          "fish",
          "eel",
          "broom",
          "romancecat",
          "transfercat",
        ].includes(o.kind) &&
        this.inks.has(o.rect.join())
      ) {
        o.inkRect = this.inks.get(o.rect.join());
        o.source = this.drawSprites.get(o.rect.join());
      }
    if (scene === 4) {
      for (const o of objects) if (o.kind === "mouse") o.cheese = true;
      // CS:4164..4174 draws a trophy at x=20,36,52,68 after each catch.
      for (let i = 1; i <= Math.min(4, 4 - b(0x3ed8)); i++) {
        const r = rect(0x51 + 4 * i, 0xc02);
        objects.push({
          kind: "mouse",
          rect: r,
          cheese: true,
          trophy: true,
          source: 0x3d20,
          inkRect: ink(data, 0x3d20, r, 3),
        });
      }
    }
    for (const o of objects) {
      if (o.kind === "mouse" && o.cheese) {
        o.source ??= 0x3d20;
        o.pose = o.source === 0x3d20 ? 0 : 1;
        const shift = o.source === 0x3d80 ? -6 : o.source === 0x3db0 ? -9 : 0;
        o.fullInkRect = ink(
          data,
          o.pose === 0 ? 0x3d20 : 0x3d50,
          [o.rect[0], o.rect[1] + shift, 16, 12],
          3,
        );
      }
      if (o.kind === "projectile")
        o.fullInkRect = ink(
          data,
          w(0x17dd),
          [o.rect[0], o.rect[1], (w(0x17df) & 255) * 8, w(0x17df) >>> 8],
          0,
        );
      if (o.kind === "fishbowl")
        o.pose = Math.max(
          0,
          [0x3530, 0x3558, 0x3580, 0x35a8].indexOf(o.source),
        );
      if (o.kind === "fish")
        o.pose = [0x330c, 0x3324].includes(o.source) ? 1 : 0;
      if (o.kind === "broom")
        o.pose = Math.max(
          0,
          [0x2ea0, 0x2f18, 0x2f90, 0x3008, 0x3080, 0x30f8, 0x3170].indexOf(
            o.source,
          ),
        );
      if (o.kind === "bird")
        o.pose =
          Math.max(
            0,
            [0x3ef0, 0x3efa, 0x3f04, 0x3f0e, 0x3f18, 0x3f22].indexOf(o.source),
          ) % 3;
      if (o.kind === "spider") o.pose = o.source === 0x3910 ? 1 : 0;
      if (o.kind === "floor-mark") o.source = 0x32b8 + 10 * o.count;
      if (o.kind === "picture") o.pose = scene === 5 ? 0 : 1;
    }
    if (scene === 0)
      for (let i = 0; i < 3; i++)
        if (b(0x1f50 + i) && !b(0x1f48 + i))
          objects.push({
            kind: "original-effect",
            source: w(0x1f5f + 2 * i),
            rect: rect(w(0x1f42 + 2 * i), 0x802),
          });
    if (scene === 7)
      for (let p = 0x2e26; w(p) !== 65535; p += 4) {
        const source = w(p),
          r = [...xy(w(p + 2)), 32, 24];
        objects.push({
          kind: "cupid",
          scenery: true,
          rect: r,
          inkRect: ink(data, source, r, 1),
          flip: source === 0x2d20,
        });
      }
    if (scene === 0 && this.binDraws !== undefined)
      objects = [
        ...objects.filter((o) => o.kind !== "bin"),
        ...structuredClone(this.binDraws),
      ];
    if (this.enemyDraw !== undefined) {
      objects = objects.filter((o) => o.kind !== "dog");
      if (this.enemyDraw?.scene === scene && ![2, 7].includes(scene))
        objects.push(structuredClone(this.enemyDraw));
    }
    return {
      scene,
      tick,
      ip,
      x: w(0x579),
      y: b(0x57b),
      hd: b(0x56e),
      vd: b(0x571),
      playerRect: pd?.rect || rect(w(0x55f), w(0x561)),
      playerInkRect: pd?.ink || null,
      playerFullInkRect: pd?.fullInk || null,
      playerSource: pd?.fullSource ?? pd?.sprite ?? null,
      playerEating: !!pd?.eating,
      eatFrame: (b(0x44d0) >>> 7) & 1,
      eatFlip: w(0x44d1) === 0x4184,
      playerVisible: !!pd,
      playerIdle: !!pd?.idle,
      walkFrame: pd?.walk ?? b(0x56b),
      playerIdleParts: pd?.parts ? structuredClone(pd.parts) : null,
      entry: b(0x558),
      transfer: scene === 4 ? b(0x39e1) : 0,
      sprite: w(0x55d),
      lives: gameover ? 0 : b(0x1f80),
      score: Array.from(data.subarray(0x1f82, 0x1f89)).join(""),
      difficulty,
      pending: !!b(0x418),
      completed: w(0x414),
      practice: null,
      gameover,
      objects,
      remaining: { 2: b(0x3410), 3: b(0x37af), 4: b(0x3ed8), 6: b(0x44d6) }[
        scene
      ],
      air:
        scene === 2
          ? Math.max(
              0,
              1 -
                ((tick - w(0x5f1)) & 65535) /
                  Math.max(1, w(0x589 + 2 * difficulty)),
            )
          : null,
      sounds: [],
      final: null,
      speakerHz: 0,
      cga: base64(cga),
      palette,
      supports: scene === 0 ? Array.from(data.subarray(0x1016, 0x1025)) : [],
      laundry:
        scene === 0 && this.laundry !== null
          ? this.laundry.map((o) => ({ ...o }))
          : null,
      alleyDetails: scene === 0 ? structuredClone(this.alleyDetails) : null,
      effects: structuredClone(this.effects),
      scroll: b(0x525),
      movingRow: w(0x52f),
    };
  }
  save() {
    return structuredClone({
      player: this.player,
      inks: [...this.inks],
      drawSprites: [...this.drawSprites],
      effects: this.effects,
      laundry: this.laundry,
      enemyDraw: this.enemyDraw,
      alleyDetails: this.alleyDetails,
      binDraws: this.binDraws,
    });
  }
  load(s) {
    this.player = structuredClone(s.player);
    this.laundry = structuredClone(s.laundry ?? null);
    this.enemyDraw = structuredClone(s.enemyDraw);
    this.alleyDetails = structuredClone(s.alleyDetails ?? null);
    this.binDraws = structuredClone(s.binDraws);
    this.inks = new Map(s.inks);
    this.drawSprites = new Map(s.drawSprites ?? []);
    this.effects = structuredClone(s.effects ?? []);
  }
}
