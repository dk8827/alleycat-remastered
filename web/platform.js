export const EXE_SHA256 =
  "4979c8867826e08881d1d4bec95c95d6bc1ac70fd21050ccdb4f733a50d7bfdd";

// Each physical key/pointer has an owner; releasing one must not cancel another.
export class HeldKeys {
  constructor(send) {
    this.send = send;
    this.owners = new Map();
  }
  down(owner, code) {
    if (this.owners.has(owner)) return;
    const already = [...this.owners.values()].includes(code);
    this.owners.set(owner, code);
    if (!already) this.send(code, true);
  }
  up(owner) {
    const code = this.owners.get(owner);
    if (code === undefined) return;
    this.owners.delete(owner);
    if (![...this.owners.values()].includes(code)) this.send(code, false);
  }
  release() {
    for (const owner of [...this.owners.keys()]) this.up(owner);
  }
}

// Queue mono PCM in Web Audio; clear stale samples on pause and restore.
export class Speaker {
  constructor(context) {
    this.context = context;
    this.sources = new Set();
    this.next = 0;
    this.enabled = true;
    this.resyncs = 0;
    this.peak = 0;
    this.samples = 0;
  }
  push(samples, rate) {
    this.samples += samples.length;
    for (const sample of samples)
      this.peak = Math.max(this.peak, Math.abs(sample));
    if (
      !this.enabled ||
      this.context.state !== "running" ||
      !rate ||
      !samples.length
    )
      return;
    const now = this.context.currentTime;
    if (this.next < now || this.next > now + 0.2) {
      this.clear();
      this.next = now + 0.04;
      this.resyncs++;
    }
    const buffer = this.context.createBuffer(1, samples.length, rate);
    buffer.copyToChannel(samples, 0);
    const source = this.context.createBufferSource();
    source.buffer = buffer;
    source.connect(this.output || this.context.destination);
    source.onended = () => {
      source.disconnect();
      this.sources.delete(source);
    };
    this.sources.add(source);
    source.start(this.next);
    this.next += buffer.duration;
  }
  clear() {
    for (const source of this.sources) {
      source.stop();
      source.disconnect();
    }
    this.sources.clear();
    this.next = 0;
  }
}
