// Serve only the built static site. Gameplay runs entirely in the browser.
import { createServer } from "node:http";
import { readFile, stat, realpath } from "node:fs/promises";
import { resolve, relative, extname, isAbsolute } from "node:path";
import { fileURLToPath } from "node:url";
const root = resolve(fileURLToPath(new URL("../dist", import.meta.url)));
const port = Number(process.env.PORT || 8770);
const base =
  "/" + (process.env.BASE_PATH || "").split("/").filter(Boolean).join("/");
const prefix = base === "/" ? "/" : base + "/";
const types = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json",
  ".css": "text/css; charset=utf-8",
  ".webp": "image/webp",
  ".png": "image/png",
  ".md": "text/plain; charset=utf-8",
};
try {
  await stat(root + "/index.html");
} catch {
  console.error("Run npm run build first.");
  process.exit(1);
}
const inside = (file) => {
  const path = relative(root, file);
  return path !== ".." && !path.startsWith("../") && !isAbsolute(path);
};
createServer(async (req, res) => {
  try {
    if (!["GET", "HEAD"].includes(req.method)) {
      res.writeHead(405).end();
      return;
    }
    const url = new URL(req.url, "http://localhost");
    if (prefix !== "/" && url.pathname === base) {
      res.writeHead(302, { Location: prefix }).end();
      return;
    }
    if (!url.pathname.startsWith(prefix)) {
      res.writeHead(404).end();
      return;
    }
    let file = resolve(
      root,
      decodeURIComponent(url.pathname.slice(prefix.length)) || ".",
    );
    if (!inside(file)) {
      res.writeHead(403).end();
      return;
    }
    if ((await stat(file)).isDirectory()) {
      if (!url.pathname.endsWith("/")) {
        res.writeHead(302, { Location: url.pathname + "/" + url.search }).end();
        return;
      }
      file = resolve(file, "index.html");
    }
    file = await realpath(file);
    if (!inside(file)) {
      res.writeHead(403).end();
      return;
    }
    const body = await readFile(file);
    res
      .writeHead(200, {
        "Content-Type": types[extname(file)] || "application/octet-stream",
        "Cache-Control": "no-store",
        "X-Content-Type-Options": "nosniff",
      })
      .end(req.method === "HEAD" ? undefined : body);
  } catch {
    res.writeHead(404).end("Not found");
  }
}).listen(port, "127.0.0.1", () =>
  console.log(`Alley Cat: http://127.0.0.1:${port}${prefix}`),
);
