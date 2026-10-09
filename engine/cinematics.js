// Read-only observations of original title, wipes, rewards and rejection.
import { rect, xy, ink } from "./presentation.js";
export const CINEMATIC_SITES = new Set([
  0x1bf0, 0x1caf, 0x1c1e, 0x1c60, 0x1cce, 0x1c66, 0x1d76, 0x1dc6, 0x1e3a,
  0x38b0, 0x39a7, 0x39db, 0x2b40, 0x528b, 0x50ff, 0x5110, 0x514a, 0x5202,
  0x5313, 0x5398, 0x6040, 0x607a, 0x60b9, 0x60f2, 0x5be0, 0x5c0a, 0x5c33,
  0x5c4e, 0x519b, 0x3a96,
]);
export class Cinematics {
  constructor() {
    this.view = null;
    this.background = null;
    this.heads = [];
    this.headMask = 65535;
    this.particles = new Map();
    this.resume = null;
  }
  observe(ip, c, last) {
    const b = (a) => c.m8(0x10100 + a),
      w = (a) => c.m16(0x10100 + a),
      r = c.r;
    const begin = (kind) => {
      this.view = { kind, start: c.tick, previous: w(6), scene: w(4) };
    };
    if (ip === 0x1bf0) {
      this.background = last
        ? structuredClone({
            ...last,
            cinematic: null,
            originalInterlude: false,
          })
        : null;
      begin("wipe");
    }
    if (ip === 0x1c1e || ip === 0x1c60) {
      if (this.view && this.view.kind !== "wipe" && last)
        this.background = { ...last, cinematic: this.frame() };
      begin("wipe");
      this.view.incoming = ip === 0x1c60;
      this.view.rect = [0, 0, 0, 0];
      this.view.rows = Array(200).fill(null);
    }
    if (ip === 0x1caf && this.view?.kind === "wipe") {
      // Observe each completed REP STOSW row, not only the previous whole
      // rectangle: browser slices can stop midway through the next expansion.
      const width = (w(0x1835) >> 3) * 8,
        [x, y] = xy((r[7] - width / 4) & 65535);
      if (width && y < 200) {
        this.view.rows ??= Array(200).fill(null);
        const prev = this.view.rows[y];
        this.view.rows[y] = [
          Math.min(prev?.[0] ?? x, x),
          Math.max(prev?.[1] ?? 0, Math.min(320, x + width)),
        ];
      }
    }
    if (ip === 0x1cce && this.view?.kind === "wipe")
      this.view.rect = [w(0x1832), b(0x1834), (w(0x1835) >> 3) * 8, b(0x1837)];
    if (ip === 0x1d76) {
      begin("failure");
      this.view.failed = !!b(0x552);
    }
    if (ip === 0x1dc6 && this.view?.kind === "failure") this.view.source = r[0];
    if (ip === 0x1e3a && this.view?.kind === "failure") {
      this.view.source = w(0x1c2e);
      this.view.mask = w(0x1c1b);
      this.view.rect = rect(r[7], r[1]);
    }
    if (ip === 0x528b) {
      begin("romance");
      this.view.elements = [];
      this.particles.clear();
    }
    if (ip === 0x50ff && this.view) {
      this.view.heart = rect(r[7], r[1]);
      this.view.couple = null;
      (this.view.elements ??= []).push({ pose: 0, rect: this.view.heart });
    }
    if (ip === 0x5110 && this.view) {
      this.view.couple = rect(r[7], r[1]);
      (this.view.elements ??= []).push({ pose: 1, rect: this.view.couple });
    }
    if (ip === 0x514a) {
      const elements = this.view?.elements ?? [];
      begin("hearts");
      this.view.elements = elements;
      this.particles.clear();
    }
    if (ip === 0x5202 && this.view?.kind === "hearts") {
      // The original zero-transparent blitter never erases these hearts.
      // Preserve every distinct stamp across all three sizes, not just the
      // latest position of each of the eight moving hearts.
      const key = `${r[6]}:${r[7]}:${r[1]}`;
      this.particles.set(
        key,
        ink(c.mem.subarray(0x10100, 0x20100), r[6], rect(r[7], r[1]), 0),
      );
    }
    if (ip === 0x38b0) {
      this.resume =
        this.view?.kind === "romance" ? structuredClone(this.view) : null;
      begin("bonus");
      this.heads = [];
    }
    if (ip === 0x3a96) this.headMask = r[2];
    if (ip === 0x2b40 && this.view?.kind === "bonus") {
      const p = [...xy(r[7]), (r[1] & 255) * 4, r[1] >>> 8],
        head = { rect: p, bright: this.headMask === 65535 },
        i = this.heads.findIndex((x) => x.rect.join() === p.join());
      if (i < 0) this.heads.push(head);
      else this.heads[i] = head;
    }
    if (ip === 0x39a7 && this.view?.kind === "bonus") {
      this.view.value = Array.from(c.mem.subarray(0x1378d, 0x13794)).join("");
      this.view.label =
        w(6) === 7
          ? String.fromCharCode(...c.mem.subarray(0x1380e, 0x13822))
          : null;
      this.view.numberY = b(0x369e);
    }
    if (ip === 0x39db && this.resume) {
      this.view = this.resume;
      this.resume = null;
    }
    if (ip === 0x5313 && w(8) >= 2) {
      begin("dance");
      this.particles.clear();
    }
    if (ip === 0x5398 && this.view?.kind === "dance")
      this.particles.set(r[7], {
        rect: rect(r[7], r[1]),
        pose: r[6] === w(0x5012) ? 7 : 8,
      });
    if (ip === 0x6040) {
      begin("rejection");
    }
    if (ip === 0x5be0) {
      begin("beckon");
      this.particles.clear();
    }
    if (ip === 0x5c0a && this.view?.kind === "beckon") {
      this.view.pose = r[6] === w(0x5f62) ? 0 : 1;
      this.view.rect = rect(r[7], r[1]);
    }
    if ((ip === 0x5c33 || ip === 0x5c4e) && this.view?.kind === "beckon")
      this.particles.set(r[7], { source: r[6], rect: rect(r[7], r[1]) });
    if ((ip === 0x607a || ip === 0x60b9) && this.view?.kind === "rejection") {
      this.view.rect = rect(r[7], r[1]);
      this.view.final = ip === 0x60b9;
    }
  }
  frame() {
    return this.view
      ? {
          ...structuredClone(this.view),
          spans:
            this.view.kind === "wipe"
              ? this.view.rows?.reduce((out, row, y) => {
                  if (row) {
                    const last = out.at(-1);
                    if (
                      last &&
                      last[0] === row[0] &&
                      last[2] === row[1] - row[0] &&
                      last[1] + last[3] === y
                    )
                      last[3]++;
                    else out.push([row[0], y, row[1] - row[0], 1]);
                  }
                  return out;
                }, [])
              : undefined,
          background: this.background,
          underlay: structuredClone(this.resume),
          heads: structuredClone(this.heads),
          particles: structuredClone([...this.particles.values()]),
        }
      : null;
  }
  clear() {
    this.view = null;
    this.background = null;
    this.resume = null;
    this.heads = [];
    this.particles.clear();
  }
  save() {
    return structuredClone({
      view: this.view,
      background: this.background,
      heads: this.heads,
      headMask: this.headMask,
      particles: [...this.particles],
      resume: this.resume,
    });
  }
  load(s) {
    this.clear();
    if (s) {
      Object.assign(this, structuredClone(s));
      this.particles = new Map(s.particles);
    }
  }
}
