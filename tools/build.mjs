import { spawnSync } from "node:child_process";
import { existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
process.chdir(fileURLToPath(new URL("..", import.meta.url)));
const python =
  process.platform === "win32"
    ? ".venv/Scripts/python.exe"
    : ".venv/bin/python";
if (!existsSync(python)) {
  console.error("Run npm run setup before building.");
  process.exit(1);
}
const r = spawnSync(python, ["tools/build.py", ...process.argv.slice(2)], {
  stdio: "inherit",
});
if (r.error) console.error(r.error.message);
process.exit(r.status ?? 1);
