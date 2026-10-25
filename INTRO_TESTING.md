# Test UI intro update

This update builds on the exact production UI copied into this test repository. The existing palettes, main window size, sidebar layout, controls, button surfaces and background artwork are retained. The production repository is unchanged.

Continue loading the test library:

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/UniversalUI.lua"))()
```

The test repository's `universal ui` alias contains the same library. Existing game modules can keep using the same controls, ConfigManager, KZAdapter and LyraZen APIs.

The compact loader uses the supplied original/Kitty/blossom logos without a circular crop, and remembers the selected theme. Its regular Frames render text and images directly, instead of flattening them into CanvasGroup textures. The main logo also renders directly under Screen at whole pixel positions, follows the window, and keeps its visibility/fades. Resampling uses Roblox's default smooth filtering; the supplied PNGs are unchanged.

Hash Brown and a plain speech bubble are anchored to the **bottom-right of the screen**, independently of the loading panel. The old slogans, stage counter, and host heading are removed. He types “hey! thanks for using KZ <3”, makes a small hop, pauses, then says “all set. bye!!!!” and leaves slowly. Halloween has two faint ghosts restricted to side lanes outside the loader; other themes have two restrained matching motifs.

The welcome, farewell, and reveal take about **ten seconds from the visible welcome**, on first and repeat launches. Slower initialization still has to finish. Once work is ready, the status shows an honest opening countdown; the progress bar continues to represent actual initialization milestones. The old short-repeat preference no longer speeds this sequence up. Skip remains available.

Tabs gain a short slide with their fade, dropdowns expand smoothly, and the existing button/toggle styling is preserved. Reduced Motion is available in Settings → Window & navigation. Test-only preferences/assets are stored in `KZScripts/Test UI`; test configs use `KZScriptsTestHub`.

The progress bar follows interface initialization milestones. Game modules that perform additional work after constructing the library can explicitly finish the intro:

```lua
getgenv().__KZ_UI_OPTIONS = {Game = "My Game", ManualReady = true}
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/UniversalUI.lua"))()
local ok, problem = pcall(function()
    -- Create game tabs/controls and apply saved configuration here.
    UI.ConfigManager.LoadAutoload()
end)
if ok then UI.FinishLoading() else UI.FailLoading(problem) end
```

Without ManualReady, the reveal follows the library's initialization. Skip, failure, unloading and a 30-second watchdog release the owned blur/effects. Skipping does not mark incomplete initialization ready. `LoadAnimation = false` bypasses decoration. Without file caching/custom-asset support, fallback branding is used.

Validate with `luau-compile --null UniversalUI.lua` and `node tests/run-tests.cjs` (Luau on PATH, or set LUAU_BIN). Tests cover lifecycle, corner placement, viewport sizing, outside-only motifs, public API compatibility, and hashes of thirteen preserved styling blocks. These checks do not emulate Roblox rendering; a live game preview remains necessary. Start a fresh client or unload the previously running UI when comparing versions.
