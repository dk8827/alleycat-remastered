import { readSave, writeSave } from "./storage.js";
import { Painter, ROOMS } from "../renderer/renderer.js";
import { pages, boundaries } from "../generated/translated.js";
import { HeldKeys, Speaker, EXE_SHA256 } from "./platform.js";
import { PortableSession, KEY_INDICES } from "../engine/portable-session.js";
const $ = (id) => document.getElementById(id),
  screen = $("screen"),
  original = $("original"),
  og = original.getContext("2d"),
  painter = new Painter(screen),
  sleep = (ms) => new Promise((r) => setTimeout(r, ms));
let cpu = null,
  audio = null,
  speaker = null,
  session = null,
  paused = false,
  starting = false,
  muted = false,
  active = false,
  state = null,
  saved = null,
  persistentSave = null,
  packetCount = 0,
  loopTimer = null,
  saving = false,
  startTime = 0,
  portableSpent = 0;
const logLines = [];
const log = (s) => {
  logLines.push(String(s));
  if (logLines.length > 100) logLines.shift();
  $("log").textContent = logLines.join("\n");
};
const fail = (e) => {
  log(e.stack || e);
  $("status").textContent = "Runtime error";
  $("boot").textContent = e.message;
};
const decoded = KEY_INDICES;
const held = new HeldKeys(() => {});
function release() {
  held.release();
  cpu?.keys([]);
  document.querySelectorAll(".held").forEach((b) => b.classList.remove("held"));
}
function key(owner, code, down) {
  if (!active || paused || starting) return;
  if (session?.phase === "intro" && down) {
    session.beginGame();
    speaker.clear();
    accept(session.frame);
    controls();
    return;
  }
  const k = decoded[code];
  if (k === undefined) return;
  if (down) held.down(owner, k);
  else held.up(owner);
  cpu.keys([...held.owners.values()]);
}

function controls() {
  for (const id of ["pause", "restart", "save", "sound"])
    $(id).disabled = !active || starting || saving;
  $("save").disabled ||= paused || session?.phase === "intro";
  $("skip-intro").hidden = !active || session?.phase !== "intro";
  $("pause").disabled ||= !!state?.gameover;
  $("load").disabled = !saved || starting || saving || !active;
  $("start").disabled = starting;
  $("pause").textContent = paused ? "Resume" : "Pause";
  $("sound").textContent = muted ? "Sound off" : "Sound on";
  $("cycles").disabled = starting || (active && !paused);
  $("difficulty").disabled = starting || (active && !paused);
  $("practice").disabled = starting || (active && !paused);
}
function wipe() {
  const stage = $("stage").getBoundingClientRect(),
    w = Math.min(stage.width, (stage.height * 4) / 3),
    h = (w * 3) / 4;
  for (const canvas of [screen, original])
    Object.assign(canvas.style, {
      position: "absolute",
      width: w + "px",
      height: h + "px",
      left: (stage.width - w) / 2 + "px",
      top: (stage.height - h) / 2 + "px",
      inset: "auto",
      right: "auto",
      bottom: "auto",
      margin: "0",
    });
  // Inset resets offsets, so set the two explicit coordinates last.
  for (const canvas of [screen, original]) {
    canvas.style.left = (stage.width - w) / 2 + "px";
    canvas.style.top = (stage.height - h) / 2 + "px";
  }
  $("divider").style.top = (stage.height - h) / 2 + "px";
  $("divider").style.height = h + "px";
  $("divider").style.bottom = "auto";
  const v = Number($("wipe").value);
  original.style.clipPath = `inset(0 ${100 - v}% 0 0)`;
  $("divider").style.display = v > 0 && v < 100 ? "block" : "none";
  const canvasRect = original.getBoundingClientRect();
  const stageRect = $("stage").getBoundingClientRect();
  $("divider").style.left =
    canvasRect.left - stageRect.left + (canvasRect.width * v) / 100 + "px";
}
function accept(s) {
  state = s;
  $("skip-intro").hidden = s.cinematic?.kind !== "intro";
  painter.update(s);
  packetCount++;
  $("hud").textContent =
    `${s.practice != null ? "Practice · " : ""}${s.lives} lives · ${s.score} · ${ROOMS[s.scene]?.[0] || "Transition"}`;
  $("status").textContent = paused
    ? "Paused"
    : s.gameover
      ? "Game over · restart to play"
      : s.cinematic?.kind === "intro"
        ? "Original title music · Enter the alley when ready"
        : "Live";
}
function gameOver(menu) {
  pause(true);
  state = {
    ...state,
    lives: 0,
    gameover: true,
    ip: menu?.ip ?? state.ip,
    tick: menu?.tick ?? state.tick,
  };
  $("hud").textContent = `0 lives · ${state.score} · Night over`;
  $("cover").classList.add("night-over");
  $("cover").hidden = false;
  $("boot").textContent =
    "The night is over. Start again or restore your snapshot.";
  $("start").textContent = "Play again";
  $("status").textContent = "Game over";
  controls();
}
function portableFrame() {
  if (!session || paused || !active || audio.state !== "running") return;
  try {
    for (let n = 0; n < 12 && speaker.next < audio.currentTime + 0.06; n++) {
      const t = performance.now();
      const result = session.advance();
      speaker.push(result.pcm, session.sound.rate);
      portableSpent += performance.now() - t;
      if (result.frame !== state) accept(result.frame);
      if (result.ended) {
        gameOver({ ip: cpu.ip, tick: cpu.tick });
        break;
      }
    }
  } catch (e) {
    pause(true);
    fail(e);
  }
}
async function stop() {
  active = false;
  release();
  clearInterval(loopTimer);
  loopTimer = null;
  cpu = null;
  speaker?.clear();
  if (audio) {
    await audio.close();
    audio = null;
  }
  speaker = null;
  session = null;
}
async function start(restore = false) {
  restore = restore === true;
  $("cover").classList.remove("night-over");
  if (starting) return;
  starting = true;
  controls();
  $("boot").textContent = "Preparing Alley Cat…";
  $("cover").hidden = false;
  try {
    await stop();
    audio = new AudioContext({ latencyHint: "interactive" });
    await audio.resume();
    saved = persistentSave?.snapshot ?? null;
    state = null;
    paused = false;
    packetCount = 0;
    portableSpent = 0;
    startTime = performance.now();
    $("snapshot-status").textContent = persistentSave
      ? "A saved game is available on this browser."
      : "Your save is stored on this browser.";
    await painter.load((f) => {
      $("boot").textContent =
        "Loading painted world · " + Math.round(f * 100) + "%";
    });
    const exe = new Uint8Array(
      await (
        await fetch(new URL("../game/CAT.EXE", import.meta.url))
      ).arrayBuffer(),
    );
    const hash = Array.from(
      new Uint8Array(await crypto.subtle.digest("SHA-256", exe)),
      (x) => x.toString(16).padStart(2, "0"),
    ).join("");
    if (hash !== EXE_SHA256) throw Error("Game data checksum mismatch");
    log("Game data verified");
    session = new PortableSession(exe, pages, boundaries, {
      difficulty: Number($("difficulty").value),
      practice: $("practice").value === "" ? null : Number($("practice").value),
      cycles: Number($("cycles").value),
      rate: audio.sampleRate,
      intro: !restore,
    });
    if (restore && persistentSave) {
      session.load(persistentSave.snapshot);
      session.cpu.keys([]);
    }
    cpu = session.cpu;
    speaker = new Speaker(audio);
    // Keep consuming PCM while muted so the audio clock still paces gameplay.
    speaker.output = audio.createGain();
    speaker.output.gain.value = muted ? 0 : 1;
    speaker.output.connect(audio.destination);
    audio.onstatechange = () => {
      if (active && !paused && audio.state !== "running") pause(true);
    };
    active = true;
    original.width = 320;
    original.height = 200;
    accept(session.frame);
    portableFrame();
    loopTimer = setInterval(portableFrame, 10);
    $("wipe").value = 0;
    wipe();
    $("cover").hidden = true;
    $("continue-save").hidden = true;
    screen.focus({ preventScroll: true });
    log(
      "Playable scene " +
        state?.scene +
        "; presentation packets " +
        packetCount,
    );
  } catch (e) {
    fail(e);
    await stop();
    $("cover").hidden = false;
  } finally {
    starting = false;
    controls();
  }
}
function pause(value) {
  if (!active) return;
  if (!value && state?.gameover) return;
  release();
  paused = value;
  speaker?.clear();
  if (!value)
    audio
      ?.resume()
      .then(() => {
        speaker?.clear();
      })
      .catch(fail);
  $("status").textContent = value ? "Paused" : "Live";
  controls();
}
async function snapshot(load) {
  if (!active || saving || (load && !saved)) return;
  release();
  saving = true;
  controls();
  try {
    if (load) {
      $("cover").hidden = true;
      $("cover").classList.remove("night-over");
      speaker.clear();
      accept(session.load(saved));
      og.drawImage(painter.cga, 0, 0);
      if (paused) pause(false);
      $("snapshot-status").textContent = "Saved game restored.";
    } else {
      saved = session.save();
      try {
        persistentSave = await writeSave(saved, EXE_SHA256);
        $("snapshot-status").textContent = "Game saved in this browser.";
      } catch (e) {
        $("snapshot-status").textContent =
          "Saved in this tab only: " + e.message;
      }
    }
  } catch (e) {
    $("snapshot-status").textContent = e.message;
    log(e.stack);
  } finally {
    saving = false;
    controls();
    screen.focus({ preventScroll: true });
  }
}
$("start").onclick = () => start();
$("continue-save").onclick = () => start(true);
$("skip-intro").onclick = () => {
  session?.beginGame();
  speaker?.clear();
  accept(session.frame);
  controls();
  screen.focus();
};
$("restart").onclick = () => start();
$("pause").onclick = () => {
  pause(!paused);
  screen.focus({ preventScroll: true });
};
$("save").onclick = () => snapshot(false);
$("load").onclick = () => snapshot(true);
$("sound").onclick = () => {
  muted = !muted;
  if (speaker?.output) speaker.output.gain.value = muted ? 0 : 1;
  else if (speaker) {
    speaker.clear();
    speaker.enabled = !muted && !paused;
  }
  controls();
  screen.focus({ preventScroll: true });
};
$("wipe").oninput = wipe;
$("geometry").onchange = () => (painter.geometry = $("geometry").checked);
function exitFullscreen() {
  if (document.fullscreenElement) return document.exitFullscreen();
  document.querySelector(".playground").classList.remove("expanded");
  wipe();
}
$("fullscreen").onclick = async () => {
  if (
    document.fullscreenElement ||
    document.querySelector(".playground").classList.contains("expanded")
  ) {
    await exitFullscreen();
    return;
  }
  const box = document.querySelector(".playground");
  try {
    if (box.requestFullscreen) await box.requestFullscreen();
    else box.classList.add("expanded");
  } catch {
    box.classList.add("expanded");
  }
  screen.focus();
  wipe();
};
$("exit-fullscreen").onclick = exitFullscreen;
document.addEventListener("fullscreenchange", () =>
  requestAnimationFrame(wipe),
);
window.addEventListener("resize", wipe);
new ResizeObserver(wipe).observe($("stage"));
screen.addEventListener("keydown", (e) => {
  if (
    e.code === "Escape" &&
    document.querySelector(".playground").classList.contains("expanded")
  ) {
    e.preventDefault();
    exitFullscreen();
    return;
  }
  if (
    !e.repeat &&
    !e.metaKey &&
    e.code === "Escape" &&
    !document.fullscreenElement
  ) {
    e.preventDefault();
    pause(!paused);
    return;
  }
  if (!e.repeat && e.ctrlKey && e.code === "KeyR") {
    e.preventDefault();
    start();
    return;
  }
  if (!e.repeat && e.ctrlKey && e.code === "KeyS") {
    e.preventDefault();
    $("sound").click();
    return;
  }
  if (e.code === "Escape" && document.fullscreenElement) {
    e.preventDefault();
    document.exitFullscreen();
    return;
  }
  if (e.metaKey || e.code === "Tab") return;
  if (decoded[e.code] !== undefined) {
    e.preventDefault();
    key(e.code, e.code, true);
  }
});
window.addEventListener("keyup", (e) => key(e.code, e.code, false));
screen.addEventListener("blur", release);
window.addEventListener("blur", () => {
  release();
  if (active && !paused) pause(true);
});
document.addEventListener("visibilitychange", () => {
  if (document.hidden && active) pause(true);
});
for (const b of document.querySelectorAll("[data-key]")) {
  b.onpointerdown = (e) => {
    e.preventDefault();
    screen.focus({ preventScroll: true });
    try {
      b.setPointerCapture(e.pointerId);
    } catch (error) {
      if (error.name !== "NotFoundError") throw error;
    }
    key("pointer:" + e.pointerId, b.dataset.key, true);
    b.classList.add("held");
  };
  const up = (e) => {
    key("pointer:" + e.pointerId, b.dataset.key, false);
    b.classList.remove("held");
  };
  b.onpointerup = up;
  b.onpointercancel = up;
  b.oncontextmenu = (e) => e.preventDefault();
  b.onlostpointercapture = up;
  b.onclick = async (e) => {
    if (e.detail === 0) {
      screen.focus({ preventScroll: true });
      key("button:" + b.dataset.key, b.dataset.key, true);
      await sleep(120);
      key("button:" + b.dataset.key, b.dataset.key, false);
    }
  };
}
function draw(now) {
  if (state && (draw.last !== state || draw.geometry !== painter.geometry)) {
    draw.last = state;
    draw.geometry = painter.geometry;
    painter.draw(now, paused);
    if (original.width === 320) og.drawImage(painter.cga, 0, 0);
  }
  requestAnimationFrame(draw);
}
requestAnimationFrame(draw);
// Read-only diagnostics for bug reports and browser regression checks.
window.alleycat = {
  get status() {
    return {
      active,
      paused,
      starting,
      state,
      packetCount,
      elapsed: performance.now() - startTime,
      translationMs: portableSpent,
      audio: speaker
        ? {
            samples: speaker.samples,
            peak: speaker.peak,
            resyncs: speaker.resyncs,
            queued: speaker.next - audio.currentTime,
            context: audio.state,
            muted,
            divisor: session?.sound.divisor,
            gate: session?.sound.gate,
            cpuTick: cpu?.tick,
          }
        : null,
    };
  },
};
controls();
wipe();

readSave(EXE_SHA256)
  .then((v) => {
    persistentSave = v;
    saved = v?.snapshot ?? null;
    $("continue-save").hidden = !v;
    controls();
  })
  .catch((e) => {
    $("snapshot-status").textContent =
      "Persistent storage unavailable; saves remain in this tab.";
    log(e.message);
  });

fetch(new URL("../data/asset-delivery.json", import.meta.url))
  .then((r) => r.json())
  .then((m) =>
    document.documentElement.style.setProperty(
      "--alley-cover",
      `url("${new URL(m["assets/alley-wall-v3.png"], import.meta.url).href}")`,
    ),
  )
  .catch(() => {});
