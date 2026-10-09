# Alley Cat Remastered

A hand-painted Alley Cat for the browser. Climb the bins, sneak into the rooms, and slide between **HD and original CGA graphics while you play**.

![Alley Cat with the live CGA/HD comparison](docs/images/gameplay.png)

- Eight scenes, room challenges, courtship, and four difficulty settings.
- Hand-painted characters and scenery, with original game coordinates.
- Live CGA/HD comparison, including transitions and result screens.
- PC speaker music and effects, keyboard and touch controls.
- Pause, full screen, and a save slot stored in your browser.
- Static hosting: gameplay, graphics, and sound all run locally in the browser.

## Run locally

Install **Node.js 22 or later**, **Python 3.10 or later**, and **NASM**. On macOS, NASM is available through `brew install nasm`; on Debian/Ubuntu, use `sudo apt-get install nasm`. Ensure `node`, `python3`, and `nasm` are on your PATH.

```sh
git clone https://github.com/dk8827/alleycat-remastered.git
cd alleycat-remastered
npm ci
npm run setup
npm run dev
```

Open **http://127.0.0.1:8770/** and choose **Play Alley Cat**. The setup command installs Python build dependencies into this project's `.venv`. It does not install Python packages globally. Set `PYTHON` when running setup to select a different Python executable.

Sound starts after you press Play. You can listen to the title music or choose **Enter the alley** to start immediately.

## Controls

| Control | Action |
| --- | --- |
| Arrow keys / WASD | Move and jump |
| Space / Alt | Room-specific action |
| Home / Page Up | Jump left / right |
| Numeric keypad | Directional movement |
| Escape | Pause / resume; exit full screen |
| Ctrl+R | Restart |
| Ctrl+S | Toggle sound |
| HD ↔ CGA slider | Reveal either presentation of the same game state |

Touch buttons are below the game. Choose a difficulty before starting; practice mode starts in a selected scene. Save and Restore use one browser-local slot. Saves are not synchronized across devices and may be unavailable in private browsing. Switching tabs pauses gameplay.

## Development

```sh
npm test              # Build the engine and run regression tests
npm run build         # Package the static player into dist/
npm start             # Serve the existing dist/ build
npm run check         # Tests plus the complete static build
npm run format:check  # Check JavaScript and JSON formatting
```

The development server serves the packaged files. Rebuild after editing source; it does not provide hot reload. To check deployment under a repository subdirectory:

```sh
BASE_PATH=/alleycat-remastered PORT=8771 npm start
```

Open `http://127.0.0.1:8771/alleycat-remastered/`. Any static host can serve `dist/`; no Python service, DOSBox download, or application backend is needed at runtime. HTTPS or localhost is required for browser cryptography and reliable audio startup.

| Directory | Purpose |
| --- | --- |
| `game/asm/` | Game program and data used by the build |
| `engine/` | Translated execution support, devices, sound, and game sessions |
| `renderer/` | CGA decoding and HD drawing |
| `web/` | Player interface, controls, storage, and audio playback |
| `assets/` | Source paintings and sprite crop definitions |
| `tools/` | Build, translation, and local static server |
| `tests/` | Engine, gameplay, audio, and presentation regression tests |

Read [architecture](docs/architecture.md) for the data flow and [contributing](CONTRIBUTING.md) before changing gameplay or artwork.

## Compatibility and limitations

The player targets current desktop Chromium, Firefox, and Safari, plus touch browsers. Device timing is modeled; this is not a cycle-exact PC simulation. The tests cover all scenes, selected complete routes, transitions, sound behavior, and save/restore; they do not prove every possible playthrough. See [testing](docs/testing.md) for the checks and how to report a problem.

## Credits and notices

Alley Cat was created by Bill Williams. This is an unofficial fan project. The HD artwork was created using image generation and registered to the game's drawing coordinates.

See [notices](NOTICE.md) and [component licensing](LICENSES.md) for original game material and third-party components.
