# Contributing

Use the setup steps in the README, then run `npm run check` before submitting a change. Keep pull requests focused and include the behavior you changed and how you checked it.

## Game and renderer changes

Gameplay state belongs to the engine. Fix a visual mismatch in the renderer instead of changing positions or collision checks to fit an image. Check both ends of the CGA/HD slider, intermediate positions, transitions, and clipping at screen edges.

For a gameplay or sound fix, add a regression that fails before the change. Exercise the affected room at both timing profiles and check whether save/restore preserves the new behavior.

## Artwork

Source PNGs live in `assets/`. Update the matching entries in `assets/atlas.json` and any geometry mappings in `renderer/registration.js`. Rebuild to generate delivery images; do not commit `dist/` or `build/`. Include before/after screenshots in the pull request when they help review a visual change.

Keep sprite bounds, feet, platform tops, window openings, and clipping aligned with the CGA view. Artwork can extend visually beyond a collision shape, but contact points should remain readable.

## Tests and fixtures

Run `npm test` for execution, room routes, audio, and renderer regression cases. Tests use compressed baseline fixtures; preserve their expected results unless the change intentionally corrects the underlying behavior. Do not refresh a fixture merely to make a failing test pass.

Use `npm run format` for JavaScript and JSON. Preserve the address-and-byte comments in assembly: the translator uses them to identify instruction boundaries.

## Reporting bugs

Include your browser and device, difficulty, room, timing profile, expected behavior, and reproduction steps. Say whether the problem appears in CGA, HD, or both. A short clip with the comparison slider is particularly useful. Do not attach browser storage exports unless you have checked their contents.
