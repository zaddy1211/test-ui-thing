# Test UI intro update

This update builds on the exact production UI copied into this test repository. The existing palettes, main window size, sidebar layout, controls, button surfaces and background artwork are retained. The production repository is unchanged.

Continue loading the test library:

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/UniversalUI.lua"))()
```

The test repository's `universal ui` alias contains the same library. Existing game modules can keep using the same controls, ConfigManager, KZAdapter and LyraZen APIs.

The loader is a borderless scene: no central card, frame, or logo. Hash Brown sits directly above a centered status and bright six-pixel loading bar, with his speech bubble above him. The mascot and bar are centered together and fit shorter screens. The track and label are visible immediately, including at 0%. The bar is up to 420 pixels wide and narrows on phones without shrinking its thickness or text. Regular Frames render text and images directly instead of flattening them into CanvasGroup textures.

The main UI retains the supplied original/Kitty/blossom logos and remembers the selected theme. Sidebar and minimized-button logos keep true circular masks, including the sidebar logo's backing. The main logo renders directly under Screen at whole pixel positions, follows the window, and keeps its visibility/fades. Resampling uses Roblox's default smooth filtering; the supplied PNGs are unchanged.

Hash Brown is centered **directly above the loading bar**, with a plain speech bubble above his head. He types “thanks for using kz <3” with “a little lag on load is normal.” on the next line, makes a small hop, pauses, then says “all set. bye!!!!” and fades away. The welcome has a minimum readable interval before farewell. Halloween has two faint ghosts; other themes have two restrained matching motifs. The scene's decorative area stays above the mascot, and decorations hide when shorter screens have insufficient space.

The status describes loading: “Loading images…”, “Setting up your UI…”, “Finishing up…”, and finally “Ready!”, with the percentage beside each message. While initialization is still running, it displays its actual image/interface/settings step. The bar fills smoothly over 4.5 seconds, then shows 100% briefly and reveals the interface in about five seconds total on a cached launch. Percentage represents the loading sequence; actual initialization must also finish before it can reach 100%. Slow downloads/initialization can extend the sequence, holding below 100% while waiting. There is no skip button, and the old LoadAnimation=false option does not bypass loading.

Halloween's ghosts use a single smooth transparent PNG sprite, rendered from the included editable SVG. Each has a separate soft radial halo, tinted to the theme and gently pulsing at low opacity. The included halo SVG and PowerShell renderer produce the small transparent PNG. Two sprites drift through open space, tilt gently, then glide outward and dissolve together with their halos at completion. A light glint follows the progress line. The line fades away as the blur clears and the main interface fades in. Reduced Motion suppresses decorative movement.

Tabs gain a short slide with their fade, dropdowns expand smoothly, and the existing button/toggle styling is preserved. Reduced Motion is available in Settings → Window & navigation. Test-only preferences/assets are stored in `KZScripts/Test UI`; test configs use `KZScriptsTestHub`.

The minimized reopen button can be dragged without reopening the window when released. Movement past its existing six-pixel threshold suppresses that gesture's click, including when click and release events arrive in either order. A new press resets the guard, so the next normal click or tap still opens the UI. Its global drag listener is tracked for cleanup.

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

Validate with `luau-compile --null UniversalUI.lua` and `node tests/run-tests.cjs` (Luau on PATH, or set LUAU_BIN). Tests cover lifecycle, the absence of a center card/logo, centered mascot/bar placement, bounded scene motifs, mouse and touch drag/click behavior, public API compatibility, and hashes of thirteen preserved styling blocks. These checks do not emulate Roblox rendering; a live game preview remains necessary. Start a fresh client or unload the previously running UI when comparing versions.
