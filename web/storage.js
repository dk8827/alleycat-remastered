// IndexedDB preserves typed arrays without converting 1 MB of emulated RAM to JSON.
const DB = "alleycat-remaster",
  STORE = "saves",
  VERSION = 1;
function database() {
  return new Promise((resolve, reject) => {
    const r = indexedDB.open(DB, VERSION);
    r.onupgradeneeded = () => r.result.createObjectStore(STORE);
    r.onsuccess = () => resolve(r.result);
    r.onerror = () => reject(r.error);
  });
}
export async function readSave(hash) {
  const db = await database();
  try {
    return await new Promise((resolve, reject) => {
      const r = db.transaction(STORE).objectStore(STORE).get("portable");
      r.onsuccess = () => {
        const v = r.result;
        resolve(
          v?.version === 1 &&
            v.hash === hash &&
            v.snapshot?.machine?.mem?.length === 1048576
            ? v
            : null,
        );
      };
      r.onerror = () => reject(r.error);
    });
  } finally {
    db.close();
  }
}
export async function writeSave(snapshot, hash) {
  const db = await database(),
    value = { version: 1, hash, savedAt: new Date().toISOString(), snapshot };
  try {
    await new Promise((resolve, reject) => {
      const t = db.transaction(STORE, "readwrite");
      t.objectStore(STORE).put(value, "portable");
      t.oncomplete = resolve;
      t.onerror = () => reject(t.error);
      t.onabort = () => reject(t.error ?? Error("Save interrupted"));
    });
    return value;
  } finally {
    db.close();
  }
}
