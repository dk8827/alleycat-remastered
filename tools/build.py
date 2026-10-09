"""Build the game, translate its instructions, and package the static player."""
from pathlib import Path
import hashlib, json, shutil, subprocess, sys
from PIL import Image
ROOT = Path(__file__).resolve().parents[1]
EXPECTED = '4979c8867826e08881d1d4bec95c95d6bc1ac70fd21050ccdb4f733a50d7bfdd'
BUILD = ROOT / 'build'
BUILD.mkdir(exist_ok=True)
subprocess.run(['nasm', '-f', 'bin', '-w+error', '-I', 'game/asm/', '-l', 'build/CAT.lst', '-o', 'build/CAT.EXE', 'game/asm/alleycat.asm'], cwd=ROOT, check=True)
exe = BUILD / 'CAT.EXE'
if hashlib.sha256(exe.read_bytes()).hexdigest() != EXPECTED:
    raise SystemExit('Game checksum mismatch: the runtime requires the pinned instruction layout.')
subprocess.run([sys.executable, 'tools/translate.py'], cwd=ROOT, check=True)
if '--engine-only' in sys.argv:
    raise SystemExit(0)
DIST = ROOT / 'dist'
if DIST.exists(): shutil.rmtree(DIST)
DIST.mkdir()
for folder in ['web', 'engine', 'renderer', 'licenses']:
    shutil.copytree(ROOT / folder, DIST / folder)
shutil.copytree(BUILD / 'generated', DIST / 'generated')
(DIST / 'game').mkdir()
shutil.copyfile(exe, DIST / 'game/CAT.EXE')
(DIST / 'data').mkdir()
shutil.copyfile(ROOT / 'assets/atlas.json', DIST / 'data/atlas.json')
(DIST / 'assets').mkdir()
cache = BUILD / 'paint'; cache.mkdir(exist_ok=True)
manifest = {}; before = after = 0
for source in sorted((ROOT / 'assets').glob('*.png')):
    digest = hashlib.sha256(source.read_bytes() + b'webp-92-alpha-exact-v1').hexdigest()[:16]
    filename = source.stem + '-' + digest + '.webp'
    target = cache / filename
    with Image.open(source) as original:
        if not target.exists(): original.save(target, 'WEBP', quality=92, method=6, exact=True)
        with Image.open(target) as delivered:
            assert delivered.size == original.size, source.name
            if original.mode == 'RGBA':
                assert delivered.getchannel('A').tobytes() == original.getchannel('A').tobytes(), source.name
    shutil.copyfile(target, DIST / 'assets' / filename)
    manifest['assets/' + source.name] = '../assets/' + filename
    before += source.stat().st_size; after += target.stat().st_size
(DIST / 'data/asset-delivery.json').write_text(json.dumps(manifest, indent=2) + '\n')
(DIST / 'index.html').write_text('<!doctype html><html lang="en"><meta charset="utf-8"><meta http-equiv="refresh" content="0;url=web/"><link rel="icon" href="data:,"><title>Alley Cat</title><a href="web/">Play Alley Cat</a></html>\n')
(DIST / '.nojekyll').touch()
for name in ['NOTICE.md', 'LICENSES.md']:
    shutil.copyfile(ROOT / name, DIST / name)
print(f'Static player: dist/ — {len(manifest)} images, {before / 2**20:.2f} → {after / 2**20:.2f} MiB; dimensions and alpha verified')
