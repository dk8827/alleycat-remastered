// Shared live engine for the browser and headless campaign validation.
// Original instructions own gameplay. This class only schedules and presents it.
import { Cinematics, CINEMATIC_SITES } from "./cinematics.js";
import { CPU, LOOPS, MENUS } from "./cpu.js";
import { PortableSpeaker } from "./speaker.js";
import { Presentation, WATCH, cgaPalette } from "./presentation.js";
export const DIFFICULTIES = ["Kitten", "House Cat", "Tomcat", "Alley Cat"];
export const KEY_INDICES = Object.freeze({
  Space: 0,
  AltLeft: 0,
  AltRight: 0,
  ArrowUp: 1,
  ArrowRight: 2,
  ArrowDown: 3,
  ArrowLeft: 4,
  PageUp: 5,
  PageDown: 6,
  End: 7,
  Home: 8,
  Numpad9: 5,
  Numpad3: 6,
  Numpad1: 7,
  Numpad7: 8,
  Numpad8: 1,
  Numpad6: 2,
  Numpad2: 3,
  Numpad4: 4,
  KeyW: 1,
  KeyD: 2,
  KeyS: 3,
  KeyA: 4,
});
export class PortableSession {
  constructor(
    exe,
    pages,
    boundaries,
    {
      difficulty = 0,
      cycles = 1500,
      rate = 44100,
      practice = null,
      intro = false,
    } = {},
  ) {
    if (!Number.isInteger(difficulty) || difficulty < 0 || difficulty > 3)
      throw Error("Invalid difficulty");
    if (
      practice !== null &&
      (!Number.isInteger(practice) || practice < 0 || practice > 7)
    )
      throw Error("Invalid practice room");
    this.practice = practice;
    this.cpu = new CPU(exe, pages, boundaries, { realtime: true, cycles });
    this.presentation = new Presentation();
    this.cinematics = new Cinematics();
    this.phase = intro && practice === null ? "intro" : "game";
    this.difficulty = difficulty;
    this.lastGame = null;
    this.cpu.biosGraphics = true;
    this.sound = new PortableSpeaker(rate, 1);
    this.lastLoopTick = 0;
    this.transition = false;
    this.drawEvents = 0;
    this.ready = false;
    this.frame = null;
    this.cpu.onSound = (p, v) => this.sound.write(p, v, this.cpu.seconds);
    this.cpu.observe = (ip, c) => {
      if (CINEMATIC_SITES.has(ip))
        this.cinematics.observe(ip, c, this.lastGame);
      if (ip === 0x1bf0) this.transition = true;
      if (WATCH.has(ip)) {
        this.drawEvents++;
        this.presentation.observe(ip, c.mem.subarray(0x10100, 0x20100), c.r);
      }
      if (LOOPS.has(ip)) {
        this.lastLoopTick = c.tick;
        if (this.phase === "game") this.cinematics.clear();
        this.transition = false;
        if (
          this.ready &&
          (c.tick !== this.frame?.tick ||
            c.m16(0x10104) !== this.frame?.scene ||
            this.frame?.originalInterlude)
        )
          this.capture();
      }
    };
    if (this.phase === "intro") this.cpu.runUntil((c) => c.ip === 0x5d71);
    else this.cpu.start(difficulty);
    if (practice !== null) {
      const c = this.cpu;
      c.runUntil((x) => LOOPS.has(x.ip) && !x.m8(0x10658));
      c.w16(0x10104, practice);
      c.w16(0x10679, 160);
      c.w8(0x1067b, 100);
      c.ip = [0xbc, 0x3e2, 0x459, 0x394, 0x349, 0x2fe, 0x2aa, 0x260][practice];
      c.runUntil((x) => LOOPS.has(x.ip));
    }
    this.sound.advance(this.cpu.seconds);
    this.sound.take();
    if (LOOPS.has(this.cpu.ip)) this.cinematics.clear();
    this.ready = true;
    this.capture();
  }
  get ended() {
    return this.phase === "game" && MENUS.has(this.cpu.ip);
  }
  beginGame() {
    if (this.phase !== "intro") return;
    const c = this.cpu;
    if (c.ip !== 0x5ef7) {
      c.keys([11], true);
      c.runUntil((c) => c.ip === 0x5ef7);
    }
    c.keys([11], true);
    c.runUntil((c) => c.ip === 0x5f29);
    c.keys([12 + this.difficulty]);
    c.runUntil((c) => c.ip === 0x5faa);
    c.keys([2]);
    c.runUntil((c) => c.ip === 0x15f);
    c.keys([]);
    this.phase = "game";
    this.cinematics.clear();
    this.lastLoopTick = c.tick;
    this.sound.advance(c.seconds);
    this.sound.take();
    this.capture();
  }
  capture(originalInterlude = false) {
    const c = this.cpu;
    this.frame = {
      ...this.presentation.state(
        c.mem.subarray(0x10100, 0x20100),
        c.mem.subarray(0xb8000, 0xbc000),
        c.tick,
        c.ip,
        cgaPalette(c.color),
      ),
      originalInterlude,
      practice: this.practice,
      cinematic:
        this.phase === "intro"
          ? {
              kind: "intro",
              publisherSource: c.m16(0x16b8f + (c.m16(0x16b8d) & 2)),
            }
          : this.ended
            ? {
                kind: "gameover",
                background: this.lastGame,
                publisherSource: c.m16(0x16b8f + (c.m16(0x16b8d) & 2)),
              }
            : this.cinematics.frame(),
    };
    if (!this.frame.cinematic && !originalInterlude) this.lastGame = this.frame;
    return this.frame;
  }
  advance() {
    if (this.phase === "intro") {
      const target = this.cpu.elapsedCycles + this.cpu.cyclesPerSecond / 100;
      this.cpu.runUntil((c) => c.elapsedCycles >= target || c.ip === 0x5ef7);
      if (this.cpu.ip === 0x5ef7) this.beginGame();
      else this.capture();
    } else if (!this.ended) this.cpu.slice();
    this.sound.advance(this.cpu.seconds);
    // Result screens, room wipes, and long blocking animations must not freeze
    // either side of the CGA/HD comparison. The original instructions drive
    // the cinematic observer, including coordinates and progress.
    if (
      this.cpu.tick !== this.frame.tick &&
      (this.transition || this.cpu.tick - this.lastLoopTick > 2)
    )
      this.capture(!this.presentation.effects.length);
    if (this.ended) this.capture(true);
    return { frame: this.frame, pcm: this.sound.take(), ended: this.ended };
  }
  save() {
    return {
      phase: this.phase,
      difficulty: this.difficulty,
      cinematics: this.cinematics.save(),
      lastGame: this.lastGame,
      practice: this.practice,
      machine: this.cpu.save(),
      presentation: this.presentation.save(),
      sound: this.sound.save(),
      view: structuredClone(this.frame),
      lastLoopTick: this.lastLoopTick,
      transition: this.transition,
    };
  }
  load(s) {
    this.practice = s.practice;
    this.phase = s.phase ?? "game";
    this.difficulty = s.difficulty ?? 0;
    this.cinematics.load(s.cinematics);
    this.lastGame = s.lastGame ?? null;
    this.cpu.load(s.machine);
    this.presentation.load(s.presentation);
    this.sound.load(s.sound);
    this.frame = structuredClone(s.view);
    this.lastLoopTick = s.lastLoopTick;
    this.transition = s.transition;
    return this.frame;
  }
}
