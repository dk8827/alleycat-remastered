import "./viewer.js";
import { readSave } from "./storage.js";
import { EXE_SHA256 } from "./platform.js";
const $ = (id) => document.getElementById(id);
let loading = false;
async function launch(restore) {
  if (loading) return;
  loading = true;
  $("settings").close();
  $("cover").hidden = false;
  $("boot").textContent = "Loading Alley Cat…";
  for (const id of ["start", "continue-save", "restart", "options"])
    $(id).disabled = true;
  let audio;
  try {
    // Create/resume in the click gesture, before the engine download, for iOS.
    audio = new AudioContext({ latencyHint: "interactive" });
    await audio.resume();
    const { start } = await import("./app.js");
    await start(restore, audio);
  } catch (error) {
    await audio?.close();
    $("boot").textContent =
      "Could not load the game. Check your connection, then reload.";
    $("status").textContent = "Unable to load";
    $("start").textContent = "Reload game";
    $("start").onclick = () => location.reload();
    $("start").hidden = false;
    console.error(error);
  } finally {
    loading = false;
    for (const id of ["start", "continue-save", "restart", "options"])
      $(id).disabled = false;
  }
}
$("start").onclick = () => launch(false);
$("continue-save").onclick = () => launch(true);
$("restart").onclick = () => launch(false);
$("options").onclick = () => $("settings").showModal();
$("close-settings").onclick = () => $("settings").close();
readSave(EXE_SHA256)
  .then((value) => {
    if (!loading && !window.alleycat?.status.active)
      $("continue-save").hidden = !value;
  })
  .catch(() => {});
