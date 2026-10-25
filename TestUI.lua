-- Safe visual test entry: all UI source and artwork come from test-ui-thing.
-- Existing game modules can keep using the same UniversalUI.lua public API.
local environment = type(getgenv) == "function" and getgenv() or _G
environment.__KZ_UI_OPTIONS = {
    Game = "UI Preview", ScriptId = "CozyPreview", Subtitle = "TEST UI · COZY PREVIEW", ManualReady = true,
}
local source = game:HttpGet("https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/UniversalUI.lua")
local compile, compileError = loadstring(source)
if not compile then environment.__KZ_UI_OPTIONS = nil; error(compileError) end
local UI = compile()
local ok, problem = pcall(function()
    -- Register through the public tab adapter so existing game integrations stay compatible.
    UI.Window:CreateTab({Name = "Controls", Icon = "settings"})
    local page = UI.pages.Controls
    local comfort = UI.Section(page, "Make it yours", "Try every control with your saved theme.")
    UI.Toggle(page, comfort, "Soft toggle", true, function() end)
    UI.Slider(page, comfort, "Intensity", 0, 100, 35, "%", function() end, 1)
    UI.RangeSlider(page, comfort, "Comfort range", 0, 100, 25, 75, "%", function() end, 1)
    UI.Dropdown(page, comfort, "A little mood", {"Cozy", "Dreamy", "Quiet"}, "Cozy", function() end)
    UI.Button(page, comfort, "Say hello to KZ", true, function()
        UI.Toast("A little hello", "Thanks for picking KZ. Make yourself at home!", 3)
    end)
    local details = UI.Section(page, "Little details", "Visual test controls only; these do not change gameplay.")
    UI.Textbox(page, details, "Your note", "Something cozy…", "", function() end)
    UI.Keybind(page, details, "Example shortcut", Enum.KeyCode.F6, function() end)
    UI.Colorpicker(page, details, "Favorite color", UI.Theme.Accent, function() end)
    UI.ReportLoadingStage(3, "Applying your saved comfort settings…")
    UI.ConfigManager.LoadAutoload()
    UI.FinishLoading()
end)
if not ok then UI.FailLoading(problem); error(problem) end
return UI
