# KZ Scripts · Cozy Test UI

The redesign lives in **this test repository**. The production library in `zaddy1211/ui` is unchanged.

Use the test library wherever your test game script previously loaded the production `universal%20ui` file:

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/UniversalUI.lua"))()
```

For a standalone preview with examples of every control:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/TestUI.lua"))()
```

`KZ-Loader-Anime.lua` is the existing separate game picker. The redesign entry is `UniversalUI.lua`; the picker and its external game downloads are unchanged.

The UI keeps the existing public controls, configs, search, favorites, tab adapter, KZAdapter, and LyraZen bridge. The library was compared against production commit `b219e64aa628a07d0fcc5d12785a9b3d78bde2c9` before editing.

- Full original silver KZ logo for default/other themes; the supplied Kitty and blossom logos for their matching themes. Logos use Fit with no circular crop.
- A frosted loading panel, gentle full-game blur, and Hash Brown's typed welcome, small hops, and brief “bye!!!!” farewell.
- Two faint ghosts outside the Halloween loader. Other themes use two side motifs. Effects never enter the loader panel.
- Actual initialization milestones instead of a timed percentage. The interface becomes interactive when initialization completes.
- Softer cards, expanded navigation, restrained button/toggle motion, sliding tab fades, animated dropdowns, and theme/logo transitions.
- Remembered theme, reduced motion, and a shorter repeat intro under **Settings → Comfort & motion**.
- Isolated test preferences/assets in `KZScripts/Test UI`; test configs/favorites in `KZScriptsTestHub`. The test library does not overwrite production saves or destroy the production ScreenGui.

For a game module that builds controls after loading this library, opt into explicit readiness:

```lua
getgenv().__KZ_UI_OPTIONS = {Game = "My Game", ManualReady = true}
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/UniversalUI.lua"))()
local ok, problem = pcall(function()
    -- Build the game's tabs and controls here, using the existing adapter API.
    UI.ConfigManager.LoadAutoload()
end)
if ok then UI.FinishLoading() else UI.FailLoading(problem) end
```

Without `ManualReady`, the reveal follows the library's own initialization. `LoadAnimation = false` skips the intro; `ReducedMotion = true` disables host travel and side effects. **Skip intro** clears the decoration without marking incomplete initialization ready. Closing, unloading, failure, and a 30-second watchdog clear the owned blur/effects. Existing unrelated blur effects are untouched.

The four supplied PNGs are included unchanged. Executors with HTTP, file caching, and custom-asset support show them directly. If those capabilities are unavailable, the loader uses its fallback logo/cat badge.

Validation: `luau-compile --null UniversalUI.lua TestUI.lua` and `node tests/run-tests.cjs` (Luau on PATH, or set `LUAU_BIN`). The deterministic tests exercise effect placement and loading lifecycle; they do not emulate Roblox rendering. In-game appearance and executor compatibility still need a live Roblox preview.
