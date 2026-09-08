local __KZ_UI_ENV = (getgenv and getgenv()) or _G
local __KZ_UI_OPTIONS = (__KZ_UI_ENV and __KZ_UI_ENV.__KZ_UI_OPTIONS) or {}
if __KZ_UI_ENV then __KZ_UI_ENV.__KZ_UI_OPTIONS = nil end



do
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

q = q or {}
q.Flags = q.Flags or {}

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

local LOGO_FALLBACK = "rbxassetid://108975487405628"
local LOGO = LOGO_FALLBACK

local ASSET_ROOT = "KZScripts/UI Library"
local ASSET_DIR = ASSET_ROOT .. "/Assets"
local LOGO_FILE = ASSET_DIR .. "/logo.png"

local LOGO_PNG_BASE64 = "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"

local function EnsureAssetFolders()
    if typeof(makefolder) ~= "function" or typeof(isfolder) ~= "function" then return false end
    pcall(function()
        if not isfolder("KZScripts") then makefolder("KZScripts") end
        if not isfolder(ASSET_ROOT) then makefolder(ASSET_ROOT) end
        if not isfolder(ASSET_DIR) then makefolder(ASSET_DIR) end
        if not isfolder(ASSET_ROOT .. "/Configs") then makefolder(ASSET_ROOT .. "/Configs") end
    end)
    return true
end

local function Base64Decode(data)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = tostring(data or ""):gsub("[^" .. b .. "=]", "")
    return (data:gsub(".", function(x)
        if x == "=" then return "" end
        local r, f = "", (b:find(x, 1, true) - 1)
        for i = 6, 1, -1 do
            r = r .. ((f % 2^i - f % 2^(i - 1) > 0 and "1") or "0")
        end
        return r
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then return "" end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == "1" and 2^(8 - i) or 0)
        end
        return string.char(c)
    end))
end

local function ResolveCustomAsset(path)
    local loaders = {
        function() return getcustomasset(path) end,
        function() return getsynasset(path) end,
        function() return getcustomasset and getcustomasset(path) end,
        function()
            if syn and syn.getcustomasset then return syn.getcustomasset(path) end end,
        function()
            if crypt and crypt.base64 and readfile then

            end end,
    }
    for _, loader in ipairs(loaders) do
        local ok, result = pcall(loader)
        if ok and type(result) == "string" and result ~= "" then
            return result
        end
    end
    return nil
end

local function SaveAndLoadLogo()
    EnsureAssetFolders()
    local decoded
    local okDecode, decodedOrErr = pcall(Base64Decode, LOGO_PNG_BASE64)
    if okDecode then decoded = decodedOrErr end
    if type(decoded) ~= "string" or #decoded < 32 then
        return LOGO_FALLBACK
    end
    if typeof(writefile) == "function" then
        pcall(writefile, LOGO_FILE, decoded)
    end
    if typeof(isfile) == "function" and isfile(LOGO_FILE) then
        local asset = ResolveCustomAsset(LOGO_FILE)
        if asset then return asset end
    end
    return LOGO_FALLBACK
end

pcall(function()
    LOGO = SaveAndLoadLogo()
end)
if type(LOGO) ~= "string" or LOGO == "" then
    LOGO = LOGO_FALLBACK
end
local ICONS = {
    Home = "rbxassetid://7733960981",
    QB = "rbxassetid://6034227067",
    Catching = "rbxassetid://7733955740",
    Kicker = "rbxassetid://80008264726368",
    Player = "rbxassetid://7992557358",
    Physics = "rbxassetid://80072619653916",
    Visual = "rbxassetid://16369898431",
    Defense = "rbxassetid://98159911363596",
    Automatics = "rbxassetid://92629709486503",
    Trolling = "rbxassetid://76699723672654",
    Misc = "rbxassetid://127904742940104",
    World = "rbxassetid://7733954611",  -- globe-2 (earth)
    Settings = "rbxassetid://7734053495",
    Search = "rbxassetid://6031154871",
    Close = "rbxassetid://6031094678",
    Minimize = "rbxassetid://6031091004",
    Chevron = "rbxassetid://6031090990",
}

local Themes = {
    ["KZ Scripts"] = {
        MainBG = Color3.fromRGB(13, 13, 17), SidebarBG = Color3.fromRGB(18, 18, 24),
        TopbarBG = Color3.fromRGB(22, 22, 30), SectionBG = Color3.fromRGB(22, 22, 30),
        SectionHeaderBG = Color3.fromRGB(26, 26, 36), ElementBG = Color3.fromRGB(26, 26, 36),
        ElementHoverBG = Color3.fromRGB(34, 30, 52), Accent = Color3.fromRGB(168, 85, 247),
        TextMain = Color3.fromRGB(243, 244, 246), TextSub = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(40, 40, 55), ControlBG = Color3.fromRGB(28, 28, 38),
    },

    ["Hello Kitty"] = {
        MainBG = Color3.fromRGB(255, 240, 246), SidebarBG = Color3.fromRGB(255, 229, 239),
        TopbarBG = Color3.fromRGB(255, 234, 242), SectionBG = Color3.fromRGB(255, 234, 242),
        SectionHeaderBG = Color3.fromRGB(255, 226, 237), ElementBG = Color3.fromRGB(255, 226, 237),
        ElementHoverBG = Color3.fromRGB(255, 212, 229), Accent = Color3.fromRGB(255, 105, 180),
        TextMain = Color3.fromRGB(97, 42, 68), TextSub = Color3.fromRGB(179, 110, 140),
        Border = Color3.fromRGB(247, 178, 205), ControlBG = Color3.fromRGB(255, 220, 234),
    },

    ["Cherry Blossom"] = {
        MainBG = Color3.fromRGB(28, 19, 31), SidebarBG = Color3.fromRGB(35, 22, 38),
        TopbarBG = Color3.fromRGB(43, 27, 44), SectionBG = Color3.fromRGB(42, 27, 44),
        SectionHeaderBG = Color3.fromRGB(55, 32, 54), ElementBG = Color3.fromRGB(52, 31, 52),
        ElementHoverBG = Color3.fromRGB(78, 42, 69), Accent = Color3.fromRGB(244, 143, 177),
        TextMain = Color3.fromRGB(255, 244, 248), TextSub = Color3.fromRGB(194, 150, 174),
        Border = Color3.fromRGB(92, 52, 80), ControlBG = Color3.fromRGB(47, 28, 48),
    },

    ["Redline"] = {
        MainBG = Color3.fromRGB(9, 9, 11), SidebarBG = Color3.fromRGB(13, 12, 15),
        TopbarBG = Color3.fromRGB(17, 14, 17), SectionBG = Color3.fromRGB(19, 16, 19),
        SectionHeaderBG = Color3.fromRGB(24, 18, 21), ElementBG = Color3.fromRGB(25, 19, 22),
        ElementHoverBG = Color3.fromRGB(43, 20, 25), Accent = Color3.fromRGB(239, 68, 68),
        TextMain = Color3.fromRGB(250, 250, 250), TextSub = Color3.fromRGB(166, 154, 158),
        Border = Color3.fromRGB(55, 35, 40), ControlBG = Color3.fromRGB(22, 17, 20),
    },

    ["Midnight"] = {
        MainBG = Color3.fromRGB(8, 12, 20), SidebarBG = Color3.fromRGB(11, 17, 28),
        TopbarBG = Color3.fromRGB(13, 21, 34), SectionBG = Color3.fromRGB(14, 23, 37),
        SectionHeaderBG = Color3.fromRGB(17, 28, 45), ElementBG = Color3.fromRGB(18, 29, 47),
        ElementHoverBG = Color3.fromRGB(20, 42, 70), Accent = Color3.fromRGB(59, 130, 246),
        TextMain = Color3.fromRGB(239, 246, 255), TextSub = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(37, 55, 78), ControlBG = Color3.fromRGB(15, 25, 41),
    },

    ["Emerald"] = {
        MainBG = Color3.fromRGB(8, 13, 11), SidebarBG = Color3.fromRGB(11, 19, 16),
        TopbarBG = Color3.fromRGB(13, 24, 20), SectionBG = Color3.fromRGB(14, 26, 22),
        SectionHeaderBG = Color3.fromRGB(17, 32, 27), ElementBG = Color3.fromRGB(18, 34, 28),
        ElementHoverBG = Color3.fromRGB(20, 52, 39), Accent = Color3.fromRGB(16, 185, 129),
        TextMain = Color3.fromRGB(240, 253, 250), TextSub = Color3.fromRGB(148, 170, 162),
        Border = Color3.fromRGB(35, 62, 51), ControlBG = Color3.fromRGB(15, 29, 24),
    },

    ["Frost"] = {
        MainBG = Color3.fromRGB(9, 13, 18), SidebarBG = Color3.fromRGB(12, 18, 25),
        TopbarBG = Color3.fromRGB(15, 22, 30), SectionBG = Color3.fromRGB(16, 24, 33),
        SectionHeaderBG = Color3.fromRGB(20, 30, 41), ElementBG = Color3.fromRGB(21, 32, 43),
        ElementHoverBG = Color3.fromRGB(25, 47, 61), Accent = Color3.fromRGB(34, 211, 238),
        TextMain = Color3.fromRGB(240, 249, 255), TextSub = Color3.fromRGB(148, 176, 190),
        Border = Color3.fromRGB(39, 66, 80), ControlBG = Color3.fromRGB(17, 27, 37),
    },

    ["Monochrome"] = {
        MainBG = Color3.fromRGB(245, 245, 245), SidebarBG = Color3.fromRGB(236, 236, 236),
        TopbarBG = Color3.fromRGB(250, 250, 250), SectionBG = Color3.fromRGB(240, 240, 240),
        SectionHeaderBG = Color3.fromRGB(230, 230, 230), ElementBG = Color3.fromRGB(232, 232, 232),
        ElementHoverBG = Color3.fromRGB(216, 216, 216), Accent = Color3.fromRGB(18, 18, 18),
        TextMain = Color3.fromRGB(15, 15, 15), TextSub = Color3.fromRGB(92, 92, 92),
        Border = Color3.fromRGB(190, 190, 190), ControlBG = Color3.fromRGB(224, 224, 224),
    },

}

local ThemeAccents = {
    ["KZ Scripts"] = {Accent2 = Color3.fromRGB(192, 132, 252), Accent3 = Color3.fromRGB(124, 58, 237)},
    ["Hello Kitty"] = {Accent2 = Color3.fromRGB(255, 158, 205), Accent3 = Color3.fromRGB(230, 72, 142)},
    ["Cherry Blossom"] = {Accent2 = Color3.fromRGB(251, 182, 206), Accent3 = Color3.fromRGB(190, 92, 139)},
    ["Redline"] = {Accent2 = Color3.fromRGB(248, 113, 113), Accent3 = Color3.fromRGB(185, 28, 28)},
    ["Midnight"] = {Accent2 = Color3.fromRGB(96, 165, 250), Accent3 = Color3.fromRGB(37, 99, 235)},
    ["Emerald"] = {Accent2 = Color3.fromRGB(52, 211, 153), Accent3 = Color3.fromRGB(5, 150, 105)},
    ["Frost"] = {Accent2 = Color3.fromRGB(103, 232, 249), Accent3 = Color3.fromRGB(8, 145, 178)},
    ["Monochrome"] = {Accent2 = Color3.fromRGB(80, 80, 80), Accent3 = Color3.fromRGB(0, 0, 0)},
}

for name, extra in pairs(ThemeAccents) do
    Themes[name].Accent2 = extra.Accent2
    Themes[name].Accent3 = extra.Accent3
end

local themeName = (Themes[__KZ_UI_OPTIONS.Theme] and __KZ_UI_OPTIONS.Theme) or "KZ Scripts"
local T = {}
for key, value in pairs(Themes[themeName]) do T[key] = value end

-- Visual theme artwork is kept separate from the UI layout so the existing
-- game modules only see the same public controls and adapter methods.
local ThemeArtFiles = {
    ["KZ Scripts"] = "kz-anime-night.png",
    ["Hello Kitty"] = "pastel-cat.png",
    ["Cherry Blossom"] = "cherry-blossom-dusk.png",
}
local LoaderArtFile = "kz-loader-night.png"

-- Public GitHub asset source. Missing artwork is downloaded once and then
-- reused from the executor cache on later launches.
local ThemeArtBaseURL = "https://raw.githubusercontent.com/zaddy1211/test-ui-thing/main/assets/"
local ThemeArtCacheDir = ASSET_DIR

local function DownloadThemeArt(fileName)
    if type(fileName) ~= "string" or typeof(writefile) ~= "function" then return nil end
    EnsureAssetFolders()
    local destination = ThemeArtCacheDir .. "/" .. fileName
    if typeof(isfile) == "function" and isfile(destination) then return destination end

    local ok, body = pcall(function()
        if game.HttpGet then return game:HttpGet(ThemeArtBaseURL .. fileName) end
        return nil
    end)
    if not ok or type(body) ~= "string" or #body < 64 then return nil end

    local wrote = pcall(writefile, destination, body)
    if wrote and (typeof(isfile) ~= "function" or isfile(destination)) then
        return destination
    end
    return nil
end

-- Share theme colors
pcall(function()
    getgenv().__kzQBAccent = T.Accent
    getgenv().__kzQBAccent2 = T.Accent2
    getgenv().__kzQBAccent3 = T.Accent3
    if not getgenv().__kzQBBeamCustom then getgenv().__kzQBBeamColor = T.Accent end
    getgenv().__kzQBCardDecals = (themeName == "Hello Kitty") and { "rbxassetid://11769216849", "rbxassetid://10973237327" } or nil
    getgenv().__kzQBCardStyle = (themeName == "Hello Kitty") and {
        bg1 = Color3.fromRGB(255, 240, 246), bg2 = Color3.fromRGB(255, 224, 236),
        label = Color3.fromRGB(179, 110, 140), value = Color3.fromRGB(97, 42, 68),
    } or nil
end)
local themeBindings = {}
local connections = {}
local destroyed = false
local uiScaleFactor = 1
local notificationsEnabled = true
local sidebarHoverEnabled = true
local menuToggleKey = Enum.KeyCode.RightControl
local GetTargetScale
local SetSidebar
local __KZ_SectionControls = setmetatable({}, {__mode = "k"})

local function DetectExecutor()
    local probes = {
        function() if identifyexecutor then return identifyexecutor() end end,
        function() if getexecutorname then return getexecutorname() end end,
        function() if getexecutor then return getexecutor() end end,
        function() if syn and syn.getexecutor then return syn.getexecutor() end end,
    }
    for _, probe in ipairs(probes) do
        local ok, value = pcall(probe)
        if ok and value and tostring(value) ~= "" then
            return tostring(value)
        end
    end
    return "Unknown"
end

local executorName = DetectExecutor()

local function New(className, props)
    local object = Instance.new(className)
    for property, value in pairs(props or {}) do
        if property ~= "Parent" then object[property] = value end
    end
    if props and props.Parent then object.Parent = props.Parent end
    return object
end

local function Corner(parent, radius)
    return New("UICorner", {Parent = parent, CornerRadius = UDim.new(0, radius or 10)})
end

local function Stroke(parent, colorKey, transparency, thickness)
    local stroke = New("UIStroke", {
        Parent = parent, Color = T[colorKey or "Border"],
        Transparency = transparency or 0, Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
    table.insert(themeBindings, function()
        if stroke.Parent then stroke.Color = T[colorKey or "Border"] end
    end)
    return stroke
end

local function BindTheme(callback)
    table.insert(themeBindings, callback)
    callback()
end

local function Mix(a, b, alpha)
    return a:Lerp(b, alpha)
end

local function Gradient(parent, keys, rotation, transparency)
    local gradient = New("UIGradient", {
        Parent = parent,
        Rotation = rotation or 0,
        Color = ColorSequence.new(Color3.new(1, 1, 1)),
        Transparency = transparency or NumberSequence.new(0),
    })
    BindTheme(function()
        if not gradient.Parent then return end
        local points = {}
        for index, key in ipairs(keys) do
            local position = (#keys == 1) and 0 or ((index - 1) / (#keys - 1))
            local color
            if type(key) == "string" then color = T[key]
            else color = key(T) end
            points[index] = ColorSequenceKeypoint.new(position, color)
        end
        gradient.Color = ColorSequence.new(points)
    end)
    return gradient
end

local function Tween(object, duration, properties, style, direction)
    if not object or not object.Parent then return end
    local tween = TweenService:Create(object, TweenInfo.new(
        duration or 0.2, style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    ), properties)
    tween:Play()
    return tween
end

-- Keep UI out of PlayerGui
local function IsPlayerGuiHost(host)
    if typeof(host) ~= "Instance" then return false end
    local ok, result = pcall(function()
        if host.ClassName == "PlayerGui" then return true end
        local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not pg then return false end
        -- Reject PlayerGui children
        return host == pg or host:IsDescendantOf(pg)
    end)
    return ok and result or false
end

-- Check hidden host
local function HiddenHostUsable(host)
    if typeof(host) ~= "Instance" then return false end
    if IsPlayerGuiHost(host) then return false end
    return pcall(function()
        local probe = Instance.new("Folder")
        probe.Name = "_kz_host_probe"
        probe.Parent = host
        probe:Destroy()
    end)
end

local function ResolveHiddenHost()
    -- Try gethui
    local ok, gethuiHost = pcall(function()
        return gethui and gethui()
    end)
    if ok and HiddenHostUsable(gethuiHost) then
        return gethuiHost
    end

    -- Try CoreGui
    local coreGui = game:GetService("CoreGui")
    if HiddenHostUsable(coreGui) then
        return coreGui
    end

    return nil
end

local parent = ResolveHiddenHost()

if not parent then
    error(
        "KZ UI: no hidden GUI container available on this executor "
        .. "(gethui returned PlayerGui or an unwritable container, and "
        .. "CoreGui is also unusable). Refusing to parent into PlayerGui "
        .. "because FF3 detects foreign GUIs there.",
        0
    )
end

-- Remove old UI copies
for _, location in ipairs({parent, LocalPlayer:FindFirstChild("PlayerGui")}) do
    if location then
        for _, staleName in ipairs({"KZScriptsUniversal", "KZCursor", "KZScriptsFootballFusion"}) do
            local old = location:FindFirstChild(staleName)
            if old then old:Destroy() end
        end
    end
end

local Screen = New("ScreenGui", {
    Parent = parent, Name = "KZScriptsUniversal", ResetOnSpawn = false,
    IgnoreGuiInset = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local Dim = New("Frame", {
    Parent = Screen, Name = "Dim", Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = T.MainBG, BackgroundTransparency = 1,
    BorderSizePixel = 0,
})

local Window = New("CanvasGroup", {
    Parent = Screen, Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(900, 540),
    BackgroundColor3 = T.MainBG, BorderSizePixel = 0, ClipsDescendants = true,
    GroupTransparency = 0, Active = true,
})
Corner(Window, 18)
local windowStroke = Stroke(Window, "Border", 0.12, 1.2)
local Scale = New("UIScale", {Parent = Window, Scale = uiScaleFactor})

-- Main background
local WindowFade = New("Frame", {
    Parent = Window, Name = "WindowFade", Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = T.MainBG, BorderSizePixel = 0, ZIndex = 0,
})
local windowFadeGradient = Gradient(WindowFade, {
    function(t) return Mix(t.MainBG, t.Accent3, 0.18) end,
    "MainBG",
    function(t) return Mix(t.MainBG, t.Accent2, 0.2) end,
}, 20)
windowFadeGradient.Offset = Vector2.new(-0.18, -0.06)
BindTheme(function()
    if WindowFade.Parent then WindowFade.BackgroundColor3 = T.MainBG end
end)

local Artwork = New("ImageLabel", {
    Parent = Window, Name = "ThemeArtwork", Size = UDim2.new(1, 42, 1, 42),
    Position = UDim2.fromOffset(-21, -21), BackgroundTransparency = 1,
    ImageTransparency = 0.62, ScaleType = Enum.ScaleType.Crop,
    ImageColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 1,
})
local ArtworkShade = New("Frame", {
    Parent = Window, Name = "ArtworkShade", Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = T.MainBG, BackgroundTransparency = 0.28,
    BorderSizePixel = 0, ZIndex = 2,
})
local ArtworkVignette = New("Frame", {
    Parent = Window, Name = "ArtworkVignette", Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.82,
    BorderSizePixel = 0, ZIndex = 3,
})

local function ResolveThemeArt(theme)
    local fileName = ThemeArtFiles[theme]
    if type(fileName) ~= "string" or typeof(isfile) ~= "function" then return nil end
    local candidates = {
        ASSET_DIR .. "/" .. fileName,
        "KZ_UI_ThemeAssets/" .. fileName,
        fileName,
    }
    local downloaded = DownloadThemeArt(fileName)
    if downloaded then table.insert(candidates, 1, downloaded) end
    for _, path in ipairs(candidates) do
        if isfile(path) then
            local ok, asset = pcall(ResolveCustomAsset, path)
            if ok and type(asset) == "string" and asset ~= "" then return asset end
        end
    end
    return nil
end

local function ResolveLoaderArt()
    if typeof(isfile) ~= "function" then return nil end
    local candidates = {ASSET_DIR .. "/" .. LoaderArtFile, "KZ_UI_ThemeAssets/" .. LoaderArtFile, LoaderArtFile}
    local downloaded = DownloadThemeArt(LoaderArtFile)
    if downloaded then table.insert(candidates, 1, downloaded) end
    for _, path in ipairs(candidates) do
        if isfile(path) then
            local ok, asset = pcall(ResolveCustomAsset, path)
            if ok and type(asset) == "string" and asset ~= "" then return asset end
        end
    end
    return ResolveThemeArt("KZ Scripts")
end

local function UpdateThemeArt(theme, animate)
    if not Artwork or not Artwork.Parent then return end
    local asset = ResolveThemeArt(theme)
    if asset then
        if animate then Tween(Artwork, 0.24, {ImageTransparency = 1}, Enum.EasingStyle.Sine) end
        task.delay(animate and 0.2 or 0, function()
            if not Artwork.Parent then return end
            Artwork.Image = asset
            Artwork.ImageTransparency = animate and 1 or 0.62
            if animate then Tween(Artwork, 0.55, {ImageTransparency = 0.62}, Enum.EasingStyle.Quint) end
        end)
    else
        Artwork.Image = ""
    end
    ArtworkShade.BackgroundColor3 = T.MainBG
    ArtworkVignette.BackgroundTransparency = theme == "Hello Kitty" and 0.9 or 0.82
end

UpdateThemeArt(themeName, false)
BindTheme(function()
    if ArtworkShade.Parent then ArtworkShade.BackgroundColor3 = T.MainBG end
end)

local SIDEBAR_COMPACT, SIDEBAR_OPEN = 64, 188
local sidebarExpanded = false
local currentPage = "Home"
local navEntries = {}
local pages = {}

-- Shared UI state
local __KZ_QOL = {
    ToggleRegistry = {},
    KeybindRegistry = {},
}

local MARGIN = 12

local Sidebar = New("Frame", {
    Parent = Window, Name = "Sidebar", Size = UDim2.new(0, SIDEBAR_COMPACT, 1, 0),
    BackgroundColor3 = T.SidebarBG, BackgroundTransparency = 0.1,
    BorderSizePixel = 0, ZIndex = 20, ClipsDescendants = true,
})

Gradient(Sidebar, {
    function(t) return Mix(t.SidebarBG, t.Accent, 0.16) end,
    "SidebarBG",
    function(t) return Mix(t.SidebarBG, t.Accent3, 0.13) end,
}, 90)
local sideLine = New("Frame", {
    Parent = Sidebar, AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0),
    Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = T.Border,
    BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 21,
    Visible = true,
})

local Brand = New("Frame", {
    Parent = Sidebar, Size = UDim2.new(1, 0, 0, 78), BackgroundTransparency = 1, ZIndex = 22,
})
local BrandLogoShell = New("Frame", {
    Parent = Brand, Position = UDim2.fromOffset(12, 16), Size = UDim2.fromOffset(40, 40),
    BackgroundColor3 = T.ElementBG, BorderSizePixel = 0, ZIndex = 23,
    Visible = true,
})

New("UICorner", {Parent = BrandLogoShell, CornerRadius = UDim.new(1, 0)})
Gradient(BrandLogoShell, {"Accent", "Accent2", "Accent3"}, 35)
Stroke(BrandLogoShell, "Accent2", 0.08, 1.2)
local BrandLogo = New("ImageLabel", {
    Parent = BrandLogoShell, AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1, Image = LOGO, ScaleType = Enum.ScaleType.Fit, ZIndex = 24,
    Visible = true,
})
New("UICorner", {Parent = BrandLogo, CornerRadius = UDim.new(1, 0)})

task.spawn(function()
    task.wait(0.25)
    local asset = nil
    pcall(function()
        if typeof(isfile) == "function" and isfile(LOGO_FILE) then
            asset = ResolveCustomAsset(LOGO_FILE)
        end
    end)
    if type(asset) == "string" and asset ~= "" then
        LOGO = asset
        if BrandLogo and BrandLogo.Parent then BrandLogo.Image = LOGO end
        if OpenButton and OpenButton.Parent and OpenButton:IsA("ImageButton") then
            OpenButton.Image = LOGO
        end
    end
end)
local BrandTitle = New("TextLabel", {
    Parent = Brand, Position = UDim2.fromOffset(70, 18), Size = UDim2.new(1, -80, 0, 22),
    BackgroundTransparency = 1, Text = "KZ SCRIPTS", Font = Enum.Font.GothamBold,
    TextSize = 16, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 1, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 23,
})
local BrandSub = New("TextLabel", {
    Parent = Brand, Position = UDim2.fromOffset(70, 40), Size = UDim2.new(1, -80, 0, 16),
    BackgroundTransparency = 1, Text = string.upper(tostring((__KZ_UI_OPTIONS.Subtitle or __KZ_UI_OPTIONS.Game) or "UNIVERSAL HUB")), Font = Enum.Font.GothamMedium,
    TextSize = 8, TextColor3 = T.Accent, TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 1, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 23,
})

local NavScroll = New("ScrollingFrame", {
    Parent = Sidebar, Position = UDim2.fromOffset(0, 78), Size = UDim2.new(1, 0, 1, -150),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
    CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 22,
})
New("UIPadding", {
    Parent = NavScroll, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
    PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 8),
})
New("UIListLayout", {Parent = NavScroll, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})

-- Keep the animated selection behind the scrolling buttons and clipped to the
-- navigation viewport. Scrolling should move the highlight with its real tab,
-- never leave it sitting over a different one.
local NavIndicatorLayer = New("Frame", {
    Parent = Sidebar, Position = UDim2.fromOffset(0, 78), Size = UDim2.new(1, 0, 1, -150),
    BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 22,
})

__KZ_QOL.NavSelectionGlow = New("Frame", {
    Parent = NavIndicatorLayer, Name = "AnimatedTabIndicator", Position = UDim2.fromOffset(10, 4),
    Size = UDim2.fromOffset(SIDEBAR_COMPACT - 20, 43), BackgroundColor3 = T.Accent,
    BackgroundTransparency = 0.88, BorderSizePixel = 0, ZIndex = 22, Visible = false,
})
Corner(__KZ_QOL.NavSelectionGlow, 11)
__KZ_QOL.NavGlowStroke = Stroke(__KZ_QOL.NavSelectionGlow, "Accent", 0.3, 1)
Gradient(__KZ_QOL.NavSelectionGlow, {
    function(t) return Mix(t.Accent, t.MainBG, .12) end,
    function(t) return Mix(t.Accent2, t.MainBG, .18) end,
}, 0)
BindTheme(function()
    if __KZ_QOL.NavSelectionGlow.Parent then
        __KZ_QOL.NavSelectionGlow.BackgroundColor3 = T.Accent
        __KZ_QOL.NavGlowStroke.Color = T.Accent
    end
end)

local SideFooter = New("Frame", {
    Parent = Sidebar, AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1),
    Size = UDim2.new(1, 0, 0, 70), BackgroundTransparency = 1, ZIndex = 22,
})
local Profile = New("Frame", {
    Parent = SideFooter, Position = UDim2.fromOffset(10, 8), Size = UDim2.new(1, -20, 0, 50),
    BackgroundColor3 = T.ElementBG, BackgroundTransparency = 0.25, ZIndex = 23,
})
Corner(Profile, 12)
Gradient(Profile, {function(t) return Mix(t.ElementBG, t.Accent3, .13) end, function(t) return Mix(t.ElementBG, t.Accent2, .10) end}, 15)
local Avatar = New("ImageLabel", {
    Parent = Profile, Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(34, 34),
    BackgroundColor3 = T.ControlBG, Image = "", ZIndex = 24,
})
Corner(Avatar, 10)
local ProfileName = New("TextLabel", {
    Parent = Profile, Position = UDim2.fromOffset(50, 7), Size = UDim2.new(1, -56, 0, 19),
    BackgroundTransparency = 1, Text = LocalPlayer.DisplayName, Font = Enum.Font.GothamSemibold,
    TextSize = 11, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 1, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 24,
})
local ProfileStatus = New("TextLabel", {
    Parent = Profile, Position = UDim2.fromOffset(50, 25), Size = UDim2.new(1, -56, 0, 16),
    BackgroundTransparency = 1, Text = "●  " .. string.upper(tostring((__KZ_UI_OPTIONS.Subtitle or __KZ_UI_OPTIONS.Game) or "UNIVERSAL HUB")), Font = Enum.Font.GothamMedium,
    TextSize = 8, TextColor3 = T.Accent, TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 1, ZIndex = 24,
})
task.spawn(function()
    -- Roblox avatar thumbnail
    if not Avatar.Parent then return end
    local url = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150"
    pcall(function() Avatar.Image = url end)
end)

local CONTENT_RIGHT_INSET = 8
local Content = New("Frame", {
    Parent = Window, Name = "Content", Position = UDim2.fromOffset(SIDEBAR_COMPACT, 0),
    Size = UDim2.new(1, -(SIDEBAR_COMPACT + CONTENT_RIGHT_INSET), 1, 0), BackgroundTransparency = 1, ZIndex = 5,
    Active = true,
})

local function ApplyContentLayout(expanded, instant)
    local offset = expanded and SIDEBAR_OPEN or SIDEBAR_COMPACT
    if instant then
        Content.Position = UDim2.fromOffset(offset, 0)
        Content.Size = UDim2.new(1, -(offset + CONTENT_RIGHT_INSET), 1, 0)
    else
        Tween(Content, 0.28, {
            Position = UDim2.fromOffset(offset, 0),
            Size = UDim2.new(1, -(offset + CONTENT_RIGHT_INSET), 1, 0),
        })
    end
end

local Topbar = New("Frame", {
    Parent = Content, Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = T.TopbarBG,
    BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 10,
    Active = true,
})
local topLine = New("Frame", {
    Parent = Topbar, AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1),
    Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = T.Border,
    BackgroundTransparency = 0.65, BorderSizePixel = 0, ZIndex = 11,
})
local PageTitle = New("TextLabel", {
    Parent = Topbar, Position = UDim2.fromOffset(24, 14), Size = UDim2.fromOffset(280, 24),
    BackgroundTransparency = 1, Text = "Status", Font = Enum.Font.GothamBold,
    TextSize = 19, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
})
local Breadcrumb = New("TextLabel", {
    Parent = Topbar, Position = UDim2.fromOffset(24, 39), Size = UDim2.fromOffset(360, 16),
    BackgroundTransparency = 1, Text = "KZ Scripts  /  " .. tostring((__KZ_UI_OPTIONS.Subtitle or __KZ_UI_OPTIONS.Game) or "Universal"), Font = Enum.Font.Gotham,
    TextSize = 10, TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
})

local SearchBox = New("Frame", {
    Parent = Topbar, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -104, 0.5, 0),
    Size = UDim2.fromOffset(210, 36), BackgroundColor3 = T.ControlBG,
    BackgroundTransparency = 0.12, ZIndex = 12,
})
Corner(SearchBox, 11)
Gradient(SearchBox, {function(t) return Mix(t.ControlBG, t.Accent3, .12) end, function(t) return Mix(t.ControlBG, t.Accent2, .10) end}, 0)
Stroke(SearchBox, "Border", 0.2)
local SearchIcon = New("ImageLabel", {
    Parent = SearchBox, Position = UDim2.fromOffset(11, 9), Size = UDim2.fromOffset(18, 18),
    BackgroundTransparency = 1, Image = ICONS.Search, ImageColor3 = T.TextSub, ZIndex = 13,
})
local SearchInput = New("TextBox", {
    Parent = SearchBox, Position = UDim2.fromOffset(38, 0), Size = UDim2.new(1, -46, 1, 0),
    BackgroundTransparency = 1, Text = "", PlaceholderText = "Search all tabs...",
    PlaceholderColor3 = T.TextSub, TextColor3 = T.TextMain, Font = Enum.Font.Gotham,
    TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 13,
})

local function IconButton(icon, xOffset)
    local button = New("ImageButton", {
        Parent = Topbar, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, xOffset, 0.5, 0), Size = UDim2.fromOffset(32, 32),
        BackgroundColor3 = T.ControlBG, BackgroundTransparency = 0.18,
        Image = icon, ImageColor3 = T.TextSub, AutoButtonColor = false, ZIndex = 12,
    })
    Corner(button, 10)
    button.MouseEnter:Connect(function()
        Tween(button, 0.16, {BackgroundTransparency = 0, ImageColor3 = T.TextMain})
    end)
    button.MouseLeave:Connect(function()
        Tween(button, 0.16, {BackgroundTransparency = 0.18, ImageColor3 = T.TextSub})
    end)
    return button
end
local MinimizeButton = IconButton(ICONS.Minimize, -58)
local CloseButton = IconButton(ICONS.Close, -18)

local PageHost = New("Frame", {
    Parent = Content, Position = UDim2.fromOffset(0, 72), Size = UDim2.new(1, 0, 1, -72),
    BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 6,
})

local OpenButton = New("ImageButton", {
    Parent = Screen, Name = "OpenButton", AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 20, 0.5, 0), Size = UDim2.fromOffset(54, 54),
    BackgroundColor3 = T.MainBG, BackgroundTransparency = 0.04,
    Image = LOGO, ImageColor3 = Color3.fromRGB(255, 255, 255),
    ScaleType = Enum.ScaleType.Fit, Visible = false, ClipsDescendants = true,
    AutoButtonColor = false, ZIndex = 100,
})
New("UICorner", {Parent = OpenButton, CornerRadius = UDim.new(1, 0)})
-- Keep minimized logo colors
Stroke(OpenButton, "Accent2", 0.02, 1.6)
New("UIPadding", {
    Parent = OpenButton, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
})

local watermarkEnabled = true

local Watermark = New("Frame", {
    Parent = Screen, Name = "Watermark", AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -20, 0, 20), Size = UDim2.fromOffset(340, 30),
    BackgroundColor3 = T.SidebarBG, BackgroundTransparency = 0.15,
    Visible = watermarkEnabled, ZIndex = 300,
})
Corner(Watermark, 8)
local watermarkStroke = Stroke(Watermark, "Border", 0.25, 1)

local watermarkLabel = New("TextLabel", {
    Parent = Watermark, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    Text = "KZ Scripts  |  " .. LocalPlayer.DisplayName .. "  |  0 FPS  |  0 ms",
    Font = Enum.Font.GothamSemibold, TextSize = 10, TextColor3 = T.TextMain,
    ZIndex = 301,
})
New("UIPadding", {
    Parent = watermarkLabel, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
})

local openButtonDragging = false
local openButtonDragStart = nil
local openButtonStartPosition = nil
local openButtonDragInput = nil
local openButtonMoved = false
local OPEN_BUTTON_DRAG_THRESHOLD = 6

OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        openButtonDragging = true
        openButtonDragStart = input.Position
        openButtonStartPosition = OpenButton.Position
        openButtonDragInput = input
        openButtonMoved = false
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                openButtonDragging = false
                openButtonDragInput = nil
            end
        end)
    end
end)

OpenButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        openButtonDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not openButtonDragging or input ~= openButtonDragInput then return end
    local delta = input.Position - openButtonDragStart

    if not openButtonMoved then
        if math.abs(delta.X) < OPEN_BUTTON_DRAG_THRESHOLD
            and math.abs(delta.Y) < OPEN_BUTTON_DRAG_THRESHOLD then
            return
        end
        openButtonMoved = true
    end

    local newX = openButtonStartPosition.X.Offset + delta.X
    local newY = openButtonStartPosition.Y.Offset + delta.Y
    OpenButton.Position = UDim2.new(
        openButtonStartPosition.X.Scale, newX,
        openButtonStartPosition.Y.Scale, newY
    )
end)

local DropdownLayer = New("Frame", {
    Parent = Window, Name = "DropdownLayer", Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 350, Visible = false,
})

local SearchResults = New("ScrollingFrame", {
    Parent = DropdownLayer, Name = "SearchResults", Size = UDim2.fromOffset(310, 220),
    BackgroundColor3 = T.SectionBG, Visible = false, ZIndex = 500,
    BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = T.Accent,
    CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Active = true, ScrollingEnabled = true, ScrollingDirection = Enum.ScrollingDirection.Y,
})
Corner(SearchResults, 10)
local searchResultsStroke = Stroke(SearchResults, "Border", 0.15)
New("UIListLayout", {Parent = SearchResults, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})
New("UIPadding", {Parent = SearchResults, PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)})
__KZ_QOL.SearchEmpty = New("TextLabel", {
    Parent = SearchResults, LayoutOrder = 100000, Size = UDim2.new(1, 0, 0, 54),
    BackgroundTransparency = 1, Text = "No matching features\nTry another name or description.",
    Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = T.TextSub,
    TextWrapped = true, Visible = false, ZIndex = 501,
})
BindTheme(function() if __KZ_QOL.SearchEmpty.Parent then __KZ_QOL.SearchEmpty.TextColor3 = T.TextSub end end)

__KZ_QOL.ThemeTransitionOverlay = New("Frame", {
    Parent = Window, Name = "ThemeTransition", Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = T.Accent, BackgroundTransparency = 1, BorderSizePixel = 0,
    Visible = false, Active = false, ZIndex = 900,
})
Gradient(__KZ_QOL.ThemeTransitionOverlay, {"Accent3", "Accent", "Accent2"}, 25)
__KZ_QOL.PlayThemeTransition = function(applyTheme)
    __KZ_QOL.ThemeTransitionOverlay.Visible = true
    __KZ_QOL.ThemeTransitionOverlay.BackgroundTransparency = 1
    Tween(__KZ_QOL.ThemeTransitionOverlay, 0.16, {BackgroundTransparency = 0.76}, Enum.EasingStyle.Sine)
    task.delay(0.12, function()
        if type(applyTheme) == "function" then pcall(applyTheme) end
        Tween(__KZ_QOL.ThemeTransitionOverlay, 0.5, {BackgroundTransparency = 1}, Enum.EasingStyle.Quint)
        task.delay(0.52, function()
            if __KZ_QOL.ThemeTransitionOverlay.Parent then __KZ_QOL.ThemeTransitionOverlay.Visible = false end
        end)
    end)
end

local function PositionSearchResults()
    if not SearchResults or not SearchBox or not Window then return end
    local windowPos = Window.AbsolutePosition
    local layerSize = DropdownLayer.AbsoluteSize
    local x = SearchBox.AbsolutePosition.X - windowPos.X
    local y = SearchBox.AbsolutePosition.Y - windowPos.Y + SearchBox.AbsoluteSize.Y + 6
    local width = SearchResults.AbsoluteSize.X > 0 and SearchResults.AbsoluteSize.X or 310
    local height = SearchResults.AbsoluteSize.Y > 0 and SearchResults.AbsoluteSize.Y or 220
    x = math.clamp(x, 8, math.max(8, layerSize.X - width - 8))
    y = math.clamp(y, 8, math.max(8, layerSize.Y - height - 8))
    SearchResults.Position = UDim2.fromOffset(x, y)
end

local ToastHost = New("Frame", {
    Parent = Screen, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -18, 1, -18),
    Size = UDim2.fromOffset(340, 320), BackgroundTransparency = 1, ZIndex = 200,
})
New("UIListLayout", {
    Parent = ToastHost, VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8),
})
local function Toast(title, message, duration)
    local life = math.max(tonumber(duration) or 3.2, 0.5)
    local holder = New("Frame", {
        Parent = ToastHost, Size = UDim2.fromOffset(320, 0), BackgroundTransparency = 1,
        ClipsDescendants = true, ZIndex = 201,
    })
    local card = New("CanvasGroup", {
        Parent = holder, Position = UDim2.fromOffset(340, 0), Size = UDim2.fromOffset(320, 86),
        BackgroundColor3 = T.SectionBG, BackgroundTransparency = 0.04,
        GroupTransparency = 1, ClipsDescendants = true, ZIndex = 202,
    })
    Corner(card, 15)
    local cardStroke = Stroke(card, "Border", 0.12, 1.1)
    Gradient(card, {
        function(t) return Mix(t.SectionBG, t.Accent3, 0.13) end,
        "SectionBG",
        function(t) return Mix(t.SectionBG, t.Accent2, 0.11) end,
    }, 0)

    local accent = New("Frame", {
        Parent = card, Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(4, 62),
        BackgroundColor3 = T.Accent, BorderSizePixel = 0, ZIndex = 203,
    })
    Corner(accent, 3)
    Gradient(accent, {"Accent3", "Accent", "Accent2"}, 90)

    local dot = New("Frame", {
        Parent = card, Position = UDim2.fromOffset(26, 15), Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = T.Accent, BorderSizePixel = 0, ZIndex = 204,
    })
    Corner(dot, 4)
    local titleLabel = New("TextLabel", {
        Parent = card, Position = UDim2.fromOffset(42, 9), Size = UDim2.new(1, -54, 0, 22),
        BackgroundTransparency = 1, Text = tostring(title or "Notice"), Font = Enum.Font.GothamBold,
        TextSize = 12, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 204,
    })
    local messageLabel = New("TextLabel", {
        Parent = card, Position = UDim2.fromOffset(42, 32), Size = UDim2.new(1, -54, 0, 34),
        BackgroundTransparency = 1, Text = tostring(message or ""), Font = Enum.Font.Gotham,
        TextSize = 10, TextColor3 = T.TextSub, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 204,
    })
    local progress = New("Frame", {
        Parent = card, Position = UDim2.new(0, 14, 1, -7), Size = UDim2.new(1, -28, 0, 3),
        BackgroundColor3 = T.Accent, BorderSizePixel = 0, ZIndex = 204,
    })
    Corner(progress, 2)
    Gradient(progress, {"Accent3", "Accent", "Accent2"}, 0)
    BindTheme(function()
        if not card.Parent then return end
        cardStroke.Color = T.Border
        dot.BackgroundColor3 = T.Accent
        titleLabel.TextColor3 = T.TextMain
        messageLabel.TextColor3 = T.TextSub
        progress.BackgroundColor3 = T.Accent
    end)

    Tween(holder, 0.22, {Size = UDim2.fromOffset(320, 86)})
    Tween(card, 0.35, {Position = UDim2.fromOffset(0, 0), GroupTransparency = 0})
    Tween(progress, life, {Size = UDim2.new(0, 0, 0, 3)}, Enum.EasingStyle.Linear)
    task.delay(life, function()
        if not card.Parent then return end
        local out = Tween(card, 0.28, {Position = UDim2.fromOffset(340, 0), GroupTransparency = 1})
        if out then out.Completed:Wait() end
        if holder.Parent then holder:Destroy() end
    end)
end

notify = function(title, message, duration)
    if notificationsEnabled then
        Toast(title, message, duration)
    end
end

local SCRIPT_ID = tostring(__KZ_UI_OPTIONS.ScriptId or __KZ_UI_OPTIONS.Game or "Universal")
local ConfigManager = (function()
    local HttpService = game:GetService("HttpService")
    local CM = {
        ScriptId = SCRIPT_ID,
        Root = "KZScriptsHub",
        Folder = "KZScriptsHub/Saves/" .. SCRIPT_ID,
        AutoloadFile = "KZScriptsHub/Saves/" .. SCRIPT_ID .. "/Autoload.txt",
        Flags = {},
        Ignore = { ["Config Name"] = true, ["View Configs"] = true, ["Autoload"] = true },
    }

    local function ensureTree()
        if typeof(makefolder) ~= "function" or typeof(isfolder) ~= "function" then return end
        if not isfolder("KZScriptsHub") then pcall(makefolder, "KZScriptsHub") end
        if not isfolder("KZScriptsHub/Saves") then pcall(makefolder, "KZScriptsHub/Saves") end
        if not isfolder(CM.Root) then pcall(makefolder, CM.Root) end
        if not isfolder(CM.Folder) then pcall(makefolder, CM.Folder) end
    end

    local function sanitize(name)
        name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
        name = name:gsub("[\\/:*?\"<>|]", "_")
        return (name ~= "" and name) or "default"
    end

    local function encode(value)
        local t = typeof(value)
        if t == "Color3" then
            return { Type = "Color3", R = value.R, G = value.G, B = value.B }
        elseif t == "EnumItem" then
            return { Type = "EnumItem", EnumType = tostring(value.EnumType), Name = value.Name }
        elseif t == "table" then
            local out = {}
            for k, v in pairs(value) do out[k] = encode(v) end
            return out
        end
        return value
    end

    local function decode(value)
        if type(value) ~= "table" then return value end
        if value.Type == "Color3" then
            return Color3.new(value.R or 0, value.G or 0, value.B or 0)
        elseif value.Type == "EnumItem" then
            local et = Enum[value.EnumType]
            if et then
                local ok, item = pcall(function() return et[value.Name] end)
                if ok then return item end
            end
            return nil
        end
        local out = {}
        for k, v in pairs(value) do out[k] = decode(v) end
        return out
    end

    function CM.Register(name, control)
        if type(name) == "string" and type(control) == "table" then
            CM.Flags[name] = control
        end
        return control
    end

    function CM.List()
        local names = {}
        if typeof(listfiles) ~= "function" then return names end
        ensureTree()
        local ok, files = pcall(listfiles, CM.Folder)
        if not ok or type(files) ~= "table" then return names end
        for _, entry in ipairs(files) do
            local path = entry
            if type(entry) == "table" then
                path = entry.Path or entry.path or entry.Name or entry.name or tostring(entry)
            end
            if type(path) == "string" then
                local n = path:match("([^/\\]+)%.json$")
                if n then table.insert(names, n) end
            end
        end
        table.sort(names)
        return names
    end

    function CM.Save(name)
        if typeof(writefile) ~= "function" then return false, "no writefile" end
        ensureTree()
        name = sanitize(name)
        local data = {}
        for flagName, flag in pairs(CM.Flags) do
            if not CM.Ignore[flagName] and type(flag) == "table" and type(flag.Get) == "function" then
                local ok, value = pcall(flag.Get)
                if ok then data[flagName] = encode(value) end
            end
        end
        local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
        if not ok then return false, encoded end
        local path = CM.Folder .. "/" .. name .. ".json"
        local wok, err = pcall(writefile, path, encoded)
        return wok, wok and path or err
    end

    function CM.ExportJSON()
        local data = {}
        for flagName, flag in pairs(CM.Flags) do
            if not CM.Ignore[flagName] and type(flag) == "table" and type(flag.Get) == "function" then
                local ok, value = pcall(flag.Get)
                if ok then data[flagName] = encode(value) end
            end
        end
        local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
        return ok, ok and encoded or tostring(encoded)
    end

    function CM.Load(name)
        if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then
            return false, "no filesystem"
        end
        ensureTree()
        name = sanitize(name)
        local path = CM.Folder .. "/" .. name .. ".json"
        if not isfile(path) then return false, "not found" end
        local ok, raw = pcall(readfile, path)
        if not ok then return false, raw end
        local dok, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not dok or type(data) ~= "table" then return false, "bad json" end

        if data["UI Theme"] and CM.Flags["UI Theme"] then
            local decoded = decode(data["UI Theme"])
            pcall(function() CM.Flags["UI Theme"].Set(decoded, true) end)
        end

        local applied = 0
        for flagName, rawValue in pairs(data) do
            if not CM.Ignore[flagName] and flagName ~= "UI Theme" then
                local flag = CM.Flags[flagName]
                if flag and type(flag.Set) == "function" then
                    local value = decode(rawValue)
                    if pcall(function() flag.Set(value, true) end) then
                        applied = applied + 1
                    end
                end
            end
        end
        return true, applied
    end

    function CM.ImportJSON(raw)
        raw = tostring(raw or "")
        if raw:gsub("%s+", "") == "" then
            return false, "paste a JSON config first"
        end

        local dok, data = pcall(function()
            return HttpService:JSONDecode(raw)
        end)
        if not dok or type(data) ~= "table" then
            return false, "invalid JSON"
        end

        -- Accept wrapped configs
        if type(data.flags) == "table" then
            data = data.flags
        elseif type(data.Flags) == "table" then
            data = data.Flags
        end

        local applied = 0
        local skipped = 0

        -- Apply theme first
        if data["UI Theme"] ~= nil and CM.Flags["UI Theme"] then
            local decodedTheme = decode(data["UI Theme"])
            if pcall(function() CM.Flags["UI Theme"].Set(decodedTheme, true) end) then
                applied = applied + 1
            else
                skipped = skipped + 1
            end
        end

        for flagName, rawValue in pairs(data) do
            if flagName ~= "UI Theme" and not CM.Ignore[flagName] then
                local flag = CM.Flags[flagName]
                if flag and type(flag.Set) == "function" then
                    local value = decode(rawValue)
                    if pcall(function() flag.Set(value, true) end) then
                        applied = applied + 1
                    else
                        skipped = skipped + 1
                    end
                else
                    skipped = skipped + 1
                end
            end
        end

        return true, applied, skipped
    end

    function CM.Delete(name)
        if typeof(delfile) ~= "function" or typeof(isfile) ~= "function" then
            return false, "no filesystem"
        end
        name = sanitize(name)
        local path = CM.Folder .. "/" .. name .. ".json"
        if isfile(path) then
            local ok, err = pcall(delfile, path)
            return ok, err
        end
        return false, "not found"
    end

    function CM.SetAutoload(name, enabled)
        if typeof(writefile) ~= "function" then return false end
        ensureTree()
        if enabled then
            pcall(writefile, CM.AutoloadFile, sanitize(name))
        elseif typeof(isfile) == "function" and isfile(CM.AutoloadFile) and typeof(delfile) == "function" then
            pcall(delfile, CM.AutoloadFile)
        end
        return true
    end

    function CM.GetAutoload()
        if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then return nil end
        if isfile(CM.AutoloadFile) then
            local ok, name = pcall(readfile, CM.AutoloadFile)
            if ok and type(name) == "string" and name ~= "" then
                return sanitize(name)
            end
        end
        return nil
    end

    function CM.LoadAutoload()
        local name = CM.GetAutoload()
        if not name then return false, "none" end
        return CM.Load(name)
    end

    ensureTree()
    return CM
end)()

local function CreatePage(name)
    local page = New("CanvasGroup", {
        Parent = PageHost, Name = name .. "Page", Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, Visible = false, GroupTransparency = 1,
    })
    local scroll = New("ScrollingFrame", {
        Parent = page, Size = UDim2.new(1, -10, 1, 0), BackgroundTransparency = 1,
        BorderSizePixel = 0, ScrollBarThickness = 6, ScrollBarImageColor3 = T.Accent,
        Active = true, ScrollingEnabled = true, ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,

        CanvasSize = UDim2.fromOffset(0, 0),
        ScrollBarImageTransparency = 0.4,
    })
    New("UIPadding", {
        Parent = scroll, PaddingTop = UDim.new(0, 18), PaddingBottom = UDim.new(0, 24),
        PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 22),
    })

    local bodyLayout = New("UIListLayout", {Parent = scroll, Padding = UDim.new(0, 14), SortOrder = Enum.SortOrder.LayoutOrder})

    pages[name] = {Name = name, Group = page, Scroll = scroll, Body = scroll, BodyLayout = bodyLayout, Searchables = {}, FavoriteCounts = {}}
    BindTheme(function()
        if scroll.Parent then scroll.ScrollBarImageColor3 = T.Accent end
    end)
    return pages[name]
end

local function Section(page, title, subtitle, widthScale)
    local card = New("Frame", {
        Parent = page.Body, Size = UDim2.new(widthScale or 1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = T.SectionBG,
        BackgroundTransparency = 0.32,
    })
    Corner(card, 14)
    Gradient(card, {
        function(t) return Mix(t.SectionBG, t.Accent3, 0.10) end,
        "SectionBG",
        function(t) return Mix(t.SectionBG, t.Accent2, 0.09) end,
    }, 18)
    local cardStroke = Stroke(card, "Border", 0.25, 1)
    Gradient(cardStroke, {"Accent", "Border", "Accent2"}, 45, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.5, 0.6),
        NumberSequenceKeypoint.new(1, 0.2)
    }))
    New("UIPadding", {
        Parent = card, PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14),
    })
    New("UIListLayout", {Parent = card, Padding = UDim.new(0, 9), SortOrder = Enum.SortOrder.LayoutOrder})
    local heading = New("Frame", {
        Parent = card, Size = UDim2.new(1, 0, 0, subtitle and 42 or 25), BackgroundTransparency = 1,
    })
    local accent = New("Frame", {
        Parent = heading, Position = UDim2.fromOffset(0, 2), Size = UDim2.fromOffset(3, 18),
        BackgroundColor3 = T.Accent, BorderSizePixel = 0,
    })
    Corner(accent, 3)
    Gradient(accent, {"Accent", "Accent2"}, 90)
    local titleLabel = New("TextLabel", {
        Parent = heading, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -101, 0, 22),
        BackgroundTransparency = 1, Text = title, Font = Enum.Font.GothamSemibold,
        TextSize = 13, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local subLabel
    if subtitle then
        subLabel = New("TextLabel", {
            Parent = heading, Position = UDim2.fromOffset(12, 22), Size = UDim2.new(1, -101, 0, 17),
            BackgroundTransparency = 1, Text = subtitle, Font = Enum.Font.Gotham,
            TextSize = 9, TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
        })
    end
    local resetButton = New("TextButton", {
        Parent = heading, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(76, 24), BackgroundColor3 = T.ControlBG,
        BackgroundTransparency = 0.16, Text = "↻  Reset", Font = Enum.Font.GothamMedium,
        TextSize = 9, TextColor3 = T.TextSub, AutoButtonColor = false, Visible = false,
    })
    Corner(resetButton, 8)
    local resetStroke = Stroke(resetButton, "Border", 0.36)
    __KZ_SectionControls[card] = {Button = resetButton, Entries = {}, Title = tostring(title or "Section")}
    resetButton.MouseEnter:Connect(function()
        Tween(resetButton, 0.15, {BackgroundTransparency = 0, TextColor3 = T.TextMain})
    end)
    resetButton.MouseLeave:Connect(function()
        Tween(resetButton, 0.15, {BackgroundTransparency = 0.16, TextColor3 = T.TextSub})
    end)
    resetButton.MouseButton1Click:Connect(function()
        local registry = __KZ_SectionControls[card]
        local changed = 0
        for _, entry in ipairs(registry and registry.Entries or {}) do
            if entry.Control and type(entry.Control.Set) == "function" then
                local ok = pcall(function() entry.Control.Set(entry.Default, true) end)
                if ok then changed = changed + 1 end
            end
        end
        Toast("Section reset", tostring(title or "Section") .. " restored " .. tostring(changed) .. " control" .. (changed == 1 and "." or "s."), 3)
    end)
    BindTheme(function()
        if card.Parent then
            card.BackgroundColor3 = T.SectionBG; accent.BackgroundColor3 = T.Accent
            titleLabel.TextColor3 = T.TextMain
            if subLabel then subLabel.TextColor3 = T.TextSub end
            resetButton.BackgroundColor3 = T.ControlBG
            resetButton.TextColor3 = T.TextSub
            resetStroke.Color = T.Border
        end
    end)
    return card
end

local function RegisterSectionControl(card, control, defaultValue)
    local registry = __KZ_SectionControls[card]
    if not registry or type(control) ~= "table" or type(control.Set) ~= "function" then return control end
    table.insert(registry.Entries, {Control = control, Default = defaultValue})
    registry.Button.Visible = true
    return control
end

local function ElementBase(page, parent, label, height)
    local row = New("Frame", {
        Parent = parent, Size = UDim2.new(1, 0, 0, height or 44),
        BackgroundColor3 = T.ElementBG, BackgroundTransparency = 0.42,
    })
    Corner(row, 10)
    Gradient(row, {
        function(t) return Mix(t.ElementBG, t.Accent3, .07) end,
        "ElementBG",
        function(t) return Mix(t.ElementBG, t.Accent2, .065) end,
    }, 0)
    local outline = Stroke(row, "Border", 0.25)
    local rowScale = New("UIScale", {Parent = row, Scale = 1})
    local hoverEdge = New("Frame", {
        Parent = row, Position = UDim2.fromOffset(5, 10), Size = UDim2.fromOffset(2, (height or 44) - 20),
        BackgroundColor3 = T.Accent, BackgroundTransparency = 0.72,
        BorderSizePixel = 0, ZIndex = 2,
    })
    Corner(hoverEdge, 999)
    Gradient(hoverEdge, {"Accent3", "Accent", "Accent2"}, 90)
    local favoriteCount = (page.FavoriteCounts[label] or 0) + 1
    page.FavoriteCounts[label] = favoriteCount
    local favoriteKey = tostring(page.Name or "Page") .. "/" .. tostring(label) .. (favoriteCount > 1 and (" #" .. tostring(favoriteCount)) or "")
    local searchable = {Object = row, Text = string.lower(label), Label = label, Page = page.Name, Key = favoriteKey}
    table.insert(page.Searchables, searchable)
    if __KZ_QOL.RegisterFavoriteRow then __KZ_QOL.RegisterFavoriteRow(page, label, row, searchable) end
    row.MouseEnter:Connect(function()
        Tween(row, 0.16, {BackgroundColor3 = T.ElementHoverBG, BackgroundTransparency = 0.18})
        Tween(rowScale, 0.18, {Scale = 1.008}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(hoverEdge, 0.18, {BackgroundTransparency = 0.12}, Enum.EasingStyle.Sine)
    end)
    row.MouseLeave:Connect(function()
        Tween(row, 0.16, {BackgroundColor3 = T.ElementBG, BackgroundTransparency = 0.42})
        Tween(rowScale, 0.18, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(hoverEdge, 0.18, {BackgroundTransparency = 0.72}, Enum.EasingStyle.Sine)
    end)
    BindTheme(function()
        if row.Parent then
            row.BackgroundColor3 = T.ElementBG
            outline.Color = T.Border
            hoverEdge.BackgroundColor3 = T.Accent
        end
    end)
    return row
end

local function Toggle(page, parentCard, label, default, onChanged)
    local state = default == true
    local row = ElementBase(page, parentCard, label, 44)
    local text = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(13, 0), Size = UDim2.new(1, -72, 1, 0),
        BackgroundTransparency = 1, Text = label, Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local track = New("Frame", {
        Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(38, 20), BackgroundColor3 = state and T.Accent or T.ControlBG,
    })
    Corner(track, 10)
    Gradient(track, {"Accent", "Accent2"}, 0)
    local knob = New("Frame", {
        Parent = track, AnchorPoint = Vector2.new(0, 0.5),
        Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        Size = UDim2.fromOffset(15, 15), BackgroundColor3 = state and T.MainBG or T.TextSub,
    })
    Corner(knob, 8)
    local knobScale = New("UIScale", {Parent = knob, Scale = 1})
    local knobGlow = Stroke(knob, "Accent2", state and 0.28 or 1, 1.4)
    local click = New("TextButton", {
        Parent = row, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "", AutoButtonColor = false, ZIndex = 4,
    })
    local function Paint(animate)
        local duration = animate and 0.24 or 0
        Tween(track, duration, {BackgroundColor3 = state and T.Accent or T.ControlBG})
        Tween(knob, duration, {
            Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
            BackgroundColor3 = state and T.MainBG or T.TextSub,
        }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Tween(knobGlow, duration, {Transparency = state and 0.28 or 1})
        if animate then
            Tween(knobScale, 0.09, {Scale = 0.78}, Enum.EasingStyle.Quad)
            task.delay(0.09, function()
                if knobScale.Parent then Tween(knobScale, 0.24, {Scale = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.Out) end
            end)
            Tween(track, 0.11, {Size = UDim2.fromOffset(42, 22)}, Enum.EasingStyle.Quad)
            task.delay(0.1, function()
                if track.Parent then Tween(track, 0.22, {Size = UDim2.fromOffset(38, 20)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out) end
            end)
        end
    end
    local function SetState(value, animate, fire)
        state = value == true
        Paint(animate)
        if fire and onChanged then
            task.spawn(function() pcall(onChanged, state) end)
        end
        if __KZ_QOL.UpdateActiveUI then task.defer(__KZ_QOL.UpdateActiveUI) end
    end
    click.MouseButton1Click:Connect(function()
        SetState(not state, true, true)
    end)
    click.MouseButton1Down:Connect(function()
        Tween(knobScale, 0.08, {Scale = 0.84}, Enum.EasingStyle.Quad)
    end)
    click.MouseButton1Up:Connect(function()
        Tween(knobScale, 0.16, {Scale = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    BindTheme(function()
        if row.Parent then text.TextColor3 = T.TextMain; Paint(false) end
    end)
    local control = {
        Get = function() return state end,
        Set = function(value, fire) SetState(value, true, fire == nil and true or fire) end,
        __KZType = "toggle",
        __KZPage = page.Name,
        __KZLabel = label,
        __KZRow = row,
    }
    table.insert(__KZ_QOL.ToggleRegistry, control)
    if __KZ_QOL.UpdateActiveUI then task.defer(__KZ_QOL.UpdateActiveUI) end
    return control
end

local function Slider(page, parentCard, label, min, max, value, suffix, onChanged, increment)
    min = tonumber(min) or 0
    max = tonumber(max) or 100
    if min > max then min, max = max, min end

    local step = math.abs(tonumber(increment) or 0.1)
    if step <= 0 then step = 0.1 end

    local precision = 0
    for digits = 0, 6 do
        local scaled = step * (10 ^ digits)
        if math.abs(scaled - math.floor(scaled + 0.5)) < 0.000001 then
            precision = digits
            break
        end
        precision = digits
    end

    local function SnapValue(raw)
        local number = tonumber(raw) or min
        number = math.clamp(number, min, max)
        local snapped = min + (math.floor(((number - min) / step) + 0.5) * step)
        return math.clamp(snapped, min, max)
    end

    local function FormatNumber(number)
        local text = string.format('%.' .. tostring(precision) .. 'f', tonumber(number) or 0)
        if precision > 0 then
            text = text:gsub('(%..-)0+$', '%1'):gsub('%.$', '')
        end
        return text
    end

    local current = SnapValue(value or min)
    local editingValue = false
    local row = ElementBase(page, parentCard, label, 62)
    local title = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(13, 5), Size = UDim2.new(1, -104, 0, 22),
        BackgroundTransparency = 1, Text = label, Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local valueText = New("TextBox", {
        Parent = row, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 5),
        Size = UDim2.fromOffset(82, 23), BackgroundColor3 = T.ControlBG,
        BackgroundTransparency = 0.12, BorderSizePixel = 0,
        Text = FormatNumber(current) .. (suffix or ""), Font = Enum.Font.GothamSemibold,
        TextSize = 10, TextColor3 = T.Accent, TextXAlignment = Enum.TextXAlignment.Center,
        ClearTextOnFocus = false, MultiLine = false, ZIndex = 5,
    })
    Corner(valueText, 7)
    Stroke(valueText, "Border", 0.32)

    local track = New("TextButton", {
        Parent = row, Position = UDim2.new(0, 13, 1, -19), Size = UDim2.new(1, -26, 0, 7),
        BackgroundColor3 = T.ControlBG, Text = "", AutoButtonColor = false,
    })
    Corner(track, 4)
    local fill = New("Frame", {
        Parent = track, Size = UDim2.new((current - min) / math.max(max - min, 0.0001), 0, 1, 0),
        BackgroundColor3 = T.Accent, BorderSizePixel = 0,
    })
    Corner(fill, 4)
    Gradient(fill, {"Accent3", "Accent", "Accent2"}, 0)
    local knob = New("Frame", {
        Parent = fill, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(13, 13), BackgroundColor3 = T.TextMain,
    })
    Corner(knob, 7)
    Stroke(knob, "Accent", 0, 2)

    local dragging = false

    local function RefreshValueText()
        valueText.Text = FormatNumber(current) .. (editingValue and "" or (suffix or ""))
    end

    local function SetValue(newValue, fire)
        current = SnapValue(newValue)
        local alpha = (current - min) / math.max(max - min, 0.0001)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        RefreshValueText()
        if fire and onChanged then
            task.spawn(function() pcall(onChanged, current) end)
        end
    end

    local function Update(inputX)
        local width = math.max(track.AbsoluteSize.X, 1)
        local alpha = math.clamp((inputX - track.AbsolutePosition.X) / width, 0, 1)
        SetValue(min + ((max - min) * alpha), true)
    end

    -- Type exact value
    valueText.Focused:Connect(function()
        editingValue = true
        valueText.Text = FormatNumber(current)
        task.defer(function()
            if not valueText:IsFocused() then return end
            pcall(function()
                valueText.SelectionStart = 1
                valueText.CursorPosition = #valueText.Text + 1
            end)
        end)
    end)

    valueText.FocusLost:Connect(function()
        local typedText = tostring(valueText.Text or ''):gsub(',', '.')
        local typedNumber = tonumber(typedText)
        if not typedNumber then
            local numericPart = typedText:match('[-+]?%d*%.?%d+')
            typedNumber = tonumber(numericPart)
        end

        editingValue = false
        if typedNumber then
            SetValue(typedNumber, true)
        else
            RefreshValueText()
        end
    end)

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Update(input.Position.X)
        end
    end)
    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input.Position.X)
        end
    end))
    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end))
    BindTheme(function()
        if row.Parent then
            title.TextColor3 = T.TextMain
            valueText.TextColor3 = T.Accent
            valueText.BackgroundColor3 = T.ControlBG
            track.BackgroundColor3 = T.ControlBG
            fill.BackgroundColor3 = T.Accent
            knob.BackgroundColor3 = T.TextMain
        end
    end)
    return {
        Get = function() return current end,
        Set = function(v, fire) SetValue(v, fire == nil and true or fire) end,
    }
end

local function RangeSlider(page, parentCard, label, min, max, minValue, maxValue, suffix, onChanged, increment)
    min = tonumber(min) or 0
    max = tonumber(max) or 100
    if min > max then min, max = max, min end

    local step = math.abs(tonumber(increment) or 0.1)
    if step <= 0 then step = 0.1 end

    local precision = 0
    for digits = 0, 6 do
        local scaled = step * (10 ^ digits)
        if math.abs(scaled - math.floor(scaled + 0.5)) < 0.000001 then
            precision = digits
            break
        end
        precision = digits
    end

    local function Snap(raw)
        local number = math.clamp(tonumber(raw) or min, min, max)
        local snapped = min + (math.floor(((number - min) / step) + 0.5) * step)
        return math.clamp(snapped, min, max)
    end

    local function Format(number)
        local text = string.format('%.' .. tostring(precision) .. 'f', tonumber(number) or 0)
        if precision > 0 then
            text = text:gsub('(%..-)0+$', '%1'):gsub('%.$', '')
        end
        return text
    end

    local currentMin = Snap(minValue == nil and min or minValue)
    local currentMax = Snap(maxValue == nil and max or maxValue)
    if currentMin > currentMax then currentMin, currentMax = currentMax, currentMin end

    local row = ElementBase(page, parentCard, label, 76)
    local title = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(13, 5), Size = UDim2.new(0.52, 0, 0, 22),
        BackgroundTransparency = 1, Text = label, Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local valueText = New("TextLabel", {
        Parent = row, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 5),
        Size = UDim2.fromOffset(128, 22), BackgroundTransparency = 1,
        Text = Format(currentMin) .. (suffix or "") .. "  –  " .. Format(currentMax) .. (suffix or ""),
        Font = Enum.Font.GothamSemibold, TextSize = 10, TextColor3 = T.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    local track = New("TextButton", {
        Parent = row, Position = UDim2.new(0, 13, 1, -22), Size = UDim2.new(1, -26, 0, 7),
        BackgroundColor3 = T.ControlBG, Text = "", AutoButtonColor = false,
    })
    Corner(track, 4)
    local fill = New("Frame", {
        Parent = track, BackgroundColor3 = T.Accent, BorderSizePixel = 0,
    })
    Corner(fill, 4)
    Gradient(fill, {"Accent3", "Accent", "Accent2"}, 0)

    local minKnob = New("TextButton", {
        Parent = track, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = T.TextMain, Text = "", AutoButtonColor = false, ZIndex = 5,
    })
    Corner(minKnob, 7)
    Stroke(minKnob, "Accent", 0, 2)
    local maxKnob = New("TextButton", {
        Parent = track, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = T.TextMain, Text = "", AutoButtonColor = false, ZIndex = 5,
    })
    Corner(maxKnob, 7)
    Stroke(maxKnob, "Accent2", 0, 2)

    local dragging = nil
    local function Alpha(value)
        return (value - min) / math.max(max - min, 0.0001)
    end
    local function Refresh()
        local minAlpha = Alpha(currentMin)
        local maxAlpha = Alpha(currentMax)
        fill.Position = UDim2.new(minAlpha, 0, 0, 0)
        fill.Size = UDim2.new(math.max(maxAlpha - minAlpha, 0), 0, 1, 0)
        minKnob.Position = UDim2.new(minAlpha, 0, 0.5, 0)
        maxKnob.Position = UDim2.new(maxAlpha, 0, 0.5, 0)
        valueText.Text = Format(currentMin) .. (suffix or "") .. "  –  " .. Format(currentMax) .. (suffix or "")
    end
    local function SetValues(newMin, newMax, fire)
        local a = Snap(newMin)
        local b = Snap(newMax)
        if a > b then
            if dragging == 'min' then a = b else b = a end
        end
        currentMin, currentMax = a, b
        Refresh()
        if fire and onChanged then
            task.spawn(function() pcall(onChanged, currentMin, currentMax) end)
        end
    end
    local function Update(which, inputX)
        local alpha = math.clamp((inputX - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        local value = min + ((max - min) * alpha)
        if which == 'min' then
            SetValues(value, currentMax, true)
        else
            SetValues(currentMin, value, true)
        end
    end
    local function Begin(which, input)
        dragging = which
        Update(which, input.Position.X)
    end

    minKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Begin('min', input)
        end
    end)
    maxKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Begin('max', input)
        end
    end)
    track.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        local value = min + ((max - min) * alpha)
        local which = math.abs(value - currentMin) <= math.abs(value - currentMax) and 'min' or 'max'
        Begin(which, input)
    end)

    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            Update(dragging, input.Position.X)
        end
    end))
    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = nil
        end
    end))

    BindTheme(function()
        if row.Parent then
            title.TextColor3 = T.TextMain
            valueText.TextColor3 = T.Accent
            track.BackgroundColor3 = T.ControlBG
            fill.BackgroundColor3 = T.Accent
            minKnob.BackgroundColor3 = T.TextMain
            maxKnob.BackgroundColor3 = T.TextMain
            Refresh()
        end
    end)
    Refresh()

    return {
        Get = function() return {Min = currentMin, Max = currentMax} end,
        Set = function(value, fire)
            if type(value) ~= 'table' then return end
            SetValues(value.Min or value[1] or currentMin, value.Max or value[2] or currentMax, fire == nil and true or fire)
        end,
    }
end

local activeDropdown
local activeColorPopup
local function Dropdown(page, parentCard, label, options, default, onChanged)
    local selected = default or options[1]
    local row = ElementBase(page, parentCard, label, 44)
    row.ClipsDescendants = false
    local title = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(13, 0), Size = UDim2.new(0.48, 0, 1, 0),
        BackgroundTransparency = 1, Text = label, Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local box = New("TextButton", {
        Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(132, 28), BackgroundColor3 = T.ControlBG,
        BackgroundTransparency = 0.30,
        Text = selected, TextColor3 = T.Accent, Font = Enum.Font.GothamMedium,
        TextSize = 10, AutoButtonColor = false, ZIndex = 10,
    })
    Corner(box, 9)
    Stroke(box, "Border", 0.35)

    local menuHeight = math.min(#options * 31 + 12, 205)
    local menu = New("ScrollingFrame", {
        Parent = DropdownLayer, Size = UDim2.fromOffset(170, menuHeight),
        BackgroundColor3 = T.SectionBG, Visible = false, ZIndex = 400,
        BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = T.Accent,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Active = true, ScrollingEnabled = true, ScrollingDirection = Enum.ScrollingDirection.Y,
    })
    Corner(menu, 12)
    Stroke(menu, "Border", 0.08)
    New("UIPadding", {
        Parent = menu, PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
    })
    New("UIListLayout", {Parent = menu, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})

    local function PositionMenu()
        local windowPos = Window.AbsolutePosition
        local layerSize = DropdownLayer.AbsoluteSize
        local menuWidth = menu.AbsoluteSize.X > 0 and menu.AbsoluteSize.X or 170
        local finalHeight = menuHeight
        local x = (box.AbsolutePosition.X - windowPos.X) + box.AbsoluteSize.X - menuWidth
        local y = (box.AbsolutePosition.Y - windowPos.Y) + box.AbsoluteSize.Y + 6
        if y + finalHeight > layerSize.Y - 8 then
            y = (box.AbsolutePosition.Y - windowPos.Y) - finalHeight - 6
        end
        x = math.clamp(x, 8, math.max(8, layerSize.X - menuWidth - 8))
        y = math.clamp(y, 8, math.max(8, layerSize.Y - finalHeight - 8))
        menu.Position = UDim2.fromOffset(x, y)
    end

    for _, option in ipairs(options) do
        local item = New("TextButton", {
            Parent = menu, Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = T.ElementBG,
            BackgroundTransparency = 1, Text = option, TextColor3 = T.TextSub,
            Font = Enum.Font.Gotham, TextSize = 10, AutoButtonColor = false, ZIndex = 401,
        })
        Corner(item, 8)
        item.MouseEnter:Connect(function() Tween(item, 0.12, {BackgroundTransparency = 0, TextColor3 = T.TextMain}) end)
        item.MouseLeave:Connect(function() Tween(item, 0.12, {BackgroundTransparency = 1, TextColor3 = T.TextSub}) end)
        item.MouseButton1Click:Connect(function()
            selected = option; box.Text = option; menu.Visible = false; activeDropdown = nil; DropdownLayer.Visible = false
            if onChanged then onChanged(option) end
        end)
        BindTheme(function()
            if item.Parent then item.BackgroundColor3 = T.ElementBG; item.TextColor3 = T.TextSub end
        end)
    end
    box.MouseButton1Click:Connect(function()
        if activeDropdown and activeDropdown ~= menu then activeDropdown.Visible = false end
        if activeColorPopup then activeColorPopup.Visible = false; activeColorPopup = nil end
        PositionMenu()
        menu.Visible = not menu.Visible
        DropdownLayer.Visible = menu.Visible
        activeDropdown = menu.Visible and menu or nil
    end)
    BindTheme(function()
        if row.Parent then
            title.TextColor3 = T.TextMain; box.BackgroundColor3 = T.ControlBG
            box.TextColor3 = T.Accent; menu.BackgroundColor3 = T.SectionBG
            menu.ScrollBarImageColor3 = T.Accent
        end
    end)
    local function SetSelected(value, fire)
        if value == nil then return end
        selected = value
        box.Text = tostring(value)
        if fire and onChanged then
            task.spawn(function() pcall(onChanged, selected) end)
        end
    end
    return {
        Get = function() return selected end,
        Set = function(value, fire) SetSelected(value, fire == nil and true or fire) end,
        Refresh = function(newOptions)
            if type(newOptions) ~= "table" then return end
            options = newOptions
            for _, child in ipairs(menu:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            for _, option in ipairs(options) do
                local optionButton = New("TextButton", {
                    Parent = menu, Size = UDim2.new(1, -8, 0, 28), BackgroundColor3 = T.ElementBG,
                    Text = "  " .. tostring(option), TextColor3 = T.TextMain, Font = Enum.Font.Gotham,
                    TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 60,
                })
                Corner(optionButton, 8)
                optionButton.MouseButton1Click:Connect(function()
                    SetSelected(option, true)
                    menu.Visible = false
                    DropdownLayer.Visible = false
                    activeDropdown = nil
                end)
            end
            menu.CanvasSize = UDim2.new(0, 0, 0, #options * 32)
        end,
    }
end

local function Button(page, parentCard, label, emphasized, action)

    local row = New("Frame", {
        Parent = parentCard, Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = emphasized and T.Accent or T.ElementBG,
        BackgroundTransparency = emphasized and 0.24 or 0.42,
    })
    Corner(row, 10)

    if not emphasized then
        Gradient(row, {
            function(t) return Mix(t.ElementBG, t.Accent3, .07) end,
            "ElementBG",
            function(t) return Mix(t.ElementBG, t.Accent2, .065) end,
        }, 0)
    end
    local outline = Stroke(row, "Border", 0.32)
    local buttonScale = New("UIScale", {Parent = row, Scale = 1})
    local buttonEdge = New("Frame", {
        Parent = row, Position = UDim2.fromOffset(5, 9), Size = UDim2.fromOffset(2, 24),
        BackgroundColor3 = emphasized and T.TextMain or T.Accent,
        BackgroundTransparency = emphasized and 0.4 or 0.72,
        BorderSizePixel = 0, ZIndex = 2,
    })
    Corner(buttonEdge, 999)
    Gradient(buttonEdge, {"Accent3", "Accent", "Accent2"}, 90)
    local favoriteCount = (page.FavoriteCounts[label] or 0) + 1
    page.FavoriteCounts[label] = favoriteCount
    local favoriteKey = tostring(page.Name or "Page") .. "/" .. tostring(label) .. (favoriteCount > 1 and (" #" .. tostring(favoriteCount)) or "")
    local searchable = {Object = row, Text = string.lower(label), Label = label, Page = page.Name, Key = favoriteKey}
    table.insert(page.Searchables, searchable)
    if __KZ_QOL.RegisterFavoriteRow then __KZ_QOL.RegisterFavoriteRow(page, label, row, searchable) end

    local function getAccentTextColor()
        local lum = 0.299 * T.Accent.R + 0.587 * T.Accent.G + 0.114 * T.Accent.B
        if lum > 0.55 then
            return Color3.fromRGB(28, 30, 38)
        else
            return Color3.fromRGB(255, 255, 255)
        end
    end
    local function getAccentHover()
        return T.Accent:Lerp(Color3.new(0, 0, 0), 0.18)
    end

    local text = New("TextLabel", {
        Parent = row, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = label, Font = Enum.Font.GothamSemibold, TextSize = 11,
        TextColor3 = emphasized and getAccentTextColor() or T.TextMain,
    })
    local click = New("TextButton", {
        Parent = row, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "", AutoButtonColor = false, ZIndex = 4,
    })
    click.MouseButton1Down:Connect(function()
        Tween(buttonScale, 0.08, {Scale = 0.975}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end)
    click.MouseButton1Up:Connect(function()
        Tween(buttonScale, 0.18, {Scale = 1.008}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    click.MouseButton1Click:Connect(function()
        if action then action() else Toast("UI Preview", label .. " is visual-only in this mockup.") end
    end)
    row.MouseEnter:Connect(function()
        Tween(buttonScale, 0.18, {Scale = 1.008}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(buttonEdge, 0.18, {BackgroundTransparency = emphasized and 0.1 or 0.12}, Enum.EasingStyle.Sine)
        if emphasized then
            Tween(row, 0.16, {BackgroundColor3 = getAccentHover(), BackgroundTransparency = 0.10})
        else
            Tween(row, 0.16, {BackgroundColor3 = T.ElementHoverBG, BackgroundTransparency = 0.18})
        end
    end)
    row.MouseLeave:Connect(function()
        Tween(buttonScale, 0.18, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(buttonEdge, 0.18, {BackgroundTransparency = emphasized and 0.4 or 0.72}, Enum.EasingStyle.Sine)
        if emphasized then
            Tween(row, 0.16, {BackgroundColor3 = T.Accent, BackgroundTransparency = 0.24})
        else
            Tween(row, 0.16, {BackgroundColor3 = T.ElementBG, BackgroundTransparency = 0.42})
        end
    end)
    BindTheme(function()
        if row.Parent then
            if emphasized then
                row.BackgroundColor3 = T.Accent
                text.TextColor3 = getAccentTextColor()
            else
                row.BackgroundColor3 = T.ElementBG
                text.TextColor3 = T.TextMain
            end
            buttonEdge.BackgroundColor3 = emphasized and T.TextMain or T.Accent
            outline.Color = T.Border
        end
    end)
end

local function Textbox(page, parentCard, label, placeholder, default, onChanged)
    local row = ElementBase(page, parentCard, label, 50)
    local title = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(13, 0), Size = UDim2.new(0.42, 0, 1, 0),
        BackgroundTransparency = 1, Text = label, Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local box = New("TextBox", {
        Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(150, 28), BackgroundColor3 = T.ControlBG,
        BackgroundTransparency = 0.30,
        Text = tostring(default or ""), PlaceholderText = placeholder or "Enter text...",
        PlaceholderColor3 = T.TextSub, TextColor3 = T.TextMain, Font = Enum.Font.Gotham,
        TextSize = 10, ClearTextOnFocus = false, ZIndex = 10,
    })
    Corner(box, 9)
    Stroke(box, "Border", 0.35)
    box.FocusLost:Connect(function(enterPressed)
        if onChanged then
            task.spawn(function() pcall(onChanged, box.Text, enterPressed) end)
        end
    end)
    BindTheme(function()
        if row.Parent then
            title.TextColor3 = T.TextMain
            box.BackgroundColor3 = T.ControlBG
            box.TextColor3 = T.TextMain
            box.PlaceholderColor3 = T.TextSub
        end
    end)
    return {
        Get = function() return box.Text end,
        Set = function(text, fire)
            box.Text = tostring(text or "")
            if fire and onChanged then
                task.spawn(function() pcall(onChanged, box.Text, false) end)
            end end,
    }
end

local function Keybind(page, parentCard, label, defaultKey, onChanged)
    local current
    if defaultKey == "None" or defaultKey == false then
        current = nil -- starts unbound; user can click the box to set one
    else
        current = defaultKey or Enum.KeyCode.E
        if typeof(current) == "string" then
            current = Enum.KeyCode[current] or Enum.KeyCode.E
        end
    end
    local listening = false
    local row = ElementBase(page, parentCard, label, 44)
    local title = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(13, 0), Size = UDim2.new(0.48, 0, 1, 0),
        BackgroundTransparency = 1, Text = label, Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local box = New("TextButton", {
        Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(110, 28), BackgroundColor3 = T.ControlBG,
        BackgroundTransparency = 0.30,
        Text = current and current.Name or "None", TextColor3 = T.Accent, Font = Enum.Font.GothamMedium,
        TextSize = 10, AutoButtonColor = false, ZIndex = 10,
    })
    Corner(box, 9)
    local boxStroke = Stroke(box, "Border", 0.35)
    local control
    local function SetKey(key, fire)
        current = key
        box.Text = (key and key.Name) or "None"
        if fire and key then
            local conflictPage, conflictLabel
            if key == menuToggleKey then
                conflictPage, conflictLabel = "UI", "Menu Toggle"
            else
                for _, other in ipairs(__KZ_QOL.KeybindRegistry) do
                    if other ~= control and type(other.Get) == "function" then
                        local ok, otherKey = pcall(other.Get)
                        if ok and otherKey == key then
                            conflictPage = tostring(other.__KZPage or "Another tab")
                            conflictLabel = tostring(other.__KZLabel or "another feature")
                            break
                        end
                    end
                end
            end
            if conflictLabel then
                Toast("Duplicate keybind", key.Name .. " is already used by " .. conflictPage .. " / " .. conflictLabel .. ".", 4)
                Tween(boxStroke, 0.14, {Color = Color3.fromRGB(248, 113, 113), Transparency = 0})
                Tween(box, 0.14, {TextColor3 = Color3.fromRGB(248, 113, 113)})
                task.delay(1.35, function()
                    if boxStroke.Parent then Tween(boxStroke, 0.28, {Color = T.Border, Transparency = 0.35}) end
                    if box.Parent then Tween(box, 0.28, {TextColor3 = T.Accent}) end
                end)
            end
        end
        if fire and onChanged then
            task.spawn(function() pcall(onChanged, current) end)
        end
    end
    box.MouseButton1Click:Connect(function()
        listening = true
        box.Text = "..."
    end)
    table.insert(connections, UserInputService.InputBegan:Connect(function(input, gpe)
        if not listening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.Gamepad1 then
            listening = false
            SetKey(input.KeyCode, true)
        end
    end))
    BindTheme(function()
        if row.Parent then
            title.TextColor3 = T.TextMain
            box.BackgroundColor3 = T.ControlBG
            box.TextColor3 = T.Accent
        end
    end)
    control = {
        Get = function() return current end,
        Set = function(key, fire) SetKey(key, fire == nil and true or fire) end,
        __KZType = "keybind",
        __KZPage = page.Name,
        __KZLabel = label,
        __KZRow = row,
    }
    table.insert(__KZ_QOL.KeybindRegistry, control)
    return control
end

local function Colorpicker(page, parentCard, label, defaultColor, onChanged)
    local committedColor = defaultColor or Color3.fromRGB(255, 255, 255)
    local pendingHue, pendingSat, pendingVal = Color3.toHSV(committedColor)
    local rainbow = false
    local rainbowClock = 0

    local row = ElementBase(page, parentCard, label, 44)
    row.ClipsDescendants = false
    local title = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(13, 0), Size = UDim2.new(0.48, 0, 1, 0),
        BackgroundTransparency = 1, Text = label, Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
    })
    local swatch = New("TextButton", {
        Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(52, 24), BackgroundColor3 = committedColor, Text = "",
        AutoButtonColor = false, ZIndex = 10,
    })
    Corner(swatch, 8)
    Stroke(swatch, "Border", 0.2)

    local PANEL_W, PANEL_H = 252, 226
    local SV_X, SV_Y, SV_W, SV_H = 12, 36, 168, 124
    local HUE_X, HUE_W = 190, 16
    local panel = New("Frame", {
        Parent = DropdownLayer, Size = UDim2.fromOffset(PANEL_W, PANEL_H),
        BackgroundColor3 = T.SectionBG, BorderSizePixel = 0, Visible = false, ZIndex = 400,
    })
    Corner(panel, 12)
    Stroke(panel, "Border", 0.08)

    local panelTitle = New("TextLabel", {
        Parent = panel, Position = UDim2.fromOffset(13, 9), Size = UDim2.fromOffset(160, 20),
        BackgroundTransparency = 1, Text = label, Font = Enum.Font.GothamSemibold,
        TextSize = 13, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 401,
    })
    local preview = New("Frame", {
        Parent = panel, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -13, 0, 10),
        Size = UDim2.fromOffset(38, 20), BackgroundColor3 = committedColor, BorderSizePixel = 0, ZIndex = 401,
    })
    Corner(preview, 6)
    Stroke(preview, "Border", 0.35)

    -- Color square
    local svBox = New("TextButton", {
        Parent = panel, Position = UDim2.fromOffset(SV_X, SV_Y), Size = UDim2.fromOffset(SV_W, SV_H),
        BackgroundColor3 = Color3.fromHSV(pendingHue, 1, 1), Text = "",
        AutoButtonColor = false, ZIndex = 401,
    })
    Corner(svBox, 6)
    local whiteLayer = New("Frame", {
        Parent = svBox, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0, ZIndex = 402,
    })
    Corner(whiteLayer, 6)
    New("UIGradient", {
        Parent = whiteLayer,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1),
        }),
    })
    local blackLayer = New("Frame", {
        Parent = svBox, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0, ZIndex = 403,
    })
    Corner(blackLayer, 6)
    New("UIGradient", {
        Parent = blackLayer, Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0),
        }),
    })
    local svCursor = New("Frame", {
        Parent = svBox, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(11, 11),
        BackgroundColor3 = committedColor, BorderSizePixel = 0, ZIndex = 404,
    })
    Corner(svCursor, 6)
    New("UIStroke", {Parent = svCursor, Color = Color3.new(1, 1, 1), Thickness = 1.5})

    -- Hue strip
    local hueStrip = New("TextButton", {
        Parent = panel, Position = UDim2.fromOffset(HUE_X, SV_Y), Size = UDim2.fromOffset(HUE_W, SV_H),
        BackgroundColor3 = Color3.new(1, 1, 1), Text = "", AutoButtonColor = false, ZIndex = 401,
    })
    Corner(hueStrip, 6)
    local hueKeys = {}
    for i = 0, 6 do
        table.insert(hueKeys, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)))
    end
    New("UIGradient", {Parent = hueStrip, Rotation = 90, Color = ColorSequence.new(hueKeys)})
    local hueMarker = New("Frame", {
        Parent = panel, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(HUE_W + 8, 3),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 404,
    })
    Corner(hueMarker, 2)

    -- Rainbow toggle
    New("TextLabel", {
        Parent = panel, Position = UDim2.fromOffset(12, SV_Y + SV_H + 10), Size = UDim2.fromOffset(80, 18),
        BackgroundTransparency = 1, Text = "Rainbow", Font = Enum.Font.Gotham,
        TextSize = 11, TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 401,
    })
    local rainbowTrack = New("Frame", {
        Parent = panel, Position = UDim2.fromOffset(86, SV_Y + SV_H + 11), Size = UDim2.fromOffset(30, 16),
        BackgroundColor3 = T.ControlBG, BorderSizePixel = 0, ZIndex = 401,
    })
    Corner(rainbowTrack, 8)
    local rainbowKnob = New("Frame", {
        Parent = rainbowTrack, AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 402,
    })
    Corner(rainbowKnob, 6)
    local rainbowClick = New("TextButton", {
        Parent = rainbowTrack, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "", AutoButtonColor = false, ZIndex = 403,
    })

    -- Color actions
    local cancelBtn = New("TextButton", {
        Parent = panel, Position = UDim2.fromOffset(12, PANEL_H - 28), Size = UDim2.fromOffset(108, 22),
        BackgroundColor3 = T.ControlBG, Text = "Cancel", Font = Enum.Font.GothamSemibold,
        TextSize = 11, TextColor3 = T.TextMain, AutoButtonColor = false, ZIndex = 401,
    })
    Corner(cancelBtn, 7)
    local applyBtn = New("TextButton", {
        Parent = panel, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, PANEL_H - 28),
        Size = UDim2.fromOffset(108, 22), BackgroundColor3 = T.Accent, Text = "Apply",
        Font = Enum.Font.GothamSemibold, TextSize = 11, TextColor3 = Color3.new(1, 1, 1),
        AutoButtonColor = false, ZIndex = 401,
    })
    Corner(applyBtn, 7)
    Gradient(applyBtn, {"Accent", "Accent3"}, 0)

    local function LiveColor()
        if rainbow then
            return Color3.fromHSV(rainbowClock % 1, 1, 1)
        end
        return committedColor
    end

    local function PaintPending()
        local pendingColor = Color3.fromHSV(pendingHue, pendingSat, pendingVal)
        preview.BackgroundColor3 = rainbow and LiveColor() or pendingColor
        svBox.BackgroundColor3 = Color3.fromHSV(pendingHue, 1, 1)
        svCursor.Position = UDim2.fromScale(pendingSat, 1 - pendingVal)
        svCursor.BackgroundColor3 = pendingColor
        hueMarker.Position = UDim2.new(0, HUE_X + HUE_W / 2, 0, SV_Y + math.clamp(pendingHue, 0, 0.99999) * SV_H)
    end

    local function Commit(newColor, fire)
        committedColor = newColor
        pendingHue, pendingSat, pendingVal = Color3.toHSV(newColor)
        swatch.BackgroundColor3 = LiveColor()
        PaintPending()
        if fire and onChanged then
            task.spawn(function() pcall(onChanged, LiveColor()) end)
        end
    end

    local function SetRainbow(on, fire)
        rainbow = on == true
        Tween(rainbowTrack, 0.15, {BackgroundColor3 = rainbow and T.Accent or T.ControlBG})
        Tween(rainbowKnob, 0.15, {
            Position = rainbow and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        })
        if not rainbow then
            swatch.BackgroundColor3 = committedColor
            PaintPending()
            if fire and onChanged then
                task.spawn(function() pcall(onChanged, committedColor) end)
            end
        end
    end
    rainbowClick.MouseButton1Click:Connect(function()
        SetRainbow(not rainbow, true)
    end)

    local activeDrag = nil
    local function IsPress(input)
        return input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
    end
    local function HandleSV(x, y)
        local px, py = svBox.AbsolutePosition.X, svBox.AbsolutePosition.Y
        local sx, sy = math.max(svBox.AbsoluteSize.X, 1), math.max(svBox.AbsoluteSize.Y, 1)
        pendingSat = math.clamp((x - px) / sx, 0, 1)
        pendingVal = 1 - math.clamp((y - py) / sy, 0, 1)
        PaintPending()
    end
    local function HandleHue(y)
        local py = hueStrip.AbsolutePosition.Y
        local sy = math.max(hueStrip.AbsoluteSize.Y, 1)
        pendingHue = math.clamp((y - py) / sy, 0, 0.99999)
        PaintPending()
    end
    svBox.InputBegan:Connect(function(input)
        if IsPress(input) then
            activeDrag = "sv"
            HandleSV(input.Position.X, input.Position.Y)
        end
    end)
    hueStrip.InputBegan:Connect(function(input)
        if IsPress(input) then
            activeDrag = "hue"
            HandleHue(input.Position.Y)
        end
    end)
    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if not activeDrag then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            if activeDrag == "sv" then
                HandleSV(input.Position.X, input.Position.Y)
            else
                HandleHue(input.Position.Y)
            end
        end
    end))
    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if IsPress(input) then activeDrag = nil end
    end))

    -- Rainbow color loop
    local lastRainbowFire = 0
    task.spawn(function()
        while not destroyed and swatch and swatch.Parent do
            -- Smooth 30 FPS color update
            local dt = task.wait(rainbow and (1 / 30) or 0.15)
            if rainbow then
                rainbowClock = (rainbowClock + dt * 0.22) % 1
                local c = LiveColor()
                swatch.BackgroundColor3 = c
                if panel.Visible then
                    preview.BackgroundColor3 = c
                    hueMarker.Position = UDim2.new(0, HUE_X + HUE_W / 2, 0, SV_Y + rainbowClock * SV_H)
                    svBox.BackgroundColor3 = Color3.fromHSV(rainbowClock, 1, 1)
                end
                if tick() - lastRainbowFire >= 0.1 then
                    lastRainbowFire = tick()
                    if onChanged then task.spawn(function() pcall(onChanged, c) end) end
                end
            end
        end
    end)

    applyBtn.MouseButton1Click:Connect(function()
        Commit(Color3.fromHSV(pendingHue, pendingSat, pendingVal), true)
        panel.Visible = false
        activeColorPopup = nil
        DropdownLayer.Visible = false
    end)
    cancelBtn.MouseButton1Click:Connect(function()
        pendingHue, pendingSat, pendingVal = Color3.toHSV(committedColor)
        PaintPending()
        panel.Visible = false
        activeColorPopup = nil
        DropdownLayer.Visible = false
    end)

    local function PositionPanel()
        local windowPos = Window.AbsolutePosition
        local layerSize = DropdownLayer.AbsoluteSize
        local x = (swatch.AbsolutePosition.X - windowPos.X) + swatch.AbsoluteSize.X - PANEL_W
        local y = (swatch.AbsolutePosition.Y - windowPos.Y) + swatch.AbsoluteSize.Y + 6
        if y + PANEL_H > layerSize.Y - 8 then
            y = (swatch.AbsolutePosition.Y - windowPos.Y) - PANEL_H - 6
        end
        x = math.clamp(x, 8, math.max(8, layerSize.X - PANEL_W - 8))
        y = math.clamp(y, 8, math.max(8, layerSize.Y - PANEL_H - 8))
        panel.Position = UDim2.fromOffset(x, y)
    end

    swatch.MouseButton1Click:Connect(function()
        if activeDropdown then activeDropdown.Visible = false; activeDropdown = nil end
        if activeColorPopup and activeColorPopup ~= panel then activeColorPopup.Visible = false end
        PositionPanel()
        panel.Visible = not panel.Visible
        if panel.Visible then
            pendingHue, pendingSat, pendingVal = Color3.toHSV(committedColor)
            PaintPending()
        end
        activeColorPopup = panel.Visible and panel or nil
        DropdownLayer.Visible = panel.Visible
    end)

    BindTheme(function()
        if row.Parent then
            title.TextColor3 = T.TextMain
            panel.BackgroundColor3 = T.SectionBG
            panelTitle.TextColor3 = T.TextMain
        end
    end)

    PaintPending()
    swatch.BackgroundColor3 = committedColor

    return {
        Get = function() return LiveColor() end,
        Set = function(value, fire)
            if typeof(value) == "Color3" then
                Commit(value, fire == nil and true or fire)
            end end,
    }
end

local function Divider(page, parentCard)
    local row = New("Frame", {
        Parent = parentCard, Size = UDim2.new(1, 0, 0, 12), BackgroundTransparency = 1,
    })
    local line = New("Frame", {
        Parent = row, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -8, 0, 1), BackgroundColor3 = T.Border, BorderSizePixel = 0,
    })
    BindTheme(function()
        if line.Parent then line.BackgroundColor3 = T.Border end
    end)
    return row
end

local function StatGrid(page, stats)
    local grid = New("Frame", {
        Parent = page.Body, Size = UDim2.new(1, 0, 0, 92), BackgroundTransparency = 1,
    })
    local layout = New("UIGridLayout", {
        Parent = grid, CellPadding = UDim2.fromOffset(10, 0),
        CellSize = UDim2.new(0.25, -8, 1, 0), SortOrder = Enum.SortOrder.LayoutOrder,
    })
    for index, stat in ipairs(stats) do
        local card = New("Frame", {
            Parent = grid, LayoutOrder = index, BackgroundColor3 = T.SectionBG,
            BackgroundTransparency = 0.07,
        })
        Corner(card, 14); Gradient(card, {function(t) return Mix(t.SectionBG, t.Accent3, .12) end, function(t) return Mix(t.SectionBG, t.Accent2, .10) end}, 20); Stroke(card, "Border", 0.18)
        local value = New("TextLabel", {
            Parent = card, Position = UDim2.fromOffset(14, 14), Size = UDim2.new(1, -28, 0, 28),
            BackgroundTransparency = 1, Text = stat[2], Font = Enum.Font.GothamBold,
            TextSize = 21, TextColor3 = T.Accent, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local label = New("TextLabel", {
            Parent = card, Position = UDim2.fromOffset(14, 48), Size = UDim2.new(1, -28, 0, 18),
            BackgroundTransparency = 1, Text = stat[1], Font = Enum.Font.Gotham,
            TextSize = 9, TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
        })
        BindTheme(function()
            if card.Parent then card.BackgroundColor3 = T.SectionBG; value.TextColor3 = T.Accent; label.TextColor3 = T.TextSub end
        end)
    end
    return layout
end

local function TwoColumnRow(page)
    local row = New("Frame", {
        Parent = page.Body, Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
    })
    New("UIListLayout", {
        Parent = row, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 14),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    local left = New("Frame", {
        Parent = row, Size = UDim2.new(0.5, -20, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
    })
    local leftLayout = New("UIListLayout", {Parent = left, Padding = UDim.new(0, 14), SortOrder = Enum.SortOrder.LayoutOrder})
    local right = New("Frame", {
        Parent = row, Size = UDim2.new(0.5, -20, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
    })
    local rightLayout = New("UIListLayout", {Parent = right, Padding = UDim.new(0, 14), SortOrder = Enum.SortOrder.LayoutOrder})

    local function UpdateRowHeight()
        local height = math.max(leftLayout.AbsoluteContentSize.Y, rightLayout.AbsoluteContentSize.Y)
        row.Size = UDim2.new(1, 0, 0, height)
    end
    UpdateRowHeight()
    table.insert(connections, leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateRowHeight))
    table.insert(connections, rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateRowHeight))

    return left, right
end

local function HomeInfoRow(parent, labelText, valueText, accentValue)
    local row = New("Frame", {
        Parent = parent, Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = T.ElementBG, BackgroundTransparency = 0.03,
    })
    Corner(row, 10)
    Gradient(row, {
        function(t) return Mix(t.ElementBG, t.Accent3, .06) end,
        "ElementBG",
        function(t) return Mix(t.ElementBG, t.Accent2, .05) end,
    }, 0)
    Stroke(row, "Border", 0.28)
    local label = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(0.42, 0, 1, 0),
        BackgroundTransparency = 1, Text = labelText, Font = Enum.Font.Gotham,
        TextSize = 10, TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local value = New("TextLabel", {
        Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0.55, 0, 1, 0), BackgroundTransparency = 1, Text = valueText,
        Font = Enum.Font.GothamSemibold, TextSize = 10,
        TextColor3 = accentValue and T.Accent or T.TextMain,
        TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd,
    })
    BindTheme(function()
        if row.Parent then
            row.BackgroundColor3 = T.ElementBG
            label.TextColor3 = T.TextSub
            value.TextColor3 = accentValue and T.Accent or T.TextMain
        end
    end)
    return {Frame = row, Label = label, Value = value}
end

local function HomeStatCard(parent, order, titleText, valueText, accentValue)
    local card = New("Frame", {
        Parent = parent, LayoutOrder = order, BackgroundColor3 = T.SectionBG,
        BackgroundTransparency = 0.14,
    })
    Corner(card, 12)
    Gradient(card, {
        function(t) return Mix(t.SectionBG, t.Accent3, .12) end,
        function(t) return Mix(t.SectionBG, t.Accent2, .10) end,
    }, 20)
    local statStroke = Stroke(card, "Border", 0.25, 1)
    Gradient(statStroke, {"Accent", "Border", "Accent2"}, 45)
    local value = New("TextLabel", {
        Parent = card, Position = UDim2.fromOffset(14, 16), Size = UDim2.new(1, -28, 0, 28),
        BackgroundTransparency = 1, Text = valueText, Font = Enum.Font.GothamBold,
        TextSize = 16, TextColor3 = accentValue and T.Accent or T.TextMain,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    })
    local title = New("TextLabel", {
        Parent = card, Position = UDim2.fromOffset(14, 52), Size = UDim2.new(1, -28, 0, 18),
        BackgroundTransparency = 1, Text = titleText, Font = Enum.Font.Gotham,
        TextSize = 9, TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
    })
    BindTheme(function()
        if card.Parent then
            card.BackgroundColor3 = T.SectionBG
            value.TextColor3 = accentValue and T.Accent or T.TextMain
            title.TextColor3 = T.TextSub
        end
    end)
    return {Frame = card, Title = title, Value = value}
end

local Home = CreatePage("Home")
do
local welcomeCard = New("Frame", {
    Parent = Home.Body, Size = UDim2.new(1, 0, 0, 86), BackgroundColor3 = T.SectionBG,
    BackgroundTransparency = 0.08, ClipsDescendants = true,
})
Corner(welcomeCard, 15)
Gradient(welcomeCard, {
    function(t) return Mix(t.SectionBG, t.Accent3, 0.3) end,
    function(t) return Mix(t.SectionBG, t.Accent, 0.1) end,
    function(t) return Mix(t.SectionBG, t.Accent2, 0.22) end,
}, 12)
local welcomeStroke = Stroke(welcomeCard, "Accent", 0.45, 1.1)
local welcomeBar = New("Frame", {
    Parent = welcomeCard, Position = UDim2.fromOffset(12, 18), Size = UDim2.fromOffset(3, 26), BackgroundColor3 = T.Accent,
    BorderSizePixel = 0,
})
Corner(welcomeBar, 3)
Gradient(welcomeBar, {"Accent3", "Accent", "Accent2"}, 90)
local welcomeTitle = New("TextLabel", {
    Parent = welcomeCard, Position = UDim2.fromOffset(25, 15), Size = UDim2.new(1, -47, 0, 28),
    BackgroundTransparency = 1, Text = "Welcome back, " .. tostring(LocalPlayer.DisplayName),
    Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = T.TextMain,
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
})
local welcomeSub = New("TextLabel", {
    Parent = welcomeCard, Position = UDim2.fromOffset(25, 45), Size = UDim2.new(1, -47, 0, 22),
    BackgroundTransparency = 1,
    Text = tostring((__KZ_UI_OPTIONS.Subtitle or __KZ_UI_OPTIONS.Game) or "Universal Hub") .. "  •  " .. themeName .. " theme  •  Ready",
    Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = T.TextSub,
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
})
BindTheme(function()
    if welcomeCard.Parent then
        welcomeCard.BackgroundColor3 = T.SectionBG
        welcomeStroke.Color = T.Accent
        welcomeBar.BackgroundColor3 = T.Accent
        welcomeTitle.TextColor3 = T.TextMain
        welcomeSub.TextColor3 = T.TextSub
        welcomeSub.Text = tostring((__KZ_UI_OPTIONS.Subtitle or __KZ_UI_OPTIONS.Game) or "Universal Hub") .. "  •  " .. themeName .. " theme  •  Ready"
    end
end)
end
local homeStats = New("Frame", {
    Parent = Home.Body, Size = UDim2.new(1, 0, 0, 92), BackgroundTransparency = 1,
})
New("UIGridLayout", {
    Parent = homeStats, CellPadding = UDim2.fromOffset(10, 0),
    CellSize = UDim2.new(0.25, -8, 1, 0), SortOrder = Enum.SortOrder.LayoutOrder,
})
local homeNameStat = HomeStatCard(homeStats, 1, "SCRIPT", string.upper(tostring((__KZ_UI_OPTIONS.Subtitle or __KZ_UI_OPTIONS.Game) or "UNIVERSAL HUB")), true)
local homeExecutorStat = HomeStatCard(homeStats, 2, "EXECUTOR", executorName, false)
local homeThemeStat = HomeStatCard(homeStats, 3, "THEME", themeName, false)
local homeStatusStat = HomeStatCard(homeStats, 4, "ACTIVE", "0", true)

__KZ_QOL.FavoritesCard = Section(Home, "Favorites", "Right-click any feature row to pin or unpin it here.")
__KZ_QOL.FavoritePlaceholder = HomeInfoRow(__KZ_QOL.FavoritesCard, "Pinned features", "None yet", false)

__KZ_QOL.QuickActions = Section(Home, "Quick actions", "Fast controls for the current session.")
Button(Home, __KZ_QOL.QuickActions, "Disable All Features", true, function()
    if __KZ_QOL.DisableAllFeatures then __KZ_QOL.DisableAllFeatures() end
end)

local lastIteration = tick()
local frameCount = 0
local currentFPS = 60
local artworkMotionClock = 0

table.insert(connections, RunService.RenderStepped:Connect(function(delta)
    frameCount = frameCount + 1
    artworkMotionClock = artworkMotionClock + (delta or 0)
    -- Very slow parallax keeps the artwork alive without burning a frame on
    -- decorative effects. It automatically stops when the window is hidden.
    if Artwork and Artwork.Parent and Window.Visible and artworkMotionClock >= 0.033 then
        artworkMotionClock = 0
        local t = tick()
        Artwork.Position = UDim2.new(0, -21 + math.sin(t * 0.22) * 3, 0, -21 + math.cos(t * 0.18) * 2)
        Artwork.Rotation = math.sin(t * 0.16) * 0.18
    end
    local now = tick()
    if now - lastIteration >= 0.5 then
        currentFPS = math.floor(frameCount / (now - lastIteration) + 0.5)
        frameCount = 0
        lastIteration = now
        
        local ping = 0
        pcall(function()
            ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
        end)
        
        if watermarkLabel and watermarkLabel.Parent then
            local activeCount = 0
            for _, control in ipairs(__KZ_QOL.ToggleRegistry) do
                local pageName = tostring(control.__KZPage or "")
                if pageName ~= "" and pageName ~= "Home" and pageName ~= "Settings" and control.__KZRow and control.__KZRow.Parent then
                    local ok, enabled = pcall(control.Get)
                    if ok and enabled == true then activeCount = activeCount + 1 end
                end
            end
            watermarkLabel.Text = string.format("KZ Scripts  |  %s  |  %d Active  |  %d FPS  |  %d ms", LocalPlayer.DisplayName, activeCount, currentFPS, ping)
        end
    end

end))

BindTheme(function()
    if homeThemeStat and homeThemeStat.Value.Parent then homeThemeStat.Value.Text = themeName end
end)

local pageDefinitions = {}

-- Favorites
do
local FavoriteHttp = game:GetService("HttpService")
local FAVORITES_FILE = ConfigManager.Folder .. "/Favorites.json"
local favoriteKeys = {}
local favoriteRowsByKey = {}

local function LoadFavoriteKeys()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" or not isfile(FAVORITES_FILE) then return end
    local ok, raw = pcall(readfile, FAVORITES_FILE)
    if not ok or type(raw) ~= "string" then return end
    local decodedOk, decoded = pcall(function() return FavoriteHttp:JSONDecode(raw) end)
    if not decodedOk or type(decoded) ~= "table" then return end
    for _, key in ipairs(decoded) do
        if type(key) == "string" then favoriteKeys[key] = true end
    end
end

local function SaveFavoriteKeys()
    if typeof(writefile) ~= "function" then return end
    local list = {}
    for key, enabled in pairs(favoriteKeys) do
        if enabled then table.insert(list, key) end
    end
    table.sort(list)
    local ok, raw = pcall(function() return FavoriteHttp:JSONEncode(list) end)
    if ok then pcall(writefile, FAVORITES_FILE, raw) end
end

local function MakeFavoriteHomeRow(meta)
    local row = New("Frame", {
        Parent = __KZ_QOL.FavoritesCard, Name = "KZFavoriteRow", Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = T.ElementBG, BackgroundTransparency = 0.06,
    })
    Corner(row, 10)
    local outline = Stroke(row, "Border", 0.28)
    local title = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(13, 4), Size = UDim2.new(1, -62, 0, 18),
        BackgroundTransparency = 1, Text = tostring(meta.Label), Font = Enum.Font.GothamSemibold,
        TextSize = 10, TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    local sub = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(13, 21), Size = UDim2.new(1, -62, 0, 15),
        BackgroundTransparency = 1, Text = tostring(meta.Page), Font = Enum.Font.Gotham,
        TextSize = 9, TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local remove = New("TextButton", {
        Parent = row, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -9, 0.5, 0),
        Size = UDim2.fromOffset(28, 28), BackgroundColor3 = T.ControlBG, BackgroundTransparency = 0.1,
        Text = "×", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = T.TextSub,
        AutoButtonColor = false, ZIndex = 7,
    })
    Corner(remove, 8)
    local jump = New("TextButton", {
        Parent = row, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "", AutoButtonColor = false, ZIndex = 6,
    })
    jump.MouseButton1Click:Connect(function()
        if __KZ_QOL.JumpToSearchable then __KZ_QOL.JumpToSearchable(meta.Page, meta.Searchable) end
    end)
    remove.MouseButton1Click:Connect(function()
        favoriteKeys[meta.Key] = nil
        SaveFavoriteKeys()
        if __KZ_QOL.RefreshFavorites then __KZ_QOL.RefreshFavorites() end
        Toast("Favorites", tostring(meta.Label) .. " unpinned.", 2)
    end)
    BindTheme(function()
        if row.Parent then
            row.BackgroundColor3 = T.ElementBG
            outline.Color = T.Border
            title.TextColor3 = T.TextMain
            sub.TextColor3 = T.TextSub
            remove.BackgroundColor3 = T.ControlBG
            remove.TextColor3 = T.TextSub
        end
    end)
    return row
end

__KZ_QOL.RefreshFavorites = function()
    for _, child in ipairs(__KZ_QOL.FavoritesCard:GetChildren()) do
        if child:IsA("Frame") and child.Name == "KZFavoriteRow" then child:Destroy() end
    end
    local metas = {}
    for key, meta in pairs(favoriteRowsByKey) do
        if favoriteKeys[key] and meta.Row and meta.Row.Parent then table.insert(metas, meta) end
    end
    table.sort(metas, function(a, b)
        if a.Page == b.Page then return a.Label < b.Label end
        return a.Page < b.Page
    end)
    __KZ_QOL.FavoritePlaceholder.Frame.Visible = #metas == 0
    if __KZ_QOL.FavoritePlaceholder.Value and __KZ_QOL.FavoritePlaceholder.Value.Parent then
        __KZ_QOL.FavoritePlaceholder.Value.Text = (#metas == 0) and "None yet" or tostring(#metas) .. " pinned"
    end
    for _, meta in ipairs(metas) do MakeFavoriteHomeRow(meta) end
end

__KZ_QOL.ToggleFavorite = function(meta)
    if not meta or not meta.Key then return end
    favoriteKeys[meta.Key] = not favoriteKeys[meta.Key]
    if not favoriteKeys[meta.Key] then favoriteKeys[meta.Key] = nil end
    SaveFavoriteKeys()
    __KZ_QOL.RefreshFavorites()
    Toast("Favorites", tostring(meta.Label) .. (favoriteKeys[meta.Key] and " pinned." or " unpinned."), 2)
end

__KZ_QOL.RegisterFavoriteRow = function(page, label, row, searchable)
    if not page or not row or not searchable then return end
    local pageName = tostring(page.Name or "")
    if pageName == "Home" or pageName == "Settings" then return end
    local meta = {
        Key = searchable.Key or (pageName .. "/" .. tostring(label)),
        Page = pageName,
        Label = tostring(label or "Feature"),
        Row = row,
        Searchable = searchable,
    }
    favoriteRowsByKey[meta.Key] = meta
    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            __KZ_QOL.ToggleFavorite(meta)
        end
    end)
    if favoriteKeys[meta.Key] then task.defer(__KZ_QOL.RefreshFavorites) end
end

LoadFavoriteKeys()
__KZ_QOL.RefreshFavorites()
end

-- Active features
__KZ_QOL.UpdateActiveUI = function()
    local total = 0
    local perPage = {}
    for _, control in ipairs(__KZ_QOL.ToggleRegistry) do
        local pageName = tostring(control.__KZPage or "")
        if pageName ~= "" and pageName ~= "Home" and pageName ~= "Settings" and control.__KZRow and control.__KZRow.Parent then
            local ok, enabled = pcall(control.Get)
            if ok and enabled == true then
                total = total + 1
                perPage[pageName] = (perPage[pageName] or 0) + 1
            end
        end
    end
    if homeStatusStat and homeStatusStat.Value and homeStatusStat.Value.Parent then
        homeStatusStat.Value.Text = tostring(total)
    end
    for pageName, item in pairs(navEntries) do
        local count = perPage[pageName] or 0
        item.ActiveCount = count
        if item.Badge and item.Badge.Parent then
            item.Badge.Text = tostring(count)
            item.Badge.Visible = sidebarExpanded and count > 0
        end
    end
end

__KZ_QOL.DisableAllFeatures = function()
    local disabled = 0
    for _, control in ipairs(__KZ_QOL.ToggleRegistry) do
        local pageName = tostring(control.__KZPage or "")
        if pageName ~= "" and pageName ~= "Home" and pageName ~= "Settings" and control.__KZRow and control.__KZRow.Parent then
            local ok, enabled = pcall(control.Get)
            if ok and enabled == true and type(control.Set) == "function" then
                disabled = disabled + 1
                pcall(function() control.Set(false, true) end)
            end
        end
    end
    task.defer(__KZ_QOL.UpdateActiveUI)
    Toast("Active Features", disabled > 0 and ("Disabled " .. tostring(disabled) .. " feature" .. (disabled == 1 and "." or "s.")) or "Nothing is enabled.", 3)
end

local function AddControl(page, card, definition)
    local control
    if definition[1] == "toggle" then
        control = Toggle(page, card, definition[2], definition[3], definition[4])
    elseif definition[1] == "slider" then
        control = Slider(page, card, definition[2], definition[3], definition[4], definition[5], definition[6], definition[7])
    elseif definition[1] == "dropdown" then
        control = Dropdown(page, card, definition[2], definition[3], definition[4], definition[5])
    elseif definition[1] == "button" then
        control = Button(page, card, definition[2], definition[3], definition[4])
    elseif definition[1] == "textbox" then
        control = Textbox(page, card, definition[2], definition[3], definition[4], definition[5])
    end
    if control and type(control) == "table" and definition[2] then
        ConfigManager.Register(definition[2], control)
    end
    return control
end

local Settings = CreatePage("Settings")
local appearance = Section(Settings, "Appearance")

-- Hello Kitty decorations
local HKDecor = {}
local function HKDecal(parent, assetId, anchor, position, size, zindex, transparency)
    local img = New("ImageLabel", {
        Parent = parent, AnchorPoint = anchor, Position = position,
        Size = size, BackgroundTransparency = 1, Image = "rbxassetid://" .. assetId,
        ImageTransparency = transparency or 0.1, ScaleType = Enum.ScaleType.Fit,
        ZIndex = zindex or 5, Visible = false,
    })
    table.insert(HKDecor, img)
    return img
end
-- Topbar charms
HKDecal(Topbar, "11769216849", Vector2.new(1, 0.5), UDim2.new(1, -324, 0.5, 0), UDim2.fromOffset(26, 26), 13, 0.05)
HKDecal(Topbar, "11744148931", Vector2.new(1, 0.5), UDim2.new(1, -354, 0.5, 0), UDim2.fromOffset(24, 24), 13, 0.1)
-- Corner decoration
HKDecal(Window, "10973237327", Vector2.new(1, 1), UDim2.new(1, 5, 1, -10), UDim2.fromOffset(46, 46), 60, 0.3)
BindTheme(function()
    local hkOn = themeName == "Hello Kitty"
    for _, img in ipairs(HKDecor) do
        if img.Parent then img.Visible = hkOn end
    end
end)

-- Sync picker colors
local AccentSyncPickers = {}

ConfigManager.Register("UI Theme", Dropdown(Settings, appearance, "UI Theme", {"KZ Scripts", "Hello Kitty", "Cherry Blossom"}, themeName, function(value)
    local selectedTheme = Themes[value] and value or "KZ Scripts"
    if selectedTheme == themeName then return end
    __KZ_QOL.PlayThemeTransition(function()
        themeName = selectedTheme
        for key in pairs(T) do T[key] = nil end
        for key, paletteValue in pairs(Themes[selectedTheme]) do T[key] = paletteValue end
        pcall(function()
            getgenv().__kzQBAccent = T.Accent
            getgenv().__kzQBAccent2 = T.Accent2
            getgenv().__kzQBAccent3 = T.Accent3
            getgenv().__kzQBBeamCustom = false
            getgenv().__kzQBBeamColor = T.Accent
            getgenv().__kzQBCardDecals = (selectedTheme == "Hello Kitty") and { "rbxassetid://11769216849", "rbxassetid://10973237327" } or nil
            getgenv().__kzQBCardStyle = (selectedTheme == "Hello Kitty") and {
                bg1 = Color3.fromRGB(255, 240, 246), bg2 = Color3.fromRGB(255, 224, 236),
                label = Color3.fromRGB(179, 110, 140), value = Color3.fromRGB(97, 42, 68),
            } or nil
        end)
        for _, picker in ipairs(AccentSyncPickers) do
            pcall(function() picker:Set(T.Accent) end)
        end
        UpdateThemeArt(selectedTheme, true)
        if homeThemeStat and homeThemeStat.Value.Parent then homeThemeStat.Value.Text = selectedTheme end
        for _, repaint in ipairs(themeBindings) do pcall(repaint) end
        if type(__KZ_ApplyTheme) == "function" then pcall(__KZ_ApplyTheme) end
        Toast("Theme changed", selectedTheme .. " palette applied.")
    end)
end))

-- Custom cursor
local CursorOptions = {"Default", "Hello Kitty"}
local CURSOR_IMAGE = "rbxassetid://12030244889"
local CURSOR_SIZE = 24 -- pixels; tweak here if you want it bigger/smaller
local currentCursor = "Default"
local cursorGui, cursorDot, cursorConn
local function EnsureCursorDot()
    if cursorDot and cursorDot.Parent then return end
    cursorGui = New("ScreenGui", {
        Parent = parent, Name = "KZCursor", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 2147483000,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    cursorDot = New("ImageLabel", {
        Parent = cursorGui, AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(CURSOR_SIZE, CURSOR_SIZE),
        BackgroundTransparency = 1, Image = CURSOR_IMAGE,
        ScaleType = Enum.ScaleType.Fit, ZIndex = 999999, Visible = false,
    })
end
local function ApplyCursor()
    pcall(function()
        if currentCursor == "Hello Kitty" then
            EnsureCursorDot()
            UserInputService.MouseIconEnabled = false
            cursorDot.Visible = true
            if not cursorConn then
                cursorConn = RunService.RenderStepped:Connect(function()
                    if currentCursor ~= "Hello Kitty" or not (cursorDot and cursorDot.Parent) then return end
                    local pos = UserInputService:GetMouseLocation()
                    cursorDot.Position = UDim2.fromOffset(pos.X, pos.Y)
                end)
                table.insert(connections, cursorConn)
            end
        else
            UserInputService.MouseIconEnabled = true
            if cursorDot then cursorDot.Visible = false end
        end
    end)
end
ConfigManager.Register("Cursor", Dropdown(Settings, appearance, "Cursor", CursorOptions, currentCursor, function(value)
    -- Support old cursor names
    currentCursor = (tostring(value):find("Hello Kitty") and "Hello Kitty") or "Default"
    ApplyCursor()
end))
table.insert(connections, LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    ApplyCursor()
end))
ConfigManager.Register("Window Scale", Slider(Settings, appearance, "Window Scale", 50, 150, 100, "%", function(value)
    uiScaleFactor = math.clamp(value / 100, 0.55, 1.25)
    task.defer(function()
        if Scale and GetTargetScale then
            Scale.Scale = GetTargetScale()
        end
    end)
end))
local behavior = Section(Settings, "Window & navigation")
ConfigManager.Register("Notifications", Toggle(Settings, behavior, "Notifications", true, function(value)
    notificationsEnabled = value
end))
ConfigManager.Register("Enable Watermark", Toggle(Settings, behavior, "Enable Watermark", true, function(value)
    watermarkEnabled = value
    if Watermark then Watermark.Visible = value end
end))
ConfigManager.Register("Show Player", Toggle(Settings, behavior, "Show Player", true, function(value)
    if Profile then Profile.Visible = value end
    if SideFooter then SideFooter.Visible = value end
end))
ConfigManager.Register("Show Logo", Toggle(Settings, behavior, "Show Logo", true, function(value)
    if BrandLogoShell then BrandLogoShell.Visible = value end
    if BrandLogo then BrandLogo.Visible = value end
    if OpenButton then OpenButton.ImageTransparency = value and 0 or 1 end
end))
ConfigManager.Register("Expand Sidebar on Hover", Toggle(Settings, behavior, "Expand Sidebar on Hover", true, function(value)
    sidebarHoverEnabled = value
    if not value then
        SetSidebar(true)
    end
end))
ConfigManager.Register("Menu Keybind", Dropdown(Settings, behavior, "Menu Keybind", {"RightControl", "Insert", "Home", "F4"}, "RightControl", function(value)
    menuToggleKey = Enum.KeyCode[value] or Enum.KeyCode.RightControl
    for _, control in ipairs(__KZ_QOL.KeybindRegistry) do
        if type(control.Get) == "function" then
            local ok, featureKey = pcall(control.Get)
            if ok and featureKey == menuToggleKey then
                Toast("Duplicate keybind", value .. " is already used by " .. tostring(control.__KZPage or "Feature") .. " / " .. tostring(control.__KZLabel or "Keybind") .. ".", 4)
                break
            end
        end
    end
    notify("Menu Keybind", value, 2.5)
end))
Button(Settings, behavior, "Preview notification", true, function() notify("KZ Scripts UI", "UI Library is ready.", 3) end)
Button(Settings, behavior, "Unload Script", false, function()
    if __KZ_UniversalUnload then __KZ_UniversalUnload() end
end)

local configs = Section(Settings, "Configs")
local configName = "default"
local configNameBox = ConfigManager.Register("Config Name", Textbox(Settings, configs, "Config Name", "default", "default", function(text)
    configName = tostring(text or "default")
end))
local autoloadToggle
autoloadToggle = ConfigManager.Register("Autoload", Toggle(Settings, configs, "Autoload", ConfigManager.GetAutoload() ~= nil, function(state)
    if configNameBox and configNameBox.Get then configName = configNameBox.Get() end
    ConfigManager.SetAutoload(configName, state)
    notify("Autoload", state and ("Will load '" .. configName .. "' for " .. SCRIPT_ID) or "Autoload disabled", 3)
end))
local viewConfigs
local function refreshConfigDropdown()
    local list = ConfigManager.List()
    if #list == 0 then list = {"default"} end
    if viewConfigs and viewConfigs.Refresh then viewConfigs.Refresh(list) end
    return list
end
viewConfigs = ConfigManager.Register("View Configs", Dropdown(Settings, configs, "View Configs", refreshConfigDropdown(), "default", function(value)
    configName = value
    if configNameBox and configNameBox.Set then configNameBox.Set(value, false) end
    if autoloadToggle and autoloadToggle.Set then
        autoloadToggle.Set(ConfigManager.GetAutoload() == value, false)
    end
end))
Button(Settings, configs, "Save Config", true, function()
    if configNameBox and configNameBox.Get then configName = configNameBox.Get() end
    local ok, err = ConfigManager.Save(configName)
    refreshConfigDropdown()
    notify("Configs", ok and ("Saved '" .. configName .. "' → " .. ConfigManager.Folder) or tostring(err), 4)
end)
Button(Settings, configs, "Load Config", false, function()
    if configNameBox and configNameBox.Get then configName = configNameBox.Get() end
    local ok, res = ConfigManager.Load(configName)
    notify("Configs", ok and ("Loaded '" .. configName .. "' (" .. tostring(res) .. " flags)") or tostring(res), 4)
end)
Button(Settings, configs, "Delete Config", false, function()
    if configNameBox and configNameBox.Get then configName = configNameBox.Get() end
    local ok, err = ConfigManager.Delete(configName)
    refreshConfigDropdown()
    notify("Configs", ok and ("Deleted '" .. configName .. "'") or tostring(err), 3)
end)

-- Config import
__KZ_QOL.ConfigImportSection = Section(Settings, "Import Config", "Paste a shared KZ JSON config and apply matching settings.")
__KZ_QOL.ConfigImportBox = Textbox(
    Settings,
    __KZ_QOL.ConfigImportSection,
    "JSON Config",
    "Paste JSON here...",
    "",
    function() end
)

Button(Settings, __KZ_QOL.ConfigImportSection, "Export Current Config", true, function()
    local ok, raw = ConfigManager.ExportJSON()
    if not ok then
        notify("Config Export", tostring(raw), 4)
        return
    end
    if __KZ_QOL.ConfigImportBox and __KZ_QOL.ConfigImportBox.Set then
        __KZ_QOL.ConfigImportBox.Set(raw, false)
    end
    local copied = false
    local clipboard = setclipboard or toclipboard
    if typeof(clipboard) == "function" then copied = pcall(clipboard, raw) end
    if not copied and typeof(writefile) == "function" then
        copied = pcall(writefile, ConfigManager.Folder .. "/ExportedConfig.json", raw)
    end
    notify("Config Export", copied and "Config copied or saved, and placed in the import box." or "Config placed in the import box.", 4)
end)

Button(Settings, __KZ_QOL.ConfigImportSection, "Import & Apply", true, function()
    local raw = (__KZ_QOL.ConfigImportBox and __KZ_QOL.ConfigImportBox.Get)
        and __KZ_QOL.ConfigImportBox.Get() or ""
    local ok, applied, skipped = ConfigManager.ImportJSON(raw)

    if ok then
        if __KZ_QOL.RefreshActiveCounts then __KZ_QOL.RefreshActiveCounts() end
        notify(
            "Config Import",
            "Applied " .. tostring(applied) .. " settings"
                .. ((skipped or 0) > 0 and (" | skipped " .. tostring(skipped) .. " unknown/invalid") or ""),
            4
        )
    else
        notify("Config Import", tostring(applied), 4)
    end
end)

Button(Settings, __KZ_QOL.ConfigImportSection, "Import, Apply & Save", false, function()
    local raw = (__KZ_QOL.ConfigImportBox and __KZ_QOL.ConfigImportBox.Get)
        and __KZ_QOL.ConfigImportBox.Get() or ""
    local ok, applied, skipped = ConfigManager.ImportJSON(raw)

    if not ok then
        notify("Config Import", tostring(applied), 4)
        return
    end

    if configNameBox and configNameBox.Get then configName = configNameBox.Get() end
    local saved, result = ConfigManager.Save(configName)
    refreshConfigDropdown()
    if __KZ_QOL.RefreshActiveCounts then __KZ_QOL.RefreshActiveCounts() end

    if saved then
        notify(
            "Config Import",
            "Applied " .. tostring(applied)
                .. " settings and saved as '" .. tostring(configName) .. "'"
                .. ((skipped or 0) > 0 and (" | skipped " .. tostring(skipped)) or ""),
            5
        )
    else
        notify("Config Import", "Applied, but save failed: " .. tostring(result), 5)
    end
end)

Button(Settings, __KZ_QOL.ConfigImportSection, "Clear Import Box", false, function()
    if __KZ_QOL.ConfigImportBox and __KZ_QOL.ConfigImportBox.Set then
        __KZ_QOL.ConfigImportBox.Set("", false)
    end
end)

notify = function(title, text, duration)
    if type(Toast) == "function" then
        Toast(tostring(title or "Notice"), tostring(text or ""), duration or 3)
    end
end



-- Tab and control bridge
__KZ_ApplyTheme = function()
    if destroyed then return end
    pcall(function()
        Window.BackgroundColor3 = T.MainBG
        Dim.BackgroundColor3 = T.MainBG
        Sidebar.BackgroundColor3 = T.SidebarBG
        sideLine.BackgroundColor3 = T.Border
        Topbar.BackgroundColor3 = T.TopbarBG
        topLine.BackgroundColor3 = T.Border
        BrandLogoShell.BackgroundColor3 = T.ElementBG
        BrandTitle.TextColor3 = T.TextMain
        BrandSub.TextColor3 = T.Accent
        Profile.BackgroundColor3 = T.ElementBG
        Avatar.BackgroundColor3 = T.ControlBG
        ProfileName.TextColor3 = T.TextMain
        ProfileStatus.TextColor3 = T.Accent
        PageTitle.TextColor3 = T.TextMain
        Breadcrumb.TextColor3 = T.TextSub
        SearchBox.BackgroundColor3 = T.ControlBG
        SearchIcon.ImageColor3 = T.TextSub
        SearchInput.TextColor3 = T.TextMain
        SearchInput.PlaceholderColor3 = T.TextSub
        MinimizeButton.BackgroundColor3 = T.ControlBG
        MinimizeButton.ImageColor3 = T.TextSub
        CloseButton.BackgroundColor3 = T.ControlBG
        CloseButton.ImageColor3 = T.TextSub
        OpenButton.BackgroundColor3 = T.MainBG
        windowStroke.Color = T.Border
        SearchResults.BackgroundColor3 = T.SectionBG
        SearchResults.ScrollBarImageColor3 = T.Accent
        searchResultsStroke.Color = T.Border
        Watermark.BackgroundColor3 = T.SidebarBG
        watermarkLabel.TextColor3 = T.TextMain
        watermarkStroke.Color = T.Border
        for _, item in pairs(navEntries) do
            item.Button.BackgroundColor3 = T.ElementBG
            item.Icon.ImageColor3 = T.TextSub
            item.Label.TextColor3 = T.TextSub
            item.Indicator.BackgroundColor3 = T.Accent
        end
    end)
end

local __KZ_UnloadHooks = {}
local __KZ_WindowGui = Window
local __KZ_WindowMethods = {}
local __KZ_TabCounter = 0
local __KZ_IconAliases = {
    swords = ICONS.Defense, target = ICONS.Defense, box = ICONS.Misc,
    layers = ICONS.Physics, settings = ICONS.Settings, defense = ICONS.Defense,
    speed = ICONS.Player, ball = ICONS.Catching, eye = ICONS.Visual,
    utility = ICONS.Misc, monitor = ICONS.Misc, atom = ICONS.Physics,
}

local function __KZ_ResolveIcon(icon)
    if type(icon) ~= "string" then return ICONS.Misc end
    if ICONS[icon] then return ICONS[icon] end
    if __KZ_IconAliases[string.lower(icon)] then return __KZ_IconAliases[string.lower(icon)] end
    if icon:match("^rbxasset") then return icon end
    return ICONS.Misc
end

local function __KZ_UpdateNavSelectionGlow(animate)
    local selectedNav = navEntries[currentPage]
    local glow = __KZ_QOL.NavSelectionGlow
    if not selectedNav or not selectedNav.Button or not selectedNav.Button.Parent or not glow.Parent then
        glow.Visible = false
        return
    end

    local button = selectedNav.Button
    local y = button.AbsolutePosition.Y - NavIndicatorLayer.AbsolutePosition.Y
    glow.Visible = true
    local goal = {
        Position = UDim2.fromOffset(10, y),
        Size = UDim2.new(1, -20, 0, 43),
    }
    if animate then
        Tween(glow, 0.34, goal, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    else
        glow.Position = goal.Position
        glow.Size = goal.Size
    end
end

local function __KZ_SelectPage(name)
    local targetPage = pages[name]
    if not targetPage then return end
    if currentPage == name and targetPage.Group.Visible then return end
    if activeDropdown then activeDropdown.Visible = false; activeDropdown = nil end
    if activeColorPopup then activeColorPopup.Visible = false; activeColorPopup = nil end
    DropdownLayer.Visible = false
    SearchResults.Visible = false
    currentPage = name
    for pageName, page in pairs(pages) do
        local selected = pageName == name
        page.Group.Visible = selected
        if selected then
            page.Group.GroupTransparency = 1
            Tween(page.Group, 0.26, {GroupTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            if page.Scroll then page.Scroll.CanvasPosition = Vector2.new(0, 0) end
        end
    end
    PageTitle.Text = name == "Home" and "Status" or name
    Breadcrumb.Text = "KZ Scripts  /  " .. (name == "Home" and "Status" or name)
    SearchInput.Text = ""
    for navName, item in pairs(navEntries) do
        local selected = navName == name
        Tween(item.Button, 0.18, {BackgroundTransparency = selected and 0.82 or 1, BackgroundColor3 = selected and T.Accent or T.SidebarBG})
        Tween(item.Icon, 0.18, {ImageColor3 = selected and T.TextMain or T.TextSub})
        Tween(item.Label, 0.18, {TextColor3 = selected and T.TextMain or T.TextSub})
        Tween(item.Indicator, 0.18, {BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 0)})
    end
    local selectedNav = navEntries[name]
    if selectedNav and selectedNav.Button then
        task.defer(function()
            __KZ_UpdateNavSelectionGlow(true)
        end)
    end
end


NavScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    __KZ_UpdateNavSelectionGlow(false)
end)

local function __KZ_AddNav(name, icon, order)
    if navEntries[name] then return navEntries[name] end
    __KZ_TabCounter = __KZ_TabCounter + 1
    local button = New("TextButton", {
        Parent = NavScroll, LayoutOrder = order or __KZ_TabCounter,
        Size = UDim2.new(1, 0, 0, 43), BackgroundColor3 = T.ElementBG,
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 23,
    })
    Corner(button, 11)
    Gradient(button, {function(t) return Mix(t.ElementBG, t.Accent3, .16) end, function(t) return Mix(t.ElementBG, t.Accent2, .13) end}, 0)
    local indicator = New("Frame", {
        Parent = button, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(0, 0), BackgroundColor3 = T.Accent,
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 24,
    })
    Corner(indicator, 3)
    Gradient(indicator, {"Accent3", "Accent", "Accent2"}, 90)
    local image = New("ImageLabel", {
        Parent = button, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(22, 22), Size = UDim2.fromOffset(21, 21),
        BackgroundTransparency = 1, Image = __KZ_ResolveIcon(icon), ImageColor3 = T.TextSub, ZIndex = 24,
    })
    local label = New("TextLabel", {
        Parent = button, Position = UDim2.fromOffset(48, 0), Size = UDim2.new(1, -78, 1, 0),
        BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamMedium, TextSize = 11,
        TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 24,
    })
    local badge = New("TextLabel", {
        Parent = button, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(22, 18), BackgroundColor3 = T.Accent, BackgroundTransparency = 0.05,
        Text = "0", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = T.MainBG,
        Visible = false, ZIndex = 25,
    })
    Corner(badge, 9)
    BindTheme(function() if badge.Parent then badge.BackgroundColor3 = T.Accent; badge.TextColor3 = T.MainBG end end)
    navEntries[name] = {Button = button, Icon = image, Label = label, Indicator = indicator, Badge = badge, ActiveCount = 0}
    button.MouseButton1Click:Connect(function() __KZ_SelectPage(name) end)
    if __KZ_QOL.UpdateActiveUI then task.defer(__KZ_QOL.UpdateActiveUI) end
    return navEntries[name]
end

SetSidebar = function(expanded)
    if sidebarExpanded == expanded then return end
    sidebarExpanded = expanded == true
    Tween(Sidebar, 0.28, {Size = UDim2.new(0, sidebarExpanded and SIDEBAR_OPEN or SIDEBAR_COMPACT, 1, 0)})
    ApplyContentLayout(sidebarExpanded, false)
    Tween(BrandLogoShell, 0.28, {Position = sidebarExpanded and UDim2.fromOffset(18, 16) or UDim2.fromOffset(12, 16)})
    Tween(BrandTitle, 0.18, {TextTransparency = sidebarExpanded and 0 or 1})
    Tween(BrandSub, 0.18, {TextTransparency = sidebarExpanded and 0 or 1})
    Tween(ProfileName, 0.18, {TextTransparency = sidebarExpanded and 0 or 1})
    Tween(ProfileStatus, 0.18, {TextTransparency = sidebarExpanded and 0 or 1})
    Tween(__KZ_QOL.NavSelectionGlow, 0.28, {Size = UDim2.new(1, -20, 0, 43)})
    for _, item in pairs(navEntries) do
        Tween(item.Label, 0.18, {TextTransparency = sidebarExpanded and 0 or 1})
        if item.Badge then item.Badge.Visible = sidebarExpanded and (item.ActiveCount or 0) > 0 end
    end
end

Sidebar.MouseEnter:Connect(function() if sidebarHoverEnabled then SetSidebar(true) end end)
Sidebar.MouseLeave:Connect(function() if sidebarHoverEnabled then SetSidebar(false) end end)

local function __KZ_DecorateControl(control, page, label, description)
    if type(control) ~= "table" then control = {} end
    local searchable = page.Searchables[#page.Searchables]
    local row = searchable and searchable.Object
    if searchable then
        searchable.Description = tostring(description or "")
        searchable.Text = string.lower(tostring(searchable.Label or label or "") .. " " .. searchable.Description)
    end
    control.GetValue = control.GetValue or function() return control.Get and control.Get() or control.Value end
    control.SetValue = control.SetValue or function(value, fire) if control.Set then control.Set(value, fire == nil and true or fire) end end
    control.Visible = control.Visible or function(value) if row then row.Visible = value end end
    control.Destroy = control.Destroy or function() if row and row.Parent then row:Destroy() end end
    control.__KZDescription = tostring(description or "")
    return control
end

local function __KZ_Label(sectionFrame, page, text)
    local row = New("Frame", {Parent = sectionFrame, Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1})
    local label = New("TextLabel", {
        Parent = row, Position = UDim2.fromOffset(4, 0), Size = UDim2.new(1, -8, 1, 0),
        BackgroundTransparency = 1, Text = tostring(text or ""), Font = Enum.Font.GothamMedium,
        TextSize = 10, TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
    })
    table.insert(page.Searchables, {Object = row, Text = string.lower(tostring(text or "")), Label = tostring(text or "")})
    BindTheme(function() if row.Parent then label.TextColor3 = T.TextSub end end)
    return {
        Value = label,
        SetValue = function(_, value) label.Text = tostring(value or "") end,
        Visible = function(_, value) row.Visible = value end,
        Destroy = function() if row.Parent then row:Destroy() end end,
    }
end

local function __KZ_Divider(sectionFrame, page)
    local line = Divider(page, sectionFrame)
    return {
        SetColor = function(_, value) if value then local child = line:FindFirstChildWhichIsA("Frame", true); if child then child.BackgroundColor3 = value end end end,
        SetHeight = function() end,
        Visible = function(_, value) line.Visible = value end,
        Destroy = function() if line.Parent then line:Destroy() end end,
    }
end

local function __KZ_MakeSection(tab, page, frame)
    local section = {Frame = frame, Tab = tab}
    function section:AddToggle(o) o=o or {}; return tab:_addToggle(frame,o) end
    function section:AddSlider(o) o=o or {}; return tab:_addSlider(frame,o) end
    function section:AddRangeSlider(o) o=o or {}; return tab:_addRangeSlider(frame,o) end
    function section:AddDropdown(o) o=o or {}; return tab:_addDropdown(frame,o) end
    function section:AddButton(o) o=o or {}; return tab:_addButton(frame,o) end
    function section:AddInput(o) o=o or {}; return tab:_addTextbox(frame,o) end
    function section:AddTextbox(o) o=o or {}; return tab:_addTextbox(frame,o) end
    function section:AddKeybind(o) o=o or {}; return tab:_addKeybind(frame,o) end
    function section:AddColorpicker(o) o=o or {}; return tab:_addColorpicker(frame,o) end
    function section:AddColorPicker(o) o=o or {}; return tab:_addColorpicker(frame,o) end
    function section:AddLabel(text) return __KZ_Label(frame,page,text) end
    function section:AddDivider() return __KZ_Divider(frame,page) end
    return section
end

local function __KZ_MakeTab(name, page)
    local tab = {Name = name, Page = page.Scroll, _page = page, _current = nil, _keys = {}}
    local function keyFor(label)
        local key = name .. "/" .. tostring(label or "Control")
        local n = tab._keys[key] or 0
        tab._keys[key] = n + 1
        return n == 0 and key or key .. " #" .. tostring(n + 1)
    end
    function tab:CreateSection(title, subtitle) self._current = __KZ_MakeSection(self, page, Section(page, title or name, subtitle)); return self._current end
    function tab:AddSection(o) o=o or {}; return self:CreateSection(o.Name or "Section", o.SubTitle or o.Subtitle) end
    function tab:_card() if not self._current then self._current = __KZ_MakeSection(self,page,Section(page,name)) end; return self._current.Frame end
    function tab:_register(label, control) ConfigManager.Register(keyFor(label), control); return control end
    function tab:_addToggle(card,o)
        o=o or {}; local default=o.Default == true
        local control=__KZ_DecorateControl(Toggle(page,card,o.Name or "Toggle",default,o.Callback),page,o.Name,o.Description or o.Tooltip)
        return self:_register(o.Name,RegisterSectionControl(card,control,default))
    end
    function tab:_addSlider(card,o)
        o=o or {}; local inc=o.Increment or (1/(10^(tonumber(o.Round) or 0))); local default=o.Default or o.Min or 0
        local control=__KZ_DecorateControl(Slider(page,card,o.Name or "Slider",o.Min or 0,o.Max or 100,default,o.Suffix or o.Type or "",o.Callback,inc),page,o.Name,o.Description or o.Tooltip)
        return self:_register(o.Name,RegisterSectionControl(card,control,default))
    end
    function tab:_addRangeSlider(card,o)
        o=o or {}; local default={Min=o.DefaultMin or o.Min or 0,Max=o.DefaultMax or o.Max or 100}
        local control=__KZ_DecorateControl(RangeSlider(page,card,o.Name or "Range",o.Min or 0,o.Max or 100,default.Min,default.Max,o.Suffix or "",o.Callback,o.Increment or 1),page,o.Name,o.Description or o.Tooltip)
        return self:_register(o.Name,RegisterSectionControl(card,control,default))
    end
    function tab:_addDropdown(card,o)
        o=o or {}; local opts=o.Options or o.Values or {}; local default=o.Default or opts[1]
        local control=__KZ_DecorateControl(Dropdown(page,card,o.Name or "Dropdown",opts,default,o.Callback),page,o.Name,o.Description or o.Tooltip)
        return self:_register(o.Name,RegisterSectionControl(card,control,default))
    end
    function tab:_addButton(card,o)
        o=o or {}; Button(page,card,o.Name or "Button",o.Emphasized == true,function() if o.Callback then pcall(o.Callback,o) end end)
        return __KZ_DecorateControl({},page,o.Name,o.Description or o.Tooltip)
    end
    function tab:_addTextbox(card,o)
        o=o or {}; local default=o.Default or ""
        local control=__KZ_DecorateControl(Textbox(page,card,o.Name or "Input",o.Placeholder or "Type...",default,o.Callback),page,o.Name,o.Description or o.Tooltip)
        return self:_register(o.Name,RegisterSectionControl(card,control,default))
    end
    function tab:_addKeybind(card,o)
        o=o or {}; local default=o.Default or Enum.KeyCode.Unknown
        local control=__KZ_DecorateControl(Keybind(page,card,o.Name or "Keybind",default,o.Callback),page,o.Name,o.Description or o.Tooltip)
        return self:_register(o.Name,RegisterSectionControl(card,control,default))
    end
    function tab:_addColorpicker(card,o)
        o=o or {}; local default=o.Default or Color3.fromRGB(255,255,255)
        local control=__KZ_DecorateControl(Colorpicker(page,card,o.Name or "Color",default,o.Callback),page,o.Name,o.Description or o.Tooltip)
        return self:_register(o.Name,RegisterSectionControl(card,control,default))
    end
    function tab:CreateToggle(o) return self:_addToggle(self:_card(),o) end
    function tab:CreateSlider(o) return self:_addSlider(self:_card(),o) end
    function tab:CreateRangeSlider(o) return self:_addRangeSlider(self:_card(),o) end
    function tab:CreateDropdown(o) return self:_addDropdown(self:_card(),o) end
    function tab:CreateButton(o) return self:_addButton(self:_card(),o) end
    function tab:CreateTextbox(o) return self:_addTextbox(self:_card(),o) end
    function tab:CreateInput(o) return self:_addTextbox(self:_card(),o) end
    function tab:CreateKeybind(o) return self:_addKeybind(self:_card(),o) end
    function tab:CreateColorpicker(o) return self:_addColorpicker(self:_card(),o) end
    function tab:CreateColorPicker(o) return self:_addColorpicker(self:_card(),o) end
    function tab:CreateDivider() return __KZ_Divider(self:_card(),page) end
    function tab:CreateLabel(text) return __KZ_Label(self:_card(),page,text) end
    return tab
end

local function __KZ_CreateTab(options)
    options = type(options) == "table" and options or {Name = tostring(options or "Tab")}
    local name = tostring(options.Name or "Tab")
    local page = pages[name] or CreatePage(name)
    if not page.__KZTab then page.__KZTab = __KZ_MakeTab(name,page) end
    __KZ_AddNav(name, options.Icon or ICONS.Misc, options.Order)
    return page.__KZTab
end

local __KZ_Window = setmetatable({Gui = __KZ_WindowGui, Screen = Screen}, {
    __index = function(object, key)
        if __KZ_WindowMethods[key] then return __KZ_WindowMethods[key] end
        return __KZ_WindowGui[key]
    end,
    __newindex = function(object, key, value)
        if __KZ_WindowMethods[key] then rawset(object,key,value) else pcall(function() __KZ_WindowGui[key] = value end) end
    end,
})
function __KZ_WindowMethods:CreateTab(options) return __KZ_CreateTab(options) end
function __KZ_WindowMethods:AddTab(options) return __KZ_CreateTab(options) end
function __KZ_WindowMethods:AddLabel(_) return nil end
function __KZ_WindowMethods:Notify(title,text,duration) return Toast(title,text,duration) end
function __KZ_WindowMethods:Unload()
    if destroyed then return end
    destroyed = true
    for _, hook in ipairs(__KZ_UnloadHooks) do pcall(hook) end
    pcall(function() UserInputService.MouseIconEnabled = true end)
    pcall(function() if cursorGui and cursorGui.Parent then cursorGui:Destroy() end end)
    for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
    if Screen and Screen.Parent then Screen:Destroy() end
end
function __KZ_WindowMethods:Destroy() return self:Unload() end

-- Shared unload function
__KZ_UniversalUnload = function() return __KZ_Window:Unload() end

-- Jump to search result
__KZ_QOL.JumpToSearchable = function(pageName, searchable)
    if not searchable or not searchable.Object then return end
    __KZ_SelectPage(pageName)
    task.defer(function()
        task.wait()
        local page = pages[pageName]
        local row = searchable.Object
        if not page or not page.Scroll or not row or not row.Parent then return end
        local scroll = page.Scroll
        local offset = row.AbsolutePosition.Y - scroll.AbsolutePosition.Y
        local desired = scroll.CanvasPosition.Y + offset - math.max(42, math.floor(scroll.AbsoluteSize.Y * 0.28))
        scroll.CanvasPosition = Vector2.new(0, math.max(0, desired))

        local old = row:FindFirstChild("_KZSearchHighlight")
        if old then old:Destroy() end
        local flash = New("UIStroke", {
            Parent = row, Name = "_KZSearchHighlight", Color = T.Accent, Transparency = 0,
            Thickness = 2.6, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        })
        local flashScale = New("UIScale", {Parent = row, Name = "_KZSearchPulse", Scale = 0.985})
        Tween(flashScale, 0.28, {Scale = 1.012}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.delay(0.3, function()
            if flashScale and flashScale.Parent then Tween(flashScale, 0.38, {Scale = 1}, Enum.EasingStyle.Quint) end
        end)
        task.delay(1.55, function()
            if flash and flash.Parent then Tween(flash, 1.05, {Transparency = 1, Thickness = 1}) end
        end)
        task.delay(2.65, function()
            if flash and flash.Parent then flash:Destroy() end
            if flashScale and flashScale.Parent then flashScale:Destroy() end
        end)
    end)
end

-- Search all tabs
SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SearchInput.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    for _, child in ipairs(SearchResults:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    __KZ_QOL.SearchEmpty.Visible = false
    if query == "" then SearchResults.Visible = false; DropdownLayer.Visible = false; return end
    local found = 0
    for pageName, page in pairs(pages) do
        for _, searchable in ipairs(page.Searchables or {}) do
            local description = tostring(searchable.Description or "")
            local haystack = tostring(searchable.Text or "") .. " " .. string.lower(description)
            if string.find(haystack, query, 1, true) then
                found = found + 1
                local item = New("TextButton", {
                    Parent = SearchResults, LayoutOrder = found, Size = UDim2.new(1, 0, 0, 48),
                    BackgroundColor3 = T.ElementBG, BackgroundTransparency = 0.14,
                    Text = "", AutoButtonColor = false, ZIndex = 501,
                })
                Corner(item, 9)
                local itemStroke = Stroke(item, "Border", 0.45)
                local itemTitle = New("TextLabel", {
                    Parent = item, Position = UDim2.fromOffset(10, 5), Size = UDim2.new(1, -20, 0, 17),
                    BackgroundTransparency = 1,
                    Text = tostring(searchable.Label or searchable.Text) .. "   •   " .. tostring(pageName),
                    Font = Enum.Font.GothamSemibold, TextSize = 10, TextColor3 = T.TextMain,
                    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 502,
                })
                local itemDescription = New("TextLabel", {
                    Parent = item, Position = UDim2.fromOffset(10, 24), Size = UDim2.new(1, -20, 0, 16),
                    BackgroundTransparency = 1,
                    Text = description ~= "" and description or ("Open this control in " .. tostring(pageName)),
                    Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = T.TextSub,
                    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 502,
                })
                item.MouseEnter:Connect(function()
                    Tween(item, 0.14, {BackgroundTransparency = 0, BackgroundColor3 = T.ElementHoverBG})
                    Tween(itemStroke, 0.14, {Transparency = 0.1})
                end)
                item.MouseLeave:Connect(function()
                    Tween(item, 0.14, {BackgroundTransparency = 0.14, BackgroundColor3 = T.ElementBG})
                    Tween(itemStroke, 0.14, {Transparency = 0.45})
                end)
                BindTheme(function()
                    if item.Parent then
                        item.BackgroundColor3 = T.ElementBG
                        itemTitle.TextColor3 = T.TextMain
                        itemDescription.TextColor3 = T.TextSub
                        itemStroke.Color = T.Border
                    end
                end)
                local targetSearchable = searchable
                local targetPageName = pageName
                item.MouseButton1Click:Connect(function()
                    SearchResults.Visible = false
                    DropdownLayer.Visible = false
                    __KZ_QOL.JumpToSearchable(targetPageName, targetSearchable)
                end)
            end
        end
    end
    __KZ_QOL.SearchEmpty.Visible = found == 0
    PositionSearchResults()
    SearchResults.Visible = true
    DropdownLayer.Visible = true
end)

-- Window controls
local __KZ_AmbientTweens = {}
local __KZ_WindowOpen = true
local function __KZ_SetOpen(open)
    __KZ_WindowOpen = open == true
    if __KZ_WindowOpen then
        Window.Visible = true; Dim.Visible = true; OpenButton.Visible = false
        for _, ambientTween in pairs(__KZ_AmbientTweens) do
            pcall(function() ambientTween:Play() end)
        end
        Window.GroupTransparency = 1
        Tween(Window, 0.28, {GroupTransparency = 0})
        Tween(Scale, 0.3, {Scale = GetTargetScale()})
    else
        for _, ambientTween in pairs(__KZ_AmbientTweens) do
            pcall(function() ambientTween:Pause() end)
        end
        if activeDropdown then activeDropdown.Visible = false end
        if activeColorPopup then activeColorPopup.Visible = false end
        DropdownLayer.Visible = false
        Tween(Window, 0.22, {GroupTransparency = 1})
        task.delay(0.23, function() if not __KZ_WindowOpen and not destroyed and Window.Parent then Window.Visible = false; Dim.Visible = false; OpenButton.Visible = true end end)
    end
end
MinimizeButton.MouseButton1Click:Connect(function() __KZ_SetOpen(false) end)
OpenButton.MouseButton1Click:Connect(function() __KZ_SetOpen(true) end)
CloseButton.MouseButton1Click:Connect(function() __KZ_Window:Unload() end)
table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == menuToggleKey then __KZ_SetOpen(not __KZ_WindowOpen) end
end))

local __KZ_Dragging, __KZ_DragStart, __KZ_StartPosition, __KZ_DragInput = false, nil, nil, nil
Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        __KZ_Dragging, __KZ_DragStart, __KZ_StartPosition = true, input.Position, Window.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then __KZ_Dragging = false end end)
    end
end)
Topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then __KZ_DragInput = input end
end)
table.insert(connections, UserInputService.InputChanged:Connect(function(input)
    if __KZ_Dragging and input == __KZ_DragInput then
        local delta = input.Position - __KZ_DragStart
        Window.Position = UDim2.new(__KZ_StartPosition.X.Scale, __KZ_StartPosition.X.Offset + delta.X, __KZ_StartPosition.Y.Scale, __KZ_StartPosition.Y.Offset + delta.Y)
    end
end))

local __KZ_BaseScale = 1
GetTargetScale = function() return math.clamp(__KZ_BaseScale * uiScaleFactor, 0.5, 1.15) end
local function __KZ_UpdateResponsiveScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    __KZ_BaseScale = math.clamp(math.min((viewport.X - 72) / 900, (viewport.Y - 72) / 540, 1), 0.55, 1)
    if __KZ_WindowOpen then Scale.Scale = GetTargetScale() end
end
if workspace.CurrentCamera then table.insert(connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(__KZ_UpdateResponsiveScale)) end
__KZ_UpdateResponsiveScale()

-- Animated background
local function __KZ_CreateAmbientLayer(host, baseZ, intensity, trackForWindow)
    -- Legacy compatibility shim. The old geometric layer is intentionally
    -- disabled so no caller can recreate the distracting moving shapes.
    return nil

    local layer = New("Frame", {
        Parent = host, Name = "KZAmbient", Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = baseZ,
    })
    local themed = {}

    local function ThemeObject(object, property, key)
        table.insert(themed, {Object = object, Property = property, Key = key})
        object[property] = T[key]
    end

    BindTheme(function()
        for _, binding in ipairs(themed) do
            if binding.Object and binding.Object.Parent then
                binding.Object[binding.Property] = T[binding.Key]
            end
        end
    end)

    local function Animate(object, duration, first, second)
        task.spawn(function()
            local forward = true
            while not destroyed and object and object.Parent do
                local target = forward and second or first
                local motion = Tween(object, duration, target, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                if not motion then break end
                if trackForWindow then
                    __KZ_AmbientTweens[object] = motion
                    if not __KZ_WindowOpen then pcall(function() motion:Pause() end) end
                end
                motion.Completed:Wait()
                forward = not forward
            end
            if trackForWindow then __KZ_AmbientTweens[object] = nil end
        end)
    end

    if trackForWindow and windowFadeGradient and windowFadeGradient.Parent then
        Animate(windowFadeGradient, 14, {Offset = Vector2.new(-0.18, -0.06)}, {
            Offset = Vector2.new(0.18, 0.06),
        })
    end

    -- Every palette gets its own quiet ambient motif.
    local motifPositions = {
        {0.12, 0.18, 0.17, 0.12}, {0.31, 0.76, 0.36, 0.68},
        {0.52, 0.22, 0.57, 0.29}, {0.72, 0.72, 0.67, 0.64},
        {0.88, 0.31, 0.82, 0.38}, {0.21, 0.48, 0.27, 0.56},
        {0.62, 0.48, 0.68, 0.41}, {0.91, 0.83, 0.85, 0.75},
    }
    local motifByTheme = {
        ["KZ Scripts"] = "◇", Redline = "/", Midnight = "✦",
        Emerald = "+", Frost = "•", Monochrome = "□", ["Hello Kitty"] = "♥",
    }
    for index, data in ipairs(motifPositions) do
        local motif = New("TextLabel", {
            Parent = layer, AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(data[1], data[2]), Size = UDim2.fromOffset(24, 24),
            BackgroundTransparency = 1, Text = motifByTheme[themeName] or "◇",
            Font = Enum.Font.GothamBold, TextSize = themeName == "Frost" and 18 or 12,
            TextColor3 = T.Accent, TextTransparency = 1 - (0.16 * intensity),
            Rotation = index % 2 == 0 and 8 or -8, ZIndex = baseZ,
        })
        BindTheme(function()
            if motif.Parent then
                motif.Text = motifByTheme[themeName] or "◇"
                motif.TextColor3 = (index % 3 == 0 and T.Accent2) or (index % 2 == 0 and T.Accent3) or T.Accent
                motif.TextSize = themeName == "Frost" and 18 or (themeName == "Redline" and 16 or 12)
            end
        end)
        Animate(motif, 13 + index, {
            Position = UDim2.fromScale(data[1], data[2]), Rotation = motif.Rotation,
        }, {
            Position = UDim2.fromScale(data[3], data[4]), Rotation = motif.Rotation + 26,
        })
    end

    -- Background dots
    for row = 0, 5 do
        for column = 0, 9 do
            local dot = New("Frame", {
                Parent = layer, AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.045 + column * 0.105, 0.055 + row * 0.178),
                Size = UDim2.fromOffset(2, 2), BackgroundTransparency = 1 - (0.12 * intensity),
                BorderSizePixel = 0, ZIndex = baseZ,
            })
            Corner(dot, 999)
            ThemeObject(dot, "BackgroundColor3", "Border")
        end
    end

    local streakData = {
        {Start = UDim2.fromScale(-0.26, 0.24), Finish = UDim2.fromScale(0.78, 0.04), Rotation = -17, Key = "Accent3", Time = 16},
        {Start = UDim2.fromScale(-0.12, 0.86), Finish = UDim2.fromScale(0.76, 0.66), Rotation = -12, Key = "Accent2", Time = 19},
    }
    for _, data in ipairs(streakData) do
        local streak = New("Frame", {
            Parent = layer, AnchorPoint = Vector2.new(0.5, 0.5), Position = data.Start,
            Size = UDim2.fromOffset(430, 3), Rotation = data.Rotation,
            BackgroundTransparency = 1 - (0.09 * intensity), BorderSizePixel = 0,
            ZIndex = baseZ,
        })
        ThemeObject(streak, "BackgroundColor3", data.Key)
        New("UIGradient", {
            Parent = streak,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0.18),
                NumberSequenceKeypoint.new(1, 1),
            }),
        })
        Animate(streak, data.Time, {Position = data.Start}, {Position = data.Finish})
    end

    local shapeData = {
        {Kind = "Diamond", Start = UDim2.fromScale(0.08, 0.23), Finish = UDim2.fromScale(0.14, 0.16), Size = 18, Key = "Accent", Time = 15, Rotation = 45},
        {Kind = "Ring", Start = UDim2.fromScale(0.79, 0.2), Finish = UDim2.fromScale(0.73, 0.28), Size = 22, Key = "Accent3", Time = 17, Rotation = 0},
        {Kind = "Square", Start = UDim2.fromScale(0.84, 0.78), Finish = UDim2.fromScale(0.76, 0.7), Size = 13, Key = "Accent2", Time = 14, Rotation = 12},
        {Kind = "Slash", Start = UDim2.fromScale(0.28, 0.82), Finish = UDim2.fromScale(0.36, 0.74), Size = 38, Key = "Accent", Time = 18, Rotation = -18},
        {Kind = "Ring", Start = UDim2.fromScale(0.46, 0.12), Finish = UDim2.fromScale(0.52, 0.18), Size = 11, Key = "Accent2", Time = 16, Rotation = 0},
        {Kind = "Diamond", Start = UDim2.fromScale(0.93, 0.42), Finish = UDim2.fromScale(0.87, 0.5), Size = 12, Key = "Accent", Time = 19, Rotation = 45},
        {Kind = "Square", Start = UDim2.fromScale(0.58, 0.91), Finish = UDim2.fromScale(0.65, 0.84), Size = 9, Key = "Accent3", Time = 15, Rotation = 18},
    }
    for _, data in ipairs(shapeData) do
        local isSlash = data.Kind == "Slash"
        local shape = New("Frame", {
            Parent = layer, AnchorPoint = Vector2.new(0.5, 0.5), Position = data.Start,
            Size = isSlash and UDim2.fromOffset(data.Size, 2) or UDim2.fromOffset(data.Size, data.Size),
            BackgroundTransparency = isSlash and (1 - 0.11 * intensity) or 1,
            BorderSizePixel = 0, Rotation = data.Rotation, ZIndex = baseZ,
        })
        if isSlash then
            ThemeObject(shape, "BackgroundColor3", data.Key)
            New("UIGradient", {
                Parent = shape,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0.1),
                    NumberSequenceKeypoint.new(1, 1),
                }),
            })
        else
            Corner(shape, data.Kind == "Ring" and 999 or (data.Kind == "Square" and 3 or 5))
            local shapeStroke = New("UIStroke", {
                Parent = shape, Transparency = 1 - (0.2 * intensity),
                Thickness = 1.1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            })
            ThemeObject(shapeStroke, "Color", data.Key)
        end
        Animate(shape, data.Time, {Position = data.Start, Rotation = data.Rotation}, {
            Position = data.Finish, Rotation = data.Rotation + (isSlash and 7 or 24),
        })
    end

    local particleData = {
        {0.19, 0.72, 0.27, 0.62, 12}, {0.35, 0.18, 0.42, 0.28, 15},
        {0.53, 0.82, 0.6, 0.7, 17}, {0.68, 0.34, 0.74, 0.25, 14},
        {0.86, 0.52, 0.79, 0.61, 18}, {0.44, 0.56, 0.49, 0.46, 13},
    }
    local particleKeys = {"Accent", "Accent2", "Accent3"}
    for index, data in ipairs(particleData) do
        local startPosition = UDim2.fromScale(data[1], data[2])
        local endPosition = UDim2.fromScale(data[3], data[4])
        local particle = New("Frame", {
            Parent = layer, AnchorPoint = Vector2.new(0.5, 0.5), Position = startPosition,
            Size = UDim2.fromOffset(index % 2 == 0 and 3 or 4, index % 2 == 0 and 3 or 4),
            BackgroundTransparency = 1 - (0.24 * intensity), BorderSizePixel = 0,
            ZIndex = baseZ,
        })
        Corner(particle, 999)
        ThemeObject(particle, "BackgroundColor3", particleKeys[((index - 1) % 3) + 1])
        Animate(particle, data[5], {Position = startPosition}, {Position = endPosition})
    end

    return layer
end

-- Geometric ambient layer removed; theme artwork is the only background.

-- Default pages
__KZ_AddNav("Home", ICONS.Home, 1)
__KZ_AddNav("Settings", ICONS.Settings, 999)
__KZ_ApplyTheme()
__KZ_SelectPage("Home")
Window.Visible = true
Window.Active = false
Window.GroupTransparency = 1
Scale.Scale = GetTargetScale()

-- Loading animation
local function __KZ_PlayLoadAnimation()
    if __KZ_UI_OPTIONS.LoadAnimation == false then
        Window.Active = true
        Window.GroupTransparency = 0
        return
    end

    local targetScale = GetTargetScale()
    Window.Visible = false
    local Intro = New("CanvasGroup", {
        Parent = Screen, Name = "KZLoadIntro", AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(900, 540),
        BackgroundColor3 = T.MainBG, BorderSizePixel = 0, ClipsDescendants = true,
        GroupTransparency = 1, ZIndex = 1000, Active = true,
    })
    Corner(Intro, 18)
    local introStroke = Stroke(Intro, "Accent", 1, 1.4)
    local introScale = New("UIScale", {Parent = Intro, Scale = targetScale * 0.72})

    local introBackdrop = New("Frame", {
        Parent = Intro, Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = T.MainBG, BorderSizePixel = 0, ZIndex = 1000,
    })
    local backdropGradient = Gradient(introBackdrop, {
        function(t) return Mix(t.MainBG, t.Accent3, 0.18) end,
        "MainBG",
        function(t) return Mix(t.MainBG, t.Accent2, 0.2) end,
    }, 20)
    backdropGradient.Offset = Vector2.new(-0.18, -0.06)
    local introArtwork = New("ImageLabel", {
        Parent = Intro, Size = UDim2.new(1, 30, 1, 30), Position = UDim2.fromOffset(-15, -15),
        BackgroundTransparency = 1, Image = ResolveLoaderArt() or "",
        ImageTransparency = 0.08, ScaleType = Enum.ScaleType.Crop, ZIndex = 1001,
    })
    local introArtworkScale = New("UIScale", {Parent = introArtwork, Scale = 1.045})
    local introArtworkShade = New("Frame", {
        Parent = Intro, Size = UDim2.fromScale(1, 1), BackgroundColor3 = T.MainBG,
        BackgroundTransparency = 0.62, BorderSizePixel = 0, ZIndex = 1001,
    })
    local loaderPanel = New("Frame", {
        Parent = Intro, AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.07, 0.5), Size = UDim2.fromOffset(390, 286),
        BackgroundColor3 = T.SectionBG, BackgroundTransparency = 0.92,
        BorderSizePixel = 0, ZIndex = 1002,
    })
    Corner(loaderPanel, 22)
    local loaderPanelStroke = Stroke(loaderPanel, "Border", 1, 1.1)
    Gradient(loaderPanel, {
        function(t) return Mix(t.SectionBG, t.Accent3, 0.12) end,
        function(t) return Mix(t.SectionBG, t.MainBG, 0.08) end,
        function(t) return Mix(t.SectionBG, t.Accent, 0.08) end,
    }, 12)
    local loaderPanelEdge = New("Frame", {
        Parent = loaderPanel, Position = UDim2.fromOffset(18, 26),
        Size = UDim2.fromOffset(3, 232), BackgroundColor3 = T.Accent,
        BackgroundTransparency = 0.65, BorderSizePixel = 0, ZIndex = 1003,
    })
    Corner(loaderPanelEdge, 999)
    Gradient(loaderPanelEdge, {"Accent3", "Accent", "Accent2"}, 90)

    -- UI reveal masks
    local sidebarRevealMask = New("Frame", {
        Parent = Window, Name = "SidebarRevealMask", Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, SIDEBAR_COMPACT, 1, 0), BackgroundColor3 = T.SidebarBG,
        BorderSizePixel = 0, ZIndex = 900,
    })
    local contentRevealMask = New("Frame", {
        Parent = Window, Name = "ContentRevealMask", AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0), Size = UDim2.new(1, -SIDEBAR_COMPACT, 1, 0),
        BackgroundColor3 = T.MainBG, BorderSizePixel = 0, ZIndex = 900,
    })

    local dragSurface = New("TextButton", {
        Parent = Intro, Name = "DragSurface", Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0, Text = "",
        AutoButtonColor = false, Active = true, ZIndex = 1100,
    })

    -- Loader drag follows UI
    local introDragging, introDragStart, introStartPosition, introDragInput = false, nil, nil, nil
    dragSurface.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            introDragging = true
            introDragStart = input.Position
            introStartPosition = Intro.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then introDragging = false end
            end)
        end
    end)
    dragSurface.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            introDragInput = input
        end
    end)
    local introMoveConnection = UserInputService.InputChanged:Connect(function(input)
        if introDragging and introDragStart and introStartPosition and input == introDragInput then
            local delta = input.Position - introDragStart
            local nextPosition = UDim2.new(
                introStartPosition.X.Scale, introStartPosition.X.Offset + delta.X,
                introStartPosition.Y.Scale, introStartPosition.Y.Offset + delta.Y
            )
            Intro.Position = nextPosition
            Window.Position = nextPosition
        end
    end)

    local logoMark = New("Frame", {
        Parent = Intro, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.28, 0.40), Size = UDim2.fromOffset(230, 104),
        BackgroundTransparency = 1, ZIndex = 1002,
    })
    local logoMarkScale = New("UIScale", {Parent = logoMark, Scale = 0.86})
    local logoK = New("TextLabel", {
        Parent = logoMark, Position = UDim2.fromOffset(12, 0), Size = UDim2.fromOffset(92, 94),
        BackgroundTransparency = 1, Text = "K", Font = Enum.Font.GothamBlack,
        TextSize = 76, TextColor3 = T.TextMain, TextTransparency = 1,
        TextStrokeColor3 = T.Accent, TextStrokeTransparency = 1, Rotation = -2, ZIndex = 1002,
    })
    local logoZ = New("TextLabel", {
        Parent = logoMark, Position = UDim2.fromOffset(126, 0), Size = UDim2.fromOffset(92, 94),
        BackgroundTransparency = 1, Text = "Z", Font = Enum.Font.GothamBlack,
        TextSize = 76, TextColor3 = T.TextMain, TextTransparency = 1,
        TextStrokeColor3 = T.Accent2, TextStrokeTransparency = 1, Rotation = 2, ZIndex = 1002,
    })
    Gradient(logoK, {"TextMain", "Accent"}, 10)
    Gradient(logoZ, {"Accent2", "TextMain"}, 10)
    local logoSlash = New("Frame", {
        Parent = logoMark, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.44), Size = UDim2.fromOffset(4, 72),
        BackgroundColor3 = T.Accent, BackgroundTransparency = 1,
        BorderSizePixel = 0, Rotation = 16, ZIndex = 1003,
    })
    Corner(logoSlash, 999)
    Gradient(logoSlash, {"Accent3", "Accent", "Accent2"}, 90)
    local logoUnderline = New("Frame", {
        Parent = logoMark, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.94), Size = UDim2.fromOffset(0, 2),
        BackgroundColor3 = T.Accent, BackgroundTransparency = 0.08,
        BorderSizePixel = 0, ZIndex = 1002,
    })
    Corner(logoUnderline, 999)
    Gradient(logoUnderline, {"Accent3", "Accent", "Accent2"}, 0)

    local subtitle = New("TextLabel", {
        Parent = Intro, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.28, 0.525), Size = UDim2.fromOffset(280, 24),
        BackgroundTransparency = 1, Text = "S C R I P T S", Font = Enum.Font.GothamMedium,
        TextSize = 11, TextColor3 = T.TextSub, TextTransparency = 1, ZIndex = 1002,
    })

    local loaderEyebrow = New("TextLabel", {
        Parent = Intro, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.28, 0.245), Size = UDim2.fromOffset(300, 18),
        BackgroundTransparency = 1, Text = "UNIVERSAL UI  /  THEMED SHELL",
        Font = Enum.Font.GothamMedium, TextSize = 8, TextColor3 = T.Accent3,
        TextTransparency = 1, ZIndex = 1003,
    })

    local statusLabel = New("TextLabel", {
        Parent = Intro, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.28, 0.585), Size = UDim2.fromOffset(260, 18),
        BackgroundTransparency = 1, Text = "INITIALIZING", Font = Enum.Font.GothamMedium,
        TextSize = 9, TextColor3 = T.Accent, TextTransparency = 1, ZIndex = 1002,
    })

    local loadingLabel = New("TextLabel", {
        Parent = Intro, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.28, 0.645), Size = UDim2.fromOffset(220, 20),
        BackgroundTransparency = 1, Text = "LOADING  0%", Font = Enum.Font.GothamSemibold,
        TextSize = 11, TextColor3 = T.TextSub, TextTransparency = 1, ZIndex = 1002,
    })

    local progressTrack = New("Frame", {
        Parent = Intro, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.28, 0.695), Size = UDim2.fromOffset(230, 5),
        BackgroundColor3 = T.ElementBG, BackgroundTransparency = 0.25,
        BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 1002,
    })
    Corner(progressTrack, 999)
    local progressFill = New("Frame", {
        Parent = progressTrack, Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = T.Accent, BorderSizePixel = 0, ZIndex = 1003,
    })
    Corner(progressFill, 999)
    Gradient(progressFill, {"Accent3", "Accent", "Accent2"}, 0)
    local progressGlow = New("Frame", {
        Parent = progressFill, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(46, 5),
        BackgroundColor3 = T.TextMain, BorderSizePixel = 0, ZIndex = 1004,
    })
    New("UIGradient", {
        Parent = progressGlow,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.68, 0.58),
            NumberSequenceKeypoint.new(1, 0.04),
        }),
    })

    local loadingProgress = New("NumberValue", {Parent = Intro, Value = 0})
    loadingProgress.Changed:Connect(function(value)
        if loadingLabel and loadingLabel.Parent then
            loadingLabel.Text = string.format("LOADING  %d%%", math.clamp(math.floor(value + 0.5), 0, 100))
        end
    end)

    task.spawn(function()
        Tween(Intro, 0.72, {GroupTransparency = 0}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Tween(introScale, 1.05, {Scale = targetScale}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(introArtwork, 0.9, {ImageTransparency = 0.04}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Tween(introArtworkScale, 6.5, {Scale = 1.075}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(loaderPanel, 0.72, {BackgroundTransparency = 0.2}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(loaderPanelStroke, 0.72, {Transparency = 0.2}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Tween(loaderPanelEdge, 0.72, {BackgroundTransparency = 0.12}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Tween(introStroke, 0.9, {Transparency = 0.16}, Enum.EasingStyle.Sine)
        task.wait(0.35)
        Tween(loaderEyebrow, 0.42, {TextTransparency = 0.08}, Enum.EasingStyle.Sine)
        Tween(logoK, 0.62, {TextTransparency = 0, TextStrokeTransparency = 0.82}, Enum.EasingStyle.Sine)
        Tween(logoZ, 0.72, {TextTransparency = 0, TextStrokeTransparency = 0.82}, Enum.EasingStyle.Sine)
        Tween(logoSlash, 0.58, {BackgroundTransparency = 0.04}, Enum.EasingStyle.Sine)
        Tween(logoMarkScale, 0.82, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(logoUnderline, 0.8, {Size = UDim2.fromOffset(124, 2)}, Enum.EasingStyle.Quint)
        task.wait(0.22)
        Tween(subtitle, 0.55, {TextTransparency = 0.12}, Enum.EasingStyle.Sine)
        Tween(statusLabel, 0.45, {TextTransparency = 0.16}, Enum.EasingStyle.Sine)
        Tween(loadingLabel, 0.55, {TextTransparency = 0.08}, Enum.EasingStyle.Sine)
        Tween(progressFill, 2.5, {Size = UDim2.fromScale(1, 1)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(loadingProgress, 2.5, {Value = 100}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.delay(0.7, function()
            if statusLabel and statusLabel.Parent then statusLabel.Text = "LOADING INTERFACE" end
        end)
        task.delay(1.55, function()
            if statusLabel and statusLabel.Parent then statusLabel.Text = "FINALIZING" end
        end)
        task.wait(2.65)

        loadingLabel.Text = "READY"
        loadingLabel.TextColor3 = T.Accent
        statusLabel.Text = "ALL SYSTEMS READY"
        Tween(logoMark, 0.58, {
            Position = UDim2.fromScale(0.28, 0.39),
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(logoMarkScale, 0.58, {Scale = 0.91}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(progressGlow, 0.32, {BackgroundTransparency = 1}, Enum.EasingStyle.Sine)
        task.wait(0.58)

        Window.Position = Intro.Position
        Window.Visible = true
        Window.Active = true
        Scale.Scale = targetScale * 0.985
        Tween(Window, 0.34, {GroupTransparency = 0}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Tween(Scale, 0.9, {Scale = targetScale}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        task.wait(0.1)
        Tween(sidebarRevealMask, 0.58, {
            Position = UDim2.fromOffset(-SIDEBAR_COMPACT - 8, 0), BackgroundTransparency = 1,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        task.wait(0.12)
        Tween(contentRevealMask, 0.68, {
            Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(logoMark, 0.52, {
            Position = UDim2.fromScale(0.28, 0.35),
        }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(logoMarkScale, 0.52, {Scale = 0.8}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(logoK, 0.44, {TextTransparency = 1, TextStrokeTransparency = 1}, Enum.EasingStyle.Sine)
        Tween(logoZ, 0.44, {TextTransparency = 1, TextStrokeTransparency = 1}, Enum.EasingStyle.Sine)
        Tween(logoSlash, 0.38, {BackgroundTransparency = 1}, Enum.EasingStyle.Sine)
        Tween(logoUnderline, 0.38, {BackgroundTransparency = 1, Size = UDim2.fromOffset(36, 2)}, Enum.EasingStyle.Sine)
        Tween(loaderEyebrow, 0.38, {TextTransparency = 1}, Enum.EasingStyle.Sine)
        Tween(subtitle, 0.42, {TextTransparency = 1}, Enum.EasingStyle.Sine)
        Tween(statusLabel, 0.38, {TextTransparency = 1}, Enum.EasingStyle.Sine)
        Tween(loadingLabel, 0.38, {TextTransparency = 1}, Enum.EasingStyle.Sine)
        Tween(Intro, 0.82, {GroupTransparency = 1}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        Tween(introScale, 0.82, {Scale = targetScale * 1.018}, Enum.EasingStyle.Quint)
        task.wait(0.85)
        if introMoveConnection then introMoveConnection:Disconnect() end
        if sidebarRevealMask and sidebarRevealMask.Parent then sidebarRevealMask:Destroy() end
        if contentRevealMask and contentRevealMask.Parent then contentRevealMask:Destroy() end
        if Intro and Intro.Parent then Intro:Destroy() end
    end)
end

__KZ_PlayLoadAnimation()

-- Legacy support
local KZAdapter = {}
KZAdapter.Version = "Universal Football Fusion UI"
KZAdapter.Theme = {Hightlight = T.Accent, Accent = T.Accent}
BindTheme(function() KZAdapter.Theme.Hightlight = T.Accent; KZAdapter.Theme.Accent = T.Accent end)
function KZAdapter:Track(connection) table.insert(connections, connection); return connection end
function KZAdapter:RandomString() return tostring(math.random(100000,999999)) end
function KZAdapter:CreateNotifier()
    local function call(a,b,c,d)
        if type(a) == "table" then return Toast(b,c,d) end
        return Toast(a,b,c)
    end
    return {new = call, Notify = call}
end
function KZAdapter:Unload() return __KZ_Window:Unload() end
function KZAdapter.new(config)
    config = config or {}
    pcall(function()
        if config.SubTitle and BrandSub and BrandSub.Parent then BrandSub.Text = string.upper(tostring(config.SubTitle)) end
        if config.SubTitle and ProfileStatus and ProfileStatus.Parent then ProfileStatus.Text = "●  " .. string.upper(tostring(config.SubTitle)) end
    end)
    return __KZ_Window
end
KZAdapter.ProtectGui = function(first, second)
    local gui = second or first
    pcall(function() if protect_gui then protect_gui(gui) elseif protectgui then protectgui(gui) elseif syn and syn.protect_gui then syn.protect_gui(gui) end end)
end

local LyraZen = {}
LyraZen.Version = "Universal Football Fusion UI"
LyraZen.Theme = T
function LyraZen:Track(connection) return KZAdapter:Track(connection) end
function LyraZen:RandomString() return KZAdapter:RandomString() end
function LyraZen:CreateNotifier() return KZAdapter:CreateNotifier() end
function LyraZen:Unload() return KZAdapter:Unload() end
function LyraZen.new(config) return KZAdapter.new(config) end
LyraZen.ProtectGui = KZAdapter.ProtectGui

local __KZ_UI_API = {
    Version = "FootballFusionShell-Universal-1.0",
    Window = __KZ_Window, WindowGui = Window, Screen = Screen,
    Theme = T, Themes = Themes, ThemeName = function() return themeName end,
    Icons = ICONS, pages = pages, navEntries = navEntries, AccentSyncPickers = AccentSyncPickers,
    JumpToSearchable = __KZ_QOL.JumpToSearchable, UpdateActiveUI = __KZ_QOL.UpdateActiveUI, DisableAllFeatures = __KZ_QOL.DisableAllFeatures,
    ConfigManager = ConfigManager, KZAdapter = KZAdapter, LyraZen = LyraZen,
    New = New, Corner = Corner, Stroke = Stroke, Tween = Tween, Gradient = Gradient,
    BindTheme = BindTheme, Mix = Mix, themeBindings = themeBindings, connections = connections,
    Scale = Scale, Sidebar = Sidebar, NavScroll = NavScroll, Topbar = Topbar, PageHost = PageHost,
    PageTitle = PageTitle, Breadcrumb = Breadcrumb, SearchInput = SearchInput, SearchBox = SearchBox,
    SearchIcon = SearchIcon, SearchResults = SearchResults, DropdownLayer = DropdownLayer,
    Watermark = Watermark, watermarkLabel = watermarkLabel, Dim = Dim, OpenButton = OpenButton,
    CloseButton = CloseButton, MinimizeButton = MinimizeButton, BrandLogoShell = BrandLogoShell,
    Logo = BrandLogo, BrandTitle = BrandTitle, BrandSub = BrandSub, Profile = Profile,
    Avatar = Avatar, ProfileName = ProfileName, ProfileStatus = ProfileStatus, SideFooter = SideFooter,
    windowStroke = windowStroke, sideLine = sideLine, topLine = topLine,
    searchResultsStroke = searchResultsStroke, watermarkStroke = watermarkStroke,
    SIDEBAR_COMPACT = SIDEBAR_COMPACT, SIDEBAR_OPEN = SIDEBAR_OPEN,
    uiScaleFactor = uiScaleFactor, sidebarExpanded = sidebarExpanded, currentPage = currentPage,
    activeDropdown = activeDropdown, activeColorPopup = activeColorPopup,
    CreatePage = CreatePage, Section = Section, Toggle = Toggle, Slider = Slider,
    RangeSlider = RangeSlider, Dropdown = Dropdown, Button = Button, Textbox = Textbox,
    Keybind = Keybind, Colorpicker = Colorpicker, Divider = Divider, Toast = Toast,
    notify = notify, ApplyContentLayout = ApplyContentLayout, SetSidebar = SetSidebar,
    SelectPage = __KZ_SelectPage, SetOpen = __KZ_SetOpen, GetTargetScale = GetTargetScale,
    OnUnload = function(callback) if type(callback) == "function" then table.insert(__KZ_UnloadHooks, callback) end; return callback end,
    SetTheme = function(name) local control = ConfigManager.Flags["UI Theme"]; if control and control.Set then control.Set(name, true) end end,
    GetCursor = function() return currentCursor end,
    IsDestroyed = function() return destroyed end,
}
__KZ_UI_API.CreateWindow = function(_) return __KZ_Window end
return __KZ_UI_API
end
