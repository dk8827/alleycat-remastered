// Both controls reveal the same pair of canvases; neither changes game state.
export function comparisonControls({
  input,
  handle,
  canvas,
  output,
  onChange,
  returnFocus,
}) {
  function update(value) {
    input.value = Math.max(0, Math.min(100, Math.round(Number(value))));
    const v = Number(input.value);
    const description =
      v === 0 ? "All HD" : v === 100 ? "All CGA" : `${v}% CGA, ${100 - v}% HD`;
    input.setAttribute("aria-valuetext", description);
    handle.setAttribute("aria-valuenow", v);
    handle.setAttribute("aria-valuetext", description);
    output.textContent =
      v === 0 || v === 100 ? description : `${v} / ${100 - v}`;
    onChange(v);
  }
  input.addEventListener("input", () => update(input.value));
  for (const button of document.querySelectorAll("[data-view]")) {
    button.addEventListener("click", () => {
      update(button.dataset.view);
      returnFocus();
    });
  }
  let pointer = null;
  function move(event) {
    const rect = canvas.getBoundingClientRect();
    if (rect.width) update(((event.clientX - rect.left) / rect.width) * 100);
  }
  handle.addEventListener("pointerdown", (event) => {
    if (!event.isPrimary || event.button !== 0) return;
    event.preventDefault();
    pointer = event.pointerId;
    handle.setPointerCapture(pointer);
    move(event);
  });
  handle.addEventListener("pointermove", (event) => {
    if (event.pointerId === pointer) move(event);
  });
  function finish(event) {
    if (event.pointerId !== pointer) return;
    pointer = null;
    if (handle.hasPointerCapture(event.pointerId))
      handle.releasePointerCapture(event.pointerId);
    returnFocus();
  }
  handle.addEventListener("pointerup", finish);
  handle.addEventListener("pointercancel", finish);
  handle.addEventListener("lostpointercapture", finish);
  handle.addEventListener("keydown", (event) => {
    const value = Number(input.value);
    const next = {
      ArrowLeft: value - 1,
      ArrowDown: value - 1,
      ArrowRight: value + 1,
      ArrowUp: value + 1,
      PageDown: value - 10,
      PageUp: value + 10,
      Home: 0,
      End: 100,
    }[event.key];
    if (next === undefined) return;
    event.preventDefault();
    update(next);
  });
  update(input.value);
  return update;
}
