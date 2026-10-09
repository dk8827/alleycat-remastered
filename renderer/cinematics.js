// HD equivalents of original noninteractive sequences. All progress/coordinates
// arrive from original execution; this painter never advances their clocks.
import { paintOriginalOutline } from "./original-outlines.js";
function text(p, value, r, color = "#ffe1a0", italic = false) {
  const g = p.g,
    [x, y, w, h] = r;
  g.save();
  g.font = `${italic ? "italic " : ""}bold 100px Georgia`;
  g.textAlign = "left";
  g.textBaseline = "alphabetic";
  const m = g.measureText(value),
    left = m.actualBoundingBoxLeft ?? 0,
    right = m.actualBoundingBoxRight ?? m.width ?? 1,
    ascent = m.actualBoundingBoxAscent ?? 75,
    descent = m.actualBoundingBoxDescent ?? 0;
  g.translate(p.x(x + w / 2), p.y(y + h / 2));
  // Fit visible glyph ink, not a 100px em box with invisible font padding.
  g.scale(
    p.x(w) / Math.max(1, left + right),
    p.y(h) / Math.max(1, ascent + descent),
  );
  g.fillStyle = color;
  g.fillText(value, (left - right) / 2, (ascent - descent) / 2);
  g.restore();
}
function background(p, s) {
  const save = p.current,
    laundry = p.laundry;
  if (s) {
    p.current = { ...s, originalInterlude: false };
    p.laundry = s.title ? [] : (s.laundry ?? p.laundry);
    p.draw(0, true);
  } else {
    p.g.fillStyle = "#101c23";
    p.g.fillRect(0, 0, 1440, 1080);
  }
  p.current = save;
  p.laundry = laundry;
}
export function paintCinematic(p, s) {
  const g = p.g,
    e = s.cinematic;
  if (e.kind === "intro" || e.kind === "gameover") {
    background(p, {
      ...s,
      cinematic: null,
      objects: s.objects.filter((o) => o.kind !== "windowpane"),
      laundry: [],
      title: true,
      playerVisible: false,
    });
    g.fillStyle = "#071018b0";
    g.fillRect(0, 0, 1440, 1080);
    text(p, "IBM", [132, 4, 56, 15], "#cbb68a");
    text(p, "PRESENTS", [120, 24, 80, 9], "#cbb68a");
    text(p, "ALLEY CAT", [59, 42, 107, 22]);
    text(p, "™", [170, 40, 14, 6], "#cbb68a");
    text(p, "by", [160, 66, 21, 12]);
    text(p, "BILL WILLIAMS", [160, 80, 107, 8]);
    text(p, "© Copyright", [56, 188, 96, 11], "#b9b9aa");
    text(p, "1984", [240, 190, 32, 8], "#b9b9aa");
    if (e.publisherSource)
      paintOriginalOutline(g, e.publisherSource, [160, 186, 80, 12], "#b9b9aa");
    if (e.kind === "gameover") text(p, `SCORE ${s.score}`, [100, 112, 120, 12]);
    else p.paintPlayer(s);
    return;
  }
  if (e.kind === "wipe") {
    background(p, e.background);
    const r = e.rect ?? [0, 0, 0, 0];
    g.save();
    g.beginPath();
    for (const a of e.spans ?? [r])
      g.rect(p.x(a[0]), p.y(a[1]), p.x(a[2]), p.y(a[3]));
    g.clip();
    g.fillStyle = e.incoming ? "#19242a" : "#060a0c";
    g.fillRect(0, 0, 1440, 1080);
    g.restore();
    return;
  }
  if (e.kind === "romance" || e.kind === "hearts") {
    background(p, e.background);
    for (const o of e.elements ?? [])
      p.asset(
        o.pose === 0 ? "solid-heart-v1" : "result-scenes-v1",
        o.pose === 0 ? 0 : o.pose,
        o.rect,
      );
    if (e.kind === "hearts")
      for (const r of e.particles) p.asset("solid-heart-v1", 0, r);
    return;
  }
  g.fillStyle = "#101c23";
  g.fillRect(0, 0, 1440, 1080);
  if (e.kind === "failure") {
    const mask = e.mask ?? 0,
      r = e.rect ?? [128, 94, 64, 12];
    g.save();
    g.beginPath();
    for (let x = 0; x < r[2]; x++)
      if ((mask >> (6 - 2 * (x % 4))) & 3)
        g.rect(p.x(r[0] + x), p.y(r[1]), p.x(1), p.y(r[3]));
    g.clip();
    paintOriginalOutline(g, e.source ?? 0x185b, r, "#ffe3b0");
    g.restore();
  } else if (e.kind === "bonus") {
    if (e.underlay)
      paintCinematic(p, {
        ...s,
        cinematic: { ...e.underlay, background: e.background },
      });
    for (const o of e.heads)
      p.asset("result-scenes-v1", 2, o.rect, { alpha: o.bright ? 1 : 0.32 });
    if (e.value) {
      text(p, e.value.slice(-4), [144, e.numberY ?? 56, 32, 8]);
      if (e.label) text(p, e.label, [80, 80, 160, 8], "#f1d0a4");
    }
  } else if (e.kind === "rejection") {
    if (e.rect) {
      const [x, y] = e.rect;
      p.asset("result-scenes-v1", 3, [x, y, 24, 12]);
      if (e.final) {
        paintOriginalOutline(g, "rejection-bubble", e.rect, "#67d9cb");
        // The original bubble is opaque; its black symbols are holes in the
        // traced fill, so its position and irregular outline stay exact.
      }
    }
  } else if (e.kind === "dance") {
    for (const o of e.particles) p.asset("courtship-cycle-v2", o.pose, o.rect);
  } else if (e.kind === "beckon") {
    if (e.rect) p.asset("beckoning-neighbor-v1", e.pose, e.rect);
    for (const o of e.particles)
      paintOriginalOutline(g, o.source, o.rect, "#69dace");
  }
}
