import { BIOS_FONT } from "./bios-font.js";
// Hardware adapter for statically translated Alley Cat. No x86 instruction decoder.
const C = 1,
  P = 4,
  A = 16,
  Z = 64,
  S = 128,
  O = 2048;
const parity = (n) => {
  n ^= n >>> 4;
  return (0x9669 >>> (n & 15)) & 1 ? P : 0;
};
export const LOOPS = new Set([
  0x15f, 0x3fa, 0x478, 0x3b2, 0x364, 0x31c, 0x2c5, 0x27e,
]);
export const MENUS = new Set([0x5d71, 0x5ef7, 0x5f29, 0x5faa]);
export class CPU {
  constructor(
    exe,
    pages,
    boundaries,
    { realtime = false, cycles = 1500 } = {},
  ) {
    // The block clock is retained only for the existing controlled-clock oracle.
    // Browser playback uses DOSBox normal-core instruction budgets per millisecond.
    this.realtime = realtime;
    this.cyclesPerSecond = cycles * 1000;
    this.elapsedCycles = 0;
    this.pitLatched = 0;

    this.pages = pages;
    this.boundaries = boundaries;
    this.mem = new Uint8Array(1 << 20);
    this.r = new Uint16Array(12);
    this.f = 2;
    this.ip = 0;
    const word = (p) => exe[p] | (exe[p + 1] << 8);
    this.mem.set(exe.subarray(word(8) * 16), 0x10000);
    for (let i = 0; i < word(6); i++) {
      let p = word(24) + 4 * i,
        a = 0x10000 + word(p + 2) * 16 + word(p);
      this.w16(a, this.m16(a) + 0x1000);
    }
    this.r.set([0, 0, 0, 0, 0x100, 0, 0, 0, 0xff0, 0x1723, 0x1000, 0xff0]);
    this.mem[0xffffe] = 255;
    this.blocks = 0;
    this.steps = 0;
    this.tick = 100;
    this.pit = 0xfa59;
    this.pitPhase = 0;
    this.retrace = 0;
    this.ports = {};
    this.color = 0x30;
    this.overrides = {};
    this.keysHeld = [];
    this.text = [];
    this.cursor = [0, 0];
    this.biosGraphics = false;
    this.mem[0x10100 + 0x697] = 255;
    this.mem[0x10100 + 0x69a] = 0x10;
    this.mem.fill(0x80, 0x10100 + 0x6b7, 0x10100 + 0x6b7 + 22);
    this.w16(0x10100 + 0x2ae5, 0xfa59);
  }
  get seconds() {
    return this.realtime
      ? this.elapsedCycles / this.cyclesPerSecond
      : this.blocks / (256 * (1193182 / 65536));
  }
  get z() {
    return !!(this.f & Z);
  }
  m8(p) {
    return this.mem[p & 0xfffff];
  }
  m16(p) {
    return this.m8(p) | (this.m8(p + 1) << 8);
  }
  w8(p, v) {
    this.mem[p & 0xfffff] = v;
  }
  w16(p, v) {
    this.w8(p, v);
    this.w8(p + 1, v >>> 8);
  }
  push(v) {
    this.r[4] -= 2;
    this.w16(this.r[10] * 16 + this.r[4], v);
  }
  pop() {
    let v = this.m16(this.r[10] * 16 + this.r[4]);
    this.r[4] += 2;
    return v;
  }
  alu(op, a, b, w) {
    const mask = w === 8 ? 255 : 65535,
      sign = 1 << (w - 1);
    a &= mask;
    b &= mask;
    let raw = 0,
      r,
      cf = 0,
      of = 0,
      af = 0,
      keep = 0;
    if (op === "inc" || op === "dec") {
      keep = this.f & C;
      b = 1;
    }
    if (op === "shl" || op === "shr" || op === "rcl" || op === "rcr") {
      if (!b) return a;
      let v = a,
        carry = this.f & C;
      for (let i = 0; i < b; i++) {
        if (op === "shl" || op === "rcl") {
          let old = carry;
          carry = v & sign ? 1 : 0;
          v = ((v << 1) | (op === "rcl" ? old : 0)) & mask;
        } else {
          let old = carry;
          carry = v & 1;
          v = (v >>> 1) | (op === "rcr" ? old * sign : 0);
        }
      }
      if (op === "rcl" || op === "rcr") this.f = (this.f & ~C) | carry;
      else
        this.f =
          (this.f & ~(C | P | Z | S | A)) |
          carry |
          parity(v) |
          (v === 0 ? Z : 0) |
          (v & sign ? S : 0);
      if (b === 1) {
        of =
          op === "shr"
            ? a & sign
              ? O
              : 0
            : op === "rcr"
              ? (v ^ (v << 1)) & sign
                ? O
                : 0
              : (v & sign ? 1 : 0) ^ carry
                ? O
                : 0;
        this.f = (this.f & ~O) | of;
      }
      return v;
    }
    if (op === "add" || op === "adc" || op === "inc") {
      raw = a + b + (op === "adc" ? this.f & C : 0);
      r = raw & mask;
      cf = raw > mask ? C : 0;
      of = ~(a ^ b) & (a ^ r) & sign ? O : 0;
      af = (a ^ b ^ r) & A;
    } else if (op === "sub" || op === "cmp" || op === "dec" || op === "neg") {
      if (op === "neg") {
        b = a;
        a = 0;
      }
      raw = a - b;
      r = raw & mask;
      cf = a < b ? C : 0;
      of = (a ^ b) & (a ^ r) & sign ? O : 0;
      af = (a ^ b ^ r) & A;
    } else {
      r = op === "or" ? a | b : op === "xor" ? a ^ b : a & b;
    }
    if (op === "inc" || op === "dec") cf = keep;
    this.f =
      (this.f & ~(C | P | A | Z | S | O)) |
      cf |
      of |
      af |
      parity(r) |
      (r === 0 ? Z : 0) |
      (r & sign ? S : 0) |
      2;
    return r;
  }
  mul(v, w) {
    let n = (this.r[0] & (w === 8 ? 255 : 65535)) * v;
    this.r[0] = n;
    if (w === 16) this.r[2] = Math.floor(n / 65536);
    this.f = (this.f & ~(C | O)) | (n > (w === 8 ? 255 : 65535) ? C | O : 0);
  }
  aaa() {
    if ((this.r[0] & 15) > 9 || this.f & A) {
      this.r[0] += 0x106;
      this.f |= C | A;
    } else this.f &= ~(C | A);
    this.r[0] &= 0xff0f;
  }
  string(name, seg) {
    const w = name.endsWith("w") ? 2 : 1,
      repeat = name.startsWith("rep"),
      scan = name.includes("scas");
    let count = repeat ? this.r[1] : 1;
    while (count--) {
      if (this.realtime) this.elapsedCycles++; // DOSBox charges each string element
      const src = this.r[seg] * 16 + this.r[6],
        dst = this.r[8] * 16 + this.r[7],
        v = w === 1 ? this.m8(src) : this.m16(src),
        step = this.f & 1024 ? -w : w;
      if (name.includes("movs") || name.includes("stos")) {
        const out = name.includes("stos") ? this.r[0] : v;
        w === 1 ? this.w8(dst, out) : this.w16(dst, out);
        this.r[7] += step;
      }
      if (name.includes("movs") || name.includes("lods")) this.r[6] += step;
      if (name.includes("lods"))
        this.r[0] = w === 1 ? (this.r[0] & 0xff00) | v : v;
      if (scan) {
        this.alu(
          "cmp",
          this.r[0],
          w === 1 ? this.m8(dst) : this.m16(dst),
          w * 8,
        );
        this.r[7] += step;
      }
      if (repeat) {
        this.r[1]--;
        if (scan && this.z) break;
      }
    }
  }
  interrupt(n) {
    const ah = this.r[0] >>> 8,
      al = this.r[0] & 255,
      bh = this.r[3] >>> 8,
      bl = this.r[3] & 255;
    if (n === 0x1a && ah === 0) {
      this.r[1] = this.tick >>> 16;
      this.r[2] = this.tick;
      this.r[0] &= 0xff00;
    } else if (n === 0x11) this.r[0] = 0x21;
    else if (n === 0x10) {
      if (ah === 0) {
        this.mem.fill(0, 0xb8000, 0xbc000);
        this.color = 0x30;
        this.overrides = {};
        this.text = [];
        this.cursor = [0, 0];
      } else if (ah === 14) {
        this.text.push(String.fromCharCode(al));
        if (this.biosGraphics) this.writeBiosCharacter(al, bl);
      } else if (ah === 2) this.cursor = [this.r[2] & 255, this.r[2] >>> 8];
      else if (ah === 11)
        this.color =
          bh === 0
            ? (this.color & 0x20) | (bl & 31)
            : (this.color & 31) | ((bl & 1) << 5);
      else if (this.r[0] === 0x1000) this.overrides[bl] = bh & 15;
      else if (ah !== 2) throw Error("INT 10 AH " + ah.toString(16));
    } else
      throw Error(
        "Unsupported BIOS " + n.toString(16) + " AX " + this.r[0].toString(16),
      );
  }
  writeBiosCharacter(ch, color) {
    let [col, row] = this.cursor;
    if (ch === 13) col = 0;
    else if (ch === 10) row++;
    else if (ch === 8) col = Math.max(0, col - 1);
    else if (ch !== 7) {
      for (let y = 0; y < 8; y++)
        for (let x = 0; x < 8; x++) {
          const px = col * 8 + x,
            py = row * 8 + y;
          if (px >= 320 || py >= 200) continue;
          const a = 0xb8000 + (py & 1) * 8192 + (py >> 1) * 80 + (px >> 2),
            shift = 6 - 2 * (px & 3),
            bit = (BIOS_FONT[ch * 8 + y] >> (7 - x)) & 1;
          if (color & 128) {
            if (bit) this.mem[a] ^= (color & 3) << shift;
          } else
            this.mem[a] =
              (this.mem[a] & ~(3 << shift)) | ((bit ? color & 3 : 0) << shift);
        }
      if (++col >= 40) {
        col = 0;
        row++;
      }
    }
    // No game result exceeds 25 rows; configuration text may scroll.
    if (row >= 25) {
      for (let y = 0; y < 192; y++)
        for (let x = 0; x < 80; x++)
          this.mem[0xb8000 + (y & 1) * 8192 + (y >> 1) * 80 + x] =
            this.mem[0xb8000 + ((y + 8) & 1) * 8192 + ((y + 8) >> 1) * 80 + x];
      for (let y = 192; y < 200; y++)
        this.mem.fill(
          0,
          0xb8000 + (y & 1) * 8192 + (y >> 1) * 80,
          0xb8000 + (y & 1) * 8192 + (y >> 1) * 80 + 80,
        );
      row = 24;
    }
    this.cursor = [col, row];
  }
  input(p) {
    if (p === 0x3da) {
      if (!this.realtime) return ++this.retrace % 2 ? 8 : 0;
      // CGA vertical sync, ~60 Hz. Horizontal/status details are not used here.
      return this.seconds % (1 / 60) < 0.0013 ? 8 : 0;
    }
    if (p === 0x40) {
      const counter = this.realtime ? this.pitLatched : this.pit;
      const v = this.pitPhase ? counter >>> 8 : counter & 255;
      if (this.pitPhase && !this.realtime)
        this.pit = (this.pit - 0x101) & 65535;
      this.pitPhase ^= 1;
      return v;
    }
    if (p === 0x61) return this.ports[p] || 0;
    if (p === 0x201) return 0x10;
    throw Error("Input port " + p.toString(16));
  }
  output(p, v) {
    this.ports[p] = v;
    if (p === 0x3d9) this.color = v;
    if (p === 0x43 && v === 0) {
      this.pitPhase = 0;
      // BIOS channel 0 is mode 3: the visible counter decrements by TWO
      // per PIT input clock and reloads on each half-period. Reads share a latch.
      if (this.realtime)
        this.pitLatched = (-2 * Math.floor(this.seconds * 1193182)) & 65535;
    }
    this.onSound?.(p, v);
  }
  keys(keys, force = false) {
    keys = [...new Set(keys)].sort((a, b) => a - b);
    if (!force && keys.join() === this.keysHeld.join()) return;
    this.keysHeld = keys;
    this.mem.fill(128, 0x107b7, 0x107cd);
    for (const k of keys) this.mem[0x107b7 + k] = 0;
    this.w16(0x10793, this.m16(0x10793) + 1);
  }
  step() {
    if (this.boundaries.has(this.ip)) {
      this.blocks++;
      if (!this.realtime) this.tick = 100 + Math.floor(this.blocks / 256);
    }
    if (this.realtime)
      this.tick = 100 + Math.floor((this.seconds * 1193182) / 65536);
    this.w16(0x46c, this.tick);
    this.w16(0x46e, this.tick >>> 16);
    this.observe?.(this.ip, this);
    const page = this.pages[this.ip >>> 8];
    if (!page) throw Error("Untranslated IP " + this.ip.toString(16));
    page(this);
    this.steps++;
    if (this.realtime) this.elapsedCycles++;
  }
  runUntil(predicate, limit = 5000000) {
    for (let n = 0; n < limit; n++) {
      if (n && predicate(this)) return n;
      this.step();
    }
    throw Error("Execution budget at " + this.ip.toString(16));
  }
  start(difficulty = 0) {
    this.runUntil((c) => c.ip === 0x5d71);
    this.keys([11]);
    this.runUntil((c) => c.ip === 0x5ef7);
    this.keys([11], true);
    this.runUntil((c) => c.ip === 0x5f29);
    this.keys([12 + difficulty]);
    this.runUntil((c) => c.ip === 0x5faa);
    this.keys([2]);
    this.runUntil((c) => c.ip === 0x15f);
    this.keys([]);
  }
  // Yield inside blocking melodies/effects. Reference mode keeps the old
  // oracle's block clock; live mode yields after 10 ms of instruction budget.
  slice(blocks = 256) {
    if (this.realtime) {
      const target = this.elapsedCycles + this.cyclesPerSecond / 100;
      return this.runUntil((c) => c.elapsedCycles >= target || MENUS.has(c.ip));
    }
    const target = this.blocks + blocks;
    return this.runUntil((c) => c.blocks >= target || MENUS.has(c.ip));
  }
  frame() {
    const target = this.tick + 1;
    return this.runUntil(
      (c) => (LOOPS.has(c.ip) && c.tick >= target) || MENUS.has(c.ip),
    );
  }
  save() {
    const out = {};
    for (const k of [
      "realtime",
      "cyclesPerSecond",
      "elapsedCycles",
      "pitLatched",
      "f",
      "ip",
      "blocks",
      "steps",
      "tick",
      "pit",
      "pitPhase",
      "retrace",
      "ports",
      "color",
      "overrides",
      "keysHeld",
      "text",
      "cursor",
      "biosGraphics",
    ])
      out[k] = structuredClone(this[k]);
    out.r = Array.from(this.r);
    out.mem = this.mem.slice();
    return out;
  }
  load(s) {
    for (const [k, v] of Object.entries(s))
      if (k === "r") this.r.set(v);
      else if (k === "mem") this.mem.set(v);
      else this[k] = structuredClone(v);
  }
}
