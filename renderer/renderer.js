import { paintCinematic } from "./cinematics.js";
import {
  ALLEY_ART,
  BIN_ART,
  INTERIOR_ART,
  binPatches,
  chairPatches,
  windowPatches,
  interiorTriangles,
  triangleTransform,
} from "./registration.js";
import { paintFenceGlyph } from "./fence-lettering.js";
import { paintOriginalOutline } from "./original-outlines.js";
import { LAUNDRY_TILES, LAUNDRY_BY_KIND, laundryFromCga } from "./laundry.js";
// The renderer reads state only. Coordinates and outcomes belong to the executable.
export const ROOMS = [
  [
    "The moonlit alley",
    "Climb the bins and clotheslines. Drop into an open window.",
  ],
  ["The fishbowl parlor", "Leap into the fishbowl on the right."],
  ["Under the surface", "Catch every fish. Return to the surface for air."],
  ["The midnight library", "Reach the shelves and knock down all three vases."],
  [
    "The cheese pantry",
    "Catch four mice. Space travels through the cheese holes.",
  ],
  ["The gilded cage", "Push the cage off the table, then catch the bird."],
  ["Let sleeping dogs lie", "Hold Space by each bowl. Watch the dogs."],
  [
    "A little romance",
    "Climb the hearts to your sweetheart. Space uses gifts.",
  ],
];
const imageCache = new Map();
export const ART_KEYS = [
  "solid-heart-v1",
  "idle-cat-v1",
  "beckoning-neighbor-v1",
  "cat",
  "cat-vertical-v1",
  "eating-contact-v3",
  "swim-cat",
  "dog",
  "mouse",
  "window-v2",
  "structure-v2",
  "furniture-v2",
  "event-props-v2",
  "cheese-hole",
  "cages-contact-v3",
  "flowers-v2",
  "laundry-exact",
  "alley-litter-v1",
  "fence-holes-v1",
  "fight-v1",
  "flight-spider-v1",
  "sleeping-dogs-v1",
  "cheese-actors-v1",
  "aquarium-swim-v1",
  "room-details",
  "broom-swing-v1",
  "fishbowl-cycle-v1",
  "result-scenes-v1",
  "courtship-cycle-v2",
  "cheese-transfer-v2",
];
export const loadImage = (src) => {
  if (imageCache.has(src)) return imageCache.get(src);
  const promise = new Promise((resolve, reject) => {
    const i = new Image();
    i.onload = () => resolve(i);
    i.onerror = () => {
      imageCache.delete(src);
      reject(Error("Could not load " + src));
    };
    i.src = src;
  });
  imageCache.set(src, promise);
  return promise;
};
// One affine world transform. Original CGA pixels have a 1:1.2 display aspect.
export const projectRect = ([x, y, w, h]) => [
  x * 4.5,
  y * 5.4,
  w * 4.5,
  h * 5.4,
];
// Match the image actually selected by the original drawing routine. Velocity
// can already have changed while the previous airborne image is still drawn.
const AIRBORNE_ART = new Map([
  [0x0a2e, ["cat-vertical-v1", 0, false]], // straight-up leap, back view
  [0x09da, ["cat-vertical-v1", 1, false]], // clothesline hold, back view
  [0x0a7c, ["cat-vertical-v1", 2, false]], // straight-down fall, front view
  [0x0b12, ["cat", 5, true]],
  [0x0aca, ["cat", 5, false]],
  [0x0b96, ["cat", 6, true]],
  [0x0b5a, ["cat", 6, false]],
]);
const WALK_SOURCES = [
  0xbd2, 0xc14, 0xc98, 0xc56, 0xcda, 0xd1c, 0xd5e, 0xda0, 0xe24, 0xde2, 0xe66,
  0xea8,
];
export function playerArtwork(s) {
  if (s.playerEating) return ["eating-contact-v3", s.eatFrame, s.eatFlip];
  if (s.scene === 2)
    return ["swim-cat", s.y < 5 ? 3 : s.walkFrame % 3, s.hd === 255];
  if (!s.playerIdle) {
    const exact = AIRBORNE_ART.get(s.playerSource ?? s.sprite);
    if (exact) return exact;
    const walk = WALK_SOURCES.indexOf(s.playerSource ?? s.sprite);
    if (walk >= 0) return ["cat", [0, 1, 2, 3, 2, 1][walk % 6], walk >= 6];
  }
  const pose = s.playerIdle
    ? 4
    : s.vd === 255
      ? 5
      : s.vd === 1
        ? 6
        : s.hd
          ? [0, 1, 2, 3, 2, 1][s.walkFrame % 6]
          : 4;
  return ["cat", pose, s.hd === 255];
}
export class Painter {
  constructor(canvas) {
    this.canvas = canvas;
    this.g = canvas.getContext("2d");
    this.images = {};
    this.cga = document.createElement("canvas");
    this.cga.width = 320;
    this.cga.height = 200;
    this.cg = this.cga.getContext("2d");
    this.pixels = this.cg.createImageData(320, 200);
    this.current = null;
    this.graphics = false;
    this.geometry = false;
    this.ghost = false;
  }
  async load(progress) {
    if (this.loaded) {
      progress?.(1);
      return;
    }
    const delivery = await fetch(
      new URL("../data/asset-delivery.json", import.meta.url),
    ).then((r) => {
      if (!r.ok) throw Error("Could not load artwork manifest");
      return r.json();
    });
    this.atlas = await fetch(
      new URL("../data/atlas.json", import.meta.url),
    ).then((r) => r.json());
    const entries = [
      ["wall", "../" + ALLEY_ART.file],
      ["bin-contact", "../" + BIN_ART.file],
      ["chair-contact", "../assets/chair-contact-v3.png"],
      ["interior", "../" + INTERIOR_ART],
      ["menu", "../assets/backdrop.png"],
      ["room2", "../assets/room-2.png"],
      ["room7", "../assets/room-7.png"],
      ...ART_KEYS.map((k) => [k, "../" + this.atlas[k].file]),
    ];
    let n = 0;
    await Promise.all(
      entries.map(async ([k, src]) => {
        this.images[k] = await loadImage(
          new URL(delivery[src.slice(3)] ?? src, import.meta.url).href,
        );
        progress?.(++n / entries.length);
      }),
    );
    this.loaded = true;
  }
  update(s) {
    this.current = s;
    const bytes = atob(s.cga),
      data = this.pixels.data;
    if (s.scene === 0) {
      const occluders = s.objects
        .filter((o) => !o.scenery && !["bin", "windowpane"].includes(o.kind))
        .map((o) => o.inkRect ?? o.rect);
      if (s.playerVisible) occluders.push(s.playerRect);
      this.laundry =
        s.laundry ??
        laundryFromCga(
          Uint8Array.from(bytes, (c) => c.charCodeAt(0)),
          occluders,
        );
    }
    for (let y = 0; y < 200; y++)
      for (let x = 0; x < 320; x++) {
        const p =
            (bytes.charCodeAt((y & 1) * 8192 + (y >> 1) * 80 + (x >> 2)) >>
              (6 - 2 * (x & 3))) &
            3,
          k = (y * 320 + x) * 4;
        data[k] = s.palette[p][0];
        data[k + 1] = s.palette[p][1];
        data[k + 2] = s.palette[p][2];
        data[k + 3] = 255;
      }
    this.cg.putImageData(this.pixels, 0, 0);
    // Original surface tiles animate at y=4..7. Read their water edge from the
    // same video frame, before drawing the cat over it.
    if (s.scene === 2)
      this.surface = Array.from({ length: 320 }, (_, x) => {
        for (let y = 4; y < 8; y++)
          if (
            ((bytes.charCodeAt((y & 1) * 8192 + (y >> 1) * 80 + (x >> 2)) >>
              (6 - 2 * (x & 3))) &
              3) ===
            1
          )
            return y;
        return 8;
      });
  }
  x(v) {
    return v * 4.5;
  }
  y(v) {
    return v * 5.4;
  }
  // All ink is contained by the executable's draw rectangle; no arbitrary offsets.
  asset(name, pose, rect, { flip = false, alpha = 1 } = {}) {
    if (rect[2] <= 0 || rect[3] <= 0) return;
    const g = this.g,
      b = this.atlas[name].frames[pose % this.atlas[name].frames.length],
      r = projectRect(rect);
    g.save();
    g.globalAlpha = alpha;
    g.translate(r[0] + (flip ? r[2] : 0), r[1]);
    g.scale(flip ? -1 : 1, 1);
    g.drawImage(this.images[name], ...b, 0, 0, r[2], r[3]);
    g.restore();
  }
  // Register painted scenery bands; gameplay coordinates themselves never bend.
  plate(name, sourceY, destY) {
    const im = this.images[name];
    for (let i = 1; i < sourceY.length; i++)
      this.g.drawImage(
        im,
        0,
        sourceY[i - 1],
        im.width,
        sourceY[i] - sourceY[i - 1],
        0,
        this.y(destY[i - 1]),
        1440,
        this.y(destY[i] - destY[i - 1]),
      );
  }
  scenery(s) {
    const g = this.g;
    if (s.scene === 0) {
      this.plate("wall", ALLEY_ART.sourceY, ALLEY_ART.worldY);
      // Contact shading belongs to the ground, beneath all gameplay sprites.
      // Bin positions can vary, so these shadows cannot be baked into the plate.
      g.save();
      g.fillStyle = "#141820";
      for (const o of s.objects.filter((o) => o.kind === "bin")) {
        const base = binPatches(o.rect).at(-1).world,
          cx = base[0] + base[2] / 2,
          foot = base[1] + base[3];
        for (const [rx, ry, opacity] of [
          [16, 2.2, 0.1],
          [14.5, 1.5, 0.18],
          [12, 0.8, 0.2],
        ]) {
          g.globalAlpha = opacity;
          g.beginPath();
          g.ellipse(
            this.x(cx),
            this.y(foot - 0.2),
            this.x(rx),
            this.y(ry),
            0,
            0,
            Math.PI * 2,
          );
          g.fill();
        }
      }
      g.restore();
    } else if (s.scene === 2) {
      g.drawImage(this.images["room" + s.scene], 0, 0, 1440, 1080);
      if (this.surface) {
        g.save();
        g.beginPath();
        g.moveTo(0, 0);
        g.lineTo(1440, 0);
        for (let x = 319; x >= 0; x--)
          g.lineTo(this.x(x + 0.5), this.y(this.surface[x]));
        g.closePath();
        g.fillStyle = "#103946";
        g.fill();
        g.beginPath();
        for (let x = 0; x < 320; x++)
          g[x ? "lineTo" : "moveTo"](this.x(x + 0.5), this.y(this.surface[x]));
        g.strokeStyle = "#baf9ef";
        g.lineWidth = 1.5;
        g.stroke();
        g.restore();
      }
    } else if (s.scene === 7)
      // Use only the empty wallpaper; the original Cupid table owns the border.
      g.drawImage(this.images.room7, 360, 200, 720, 640, 0, 0, 1440, 1080);
    else {
      for (const patch of interiorTriangles(s.scene)) {
        const target = patch.world.map(([x, y]) => [this.x(x), this.y(y)]);
        g.save();
        g.beginPath();
        g.moveTo(...target[0]);
        g.lineTo(...target[1]);
        g.lineTo(...target[2]);
        g.closePath();
        g.clip();
        g.transform(...triangleTransform(patch.source, target));
        g.drawImage(this.images.interior, 0, 0);
        g.restore();
      }
      // Palette tint is decoration only, below all collision-bearing furniture.
      g.save();
      g.globalCompositeOperation = "soft-light";
      g.fillStyle =
        { 3: "#7c773c", 4: "#c46b25", 5: "#b36337", 6: "#3d4380" }[s.scene] ||
        "#376a68";
      g.globalAlpha = 0.35;
      g.fillRect(0, 0, 1440, 1080);
      g.restore();
    }
    for (const o of s.objects.filter((o) => o.scenery)) this.furniture(o);
  }
  furniture(o) {
    const r = o.rect,
      g = this.g;
    if (o.kind === "cupid")
      this.asset("room-details", 2, o.inkRect ?? r, { flip: o.flip });
    else if (o.kind === "picture")
      this.asset(
        "room-details",
        o.pose ?? (this.current.scene === 5 ? 0 : 1),
        r,
      );
    else if (o.kind === "window") {
      for (const patch of windowPatches(r))
        g.drawImage(
          this.images["furniture-v2"],
          ...patch.source,
          ...projectRect(patch.world),
        );
    } else if (o.kind === "bookshelf") {
      // Nine measured shelf edges in the painting registered to 16-pixel rows.
      const im = this.images["structure-v2"],
        src = [30, 170, 258, 348, 438, 528, 618, 708, 857];
      for (let i = 0; i < 8; i++)
        g.drawImage(
          im,
          21,
          src[i],
          756,
          src[i + 1] - src[i],
          this.x(r[0]),
          this.y(r[1] + 16 * i),
          this.x(r[2]),
          this.y(16),
        );
    } else if (o.kind === "cheese") {
      const im = this.images["structure-v2"],
        sx = [885, 1261, 1740],
        sy = [223, 509, 857],
        dx = [24, 128, 224],
        dy = [32, 80, 168];
      g.save();
      g.beginPath();
      g.moveTo(this.x(24), this.y(32));
      g.lineTo(this.x(128), this.y(32));
      g.lineTo(this.x(224), this.y(80));
      g.lineTo(this.x(224), this.y(168));
      g.lineTo(this.x(24), this.y(168));
      g.closePath();
      g.clip();
      for (let y = 0; y < 2; y++)
        for (let x = 0; x < 2; x++)
          g.drawImage(
            im,
            sx[x],
            sy[y],
            sx[x + 1] - sx[x],
            sy[y + 1] - sy[y],
            this.x(dx[x]),
            this.y(dy[y]),
            this.x(dx[x + 1] - dx[x]),
            this.y(dy[y + 1] - dy[y]),
          );
      g.restore();
    } else if (o.kind.startsWith("chair")) {
      const right = o.kind === "chair-r";
      g.save();
      g.translate(this.x(r[0] + (right ? r[2] : 0)), 0);
      if (right) g.scale(-1, 1);
      for (const patch of chairPatches(r, right))
        g.drawImage(
          this.images["chair-contact"],
          ...patch.source,
          ...projectRect(patch.world),
        );
      g.restore();
    } else {
      this.asset(
        "furniture-v2",
        { table: 1, pedestal: 2, window: 3, lamp: 4, picture: 5 }[o.kind],
        r,
      );
      if (o.kind === "lamp") {
        // The original lamp has a pull-chain to the right of its stem.
        g.save();
        g.strokeStyle = "#f6d195";
        g.lineWidth = 1.8;
        g.beginPath();
        g.moveTo(this.x(r[0] + 18), this.y(r[1] + 15));
        g.lineTo(this.x(r[0] + 18), this.y(r[1] + 22));
        g.stroke();
        g.fillStyle = "#f6d195";
        g.beginPath();
        g.ellipse(
          this.x(r[0] + 18),
          this.y(r[1] + 22.5),
          this.x(0.85),
          this.y(1.2),
          0,
          0,
          Math.PI * 2,
        );
        g.fill();
        g.restore();
      }
    }
  }
  draw(now, paused = false) {
    const g = this.g,
      s = this.current;
    g.clearRect(0, 0, 1440, 1080);
    if (!s) {
      g.drawImage(this.images.menu, 0, 0, 1440, 1080);
      return;
    }
    if (this.graphics) {
      g.imageSmoothingEnabled = false;
      g.drawImage(this.cga, 0, 0, 1440, 1080);
      g.imageSmoothingEnabled = true;
      return;
    }
    if (s.cinematic) {
      paintCinematic(this, s);
      return;
    }
    this.scenery(s);
    // The same saved state always renders the same frame, including pause/reload.
    if (s.scene === 0) this.alley(s);
    const litter =
      s.scene === 0
        ? (s.alleyDetails?.litter ?? []).map((o) => ({
            ...o,
            kind: "alley-litter",
          }))
        : [];
    const ordered = [...litter, ...s.objects]
      .filter((o) => !o.scenery)
      .sort(
        (a, b) =>
          (["windowpane", "bin", "hole", "heart"].includes(a.kind) ? -1 : 0) -
          (["windowpane", "bin", "hole", "heart"].includes(b.kind) ? -1 : 0),
      );
    for (const o of ordered) {
      const r = o.inkRect ?? o.rect,
        flip = o.d === 255;
      switch (o.kind) {
        case "alley-litter":
          g.save();
          this.clipDetail(o);
          this.asset("alley-litter-v1", o.pose, r);
          g.restore();
          break;
        case "windowpane": {
          this.asset("window-v2", 0, r);
          if (o.opening[3] > 0) {
            g.save();
            g.beginPath();
            g.rect(...projectRect(o.opening));
            g.clip();
            this.asset("window-v2", 1, r);
            if (o.pending) {
              this.asset("room-details", 3, [o.x + 13, o.y + 3, 12, 13]);
              paintOriginalOutline(
                g,
                "window-letters",
                [o.x + 4, o.y, 32, 16],
                "#ffd48d",
              );
            }
            g.restore();
          }
          break;
        }
        case "bin":
          for (const patch of binPatches(r))
            g.drawImage(
              this.images["bin-contact"],
              ...patch.source,
              ...projectRect(patch.world),
            );
          break;
        case "hole":
          this.asset("cheese-hole", 0, o.inkRect);
          break;
        case "popup":
          g.save();
          g.beginPath();
          g.rect(...projectRect(r));
          g.clip();
          this.asset("event-props-v2", 0, [r[0], r[1], r[2], 13]);
          g.restore();
          break;
        case "mouse":
          if (o.cheese) {
            g.save();
            g.beginPath();
            g.rect(...projectRect(o.rect));
            g.clip();
            this.asset("cheese-actors-v1", o.pose ?? 0, o.fullInkRect ?? r);
            g.restore();
          } else this.asset("mouse", o.pose ?? 3, r, { flip });
          break;
        case "fight":
        case "dog":
          g.save();
          g.beginPath();
          g.rect(...projectRect(o.rect));
          g.clip();
          this.asset(
            o.kind === "fight" ? "fight-v1" : "dog",
            o.kind === "fight" ? o.pose : o.d ? o.pose : 3,
            o.fullInkRect ?? r,
            {
              flip: o.kind === "dog" && o.d === 1,
            },
          );
          g.restore();
          break;
        case "projectile":
          g.save();
          g.beginPath();
          g.rect(...projectRect(o.rect));
          g.clip();
          this.asset("event-props-v2", 4 + o.variant, o.fullInkRect ?? r);
          g.restore();
          break;
        case "broom":
          this.asset("broom-swing-v1", o.pose ?? 0, r);
          break;
        case "fishbowl":
          this.asset("fishbowl-cycle-v1", o.pose ?? 0, r);
          break;
        case "fish":
          this.asset("aquarium-swim-v1", o.pose ?? 0, r, { flip });
          break;
        case "eel":
          g.save();
          // At just two original scanlines the textured eel collapsed into a
          // faint smear. Preserve all four original wave silhouettes and their
          // bright/dark contrast, with smooth HD outlines within the same box.
          g.beginPath();
          g.rect(...projectRect(o.rect));
          g.clip();
          {
            const source = o.source ?? 0x3330,
              bright = [0x3330, 0x3340].includes(source);
            paintOriginalOutline(
              g,
              source,
              o.rect,
              bright ? "#f4fff4" : "#071f30",
              bright ? "#d4fff5" : "#06232e",
            );
          }
          g.restore();
          break;
        case "vase":
          this.asset("flowers-v2", 0, r);
          break;
        case "spider":
          this.asset("flight-spider-v1", 3 + (o.pose ?? 0), r);
          break;
        case "cage":
          this.asset("cages-contact-v3", o.open ? 1 : 0, r);
          break;
        case "bird":
          this.asset("flight-spider-v1", o.pose ?? 0, r, { flip });
          break;
        case "food":
          if (o.portions > 0)
            this.asset("result-scenes-v1", 3 + Math.min(4, o.portions), r);
          break;
        case "sleepingdog":
          this.asset("sleeping-dogs-v1", Math.min(2, o.alert), r, {
            flip: o.flip,
          });
          break;
        case "heart":
          this.asset("event-props-v2", o.broken ? 3 : 2, r);
          break;
        case "romancecat":
          this.asset(
            "courtship-cycle-v2",
            !o.source || o.source === 0x4500
              ? 0
              : 1 +
                  (Math.floor(
                    (o.source - (o.source >= 0x48b0 ? 0x48b0 : 0x4700)) / 72,
                  ) %
                    6),
            r,
            { flip: o.source >= 0x48b0 },
          );
          break;
        case "arrow":
          paintOriginalOutline(
            g,
            o.source ?? (o.d === 255 ? 0x6f30 : 0x6ff0),
            o.rect,
            "#ffd875",
            "#824512",
          );
          break;
        case "transfercat":
          // The original composite shrinks and finally erases the cat; it never fades.
          {
            const pose = [0x39ea, 0x3a2a, 0x3a6a, 0x3aaa].indexOf(o.source);
            if (pose >= 0) this.asset("cheese-transfer-v2", pose, r);
          }
          break;
        case "floor-mark":
          paintOriginalOutline(
            g,
            o.source ?? 0x32b8 + 10 * o.count,
            o.rect,
            "#241711",
          );
          break;
        case "original-effect":
          this.effect(o);
          break;
        case "gift":
          this.asset("event-props-v2", 1, r);
          break;
      }
    }
    this.paintPlayer(s);
    for (const o of s.effects ?? []) this.effect(o);
    if (this.ghost) {
      g.save();
      g.globalAlpha = 0.38;
      g.imageSmoothingEnabled = false;
      g.drawImage(this.cga, 0, 0, 1440, 1080);
      g.restore();
    }
    if (this.geometry) {
      g.save();
      g.lineWidth = 1.5;
      g.font = "13px monospace";
      for (const o of [...s.objects, { kind: "player", rect: s.playerRect }]) {
        g.strokeStyle = o.scenery
          ? "#eac46f"
          : o.kind === "player"
            ? "#fff"
            : "#74ffc5";
        g.strokeRect(...projectRect(o.rect));
        const ink = o.inkRect ?? (o.kind === "player" ? s.playerInkRect : null);
        if (ink) {
          g.strokeStyle = "#ffb45c";
          g.strokeRect(...projectRect(ink));
        }
        g.fillStyle = g.strokeStyle;
        g.fillText(o.kind, this.x(o.rect[0]) + 2, this.y(o.rect[1]) - 3);
      }
      g.restore();
    }
  }
  paintPlayer(s) {
    const g = this.g;
    if (s.playerVisible && !s.transfer) {
      if (s.playerIdle && s.playerIdleParts?.length) {
        for (const part of s.playerIdleParts) {
          const pose = part.head
            ? ({ [0xeea]: 0, [0xf02]: 1, [0xf1a]: 2 }[part.source] ?? 0)
            : ({ [0xf32]: 3, [0xf4a]: 4, [0xf62]: 5 }[part.source] ?? 3);
          this.asset("idle-cat-v1", pose, part.inkRect, {
            flip: part.head && pose === 1,
          });
        }
        return;
      }
      const [art, pose, flip] = playerArtwork(s);
      const rect = [...(s.playerInkRect ?? s.playerRect)];
      g.save();
      if (s.playerFullInkRect) {
        g.beginPath();
        g.rect(...projectRect(s.playerRect));
        g.clip();
        rect.splice(0, 4, ...s.playerFullInkRect);
      }
      if (s.scene === 0 && s.entry && s.playerRect[2] < 24) {
        rect.splice(0, 4, ...s.playerRect);
        g.beginPath();
        g.rect(...projectRect(rect));
        g.clip();
        if (s.hd !== 255) rect[0] -= 24 - rect[2];
        rect[2] = 24;
      }
      this.asset(art, pose, rect, { flip });
      g.restore();
    }
  }
  clipDetail(o) {
    this.g.beginPath();
    for (const r of o.clips ?? [o.inkRect]) this.g.rect(...projectRect(r));
    this.g.clip();
  }
  effect(o) {
    paintOriginalOutline(
      this.g,
      o.source + "-back",
      o.rect,
      "#fff0c7",
      "#512335",
    );
    paintOriginalOutline(this.g, o.source, o.rect, "#e68c43", "#512335");
  }
  alley(s) {
    const g = this.g;
    for (const o of s.alleyDetails?.holes ?? []) {
      g.save();
      this.clipDetail(o);
      this.asset("fence-holes-v1", o.pose, o.inkRect);
      g.restore();
    }
    // The original glyph outlines contain their own irregular angles. Keep
    // both those angles and the original rising/falling character placements.
    for (const o of s.alleyDetails?.glyphs ?? []) {
      const r = projectRect(o.inkRect);
      if (r[2] <= 0 || r[3] <= 0) continue;
      g.save();
      this.clipDetail(o);
      g.fillStyle = "#12282a";
      paintFenceGlyph(g, o);
      g.restore();
    }
    for (let row = 0; row < (s.title ? 0 : 3); row++) {
      const yy = [9, 41, 73][row];
      g.strokeStyle = "#d4b98f";
      g.lineWidth = 2;
      g.beginPath();
      g.moveTo(0, this.y(yy));
      g.lineTo(1440, this.y(yy));
      g.stroke();
    }
    for (const o of this.laundry ?? []) {
      const t = LAUNDRY_BY_KIND[o.kind],
        [x, y, w, h] = t.ink;
      if (o.x + x + w <= 0 || o.x + x >= 320) continue;
      this.asset("laundry-exact", LAUNDRY_TILES.indexOf(t), [
        o.x + x,
        o.y + y,
        w,
        h,
      ]);
    }
  }
}
