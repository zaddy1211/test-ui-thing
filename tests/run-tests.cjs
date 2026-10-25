const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const assert = require('node:assert/strict');
const cp = require('node:child_process');
const crypto = require('node:crypto');
const root = path.resolve(__dirname, '..');
const source = fs.readFileSync(path.join(root, 'UniversalUI.lua'), 'utf8');
const introStart = source.indexOf('-- Test-only loading host.');
const introEnd = source.indexOf('\n__KZ_Cozy.Begin()\n__KZ_Cozy.Progress(1,', introStart);
assert(introStart >= 0 && introEnd > introStart);
assert(!source.includes('raw.githubusercontent.com/zaddy1211/ui/'), 'production asset dependency');
assert(source.includes('local ASSET_ROOT = "KZScripts/Test UI"'));
assert(source.includes('Root = "KZScriptsTestHub"'));
assert(!source.includes('Root = "KZScriptsHub"'));
assert(source.includes('Parent = Screen, Name = "CrispBrandLogo"'), 'main logo is inside the flattened window');
assert(!source.includes('HASH BROWN · YOUR KZ HOST') && !source.includes('A little comfort. A little KZ.'), 'old slogans returned');
assert(!source.includes('ConfigManager.Register("Short Repeat Intro"'), 'old short intro overrides requested pace');
assert(!source.includes('Opening in ') && !source.includes('c.OpenAt'), 'old countdown returned');
assert(!source.includes('Skip intro') && !source.includes('c.Skip') && !source.includes('__KZ_UI_OPTIONS.LoadAnimation == false'), 'loading can be skipped');
assert(source.includes('thanks for using KZ! a little lag on load is normal.'), 'cat lag message missing');
for (const logo of ['c.Logo','BrandLogoShell','BrandLogo','OpenButton']) {
  assert(source.includes('New("UICorner", {Parent = '+logo+', CornerRadius = UDim.new(1, 0)})'), 'noncircular logo: '+logo);
}
assert.equal(source, fs.readFileSync(path.join(root,'universal ui'),'utf8'), 'test entry aliases differ');
const baseline = JSON.parse(fs.readFileSync(path.join(__dirname,'style-baseline.json'),'utf8'));
for (const block of baseline.blocks) {
  const a=source.indexOf(block.start), b=source.indexOf(block.end,a+block.start.length);
  assert(a>=0 && b>a, 'missing surface: '+block.name);
  assert.equal(crypto.createHash('sha256').update(source.slice(a,b)).digest('hex'),block.sha256,
    'production styling changed: '+block.name);
}
for (const name of baseline.publicFields) assert(source.includes(name+' ='), 'public field removed: '+name);
console.log('PASS '+baseline.blocks.length+' production styling blocks unchanged; '+baseline.publicFields.length+' public fields retained');
for (const name of ['Toggle', 'Slider', 'RangeSlider', 'Dropdown', 'Button', 'Textbox', 'Keybind', 'Colorpicker', 'ConfigManager', 'LyraZen', 'KZAdapter']) {
  assert(source.includes(name + ' = ' + name), 'missing public API: ' + name);
}
for (const name of ['kz-logo-original-v2.png', 'kz-logo-kitty-v1.png', 'kz-logo-blossom-v1.png', 'hash-brown-host-v1.png', 'kz-ghost-soft-v1.png']) {
  const png = fs.readFileSync(path.join(root, 'assets', name));
  assert(png.subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10])), 'invalid PNG: ' + name);
}
console.log('PASS test repository boundaries, public controls API, and five PNG assets');
const temp = fs.mkdtempSync(path.join(os.tmpdir(), 'kz-cozy-tests-'));
try {
  const bundle = path.join(temp, 'intro-tests.luau');
  const syncStart = source.indexOf('function __KZ_Cozy.SyncBrandLogo()');
  const syncEnd = source.indexOf('\nend',syncStart)+4;
  assert(syncStart>=0 && syncEnd>syncStart);
  fs.writeFileSync(bundle, fs.readFileSync(path.join(__dirname,'intro-harness.luau'),'utf8') + '\n'
    + source.slice(introStart,introEnd) + '\n' + source.slice(syncStart,syncEnd) + '\n'
    + fs.readFileSync(path.join(__dirname,'intro-cases.luau'),'utf8'));
  const run = cp.spawnSync(process.env.LUAU_BIN || 'luau', [bundle], {encoding:'utf8'});
  process.stdout.write(run.stdout || ''); process.stderr.write(run.stderr || '');
  if (run.error) throw run.error;
  assert.equal(run.status,0,'Luau lifecycle tests failed');
} finally { fs.rmSync(temp, {recursive:true,force:true}); }
