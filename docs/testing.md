# Testing

`npm test` assembles and checks the game image, generates JavaScript, and runs Node's built-in test runner. It needs the project virtual environment created by `npm run setup`.

The suite covers:

- Register, memory, and CGA results at recorded execution checkpoints.
- Objective, collision, score, progression, and restart contracts with explicit device inputs.
- All eight scenes at four menu difficulties and both timing profiles.
- Input sequences for room entry, room objectives, and courtship.
- Deterministic save/restore, including sound and presentation.
- Speaker notes, gates, rests, queue behavior, and timing regressions.
- Sprite bounds, scenery registration, drawing order, clipping, and cinematics.

Fixtures contain test data and expected results. Some tests set up an explicit state to exercise a transition; route tests identify campaign and practice starts. These checks are regression coverage, not a claim that every possible campaign is proven identical to a physical DOS PC.

## Browser checks

After `npm run build` and `npm start`, check:

1. Compare the still preview before Play, then start a campaign, hear the title, and enter the alley.
2. Move, jump, and use both the wide slider and the on-screen drag handle through both endpoints, with mouse, touch, and keyboard.
3. Pause, resume, and mute. Open Options to save, restore, or start a selected game. Closing Options should resume only if the game was running before opening it.
4. Reload and continue the persistent save.
5. Select every practice room and check its initial CGA and HD presentation.
6. Switch tabs and return; the game should remain paused until resumed.
7. Use touch controls in portrait and landscape, including diagonal jumps.
8. Enter and exit full screen; check the comparison controls and Options there too.
9. Repeat the loading and control checks under the subdirectory URL documented in the README.

Inspect the browser console and failed network requests. The read-only `window.alleycat.status` object exposes game and audio diagnostics for debugging.

CI performs a fresh dependency install, formatting checks, the regression suite, and a static build. It stores the resulting player as a workflow artifact; successful builds on `main` also deploy to GitHub Pages.
