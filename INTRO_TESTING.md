# Test UI intro update

This update builds on the exact production UI copied into this test repository. The existing palettes, main window size, sidebar layout, controls, button surfaces and background artwork are retained. The production repository is unchanged.

Continue loading the test library:

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/UniversalUI.lua"))()
```

The test repository's `universal ui` alias contains the same library. Existing game modules can keep using the same controls, ConfigManager, KZAdapter and LyraZen APIs.

The intro uses the supplied original/Kitty/blossom logos without a circular crop, and remembers the selected theme. Hash Brown and his speech bubble are anchored to the **bottom-right of the screen**, independently of the centered loading panel. He welcomes the user with typed text and small hops, says “bye!!!!” after readiness, and exits downward. Halloween has two faint ghosts restricted to side lanes outside the loader; other themes have two restrained matching motifs. The game blurs during loading and clears during the reveal.

Tabs gain a short slide with their fade, dropdowns expand smoothly, and the existing button/toggle styling is preserved. Reduced Motion and Short Repeat Intro are available in Settings → Window & navigation. Test-only preferences/assets are stored in `KZScripts/Test UI`; test configs use `KZScriptsTestHub`.

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
