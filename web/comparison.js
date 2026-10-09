// Both controls reveal the same pair of canvases; neither changes game state.
export function comparisonControls({
  input,
  handle,
  divider,
  canvas,
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
    onChange(v);
  }
  input.addEventListener("input", () => update(input.value));
  // Pointer users resume playing after a drag; keyboard users keep native range focus.
  let rangePointer = null;
  input.addEventListener("pointerdown", (event) => {
    if (event.isPrimary && event.button === 0) rangePointer = event.pointerId;
  });
  function finishRange(event) {
    if (event.pointerId !== rangePointer) return;
    rangePointer = null;
    returnFocus();
  }
  window.addEventListener("pointerup", finishRange);
  window.addEventListener("pointercancel", finishRange);
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
  divider.addEventListener("pointerdown", (event) => {
    if (!event.isPrimary || event.button !== 0) return;
    event.preventDefault();
    pointer = event.pointerId;
    divider.setPointerCapture(pointer);
    move(event);
  });
  divider.addEventListener("pointermove", (event) => {
    if (event.pointerId === pointer) move(event);
  });
  function finish(event) {
    if (event.pointerId !== pointer) return;
    pointer = null;
    if (divider.hasPointerCapture(event.pointerId))
      divider.releasePointerCapture(event.pointerId);
    returnFocus();
  }
  divider.addEventListener("pointerup", finish);
  divider.addEventListener("pointercancel", finish);
  divider.addEventListener("lostpointercapture", finish);
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
