# Test UI intro update

This update builds on the exact production UI copied into this test repository. The existing palettes, main window size, sidebar layout, controls, button surfaces and background artwork are retained. The production repository is unchanged.

Continue loading the test library:

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/UniversalUI.lua"))()
```

The test repository's `universal ui` alias contains the same library. Existing game modules can keep using the same controls, ConfigManager, KZAdapter and LyraZen APIs.

The loader is now a borderless scene: no central card, frame, or logo. A small left-aligned Loading percentage sits over a thin progress line at the bottom-left, while two theme motifs drift through the blurred game scene. The line moves above the corner cat on narrower screens. Regular Frames render text and images directly instead of flattening them into CanvasGroup textures.

The main UI retains the supplied original/Kitty/blossom logos and remembers the selected theme. Sidebar and minimized-button logos keep true circular masks, including the sidebar logo's backing. The main logo renders directly under Screen at whole pixel positions, follows the window, and keeps its visibility/fades. Resampling uses Roblox's default smooth filtering; the supplied PNGs are unchanged.

Hash Brown and a plain speech bubble are anchored to the **bottom-right of the screen**, independently of the loading line. He types “thanks for using KZ! a little lag on load is normal.”, makes a small hop, pauses, then says “all set. bye!!!!” and leaves slowly. The welcome has a minimum readable interval before farewell. Halloween has two faint ghosts; other themes have two restrained matching motifs. The scene's decorative area stays above the line and cat.

The status now reads **Loading 0% → Loading 100%**. The bar fills smoothly over 4.5 seconds, then shows 100% briefly and reveals the interface in about five seconds total on a cached launch. Percentage represents the loading sequence; actual initialization must also finish before it can reach 100%. Slow downloads/initialization can extend the sequence, holding below 100% while waiting. There is no skip button, and the old LoadAnimation=false option does not bypass loading.

Halloween's ghosts use a single smooth transparent PNG sprite, rendered from the included editable SVG. Two softly lit sprites drift through open space, tilt gently, then glide outward and dissolve at completion. A light glint follows the progress line. The line fades away as the blur clears and the main interface fades in. Reduced Motion suppresses decorative movement.

Tabs gain a short slide with their fade, dropdowns expand smoothly, and the existing button/toggle styling is preserved. Reduced Motion is available in Settings → Window & navigation. Test-only preferences/assets are stored in `KZScripts/Test UI`; test configs use `KZScriptsTestHub`.

Game modules that perform additional work after constructing the library can explicitly mark initialization complete:

```lua
getgenv().__KZ_UI_OPTIONS = {Game = "My Game", ManualReady = true}
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/UniversalUI.lua"))()
local ok, problem = pcall(function()
    -- Create game tabs/controls and apply saved configuration here.
    UI.ConfigManager.LoadAutoload()
end)
if ok then UI.FinishLoading() else UI.FailLoading(problem) end
```

Without ManualReady, the reveal follows the library's initialization and completed loading animation. Failure, unloading and a 30-second watchdog still release the owned blur/effects. These cleanup paths do not reveal an incomplete interface. Without file caching/custom-asset support, fallback branding is used.

Validate with `luau-compile --null UniversalUI.lua` and `node tests/run-tests.cjs` (Luau on PATH, or set LUAU_BIN). Tests cover lifecycle, the absence of a center card/logo, corner placement, responsive line/host placement, bounded scene motifs, public API compatibility, and hashes of thirteen preserved styling blocks. These checks do not emulate Roblox rendering; a live game preview remains necessary. Start a fresh client or unload the previously running UI when comparing versions.
