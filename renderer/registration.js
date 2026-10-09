// Measured source-art landmarks registered to ORIGINAL world coordinates.
// These transforms apply to artwork only. Player/collision coordinates never warp.
export const ALLEY_ART = {
  file: "assets/alley-wall-v3.png",
  // Measured fence top and fence/pavement seam in the regenerated painting.
  sourceY: [0, 558, 905, 1086],
  // Both can heights end at Y=187; the seam must sit BEHIND their bases.
  worldY: [0, 108, 172, 200],
};
export const BIN_ART = {
  file: "assets/bin-open-v4.png",
  // Loose diagonal lid and exposed mouth, matching DS:2976's 12-row cap.
  // The original flat support plane is y+6 even though its lid is sloped.
  lid: [160, 128, 704, 332],
  landingY: 280,
  body: [171, 460, 684, 800],
  base: [171, 1260, 684, 154],
};
// Register the four perspective corners without stretching a thin floor strip
// across the entire screen. Texture triangles preserve detail within each plane.
export const INTERIOR_ART = "assets/interior-aligned-v3.png";
export function interiorTriangles(scene) {
  const sx = [0, 116, 1422, 1536],
    dx = [0, 16, 304, 320],
    shift = scene === 6 ? 40 : 0,
    sy = [
      [0, 0, 0, 0],
      [128, 241, 241, 128],
      [765, 731, 731, 765],
      [1024, 1024, 1024, 1024],
    ],
    dy = [
      [0, 0, 0, 0],
      [40, 56, 56, 40].map((y) => y - shift),
      [168, 152, 152, 168].map((y) => y - shift),
      [200, 200, 200, 200],
    ],
    out = [];
  for (let y = 0; y < 3; y++)
    for (let x = 0; x < 3; x++)
      for (const corners of [
        [
          [x, y],
          [x + 1, y],
          [x + 1, y + 1],
        ],
        [
          [x, y],
          [x + 1, y + 1],
          [x, y + 1],
        ],
      ])
        out.push({
          source: corners.map(([i, j]) => [sx[i], sy[j][i]]),
          world: corners.map(([i, j]) => [dx[i], dy[j][i]]),
        });
  return out;
}
export function triangleTransform(source, target) {
  const [[x0, y0], [x1, y1], [x2, y2]] = source,
    [[u0, v0], [u1, v1], [u2, v2]] = target,
    d = (x1 - x0) * (y2 - y0) - (x2 - x0) * (y1 - y0),
    a = ((u1 - u0) * (y2 - y0) - (u2 - u0) * (y1 - y0)) / d,
    c = ((x1 - x0) * (u2 - u0) - (x2 - x0) * (u1 - u0)) / d,
    b = ((v1 - v0) * (y2 - y0) - (v2 - v0) * (y1 - y0)) / d,
    e = ((x1 - x0) * (v2 - v0) - (x2 - x0) * (v1 - v0)) / d;
  return [a, b, c, e, u0 - a * x0 - c * y0, v0 - b * x0 - e * y0];
}
export const CHAIR_ART = {
  x: [128, 432, 932],
  y: [76, 170, 828, 950, 1454],
  worldY: [0, 4, 30, 36, 53],
};
export function binPatches([x, y, w, h]) {
  const b = BIN_ART,
    bodyHeight = h - 23,
    [lx, ly, lw, lh] = b.lid;
  return [
    { source: [lx, ly, lw, b.landingY - ly], world: [x + 3, y + 1, 30, 5] },
    {
      source: [lx, b.landingY, lw, ly + lh - b.landingY],
      world: [x + 3, y + 6, 30, 6],
    },
    { source: b.body, world: [x + 3, y + 12, 27, bodyHeight] },
    { source: b.base, world: [x + 3, y + 12 + bodyHeight, 27, 11] },
  ];
}
export function chairPatches([x, y, w, h], right = false) {
  const a = CHAIR_ART,
    xs = right ? [0, 24, 32] : [0, 20, 36],
    ys = [0, 4, 30, 36, h],
    out = [];
  for (let j = 0; j < ys.length - 1; j++)
    for (let i = 0; i < xs.length - 1; i++)
      out.push({
        source: [a.x[i], a.y[j], a.x[i + 1] - a.x[i], a.y[j + 1] - a.y[j]],
        world: [xs[i], y + ys[j], xs[i + 1] - xs[i], ys[j + 1] - ys[j]],
      });
  return out;
}

// DS:2540's top six rows are blank. The black opening is precisely 32x16
// at (+16,+8); curtain hems extend to +32, not the bottom of the opening.
export function windowPatches([x, y]) {
  return [
    { source: [56, 536, 595, 49], world: [x, y + 6, 64, 2] },
    { source: [56, 585, 148, 375], world: [x, y + 8, 16, 24] },
    { source: [502, 585, 149, 375], world: [x + 48, y + 8, 16, 24] },
    { source: [204, 574, 298, 324], world: [x + 16, y + 8, 32, 16] },
  ];
}
