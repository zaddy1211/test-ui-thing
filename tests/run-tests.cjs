const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const assert = require('node:assert/strict');
const cp = require('node:child_process');
const root = path.resolve(__dirname, '..');
const source = fs.readFileSync(path.join(root, 'UniversalUI.lua'), 'utf8');
const introStart = source.indexOf('-- Test-only loading host.');
const introEnd = source.indexOf('\n__KZ_Cozy.Begin()\n__KZ_Cozy.Progress(1,', introStart);
assert(introStart >= 0 && introEnd > introStart);
assert(!source.includes('raw.githubusercontent.com/zaddy1211/ui/'), 'production asset dependency');
assert(source.includes('local ASSET_ROOT = "KZScripts/Test UI"'));
assert(source.includes('Root = "KZScriptsTestHub"'));
assert(!source.includes('Root = "KZScriptsHub"'));
for (const name of ['Toggle', 'Slider', 'RangeSlider', 'Dropdown', 'Button', 'Textbox', 'Keybind', 'Colorpicker', 'ConfigManager', 'LyraZen', 'KZAdapter']) {
  assert(source.includes(name + ' = ' + name), 'missing public API: ' + name);
}
for (const name of ['kz-logo-original-v2.png', 'kz-logo-kitty-v1.png', 'kz-logo-blossom-v1.png', 'hash-brown-host-v1.png']) {
  const png = fs.readFileSync(path.join(root, 'assets', name));
  assert(png.subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10])), 'invalid PNG: ' + name);
}
console.log('PASS test repository boundaries, public controls API, and four PNG assets');
const temp = fs.mkdtempSync(path.join(os.tmpdir(), 'kz-cozy-tests-'));
try {
  const bundle = path.join(temp, 'intro-tests.luau');
  fs.writeFileSync(bundle, fs.readFileSync(path.join(__dirname,'intro-harness.luau'),'utf8') + '\n'
    + source.slice(introStart,introEnd) + '\n' + fs.readFileSync(path.join(__dirname,'intro-cases.luau'),'utf8'));
  const run = cp.spawnSync(process.env.LUAU_BIN || 'luau', [bundle], {encoding:'utf8'});
  process.stdout.write(run.stdout || ''); process.stderr.write(run.stderr || '');
  if (run.error) throw run.error;
  assert.equal(run.status,0,'Luau lifecycle tests failed');
} finally { fs.rmSync(temp, {recursive:true,force:true}); }
