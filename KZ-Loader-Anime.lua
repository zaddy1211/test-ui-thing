-- KZ Scripts Loader v2.1
-- Key / Cloudflare authentication temporarily removed.
-- Restore a server-side authentication gate before distributing publicly.

-- KZ Scripts Loader v2.1
-- Redesigned UI + Basketball Legends + Dungeon Heroes added + logo fix setup
-- Window height now auto-sizes to the Games list (add a game, nothing else to edit)

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════
-- Theme
-- ═══════════════════════════════════════════════════════════════════
local T = {
	MainBG = Color3.fromRGB(13, 13, 17),
	HeaderBG = Color3.fromRGB(22, 22, 30),
	CardBG = Color3.fromRGB(22, 22, 30),
	CardHoverBG = Color3.fromRGB(34, 30, 52),
	ControlBG = Color3.fromRGB(28, 28, 38),
	Accent = Color3.fromRGB(168, 85, 247),
	Accent2 = Color3.fromRGB(192, 132, 252),
	Accent3 = Color3.fromRGB(124, 58, 237),
	TextMain = Color3.fromRGB(243, 244, 246),
	TextSub = Color3.fromRGB(148, 154, 164),
	Border = Color3.fromRGB(40, 40, 55),
}

-- ═══════════════════════════════════════════════════════════════════
-- Logo (self-contained — no asset upload needed)
-- The logo PNG below is embedded as base64. On run, the loader writes
-- it to a file via the executor's writefile() and displays it with
-- getcustomasset() (works on Synapse, Script-Ware, Delta, Fluxus,
-- Solara, Wave, etc.). If the executor can't do that, it falls back
-- to LOGO_IDS below, then to a "KZ" text badge.
-- ═══════════════════════════════════════════════════════════════════
local LOGO_PNG_BASE64 = [==[
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
]==]

local LOGO_IDS = {
	"rbxassetid://108975487405628", -- legacy ID (private asset, will stay blank)
}

local function B64Decode(s)
	local fns = {
		(crypt and crypt.base64decode),
		(crypt and crypt.base64 and crypt.base64.decode),
		(syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode),
		base64_decode,
		base64decode,
	}
	for _, f in ipairs(fns) do
		if type(f) == "function" then
			local ok, out = pcall(f, s)
			if ok and type(out) == "string" and #out > 100 then
				return out
			end
		end
	end
	local ok, out = pcall(function()
		local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
		local cleaned = s:gsub("[^" .. alphabet .. "=]", "")
		local bits = cleaned:gsub(".", function(char)
			if char == "=" then return "" end
			local value = alphabet:find(char, 1, true) - 1
			local binary = ""
			for bit = 6, 1, -1 do
				binary = binary .. (value % 2 ^ bit - value % 2 ^ (bit - 1) > 0 and "1" or "0")
			end
			return binary
		end)
		return bits:gsub("%d%d%d?%d?%d?%d?%d?%d?", function(byte)
			if #byte ~= 8 then return "" end
			local value = 0
			for index = 1, 8 do
				if byte:sub(index, index) == "1" then value = value + 2 ^ (8 - index) end
			end
			return string.char(value)
		end)
	end)
	if ok and type(out) == "string" and #out > 100 then return out end
	return nil
end

local CachedLogoAsset
local function GetLogoAsset()
	if CachedLogoAsset then return CachedLogoAsset end
	local write = writefile
	local getAsset = getcustomasset or getsynasset
	if not (type(write) == "function" and type(getAsset) == "function") then return nil end
	local data = B64Decode(LOGO_PNG_BASE64)
	if not data then return nil end
	local ok, res = pcall(function()
		write("kz-logo.png", data)
		return getAsset("kz-logo.png")
	end)
	if ok and type(res) == "string" and #res > 0 then
		CachedLogoAsset = res
		return CachedLogoAsset
	end
	return nil
end

-- ═══════════════════════════════════════════════════════════════════
-- Scripts
-- ═══════════════════════════════════════════════════════════════════
local BASE = "https://raw.githubusercontent.com/zaddy1211/sum-diddy-tickle/refs/heads/main/"

-- Optional animated-loader artwork from the shared UI repository.
-- The loader never depends on this download: if an executor cannot cache
-- custom assets, the procedural neon/petal background below remains active.
local LOADER_ART_URL = "https://raw.githubusercontent.com/zaddy1211/ui/main/assets/kz-anime-night.png"
local LOADER_ART_FILE = "KZScripts/UI Library/Assets/kz-anime-night.png"

local function GetLoaderArt()

	local getAsset = getcustomasset or getsynasset
	if type(writefile) ~= "function" or type(getAsset) ~= "function" then return nil end

	pcall(function()
		if type(makefolder) == "function" and type(isfolder) == "function" then
			if not isfolder("KZScripts") then makefolder("KZScripts") end
			if not isfolder("KZScripts/UI Library") then makefolder("KZScripts/UI Library") end
			if not isfolder("KZScripts/UI Library/Assets") then makefolder("KZScripts/UI Library/Assets") end
		end
	end)

	local function resolve()
		if type(isfile) ~= "function" or not isfile(LOADER_ART_FILE) then return nil end
		local ok, result = pcall(getAsset, LOADER_ART_FILE)
		return ok and type(result) == "string" and result ~= "" and result or nil
	end

	local cached = resolve()
	if cached then return cached end

	local body
	local request = syn and syn.request or http_request or request
	if type(request) == "function" then
		local ok, response = pcall(request, {Url = LOADER_ART_URL, Method = "GET"})
		if ok and response and tonumber(response.StatusCode) == 200 then body = response.Body end
	elseif game and game.HttpGet then
		local ok, response = pcall(function() return game:HttpGet(LOADER_ART_URL) end)
		if ok then body = response end
	end

	if type(body) == "string" and #body > 1000 then
		pcall(writefile, LOADER_ART_FILE, body)
		return resolve()
	end
	return nil
end

local Games = {
	{
		Name = "Blade Ball",
		GameId = 4777817887,
		PlaceId = 13772394625,
		Description = "Auto parry, trigger bot, visualisers & more",
		Color = Color3.fromRGB(168, 85, 247),
		Icon = "rbxthumb://type=GameIcon&id=4777817887&w=150&h=150",
		Initials = "BB",
		Url = BASE .. "Blade%20Ball",
	},
	{
		Name = "Football Fusion",
		GameId = 9908641400,
		PlaceId = 82866880824588,
		Description = "Football Fusion features & enhancements",
		Color = Color3.fromRGB(85, 168, 247),
		Icon = "rbxthumb://type=GameIcon&id=9908641400&w=150&h=150",
		Initials = "FF",
		Url = BASE .. "ff3",
	},
	{
		Name = "Murder Mystery 2",
		GameId = 66654135,
		PlaceId = 142823291,
		Description = "Murder Mystery 2 features & enhancements",
		Color = Color3.fromRGB(232, 65, 90),
		Icon = "rbxthumb://type=GameIcon&id=142823291&w=150&h=150",
		Initials = "MM2",
		Url = BASE .. "mm2",
	},
	{
		Name = "Basketball Legends",
		GameId = 4931927012,
		PlaceId = 14259168147,
		Description = "Basketball Legends features & enhancements",
		Color = Color3.fromRGB(255, 176, 46),
		Icon = "rbxthumb://type=GameIcon&id=4931927012&w=150&h=150",
		Initials = "BL",
		Url = BASE .. "Basketball%20legends",
	},
	{
		Name = "Dungeon Heroes",
		GameId = 7546582051,
		PlaceId = 94845773826960,
		Description = "Dungeon Heroes features & enhancements",
		Color = Color3.fromRGB(96, 165, 250),
		Icon = "rbxthumb://type=GameIcon&id=7546582051&w=150&h=150",
		Initials = "DH",
		Url = BASE .. "dungeon%20heros",
	},
	{
		Name = "Practical Basketball",
		GameId = 109983668843500,
		PlaceId = 109983668843500,
		Description = "Practical Basketball features & enhancements",
		Color = Color3.fromRGB(99, 208, 157),
		Icon = "rbxthumb://type=GameIcon&id=109983668843500&w=150&h=150",
		Initials = "PBB",
		Url = BASE .. "practical%20bb",
	},
}

-- Put the current experience first and mark it without auto-launching anything.
local RecommendedGame
for index, entry in ipairs(Games) do
	local sameUniverse = tonumber(entry.GameId) == tonumber(game.GameId)
	local samePlace = tonumber(entry.PlaceId) == tonumber(game.PlaceId)
	if sameUniverse or samePlace then
		entry.Recommended = true
		RecommendedGame = entry
		if index > 1 then
			table.remove(Games, index)
			table.insert(Games, 1, entry)
		end
		break
	end
end

-- How many are actually runnable right now (locked ones don't count)
local AvailableCount = 0
for _, g in ipairs(Games) do
	if not g.Locked then AvailableCount = AvailableCount + 1 end
end

-- ═══════════════════════════════════════════════════════════════════
-- Helpers
-- ═══════════════════════════════════════════════════════════════════
local function New(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then obj[k] = v end
	end
	if props and props.Parent then obj.Parent = props.Parent end
	return obj
end

local function Tween(obj, dur, props, style, dir)
	if not obj or not obj.Parent then return end
	local tw = TweenService:Create(obj,
		TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function Stroke(parent, colorKey, transparency, thickness)
	return New("UIStroke", {
		Parent = parent,
		Color = T[colorKey or "Border"],
		Transparency = transparency or 0,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function Gradient(parent, c1, c2, rotation)
	return New("UIGradient", {
		Parent = parent,
		Rotation = rotation or 0,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, c1),
			ColorSequenceKeypoint.new(1, c2),
		}),
	})
end

-- ═══════════════════════════════════════════════════════════════════
-- Screen setup
-- ═══════════════════════════════════════════════════════════════════
local parent
pcall(function() parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not parent then parent = LocalPlayer:WaitForChild("PlayerGui") end

for _, loc in ipairs({parent, LocalPlayer:FindFirstChild("PlayerGui")}) do
	if loc then
		local old = loc:FindFirstChild("KZScriptsLoader")
		if old then old:Destroy() end
	end
end

local Screen = New("ScreenGui", {
	Parent = parent, Name = "KZScriptsLoader", ResetOnSpawn = false,
	IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

-- ═══════════════════════════════════════════════════════════════════
-- Main window  (auto-sizes to the number of scripts in the Games list)
-- ═══════════════════════════════════════════════════════════════════
local HEADER_H = 76
local CARDS_TOP = HEADER_H + 44
local CARD_H, CARD_GAP = MOBILE_LAYOUT and 88 or 82, 10
local FOOTER_H = 50
local initialCamera = workspace.CurrentCamera
local initialViewport = initialCamera and initialCamera.ViewportSize or Vector2.new(1280, 720)
local MOBILE_LAYOUT = UserInputService.TouchEnabled and initialViewport.X < 760
local CARD_COLUMNS = MOBILE_LAYOUT and 1 or 2

local WIN_W = MOBILE_LAYOUT and math.min(420, math.max(300, initialViewport.X - 20)) or 620
local CARD_W = CARD_COLUMNS == 1 and (WIN_W - 32) or math.floor((WIN_W - 42) / CARD_COLUMNS)
local CARD_ROWS = math.ceil(#Games / CARD_COLUMNS)
local CARD_CONTENT_H = CARD_ROWS * (CARD_H + CARD_GAP) - CARD_GAP
local DESIRED_WIN_H = CARDS_TOP + CARD_CONTENT_H + FOOTER_H
local WIN_H = math.min(DESIRED_WIN_H, math.max(340, initialViewport.Y - 24))
local FOOT_TOP = WIN_H - FOOTER_H

local Window = New("CanvasGroup", {
	Parent = Screen, Name = "LoaderWindow",
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(WIN_W, WIN_H),
	BackgroundColor3 = T.MainBG, BorderSizePixel = 0,
	ClipsDescendants = true, GroupTransparency = 1, Active = true,
})
New("UICorner", {Parent = Window, CornerRadius = UDim.new(0, 18)})
Stroke(Window, "Border", 0.18, 1.2)

local function GetWindowScale()
	local camera = workspace.CurrentCamera
	local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
	return math.clamp(math.min((viewport.X - 20) / WIN_W, (viewport.Y - 20) / WIN_H, 1), MOBILE_LAYOUT and 0.78 or 0.62, 1)
end

local baseScale = GetWindowScale()
local winScale = New("UIScale", {Parent = Window, Scale = baseScale * 0.94})

-- Animated background
local WindowBg = New("Frame", {
	Parent = Window, Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = T.MainBG, BorderSizePixel = 0, ZIndex = 0,
})
local bgGradient = New("UIGradient", {
	Parent = WindowBg, Rotation = 20, Offset = Vector2.new(-0.18, -0.06),
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, T.Accent3:Lerp(T.MainBG, 0.82)),
		ColorSequenceKeypoint.new(0.5, T.MainBG),
		ColorSequenceKeypoint.new(1, T.Accent2:Lerp(T.MainBG, 0.84)),
	}),
})

local AnimeBackdrop = New("ImageLabel", {
	Parent = WindowBg, Name = "AnimeBackdrop", Size = UDim2.fromScale(1.08, 1.08),
	Position = UDim2.fromScale(-0.04, -0.04), BackgroundTransparency = 1,
	Image = "", ImageTransparency = 0.52, ImageColor3 = T.TextMain,
	ScaleType = Enum.ScaleType.Crop, ZIndex = 0,
})

task.spawn(function()
	local art = GetLoaderArt()
	if art and AnimeBackdrop.Parent then
		AnimeBackdrop.Image = art
		Tween(AnimeBackdrop, 0.7, {ImageTransparency = 0.28})
		AnimeBackdrop:SetAttribute("KZArtReady", true)
	end
end)

local AmbientLayer = New("Frame", {
	Parent = Window, Name = "AmbientLayer", Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 1,
})

local ambientTweens = {}
local ambientPaused = false
local function AnimateAmbient(object, duration, first, second)
	task.spawn(function()
		local forward = true
		while Screen.Parent and object.Parent do
			local motion = Tween(object, duration, forward and second or first, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			if not motion then break end
			ambientTweens[object] = motion
			if ambientPaused then motion:Pause() end
			motion.Completed:Wait()
			forward = not forward
		end
		ambientTweens[object] = nil
	end)
end

task.spawn(function()
	while Screen.Parent and not AnimeBackdrop:GetAttribute("KZArtReady") do task.wait(0.1) end
	if Screen.Parent and AnimeBackdrop.Image ~= "" then
		AnimateAmbient(AnimeBackdrop, MOBILE_LAYOUT and 24 or 18,
			{Position = UDim2.fromScale(-0.04, -0.04)},
			{Position = UDim2.fromScale(-0.08, -0.06)})
	end
end)

AnimateAmbient(bgGradient, 14, {Offset = Vector2.new(-0.18, -0.06)}, {Offset = Vector2.new(0.18, 0.06)})

for row = 0, 3 do
	for column = 0, 5 do
		local dot = New("Frame", {
			Parent = AmbientLayer, AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.08 + column * 0.18, 0.1 + row * 0.27),
			Size = UDim2.fromOffset(2, 2), BackgroundColor3 = T.Border,
			BackgroundTransparency = 0.88, BorderSizePixel = 0, ZIndex = 1,
		})
		New("UICorner", {Parent = dot, CornerRadius = UDim.new(1, 0)})
	end
end

local shapeData = {
	{"Diamond", 0.08, 0.2, 0.15, 0.14, 16, T.Accent, 15, 45},
	{"Ring", 0.82, 0.17, 0.74, 0.25, 20, T.Accent3, 17, 0},
	{"Slash", 0.18, 0.84, 0.31, 0.76, 34, T.Accent, 18, -18},
}

for _, data in ipairs(shapeData) do
	local isSlash = data[1] == "Slash"
	local shape = New("Frame", {
		Parent = AmbientLayer, AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(data[2], data[3]),
		Size = isSlash and UDim2.fromOffset(data[6], 2) or UDim2.fromOffset(data[6], data[6]),
		BackgroundColor3 = data[7], BackgroundTransparency = isSlash and 0.84 or 1,
		BorderSizePixel = 0, Rotation = data[9], ZIndex = 1,
	})
	if isSlash then
		New("UIGradient", {
			Parent = shape,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0.05),
				NumberSequenceKeypoint.new(1, 1),
			}),
		})
	else
		New("UICorner", {Parent = shape, CornerRadius = UDim.new(0, data[1] == "Ring" and 99 or 4)})
		New("UIStroke", {Parent = shape, Color = data[7], Transparency = 0.66, Thickness = 1.1})
	end
	AnimateAmbient(shape, data[8], {Position = UDim2.fromScale(data[2], data[3]), Rotation = data[9]}, {
		Position = UDim2.fromScale(data[4], data[5]), Rotation = data[9] + (isSlash and 7 or 24),
	})
end

local particleData = {
	{0.2, 0.68, 0.28, 0.59, 12}, {0.37, 0.25, 0.44, 0.34, 15},
	{0.76, 0.38, 0.83, 0.29, 14},
}
local particleColors = {T.Accent, T.Accent2, T.Accent3}
for index, data in ipairs(particleData) do
	local particle = New("Frame", {
		Parent = AmbientLayer, AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(data[1], data[2]), Size = UDim2.fromOffset(index % 2 == 0 and 3 or 4, index % 2 == 0 and 3 or 4),
		BackgroundColor3 = particleColors[((index - 1) % 3) + 1], BackgroundTransparency = 0.66,
		BorderSizePixel = 0, ZIndex = 1,
	})
	New("UICorner", {Parent = particle, CornerRadius = UDim.new(1, 0)})
	AnimateAmbient(particle, data[5], {Position = UDim2.fromScale(data[1], data[2])}, {Position = UDim2.fromScale(data[3], data[4])})
end

-- ═══════════════════════════════════════════════════════════════════
-- Header (draggable)
-- ═══════════════════════════════════════════════════════════════════
local Header = New("Frame", {
	Parent = Window, Size = UDim2.new(1, 0, 0, HEADER_H),
	BackgroundColor3 = T.HeaderBG, BackgroundTransparency = 0.28,
	BorderSizePixel = 0, ZIndex = 10, Active = true,
})

-- Original image logo
local LogoShell = New("Frame", {
	Parent = Header, Position = UDim2.fromOffset(16, 11), Size = UDim2.fromOffset(54, 54),
	BackgroundColor3 = Color3.fromRGB(5, 5, 9), BackgroundTransparency = 0,
	BorderSizePixel = 0, ZIndex = 11,
})
New("UICorner", {Parent = LogoShell, CornerRadius = UDim.new(1, 0)})
Stroke(LogoShell, "Border", 0.18, 1)

local LogoFallback = New("TextLabel", {
	Parent = LogoShell, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
	Text = "KZ", Font = Enum.Font.GothamBlack, TextSize = 17,
	TextColor3 = T.Accent2, ZIndex = 12,
})

local LogoImage = New("ImageLabel", {
	Parent = LogoShell, Position = UDim2.fromOffset(2, 2), Size = UDim2.new(1, -4, 1, -4),
	BackgroundTransparency = 1, Image = LOGO_IDS[1], ScaleType = Enum.ScaleType.Fit, ZIndex = 13,
})
New("UICorner", {Parent = LogoImage, CornerRadius = UDim.new(1, 0)})

task.spawn(function()
	local candidates = {}
	local fileAsset = GetLogoAsset()
	if fileAsset then table.insert(candidates, fileAsset) end
	for _, id in ipairs(LOGO_IDS) do table.insert(candidates, id) end
	for _, id in ipairs(candidates) do
		LogoImage.Image = id
		local started = os.clock()
		repeat task.wait(0.1) until LogoImage.IsLoaded or os.clock() - started > 4
		if LogoImage.IsLoaded then
			LogoFallback.Visible = false
			return
		end
	end
	LogoImage.Image = ""
end)

local Title = New("TextLabel", {
	Parent = Header, Position = UDim2.fromOffset(84, 17),
	Size = UDim2.new(1, -210, 0, 22),
	BackgroundTransparency = 1, Text = "KZ SCRIPTS",
	Font = Enum.Font.GothamBold, TextSize = 17,
	TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 11,
})

local Subtitle = New("TextLabel", {
	Parent = Header, Position = UDim2.fromOffset(84, 40),
	Size = UDim2.new(1, -210, 0, 15),
	BackgroundTransparency = 1,
	Text = RecommendedGame and ("DETECTED  •  " .. string.upper(RecommendedGame.Name)) or ("SCRIPT LIBRARY  •  " .. AvailableCount .. " AVAILABLE"),
	Font = Enum.Font.GothamMedium, TextSize = 10,
	TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 11,
})

-- Minimize / Close buttons
local MinBtn = New("ImageButton", {
	Parent = Header, AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -54, 0, 23), Size = UDim2.fromOffset(28, 28),
	BackgroundColor3 = T.ControlBG, BackgroundTransparency = 0.2,
	Image = "rbxassetid://6031091004", ImageColor3 = T.TextSub,
	AutoButtonColor = false, ZIndex = 12,
})
New("UICorner", {Parent = MinBtn, CornerRadius = UDim.new(0, 8)})

local CloseBtn = New("ImageButton", {
	Parent = Header, AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -18, 0, 23), Size = UDim2.fromOffset(28, 28),
	BackgroundColor3 = T.ControlBG, BackgroundTransparency = 0.2,
	Image = "rbxassetid://6031094678", ImageColor3 = T.TextSub,
	AutoButtonColor = false, ZIndex = 12,
})
New("UICorner", {Parent = CloseBtn, CornerRadius = UDim.new(0, 8)})

local function styleHeaderBtn(btn, hoverColor, hoverText, normalColor)
	btn.MouseEnter:Connect(function()
		Tween(btn, 0.15, {BackgroundColor3 = hoverColor, BackgroundTransparency = 0, ImageColor3 = hoverText})
	end)
	btn.MouseLeave:Connect(function()
		Tween(btn, 0.15, {BackgroundColor3 = normalColor, BackgroundTransparency = 0.2, ImageColor3 = T.TextSub})
	end)
end
styleHeaderBtn(MinBtn, T.Accent3, T.TextMain, T.ControlBG)
styleHeaderBtn(CloseBtn, Color3.fromRGB(220, 50, 50), T.TextMain, T.ControlBG)

-- Hairline divider under header
local Divider = New("Frame", {
	Parent = Window, Position = UDim2.new(0, 0, 0, HEADER_H),
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = T.Border, BackgroundTransparency = 0.45,
	BorderSizePixel = 0, ZIndex = 11,
})

-- ═══════════════════════════════════════════════════════════════════
-- Section label
-- ═══════════════════════════════════════════════════════════════════
New("TextLabel", {
	Parent = Window, Position = UDim2.fromOffset(16, HEADER_H + 12),
	Size = UDim2.new(1, -120, 0, 18),
	BackgroundTransparency = 1, Text = "SELECT A SCRIPT",
	Font = Enum.Font.GothamBold, TextSize = 11,
	TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 8,
})

local CountBadge = New("Frame", {
	Parent = Window, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, HEADER_H + 9),
	Size = UDim2.fromOffset(92, 24), BackgroundColor3 = T.Accent3,
	BackgroundTransparency = 0.78, BorderSizePixel = 0, ZIndex = 8,
})
New("UICorner", {Parent = CountBadge, CornerRadius = UDim.new(1, 0)})
Stroke(CountBadge, "Accent", 0.62, 1)
New("TextLabel", {
	Parent = CountBadge, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
	Text = AvailableCount .. " AVAILABLE", Font = Enum.Font.GothamBold, TextSize = 9,
	TextColor3 = T.Accent2, ZIndex = 9,
})

local CardsScroll = New("ScrollingFrame", {
	Parent = Window, Position = UDim2.fromOffset(16, CARDS_TOP),
	Size = UDim2.new(1, -32, 0, math.max(80, FOOT_TOP - CARDS_TOP - 8)),
	BackgroundTransparency = 1, BorderSizePixel = 0,
	CanvasSize = UDim2.fromOffset(0, CARD_CONTENT_H + 16), AutomaticCanvasSize = Enum.AutomaticSize.None,
	ScrollBarThickness = MOBILE_LAYOUT and 3 or 2, ScrollBarImageColor3 = T.Accent,
	ScrollBarImageTransparency = 0.32, ScrollingDirection = Enum.ScrollingDirection.Y,
	Active = true, ZIndex = 5,
})

-- ═══════════════════════════════════════════════════════════════════
-- Game cards
-- ═══════════════════════════════════════════════════════════════════
local loading = false
local ProgressFill, ProgressTip, ProgressPercent, StatusDot
local progressGeneration = 0
local cardRegistry = {}

local function SetStatus(text, color)
	local st = Window:FindFirstChild("StatusText")
	if st then
		st.Text = text
		st.TextColor3 = color or T.TextSub
	end
end

local function SetProgress(value, label, color)
	value = math.clamp(value or 0, 0, 100)
	if ProgressFill then
		Tween(ProgressFill, 0.28, {Size = UDim2.fromScale(value / 100, 1)}, Enum.EasingStyle.Quint)
	end
	if ProgressTip then
		ProgressTip.BackgroundColor3 = color or T.Accent2
		ProgressTip.Visible = value > 0
	end
	if ProgressPercent then
		ProgressPercent.Text = label or (math.floor(value) .. "%")
		ProgressPercent.TextColor3 = color or T.Accent
	end
end

local function SetStage(text, value, color)
	SetStatus(text, color)
	local label = value <= 0 and "ERROR" or (value >= 100 and "READY" or (math.floor(value) .. "%"))
	SetProgress(value, label, color)
	if StatusDot then
		Tween(StatusDot, 0.18, {BackgroundColor3 = color or T.Accent, BackgroundTransparency = 0})
	end
end

local function RestoreCards()
	CardsScroll.ScrollingEnabled = true
	for _, meta in ipairs(cardRegistry) do
		Tween(meta.Card, 0.24, {GroupTransparency = 0, BackgroundColor3 = T.CardBG})
		Tween(meta.Scale, 0.24, {Scale = 1}, Enum.EasingStyle.Back)
		Tween(meta.Stroke, 0.24, {Color = meta.Game.Recommended and meta.Game.Color or T.Border, Transparency = meta.Game.Recommended and 0.18 or 0.4, Thickness = 1})
	end
end

local function FocusSelectedCard(selected)
	CardsScroll.ScrollingEnabled = false
	for _, meta in ipairs(cardRegistry) do
		if meta == selected then
			Tween(meta.Card, 0.24, {GroupTransparency = 0, BackgroundColor3 = T.CardHoverBG})
			Tween(meta.Scale, 0.3, {Scale = 1.025}, Enum.EasingStyle.Back)
			Tween(meta.Stroke, 0.2, {Color = meta.Game.Color or T.Accent, Transparency = 0.05, Thickness = 1.4})
		else
			Tween(meta.Card, 0.24, {GroupTransparency = 0.62})
			Tween(meta.Scale, 0.24, {Scale = 0.985})
		end
	end
end

local function CloseLoader()
	Tween(Window, 0.22, {GroupTransparency = 1})
	Tween(winScale, 0.22, {Scale = baseScale * 0.94})
	task.delay(0.25, function()
		if Screen and Screen.Parent then Screen:Destroy() end
	end)
end

local function DownloadScript(url)
	local request = (syn and syn.request) or http_request or request
	if type(request) == "function" then
		local response = request({Url = url, Method = "GET"})
		local statusCode = tonumber(response and (response.StatusCode or response.Status))
		if statusCode and statusCode ~= 200 then error("HTTP " .. tostring(statusCode)) end
		local body = response and (response.Body or response.body)
		if type(body) == "string" and #body > 10 then return body end
		error("empty response")
	end
	if game and type(game.HttpGet) == "function" then
		local body = game:HttpGet(url)
		if type(body) == "string" and #body > 10 then return body end
	end
	error("No compatible HTTP function")
end

local function ExecuteScript(g, selected)
	if loading then return end
	loading = true
	progressGeneration = progressGeneration + 1
	FocusSelectedCard(selected)
	SetStage("Connecting to " .. g.Name .. "…", 10, T.Accent)
	task.wait()
	SetStage("Downloading " .. g.Name .. "…", 35, T.Accent2)

	local ok, result = pcall(DownloadScript, g.Url)

	if not (ok and result and type(result) == "string" and #result > 10) then
		loading = false
		progressGeneration = progressGeneration + 1
		SetStage("Download failed — tap the card to retry", 0, Color3.fromRGB(235, 75, 75))
		RestoreCards()
		warn("Failed to load script:", ok and "empty response" or tostring(result))
		return
	end

	SetStage("Validating " .. g.Name .. "…", 65, T.Accent2)
	local compileOk, fn, compileError = pcall(loadstring, result)
	if not compileOk or type(fn) ~= "function" then
		loading = false
		progressGeneration = progressGeneration + 1
		SetStage("Validation failed — tap the card to retry", 0, Color3.fromRGB(235, 75, 75))
		RestoreCards()
		warn("Failed to validate script:", tostring(compileError or fn))
		return
	end

	SetStage("Starting " .. g.Name .. "…", 85, T.Accent2)
	task.spawn(function()
		local oldIdentity = 2
		if getthreadidentity then oldIdentity = getthreadidentity() end
		if setthreadidentity then setthreadidentity(7) end
		if not game:IsLoaded() then game.Loaded:Wait() end
		local runOk, runError = pcall(fn)
		if setthreadidentity then pcall(setthreadidentity, oldIdentity) end

		if not runOk then
			loading = false
			progressGeneration = progressGeneration + 1
			SetStage("Startup failed — tap the card to retry", 0, Color3.fromRGB(235, 75, 75))
			RestoreCards()
			warn("Failed to start script:", tostring(runError))
			return
		end

		SetStage("Ready — opening " .. g.Name, 100, Color3.fromRGB(80, 220, 120))
		for _, meta in ipairs(cardRegistry) do
			if meta ~= selected then Tween(meta.Card, 0.28, {GroupTransparency = 1}) end
		end
		Tween(selected.Scale, 0.32, {Scale = 1.055}, Enum.EasingStyle.Back)
		Tween(selected.Card, 0.32, {GroupTransparency = 0.08})
		task.delay(0.38, CloseLoader)
	end)
end

local function CreateGameCard(g, index)
	local row = math.floor((index - 1) / CARD_COLUMNS)
	local column = (index - 1) % CARD_COLUMNS
	local isLastOdd = index == #Games and #Games % CARD_COLUMNS == 1
	local contentWidth = WIN_W - 32
	local x = isLastOdd and CARD_COLUMNS > 1 and math.floor((contentWidth - CARD_W) / 2) or (column * (CARD_W + CARD_GAP))
	local y = row * (CARD_H + CARD_GAP)

	local card = New("CanvasGroup", {
		Parent = CardsScroll, Position = UDim2.fromOffset(x, y + 8),
		Size = UDim2.fromOffset(CARD_W, CARD_H),
		BackgroundColor3 = T.CardBG, BackgroundTransparency = 0.12,
		BorderSizePixel = 0, ZIndex = 6, GroupTransparency = 1,
	})
	New("UICorner", {Parent = card, CornerRadius = UDim.new(0, 12)})
	local cardScale = New("UIScale", {Parent = card, Name = "CardScale", Scale = 0.96})
	local cardStroke = Stroke(card, "Border", 0.4, 1)
	if g.Recommended then
		cardStroke.Color = g.Color or T.Accent
		cardStroke.Transparency = 0.18
	end
	-- Icon chip
	local chip = New("Frame", {
		Parent = card, Position = UDim2.new(0, 12, 0.5, -25),
		Size = UDim2.fromOffset(50, 50),
		BackgroundColor3 = T.ControlBG, BorderSizePixel = 0, ZIndex = 7,
	})
	New("UICorner", {Parent = chip, CornerRadius = UDim.new(0, 13)})
	local chipStroke = Stroke(chip, "Border", 0.38, 1)
	chipStroke.Color = g.Color or T.Accent

	New("TextLabel", { -- initials fallback under the image
		Parent = chip, Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1, Text = g.Initials,
		Font = Enum.Font.GothamBlack, TextSize = 15,
		TextColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 8,
	})

	local icon = New("ImageLabel", {
		Parent = chip, Position = UDim2.fromOffset(2, 2), Size = UDim2.new(1, -4, 1, -4),
		BackgroundTransparency = 1, Image = g.Icon,
		ScaleType = Enum.ScaleType.Fit, ZIndex = 9,
	})
	New("UICorner", {Parent = icon, CornerRadius = UDim.new(0, 11)})
	local iconScale = New("UIScale", {Parent = icon, Scale = 1})

	if g.Recommended and not g.Locked then
		local currentBadge = New("Frame", {
			Parent = card, AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0, 37, 0.5, 25),
			Size = UDim2.fromOffset(48, 14), BackgroundColor3 = g.Color or T.Accent,
			BorderSizePixel = 0, ZIndex = 10,
		})
		New("UICorner", {Parent = currentBadge, CornerRadius = UDim.new(0, 4)})
		New("TextLabel", {
			Parent = currentBadge, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
			Text = "CURRENT", Font = Enum.Font.GothamBlack, TextSize = 7,
			TextColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 11,
		})
	end

	if not g.Locked then
		local readyBadge = New("Frame", {
			Parent = card, AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -50, 0, 12), Size = UDim2.fromOffset(42, 16),
			BackgroundColor3 = g.Recommended and (g.Color or T.Accent) or T.ControlBG,
			BackgroundTransparency = g.Recommended and 0.72 or 0.18,
			BorderSizePixel = 0, ZIndex = 8,
		})
		New("UICorner", {Parent = readyBadge, CornerRadius = UDim.new(1, 0)})
		New("TextLabel", {
			Parent = readyBadge, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
			Text = "READY", Font = Enum.Font.GothamBold, TextSize = 7,
			TextColor3 = g.Recommended and Color3.fromRGB(255, 255, 255) or T.TextSub, ZIndex = 9,
		})
	end

	-- Name + description
	New("TextLabel", {
		Parent = card, Position = UDim2.fromOffset(76, 17),
		Size = UDim2.new(1, -128, 0, 20),
		BackgroundTransparency = 1, Text = g.Name,
		Font = Enum.Font.GothamBold, TextSize = 14,
		TextColor3 = T.TextMain, TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 7,
	})

	New("TextLabel", {
		Parent = card, Position = UDim2.fromOffset(76, 42),
		Size = UDim2.new(1, -126, 0, 18),
		BackgroundTransparency = 1, Text = g.Description,
		Font = Enum.Font.Gotham, TextSize = 10,
		TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 7,
	})

	-- Consistent image arrow; locked cards use a plain text label instead of an emoji.
	local arrow = New("Frame", {
		Parent = card, AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(30, 30),
		BackgroundColor3 = T.ControlBG, BackgroundTransparency = 0.25,
		BorderSizePixel = 0, ZIndex = 7,
	})
	New("UICorner", {Parent = arrow, CornerRadius = UDim.new(1, 0)})

	local arrowIcon = New("ImageLabel", {
		Parent = arrow, Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1, Image = "rbxassetid://6031090990",
		ImageColor3 = T.TextSub, Rotation = -90, Visible = not g.Locked, ZIndex = 8,
	})
	New("UIPadding", {Parent = arrowIcon, PaddingTop = UDim.new(0, 7), PaddingBottom = UDim.new(0, 7), PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7)})
	if g.Locked then
		New("TextLabel", {
			Parent = arrow, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
			Text = "LOCK", Font = Enum.Font.GothamBold, TextSize = 7,
			TextColor3 = T.TextSub, ZIndex = 8,
		})
	end

	-- Locked treatment: grey it out and stamp a "DOWN" badge over the icon
	if g.Locked then
		card.GroupColor3 = Color3.fromRGB(150, 150, 156) -- dimming wash over the whole card
		cardStroke.Transparency = 0.7

		local badge = New("Frame", {
			Parent = card, AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0, 37, 0.5, 25),
			Size = UDim2.fromOffset(42, 14),
			BackgroundColor3 = Color3.fromRGB(255, 90, 90),
			BorderSizePixel = 0, ZIndex = 10,
		})
		New("UICorner", {Parent = badge, CornerRadius = UDim.new(0, 4)})
		New("TextLabel", {
			Parent = badge, Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1, Text = "DOWN",
			Font = Enum.Font.GothamBlack, TextSize = 8,
			TextColor3 = Color3.fromRGB(255, 255, 255), ZIndex = 11,
		})
	end

	-- Invisible hit target on top of everything
	local hit = New("TextButton", {
		Parent = card, Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		ZIndex = 20,
	})
	local meta = {Card = card, Scale = cardScale, IconScale = iconScale, Stroke = cardStroke, Game = g}
	table.insert(cardRegistry, meta)

	hit.MouseEnter:Connect(function()
		if loading then return end
		if g.Locked then
			-- No accent hover for locked cards, just a subtle lift + reason in the footer
			Tween(card, 0.15, {BackgroundTransparency = 0})
			SetStatus(g.LockedReason or (g.Name .. " is currently unavailable"), Color3.fromRGB(235, 130, 75))
			return
		end
		Tween(card, 0.15, {BackgroundColor3 = T.CardHoverBG, BackgroundTransparency = 0})
		Tween(cardScale, 0.18, {Scale = 1.012}, Enum.EasingStyle.Back)
		Tween(iconScale, 0.18, {Scale = 1.06}, Enum.EasingStyle.Back)
		Tween(cardStroke, 0.15, {Color = g.Color or T.Accent, Transparency = 0.12})
		Tween(arrow, 0.15, {BackgroundColor3 = g.Color or T.Accent, BackgroundTransparency = 0, Position = UDim2.new(1, -10, 0.5, 0)})
		Tween(arrowIcon, 0.15, {ImageColor3 = Color3.fromRGB(15, 15, 20)})
	end)
	hit.MouseLeave:Connect(function()
		if loading then return end
		if g.Locked then
			Tween(card, 0.2, {BackgroundTransparency = 0.12})
			SetStatus("Ready")
			return
		end
		Tween(card, 0.2, {BackgroundColor3 = T.CardBG, BackgroundTransparency = 0.12})
		Tween(cardScale, 0.2, {Scale = 1})
		Tween(iconScale, 0.2, {Scale = 1})
		Tween(cardStroke, 0.2, {Color = g.Recommended and (g.Color or T.Accent) or T.Border, Transparency = g.Recommended and 0.18 or 0.4, Thickness = 1})
		Tween(arrow, 0.2, {BackgroundColor3 = T.ControlBG, BackgroundTransparency = 0.25, Position = UDim2.new(1, -14, 0.5, 0)})
		Tween(arrowIcon, 0.2, {ImageColor3 = T.TextSub})
	end)
	hit.MouseButton1Down:Connect(function()
		if not loading and not g.Locked then
			Tween(card, 0.08, {BackgroundColor3 = (g.Color or T.Accent):Lerp(T.CardBG, 0.7)})
			Tween(cardScale, 0.08, {Scale = 0.985})
		end
	end)
	hit.MouseButton1Up:Connect(function()
		if not loading and not g.Locked then
			Tween(card, 0.12, {BackgroundColor3 = T.CardHoverBG})
			Tween(cardScale, 0.18, {Scale = 1.012}, Enum.EasingStyle.Back)
		end
	end)
	hit.MouseButton1Click:Connect(function()
		if g.Locked then
			-- Refuse the click and shake the card
			SetStatus(g.LockedReason or (g.Name .. " is currently unavailable"), Color3.fromRGB(235, 75, 75))
			local baseX = x
			task.spawn(function()
				for _, dx in ipairs({6, -5, 4, -3, 0}) do
					card.Position = UDim2.new(0, baseX + dx, 0, card.Position.Y.Offset)
					task.wait(0.04)
				end
				card.Position = UDim2.new(0, baseX, 0, card.Position.Y.Offset)
			end)
			return
		end
		ExecuteScript(g, meta)
	end)

	return card
end

local cards = {}
for i, g in ipairs(Games) do
	cards[i] = CreateGameCard(g, i)
end

-- ═══════════════════════════════════════════════════════════════════
-- Footer
-- ═══════════════════════════════════════════════════════════════════
local ProgressTrack = New("Frame", {
	Parent = Window, Position = UDim2.new(0, 16, 0, FOOT_TOP - 7),
	Size = UDim2.new(1, -32, 0, 2), BackgroundColor3 = T.ControlBG,
	BackgroundTransparency = 0.42, BorderSizePixel = 0, ClipsDescendants = false, ZIndex = 9,
})
New("UICorner", {Parent = ProgressTrack, CornerRadius = UDim.new(1, 0)})

ProgressFill = New("Frame", {
	Parent = ProgressTrack, Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = T.Accent, BorderSizePixel = 0, ZIndex = 10,
})
New("UICorner", {Parent = ProgressFill, CornerRadius = UDim.new(1, 0)})
Gradient(ProgressFill, T.Accent3, T.Accent2, 0)

ProgressTip = New("Frame", {
	Parent = ProgressFill, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(1, 0.5),
	Size = UDim2.fromOffset(7, 7), BackgroundColor3 = T.Accent2,
	BackgroundTransparency = 0.08, BorderSizePixel = 0, Visible = false, ZIndex = 11,
})
New("UICorner", {Parent = ProgressTip, CornerRadius = UDim.new(1, 0)})

New("Frame", {
	Parent = Window, Position = UDim2.new(0, 0, 0, FOOT_TOP),
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = T.Border, BackgroundTransparency = 0.45,
	BorderSizePixel = 0, ZIndex = 8,
})

StatusDot = New("Frame", {
	Parent = Window, Position = UDim2.fromOffset(18, FOOT_TOP + 16),
	Size = UDim2.fromOffset(6, 6),
	BackgroundColor3 = Color3.fromRGB(80, 220, 120), BorderSizePixel = 0, ZIndex = 8,
})
New("UICorner", {Parent = StatusDot, CornerRadius = UDim.new(1, 0)})

New("TextLabel", {
	Parent = Window, Name = "StatusText",
	Position = UDim2.fromOffset(32, FOOT_TOP + 11),
	Size = UDim2.new(1, -110, 0, 16),
	BackgroundTransparency = 1, Text = "Ready",
	Font = Enum.Font.GothamMedium, TextSize = 10,
	TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 8,
})

ProgressPercent = New("TextLabel", {
	Parent = Window, AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -16, 0, FOOT_TOP + 11),
	Size = UDim2.fromOffset(60, 16),
	BackgroundTransparency = 1, Text = "v2.1",
	Font = Enum.Font.GothamBold, TextSize = 10,
	TextColor3 = T.Accent, TextXAlignment = Enum.TextXAlignment.Right,
	ZIndex = 8,
})

-- Status dot pulse
task.spawn(function()
	while Screen.Parent do
		Tween(StatusDot, 0.7, {BackgroundTransparency = 0.55})
		task.wait(0.7)
		Tween(StatusDot, 0.7, {BackgroundTransparency = 0})
		task.wait(0.7)
	end
end)

-- ═══════════════════════════════════════════════════════════════════
-- Minimize / Close
-- ═══════════════════════════════════════════════════════════════════
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	MinBtn.Image = minimized and "rbxassetid://6031090990" or "rbxassetid://6031091004"
	MinBtn.Rotation = minimized and -90 or 0
	ambientPaused = minimized
	for _, motion in pairs(ambientTweens) do
		pcall(function()
			if minimized then motion:Pause() else motion:Play() end
		end)
	end
	Tween(Window, 0.3, {Size = UDim2.fromOffset(WIN_W, minimized and HEADER_H or WIN_H)})
end)

CloseBtn.MouseButton1Click:Connect(CloseLoader)

-- ═══════════════════════════════════════════════════════════════════
-- Dragging
-- ═══════════════════════════════════════════════════════════════════
local dragging, dragStart, startPos, dragInput

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Window.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

Header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		Window.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)


-- ═══════════════════════════════════════════════════════════════════
-- Entrance animation (window pop + staggered cards)
-- ═══════════════════════════════════════════════════════════════════
task.spawn(function()
	task.wait(0.08)
	Tween(Window, 0.48, {GroupTransparency = 0}, Enum.EasingStyle.Quint)
	Tween(winScale, 0.52, {Scale = baseScale}, Enum.EasingStyle.Back)
	for i, card in ipairs(cards) do
		task.delay(0.18 + i * 0.07, function()
			Tween(card, 0.36, {GroupTransparency = 0}, Enum.EasingStyle.Quint)
			local scale = card:FindFirstChild("CardScale")
			if scale then Tween(scale, 0.42, {Scale = 1}, Enum.EasingStyle.Back) end
		end)
	end
end)

if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		baseScale = GetWindowScale()
		Tween(winScale, 0.2, {Scale = baseScale})
	end)
end
