import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { PortableSession } from "../engine/portable-session.js";
import { pages, boundaries } from "../build/generated/translated.js";
const exe = fs.readFileSync(new URL("../build/CAT.EXE", import.meta.url)),
  make = (o) => new PortableSession(exe, pages, boundaries, o);
test("original title executes its melody, remains in HD and can enter all four difficulty selections", () => {
  for (const cycles of [1500, 3000])
    for (let difficulty = 0; difficulty < 4; difficulty++) {
      const s = make({ intro: true, cycles, difficulty }),
        tones = [];
      let peak = 0;
      const old = s.cpu.onSound;
      s.cpu.onSound = (p, v) => {
        old(p, v);
        if (p === 0x42) tones.push(v);
      };
      for (let i = 0; i < 400; i++) {
        const r = s.advance();
        for (const v of r.pcm) peak = Math.max(peak, Math.abs(v));
        assert.equal(r.frame.cinematic?.kind, "intro");
      }
      const notes = [];
      for (let n = 0; n < tones.length; n += 2)
        notes.push(tones[n] | (tones[n + 1] << 8));
      const expected = [];
      for (let a = 0x1548c; expected.length < notes.length; a++) {
        const code = s.cpu.m8(a);
        if (code === 0x66) break;
        if (code) expected.push(s.cpu.m16(0x15424 + code));
      }
      assert.equal(
        s.frame.objects.filter((o) => o.kind === "bin").length,
        5,
        "title uses its original fixed five-bin layout",
      );
      assert.ok(notes.length > 4);
      assert.deepEqual(
        notes,
        expected,
        "PIT writes match original title score",
      );
      assert.ok(peak > 0.01);
      s.beginGame();
      for (let i = 0; i < 60; i++) s.advance();
      assert.equal(s.phase, "game");
      assert.equal(s.frame.difficulty, difficulty);
      assert.equal(s.frame.scene, 0);
      assert.ok(!s.ended);
    }
});
test("HD outcomes, dances and rejection run at all eight internal difficulty levels with deterministic saves", () => {
  const all = new Set();
  let snapshots = 0;
  for (let difficulty = 0; difficulty < 8; difficulty++)
    for (const failed of [false, true]) {
      const s = make({ practice: 7 }),
        c = s.cpu;
      c.w16(0x10108, difficulty);
      c.w8(0x10651, failed ? 1 : 0);
      c.w8(0x10653, failed ? 0 : 1);
      const seen = new Set();
      let complete = false;
      for (let i = 0; i < 4000; i++) {
        s.advance();
        const e = s.frame.cinematic;
        if (e) {
          seen.add(e.kind);
          all.add(e.kind);
          if (e.kind === "bonus" && e.value && snapshots < 2) {
            const snapshot = s.save(),
              expected = s.advance();
            s.load(snapshot);
            assert.deepEqual(s.advance(), expected);
            snapshots++;
          }
        }
        if (s.frame.scene === 0 && !s.frame.originalInterlude && !e) {
          complete = true;
          break;
        }
      }
      assert.ok(complete, `difficulty ${difficulty} failed ${failed}`);
      if (failed) {
        assert.ok(seen.has("rejection"));
        assert.equal(s.frame.lives, 3);
      } else {
        assert.ok(seen.has("romance"));
        assert.ok(seen.has("hearts"));
        assert.ok(seen.has("bonus"));
        if (difficulty >= 1) assert.ok(seen.has("dance"));
        assert.equal(s.frame.lives, 4);
        assert.equal(s.frame.difficulty, Math.min(7, difficulty + 1));
      }
    }
  assert.equal(snapshots, 2);
  console.log("Original cinematic states:", [...all].join(", "));
});
test("BIOS bonus digits and multiplier are visible in the original CGA frame", () => {
  const s = make({ practice: 7, difficulty: 1 }),
    c = s.cpu;
  c.w8(0x10653, 1);
  for (let n = 0; n < 3000; n++) {
    s.advance();
    if (s.frame.cinematic?.kind === "bonus" && s.frame.cinematic.value) break;
  }
  const e = s.frame.cinematic;
  assert.equal(e?.kind, "bonus");
  assert.match(e.label, /BONUS MULTIPLIER/);
  const bytes = Buffer.from(s.frame.cga, "base64");
  const ink = (x, y, w, h) => {
    let count = 0;
    for (let yy = y; yy < y + h; yy++)
      for (let xx = x; xx < x + w; xx++)
        count +=
          ((bytes[(yy & 1) * 8192 + (yy >> 1) * 80 + (xx >> 2)] >>
            (6 - 2 * (xx & 3))) &
            3) !==
          0;
    return count;
  };
  assert.ok(ink(144, e.numberY, 32, 8) > 20);
  assert.ok(ink(80, 80, 160, 8) > 100);
});
test("special DD failure shows both beckoning poses and all original HERE KITTY placements", () => {
  const s = make({ practice: 3, difficulty: 1 }),
    c = s.cpu;
  c.w8(0x10652, 0xdd);
  const poses = new Set(),
    locations = new Set();
  for (let n = 0; n < 3000; n++) {
    s.advance();
    const e = s.frame.cinematic;
    if (e?.kind === "beckon") {
      if (e.rect) poses.add(e.pose);
      for (const o of e.particles)
        locations.add(o.source + ":" + o.rect.join());
    }
    if (s.frame.scene === 0 && !s.frame.cinematic && !s.frame.originalInterlude)
      break;
  }
  assert.deepEqual([...poses].sort(), [0, 1]);
  assert.equal(locations.size, 4);
  assert.equal(s.frame.lives, 2);
});
test("rare YOW and SQUEEK execute their original contacts, show an HD effect, then restore CGA pixels", () => {
  for (const name of ["YOW", "SQUEEK"]) {
    const s = make({ practice: 0 }),
      c = s.cpu;
    for (let n = 0; n < 30; n++) s.advance();
    c.w16(0x10679, 144);
    c.w8(0x1067b, 96);
    c.w8(0x1067c, 146);
    if (name === "YOW") {
      c.w8(0x11778, 1);
      c.ip = 0x1166;
    } else {
      c.w16(0x1206c, 0);
      c.w16(0x12030, 144);
      c.w8(0x12036, 96);
      c.w8(0x12050, 0);
      c.w8(0x1065c, 1);
      c.w16(0x12042, 48 * 80 + 36);
      c.ip = 0x2567;
    }
    const before = c.mem.slice(0xb8000, 0xbc000);
    c.push(0xff00);
    let shown = false,
      restored = false;
    const old = c.observe;
    c.observe = (ip, c) => {
      old(ip, c);
      if (ip === (name === "YOW" ? 0x1197 : 0x25e4)) {
        shown = true;
        assert.equal(
          s.capture().effects[0].source,
          name === "YOW" ? 0x1679 : 0x1d70,
        );
      }
      if (ip === (name === "YOW" ? 0x11d0 : 0x260c)) restored = true;
    };
    c.runUntil((c) => c.ip === 0xff00, 20000000);
    assert.ok(shown, name);
    assert.ok(restored, name);
    assert.equal(s.capture().effects.length, 0);
    assert.deepEqual(
      c.mem.slice(0xb8000, 0xbc000),
      before,
      "temporary lettering must restore underlying graphics",
    );
  }
});
