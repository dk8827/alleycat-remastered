import { readFixture } from "./helpers/fixtures.mjs";
import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { CPU } from "../engine/cpu.js";
import { PortableSpeaker, BLOCK_HZ } from "../engine/speaker.js";
import { Speaker } from "../web/platform.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url));
const tone = (s, divisor, time = 0) => {
  s.write(0x43, 0xb6, time);
  s.write(0x42, divisor & 255, time);
  s.write(0x42, divisor >>> 8, time);
  s.write(0x61, 3, time);
};
const peak = (pcm) => pcm.reduce((m, v) => Math.max(m, Math.abs(v)), 0);
test("PIT byte pairing, zero divisor, channel-0 latch and fractional sample durations", () => {
  const s = new PortableSpeaker(48000);
  tone(s, 0);
  assert.equal(s.divisor, 65536);
  s.write(0x43, 0xb6, 0);
  s.write(0x42, 0x34, 0);
  s.write(0x43, 0, 0);
  s.write(0x42, 0x12, 0);
  assert.equal(s.divisor, 0x1234);
  let count = 0;
  for (let b = 256; b <= 25600; b += 256) {
    s.advance(b);
    count += s.take().length;
  }
  assert.equal(count, Math.floor((25600 / BLOCK_HZ) * 48000));
});
test("tone frequency derives from PIT divisor; gate-off produces silence", () => {
  const s = new PortableSpeaker();
  tone(s, 1193);
  s.advance(BLOCK_HZ);
  const pcm = s.take();
  let rises = 0;
  for (let i = 1; i < pcm.length; i++)
    if (pcm[i - 1] <= 0.15 && pcm[i] > 0.15) rises++;
  assert.ok(Math.abs(rises - 1193182 / 1193) < 2, `frequency ${rises}`);
  s.write(0x61, 0, BLOCK_HZ);
  s.advance(2 * BLOCK_HZ);
  assert.ok(peak(s.take().slice(-1000)) < 1e-8);
});
test("direct speaker modulation is audible without a PIT divisor or clock gate", () => {
  const s = new PortableSpeaker();
  for (let i = 0; i < 400; i++)
    s.write(0x61, i % 2 ? 2 : 0, (i * BLOCK_HZ) / 4000);
  s.advance(BLOCK_HZ / 10);
  assert.ok(peak(s.take()) > 0.04);
  assert.equal(s.loaded, false);
});
test("waveform and fractional phase survive save/load exactly", () => {
  const s = new PortableSpeaker(48000);
  tone(s, 1777);
  s.advance(257);
  s.take();
  const saved = s.save();
  s.write(0x61, 2, 333);
  s.write(0x61, 3, 340);
  s.advance(700);
  const expected = s.take();
  const end = s.save();
  s.load(saved);
  s.write(0x61, 2, 333);
  s.write(0x61, 3, 340);
  s.advance(700);
  assert.deepEqual(s.take(), expected);
  assert.deepEqual(s.save(), end);
});
test("sample stream is independent of browser callback chunk sizes", () => {
  const events = [
    [0, 0x43, 0xb6],
    [0, 0x42, 0xa9],
    [0, 0x42, 4],
    [0, 0x61, 3],
    [600, 0x61, 0],
    [610, 0x61, 2],
    [618, 0x61, 0],
    [700, 0x61, 3],
    [950, 0x42, 0],
    [950, 0x42, 2],
  ];
  const run = (chunk) => {
    const s = new PortableSpeaker(),
      out = [];
    let i = 0;
    for (let b = chunk; b <= 1200; b += chunk) {
      while (i < events.length && events[i][0] <= b) {
        const [at, p, v] = events[i++];
        s.write(p, v, at);
      }
      s.advance(b);
      out.push(...s.take());
    }
    return Float32Array.from(out);
  };
  assert.deepEqual(run(12), run(1200));
});
test("bounded slices preserve the original instruction path including speaker writes", () => {
  const a = new CPU(exe, pages, boundaries),
    b = new CPU(exe, pages, boundaries);
  a.start();
  b.start();
  const ea = [],
    eb = [];
  a.onSound = (p, v) => ea.push([a.blocks, p, v]);
  b.onSound = (p, v) => eb.push([b.blocks, p, v]);
  for (let i = 0; i < 120; i++) a.slice();
  b.runUntil((c) => c.steps === a.steps);
  assert.deepEqual(a.save(), b.save());
  assert.deepEqual(ea, eb);
});
test("startup programming is captured and alley slices produce finite bounded PCM", () => {
  const c = new CPU(exe, pages, boundaries),
    s = new PortableSpeaker();
  const startup = [];
  c.onSound = (p, v) => {
    startup.push([p, v]);
    s.write(p, v, c.blocks);
  };
  c.start();
  s.advance(c.blocks);
  s.take();
  assert.ok(
    startup.some(([p, v]) => p === 0x61 && v === 0),
    "capture startup speaker reset",
  );
  const initial = c.blocks;
  for (let i = 0; i < 100; i++) {
    c.slice();
    s.advance(c.blocks);
  }
  const pcm = s.take();
  assert.ok(pcm.length > 200000);
  assert.ok(peak(pcm) > 0.01);
  assert.ok(pcm.every((x) => Number.isFinite(x) && Math.abs(x) < 0.31));
  assert.equal(c.blocks - initial, 25600);
});
test("PCM playback appends without cancelling earlier chunks; clear stops queued audio", () => {
  const starts = [],
    stops = [];
  const ctx = {
    state: "running",
    currentTime: 1,
    destination: {},
    createBuffer: (_, n, rate) => ({ duration: n / rate, copyToChannel() {} }),
    createBufferSource: () => ({
      connect() {},
      disconnect() {},
      start(t) {
        starts.push(t);
      },
      stop() {
        stops.push(true);
      },
    }),
  };
  const queue = new Speaker(ctx);
  for (let i = 0; i < 3; i++) queue.push(new Float32Array(441), 44100);
  assert.deepEqual(starts, [1.04, 1.05, 1.06]);
  assert.equal(stops.length, 0);
  queue.clear();
  assert.equal(stops.length, 3);
});
test("translated title, result, courtship, alternating and noise routines match original port traces", () => {
  const cases = readFixture("audio-oracle.json");
  for (const fixture of cases) {
    const c = new CPU(exe, pages, new Set()),
      writes = [];
    const s = new PortableSpeaker();
    for (const [p, width, v] of fixture.patches)
      c[width === 1 ? "w8" : "w16"](0x10100 + p, v);
    c.onSound = (p, v) => {
      writes.push([c.tick, p, v]);
      s.write(p, v, c.tick * 256);
    };
    for (const [tick, ip] of fixture.calls) {
      c.r.fill(0);
      c.r[4] = 0xfe;
      c.r[8] = c.r[11] = 0x1010;
      c.r[9] = 0x1723;
      c.r[10] = 0x1000;
      c.f = 2;
      c.w16(0x100fe, 0xff00);
      c.ip = ip;
      c.tick = tick;
      c.runUntil((x) => x.ip === 0xff00);
    }
    assert.deepEqual(writes, fixture.writes, fixture.name);
    s.advance((c.tick + 2) * 256);
    assert.ok(s.take().every(Number.isFinite), fixture.name);
  }
});
// Native reference: SOUNDPRO.EXE calls the original, unchanged routine bytes
// in DOSBox-X at 1500/3000 cycles. 44.1 kHz PCM >0.03 gave jump/landing spans
// of 4.240/3.968 ms and 2.018/2.177 ms. Gate timestamps and PCM spans differ
// slightly because the last square-wave half-period may already be low.
function liveEffect(ip, cycles, delay = 4096) {
  const c = new CPU(exe, pages, boundaries, { realtime: true, cycles });
  c.r[11] = 0x1010;
  c.ip = ip;
  c.push(0xff00);
  c.w8(0x10100, 255);
  c.w8(0x10100 + 0x1cbf, 0);
  c.w16(0x10100 + 0x592a, 1000);
  c.w16(0x10100 + 0x592e, delay);
  const s = new PortableSpeaker(44100, 1);
  let start, end;
  c.onSound = (p, v) => {
    s.write(p, v, c.seconds);
    if (p === 0x61) {
      if ((v & 3) === 3) start = c.seconds;
      else end = c.seconds;
    }
  };
  c.runUntil((x) => x.ip === 0xff00);
  s.advance(c.seconds + 0.02);
  return { duration: (end - start) * 1000, pcm: s.take() };
}
test("live jump and landing match millisecond-scale original DOSBox chirps, not 1.32-second beeps", () => {
  const native = JSON.parse(
    fs.readFileSync(new URL("./native-sound-reference.json", import.meta.url)),
  );
  for (const [index, ip] of [0x58f8, 0x590e].entries()) {
    const slow = liveEffect(ip, 1500),
      fast = liveEffect(ip, 3000);
    assert.ok(
      Math.abs(slow.duration - 4.1) < 0.3,
      `${ip.toString(16)}: ${slow.duration}ms`,
    );
    assert.ok(Math.abs(fast.duration - 2.05) < 0.3);
    assert.ok(Math.abs(slow.duration / fast.duration - 2) < 0.01);
    assert.ok(
      Math.abs(slow.duration - native.milliseconds["1500"][index]) < 0.35,
    );
    assert.ok(
      Math.abs(fast.duration - native.milliseconds["3000"][index]) < 0.35,
    );
    for (const { pcm } of [slow, fast]) {
      const first = pcm.findIndex((x) => x > 0.03),
        last = pcm.findLastIndex((x) => x > 0.03);
      assert.ok(first >= 0 && (last - first) / 44100 < 0.005);
      assert.ok(
        pcm.slice(last + 2).every((x) => x === 0),
        "no artificial filter tail",
      );
    }
  }
});
test("live PIT waits use elapsed timer clocks and remain stable across CPU speeds", () => {
  for (const cycles of [1500, 3000]) {
    // Mode-3 channel-0 count decrements twice per 1,193,182 Hz input clock.
    const long = liveEffect(0x5b28, cycles, 4096).duration;
    const short = liveEffect(0x5b28, cycles, 512).duration;
    assert.ok(
      Math.abs(long - (4096 / (2 * 1193182)) * 1000) < 0.04,
      String(long),
    );
    assert.ok(
      Math.abs(short - (512 / (2 * 1193182)) * 1000) < 0.04,
      String(short),
    );
  }
});
test("live PIT latch survives intervening instructions; BIOS ticks and audio share elapsed time", () => {
  const c = new CPU(exe, pages, boundaries, { realtime: true });
  c.elapsedCycles = 150000;
  c.output(0x43, 0);
  const expected = c.pitLatched,
    lo = c.input(0x40);
  c.elapsedCycles += 200;
  assert.equal(lo | (c.input(0x40) << 8), expected);
  c.output(0x43, 0);
  assert.notEqual(c.pitLatched, expected);
  c.ip = 0x59c5;
  c.r[1] = 10000;
  c.step(); // countdown loop
  assert.equal(
    c.tick,
    100 + Math.floor(((150200 / 1500000) * 1193182) / 65536),
  );
  assert.equal(c.seconds, c.elapsedCycles / 1500000);
});
test("live save/load reproduces CPU, timer phase and exact subsequent audio", () => {
  const c = new CPU(exe, pages, boundaries, { realtime: true });
  const s = new PortableSpeaker(44100, 1);
  c.onSound = (p, v) => s.write(p, v, c.seconds);
  c.start();
  s.advance(c.seconds);
  s.take();
  for (let i = 0; i < 25; i++) {
    c.slice();
    s.advance(c.seconds);
    s.take();
  }
  const machine = c.save(),
    sound = s.save();
  const run = () => {
    c.keys([0, 1, 2]);
    for (let i = 0; i < 50; i++) {
      c.slice();
      s.advance(c.seconds);
    }
    return { machine: c.save(), sound: s.save(), pcm: s.take() };
  };
  const expected = run();
  c.load(machine);
  s.load(sound);
  assert.deepEqual(run(), expected);
});
test("all eight room fixtures execute with the live clock and continuous speaker output", () => {
  const rooms = readFixture("room-oracles.json");
  for (const room of rooms) {
    const c = new CPU(exe, pages, boundaries, { realtime: true });
    c.load({ ...room.initial, mem: Buffer.from(room.initial.mem, "base64") });
    c.realtime = true;
    c.elapsedCycles = (((c.tick - 100) * 65536) / 1193182) * c.cyclesPerSecond;
    const sound = new PortableSpeaker(44100, 1);
    // Align a fresh test audio cursor to the explicitly selected room fixture.
    sound.position = c.seconds * sound.rate;
    c.onSound = (p, v) => sound.write(p, v, c.seconds);
    const start = c.seconds;
    for (let i = 0; i < 80; i++) {
      if (i === 20) c.keys([0, 1, 2]);
      if (i === 50) c.keys([]);
      c.slice();
      sound.advance(c.seconds);
      assert.ok(sound.take().every(Number.isFinite), `room ${room.scene}`);
    }
    assert.ok(c.seconds >= start + 0.79, `room ${room.scene} clock stalled`);
  }
});
