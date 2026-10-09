import { spawnSync } from "node:child_process";
import { existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
process.chdir(fileURLToPath(new URL("..", import.meta.url)));
function run(command, args) {
  const r = spawnSync(command, args, { stdio: "inherit" });
  if (r.error || r.status !== 0) {
    console.error(r.error?.message || `${command} failed`);
    process.exit(1);
  }
}
if (!existsSync(".venv"))
  run(process.env.PYTHON || "python3", ["-m", "venv", ".venv"]);
run(
  process.platform === "win32"
    ? ".venv/Scripts/python.exe"
    : ".venv/bin/python",
  ["-m", "pip", "install", "-r", "requirements.txt"],
);
run("nasm", ["-v"]);
