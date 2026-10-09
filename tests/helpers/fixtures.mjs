import { readFileSync } from "node:fs";
import { gunzipSync } from "node:zlib";
export const readFixture = (name) =>
  JSON.parse(
    gunzipSync(
      readFileSync(new URL("../fixtures/" + name + ".gz", import.meta.url)),
    ),
  );
