-- KZ Loader | Anime Edition
-- UI-only loader shell. Keep your real/obfuscated payload in a separate repository.
-- Configure before running:
-- getgenv().KZ_LOADER_CONFIG = {
--     MainURL = "https://raw.githubusercontent.com/your-account/your-private-loader/main/main.lua",
--     BackgroundImage = "rbxassetid://YOUR_ANIME_BACKGROUND_ID",
--     Title = "KZ SCRIPTS",
-- }

local Env = (type(getgenv) == "function" and getgenv()) or _G
local Config = Env.KZ_LOADER_CONFIG or {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

local function safeCall(fn, ...)
    local ok, result = pcall(fn, ...)
    return ok, result
end

local function getGuiParent()
    if type(gethui) == "function" then
        local ok, result = safeCall(gethui)
        if ok and result then return result end
    end
    return CoreGui
end

local function tween(object, time, style, direction, properties)
    local info = TweenInfo.new(time, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local animation = TweenService:Create(object, info, properties)
    animation:Play()
    return animation
end

local function new(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do
        object[key] = value
    end
    if parent then object.Parent = parent end
    return object
end

local old = getGuiParent():FindFirstChild("KZ_AnimeLoader")
if old then old:Destroy() end

local gui = new("ScreenGui", {
    Name = "KZ_AnimeLoader",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, getGuiParent())

pcall(function()
    if type(syn) == "table" and type(syn.protect_gui) == "function" then
        syn.protect_gui(gui)
    elseif type(protectgui) == "function" then
        protectgui(gui)
    end
end)

local root = new("Frame", {
    Name = "Root",
    BackgroundColor3 = Color3.fromRGB(7, 8, 15),
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1),
}, gui)

local bg = new("Frame", {
    Name = "AnimeBackdrop",
    BackgroundColor3 = Color3.fromRGB(9, 11, 23),
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1),
    ClipsDescendants = true,
}, root)

local bgGradient = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 14, 42)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(9, 17, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 10, 41)),
    }),
    Rotation = 25,
}, bg)

local imageId = tostring(Config.BackgroundImage or "")
if imageId ~= "" and not imageId:find("YOUR_ANIME", 1, true) then
    new("ImageLabel", {
        Name = "AnimeImage",
        BackgroundTransparency = 1,
        Image = imageId,
        ImageColor3 = Color3.fromRGB(190, 180, 255),
        ImageTransparency = 0.38,
        ScaleType = Enum.ScaleType.Crop,
        Size = UDim2.fromScale(1.08, 1.08),
        Position = UDim2.fromScale(-0.04, -0.04),
        ZIndex = 1,
    }, bg)
end

local vignette = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(3, 4, 9),
    BackgroundTransparency = 0.26,
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 2,
}, bg)
new("UIGradient", {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.08),
        NumberSequenceKeypoint.new(0.5, 0.62),
        NumberSequenceKeypoint.new(1, 0.08),
    }),
    Rotation = 90,
}, vignette)

local function addGlow(position, size, color, transparency)
    local glow = new("Frame", {
        BackgroundColor3 = color,
        BackgroundTransparency = transparency or 0.82,
        BorderSizePixel = 0,
        Position = position,
        Size = size,
        ZIndex = 2,
    }, bg)
    new("UICorner", {CornerRadius = UDim.new(1, 0)}, glow)
    return glow
end

local glowA = addGlow(UDim2.fromScale(-0.12, 0.1), UDim2.fromScale(0.38, 0.64), Color3.fromRGB(137, 77, 255), 0.82)
local glowB = addGlow(UDim2.fromScale(0.74, 0.46), UDim2.fromScale(0.34, 0.52), Color3.fromRGB(255, 74, 190), 0.84)

local particles = new("Frame", {
    Name = "Petals",
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 3,
}, bg)

local rng = Random.new()
local particleData = {}
for index = 1, 22 do
    local petal = new("Frame", {
        BackgroundColor3 = (index % 2 == 0) and Color3.fromRGB(255, 151, 218) or Color3.fromRGB(190, 157, 255),
        BackgroundTransparency = rng:NextNumber(0.18, 0.62),
        BorderSizePixel = 0,
        Position = UDim2.fromScale(rng:NextNumber(-0.05, 1.02), rng:NextNumber(-0.2, 1)),
        Rotation = rng:NextNumber(-45, 45),
        Size = UDim2.fromOffset(rng:NextInteger(3, 8), rng:NextInteger(2, 5)),
        ZIndex = 3,
    }, particles)
    new("UICorner", {CornerRadius = UDim.new(1, 0)}, petal)
    particleData[#particleData + 1] = {
        object = petal,
        speed = rng:NextNumber(0.035, 0.09),
        sway = rng:NextNumber(0.5, 1.5),
        phase = rng:NextNumber(0, math.pi * 2),
    }
end

local card = new("Frame", {
    Name = "LoaderCard",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(16, 16, 28),
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    Position = UDim2.fromScale(0.5, 0.54),
    Size = UDim2.fromOffset(470, 292),
    ZIndex = 5,
}, root)
new("UICorner", {CornerRadius = UDim.new(0, 18)}, card)
new("UIStroke", {
    Color = Color3.fromRGB(148, 100, 255),
    Transparency = 0.42,
    Thickness = 1,
}, card)
new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 25, 53)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 17, 29)),
    }),
    Rotation = 135,
}, card)

local accent = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(186, 103, 255),
    BorderSizePixel = 0,
    Position = UDim2.fromScale(0, 0),
    Size = UDim2.new(1, 0, 0, 3),
    ZIndex = 7,
}, card)
new("UICorner", {CornerRadius = UDim.new(0, 18)}, accent)

local logo = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBlack,
    Text = "K/Z",
    TextColor3 = Color3.fromRGB(238, 220, 255),
    TextSize = 44,
    Position = UDim2.fromOffset(30, 25),
    Size = UDim2.fromOffset(104, 54),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
}, card)
new("UIGradient", {
    Color = ColorSequence.new(Color3.fromRGB(255, 155, 232), Color3.fromRGB(149, 112, 255)),
    Rotation = 18,
}, logo)

local title = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = tostring(Config.Title or "KZ SCRIPTS"),
    TextColor3 = Color3.fromRGB(247, 245, 255),
    TextSize = 23,
    Position = UDim2.fromOffset(31, 94),
    Size = UDim2.new(1, -62, 0, 30),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
}, card)

local subtitle = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Preparing your experience",
    TextColor3 = Color3.fromRGB(171, 165, 198),
    TextSize = 13,
    Position = UDim2.fromOffset(33, 127),
    Size = UDim2.new(1, -66, 0, 22),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
}, card)

local percent = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "0%",
    TextColor3 = Color3.fromRGB(247, 222, 255),
    TextSize = 15,
    Position = UDim2.new(1, -92, 0, 96),
    Size = UDim2.fromOffset(60, 26),
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 7,
}, card)

local barBack = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(38, 35, 56),
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(32, 171),
    Size = UDim2.new(1, -64, 0, 8),
    ZIndex = 7,
}, card)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, barBack)

local bar = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(191, 100, 255),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 0, 1, 0),
    ZIndex = 8,
}, barBack)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, bar)

local status = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Starting...",
    TextColor3 = Color3.fromRGB(176, 170, 202),
    TextSize = 12,
    Position = UDim2.fromOffset(33, 192),
    Size = UDim2.new(1, -66, 0, 22),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
}, card)

local dots = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "•  •  •",
    TextColor3 = Color3.fromRGB(225, 160, 255),
    TextSize = 15,
    Position = UDim2.new(1, -105, 0, 191),
    Size = UDim2.fromOffset(72, 22),
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 7,
}, card)

local foot = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "ANIME EDITION  •  SECURE STARTUP",
    TextColor3 = Color3.fromRGB(111, 105, 137),
    TextSize = 10,
    Position = UDim2.fromOffset(33, 247),
    Size = UDim2.new(1, -66, 0, 18),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
}, card)

local closed = false
local function closeLoader()
    if closed then return end
    closed = true
    tween(card, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.In, {
        Position = UDim2.fromScale(0.5, 0.57),
        Size = UDim2.fromOffset(440, 270),
        BackgroundTransparency = 1,
    })
    tween(vignette, 0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundTransparency = 1})
    task.wait(0.4)
    if gui then gui:Destroy() end
end

local function setProgress(value, message)
    value = math.clamp(value, 0, 100)
    percent.Text = string.format("%d%%", value)
    status.Text = message or status.Text
    tween(bar, 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
        Size = UDim2.fromScale(value / 100, 1),
    })
end

local function runPayload()
    local callback = Config.MainCallback or Config.OnReady
    if type(callback) == "function" then
        local ok, err = pcall(callback)
        if not ok then
            status.Text = "Startup failed: " .. tostring(err):sub(1, 54)
            return false
        end
        return true
    end

    local url = tostring(Config.MainURL or "")
    if url == "" or url:find("your%-account", 1, false) then
        status.Text = "Set MainURL in KZ_LOADER_CONFIG"
        return false
    end

    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or type(body) ~= "string" or #body < 8 then
        status.Text = "Could not download the startup module"
        return false
    end

    local compiled, compileError = loadstring(body)
    if type(compiled) ~= "function" then
        status.Text = "Startup module rejected: " .. tostring(compileError):sub(1, 42)
        return false
    end

    local executed, executeError = pcall(compiled)
    if not executed then
        status.Text = "Startup module error: " .. tostring(executeError):sub(1, 42)
        return false
    end
    return true
end

local animationClock = 0
local connection = RunService.RenderStepped:Connect(function(delta)
    animationClock += delta
    bgGradient.Rotation = 25 + math.sin(animationClock * 0.18) * 8
    glowA.Position = UDim2.fromScale(-0.12 + math.sin(animationClock * 0.22) * 0.035, 0.1 + math.cos(animationClock * 0.16) * 0.03)
    glowB.Position = UDim2.fromScale(0.74 + math.cos(animationClock * 0.2) * 0.03, 0.46 + math.sin(animationClock * 0.17) * 0.03)
    for _, data in ipairs(particleData) do
        local current = data.object.Position
        local x = current.X.Scale + math.sin(animationClock * data.sway + data.phase) * delta * 0.025
        local y = current.Y.Scale + delta * data.speed
        if y > 1.08 then y = -0.08 end
        data.object.Position = UDim2.fromScale(x, y)
        data.object.Rotation += delta * 18
    end
end)

task.spawn(function()
    tween(card, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
        Position = UDim2.fromScale(0.5, 0.5),
    })
    local stages = {
        {8, "Connecting to startup service..."},
        {24, "Checking interface assets..."},
        {45, "Building anime environment..."},
        {67, "Preparing your modules..."},
        {84, "Almost ready..."},
    }
    for _, stage in ipairs(stages) do
        if closed then return end
        setProgress(stage[1], stage[2])
        task.wait(0.34)
    end

    local success = runPayload()
    if success then
        setProgress(100, "Ready — launching now")
        task.wait(0.42)
        if connection then connection:Disconnect() end
        closeLoader()
    else
        setProgress(100, "Startup paused — check your configuration")
        tween(accent, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(255, 121, 153),
        })
    end
end)
