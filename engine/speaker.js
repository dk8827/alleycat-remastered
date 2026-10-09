// Alley Cat's channel-2 mode-3 PIT and direct port-61 speaker output.
// Live playback supplies elapsed seconds; reference tests may supply block-clock units.
export const PIT_HZ = 1193182;
export const BIOS_HZ = PIT_HZ / 65536;
export const BLOCK_HZ = BIOS_HZ * 256;
export class PortableSpeaker {
  constructor(rate = 44100, clockHz = BLOCK_HZ) {
    this.rate = rate;
    this.clockHz = clockHz;
    this.position = 0; // fractional PCM sample position
    this.area = 0;
    this.phase = 0; // PIT input clocks within the current period
    this.divisor = 65536;
    this.pending = 65536;
    this.low = null;
    this.access = 3;
    this.loaded = false;
    this.gate = 0;
    this.samples = [];
  }
  // Integrate the square wave over a sample, including sub-sample gate changes.
  // This avoids clamping high frequencies into an unrelated audible tone.
  level(ticks) {
    if (!(this.gate & 1) || !this.loaded) return this.gate & 2 ? 1 : 0;
    let high = 0,
      left = ticks;
    while (left > 1e-9) {
      const span = Math.min(left, this.divisor - this.phase);
      high += Math.max(
        0,
        Math.min(this.phase + span, Math.ceil(this.divisor / 2)) - this.phase,
      );
      this.phase += span;
      left -= span;
      if (this.phase >= this.divisor - 1e-9) {
        this.phase = 0;
        this.divisor = this.pending;
        // Whole periods have a known duty cycle; no loop per PIT edge.
        const periods = Math.floor(left / this.divisor);
        high += periods * Math.ceil(this.divisor / 2);
        left -= periods * this.divisor;
      }
    }
    return this.gate & 2 ? high / ticks : 0;
  }
  advance(blocks) {
    const end = (blocks / this.clockHz) * this.rate;
    if (end < this.position - 1e-6)
      throw Error("Speaker clock moved backwards without a restore");
    while (end - this.position > 1e-7) {
      const boundary = Math.floor(this.position + 1e-7) + 1;
      const next = Math.min(end, boundary),
        span = next - this.position;
      this.area += this.level((span * PIT_HZ) / this.rate) * span;
      this.position = next;
      if (Math.abs(next - boundary) < 1e-7) {
        // Match DOSBox-X's unipolar mixer level (SPKR_VOLUME = 10000).
        // A synthetic high-pass tail would lengthen these very short chirps.
        this.samples.push(this.area * (10000 / 32768));
        this.area = 0;
      }
    }
  }
  write(port, value, blocks) {
    if (![0x42, 0x43, 0x61].includes(port)) return;
    this.advance(blocks);
    value &= 255;
    if (port === 0x43) {
      if (value >>> 6 !== 2 || !(value & 0x30)) return; // another channel or latch
      if (((value >>> 1) & 7) !== 3 || value & 1)
        throw Error("Unsupported speaker PIT control " + value.toString(16));
      this.access = (value >>> 4) & 3;
      this.low = null;
      this.loaded = false;
      this.phase = 0;
    } else if (port === 0x42) {
      let count;
      if (this.access === 1) count = value;
      else if (this.access === 2) count = value << 8;
      else if (this.low === null) {
        this.low = value;
        return;
      } else {
        count = this.low | (value << 8);
        this.low = null;
      }
      this.pending = count || 65536;
      if (!this.loaded || !(this.gate & 1)) {
        this.divisor = this.pending;
        this.phase = 0;
      }
      this.loaded = true;
    } else {
      if (!(value & 1) || !(this.gate & 1)) {
        this.phase = 0;
        this.divisor = this.pending;
      }
      this.gate = value & 3;
    }
  }
  take() {
    const samples = Float32Array.from(this.samples);
    this.samples.length = 0;
    return samples;
  }
  save() {
    const { samples, ...state } = this;
    return structuredClone(state);
  }
  load(state) {
    Object.assign(this, structuredClone(state));
    this.samples = [];
  }
}
