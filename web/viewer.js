import { comparisonControls } from "./comparison.js";
const $ = (id) => document.getElementById(id),
  screen = $("screen"),
  original = $("original");
export function wipe() {
  const stage = $("stage").getBoundingClientRect(),
    w = Math.min(stage.width, (stage.height * 4) / 3),
    h = (w * 3) / 4;
  for (const canvas of [screen, original, $("preview-hd"), $("preview-cga")])
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
  for (const canvas of [screen, original, $("preview-hd"), $("preview-cga")]) {
    canvas.style.left = (stage.width - w) / 2 + "px";
    canvas.style.top = (stage.height - h) / 2 + "px";
  }
  $("divider").style.top = (stage.height - h) / 2 + "px";
  $("divider").style.height = h + "px";
  $("divider").style.bottom = "auto";
  const v = Number($("wipe").value);
  original.style.clipPath = `inset(0 ${100 - v}% 0 0)`;
  $("preview-cga").style.clipPath = original.style.clipPath;
  $("divider").style.display = "block";
  // Keep the handle reachable when either view fills the screen.
  $("divider-handle").style.marginLeft =
    v === 0 ? "24px" : v === 100 ? "-24px" : "0";
  $("cga-label").hidden = v < 18;
  $("hd-label").hidden = v > 82;
  const canvasRect = original.getBoundingClientRect();
  const stageRect = $("stage").getBoundingClientRect();
  $("divider").style.left =
    canvasRect.left - stageRect.left + (canvasRect.width * v) / 100 + "px";
}
comparisonControls({
  input: $("wipe"),
  handle: $("divider-handle"),
  canvas: original,
  output: $("comparison-value"),
  onChange: wipe,
  returnFocus: () => screen.focus({ preventScroll: true }),
});
export function exitFullscreen() {
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

wipe();

// Escape also exits the CSS fallback before the game engine is loaded.
document.addEventListener("keydown", (event) => {
  if (
    !event.defaultPrevented &&
    event.key === "Escape" &&
    document.querySelector(".playground").classList.contains("expanded") &&
    !$("settings").open
  ) {
    event.preventDefault();
    exitFullscreen();
  }
});
