// Original CGA garment templates, recovered from DS:0440..04CF.
// Support bits encode 8-pixel collision cells, not the number or kind of clothes.
export const LAUNDRY_TILES = [
  {
    name: "small",
    source: 1152,
    width: 8,
    height: 8,
    bytes: [
      175, 170, 255, 212, 255, 254, 191, 255, 175, 255, 175, 254, 175, 250, 175,
      170,
    ],
    ink: [0, 0, 8, 8],
  },
  {
    name: "sock-left",
    source: 1088,
    width: 8,
    height: 8,
    bytes: [
      175, 250, 79, 244, 175, 250, 175, 250, 175, 250, 191, 250, 255, 250, 254,
      170,
    ],
    ink: [0, 0, 6, 8],
  },
  {
    name: "sock-right",
    source: 1104,
    width: 8,
    height: 8,
    bytes: [
      191, 234, 127, 196, 191, 234, 191, 234, 191, 234, 191, 250, 191, 254, 170,
      254,
    ],
    ink: [1, 0, 6, 8],
  },
  {
    name: "wide",
    source: 1120,
    width: 16,
    height: 8,
    bytes: [
      190, 170, 171, 234, 127, 196, 127, 196, 191, 234, 191, 234, 191, 250, 255,
      234, 171, 255, 254, 170, 171, 255, 254, 170, 170, 191, 234, 170, 170, 170,
      170, 170,
    ],
    ink: [1, 0, 12, 7],
  },
  {
    name: "long",
    source: 1168,
    width: 16,
    height: 16,
    bytes: [
      175, 170, 170, 250, 255, 17, 31, 255, 255, 234, 175, 255, 255, 250, 255,
      255, 250, 255, 255, 175, 250, 247, 255, 175, 170, 255, 255, 170, 170, 247,
      255, 170, 170, 255, 255, 170, 170, 247, 255, 170, 170, 255, 255, 234, 170,
      247, 255, 234, 171, 255, 239, 250, 171, 254, 175, 250, 175, 234, 170, 250,
      170, 170, 171, 234,
    ],
    ink: [0, 0, 16, 16],
  },
];
export const LAUNDRY_BY_KIND = Object.fromEntries(
  LAUNDRY_TILES.map((t) => [t.name, t]),
);
const pixel = (bytes, x, y) =>
  (bytes[(y & 1) * 8192 + (y >> 1) * 80 + (x >> 2)] >> (6 - 2 * (x & 3))) & 3;
// Read-only fallback for legacy/reference hosts that don't publish strip draws.
// Ignore actor-covered pixels, and prefer whole wide garments over fragments.
export function laundryFromCga(bytes, occluders = []) {
  const out = [];
  const templates = [...LAUNDRY_TILES].sort(
    (a, b) => b.width * b.height - a.width * a.height,
  );
  for (const y of [8, 40, 72]) {
    const taken = [];
    for (const t of templates)
      for (let x = -12; x < 320; x += 4) {
        if (
          x + t.width <= 0 ||
          taken.some(([a, b]) => x < b && x + t.width > a)
        )
          continue;
        let seen = 0,
          ok = true;
        for (let yy = 0; yy < 16 && ok; yy++)
          for (let xx = 0; xx < t.width; xx++) {
            const px = x + xx,
              py = y + yy;
            if (
              px < 0 ||
              px >= 320 ||
              occluders.some(
                ([a, b, w, h]) =>
                  px >= a && px < a + w && py >= b && py < b + h,
              )
            )
              continue;
            const expected =
              yy < t.height &&
              ((t.bytes[(yy * t.width + xx) >> 2] >> (6 - 2 * (xx & 3))) &
                3) ===
                3;
            const actual = pixel(bytes, px, py) === 3;
            if (expected !== actual) {
              ok = false;
              break;
            }
            if (actual) seen++;
          }
        if (ok && seen) {
          out.push({ kind: t.name, x, y });
          taken.push([x, x + t.width]);
        }
      }
  }
  return out.sort((a, b) => a.y - b.y || a.x - b.x);
}
