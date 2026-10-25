-- Deterministic lifecycle harness. Tween targets are immediate; this does not emulate rendering.
local now, queue, nodes = 0, {}, {}
local Screen, Window, Scale, destroyed, __KZ_Cozy, __KZ_UI_OPTIONS, themeName
__KZ_Cozy = {}
local function signal()
    local s = {Listeners = {}}
    function s:Connect(fn)
        local connection = {Connected = true}
        function connection:Disconnect() self.Connected = false end
        table.insert(self.Listeners, {Connection = connection, Fn = fn})
        return connection
    end
    function s:Fire(...)
        for _, item in ipairs(self.Listeners) do if item.Connection.Connected then item.Fn(...) end end
    end
    return s
end
local function New(class, props)
    local node = {ClassName = class, Children = {}, Destroying = signal(), Activated = signal()}
    for key, value in pairs(props or {}) do node[key] = value end
    function node:Destroy()
        if self.Dead then return end
        self.Dead = true
        self.Destroying:Fire()
        for _, child in ipairs(self.Children) do child:Destroy() end
        self.Parent = nil
    end
    if node.Parent then table.insert(node.Parent.Children, node) end
    table.insert(nodes, node)
    return node
end
local function enqueue(thread, due) table.insert(queue, {Thread = thread, Due = due}) end
local task = {}
function task.spawn(fn) enqueue(coroutine.create(fn), now) end
function task.delay(delay, fn) enqueue(coroutine.create(fn), now + delay) end
function task.wait(duration) return coroutine.yield(duration or .016) end
local function advance(seconds)
    local target = now + seconds
    for iteration = 1, 100000 do
        local selected, due
        for index, item in ipairs(queue) do
            if item.Due <= target and (not due or item.Due < due) then selected, due = index, item.Due end
        end
        if not selected then now = target; return end
        local item = table.remove(queue, selected)
        now = item.Due
        local ok, delay = coroutine.resume(item.Thread)
        assert(ok, delay)
        if coroutine.status(item.Thread) ~= "dead" then enqueue(item.Thread, now + (delay or .016)) end
    end
    error("scheduler did not settle")
end
local os = {clock = function() return now end}
local UDim2 = {}
function UDim2.new(xs, xo, ys, yo) return {X = {Scale = xs, Offset = xo}, Y = {Scale = ys, Offset = yo}} end
function UDim2.fromOffset(x, y) return UDim2.new(0, x, 0, y) end
function UDim2.fromScale(x, y) return UDim2.new(x, 0, y, 0) end
local UDim = {new = function(s, o) return {Scale = s, Offset = o} end}
local Vector2 = {new = function(x,y) return {X=x,Y=y} end}
local Color3 = {fromRGB = function(r,g,b) return {R=r/255,G=g/255,B=b/255} end}
local Enum = setmetatable({}, {__index = function(self, key)
    local child = setmetatable({}, {__index = function(_, value) return value end})
    rawset(self, key, child); return child
end})
local RunService = {RenderStepped = signal()}
local lighting = New("Lighting", {})
local game = {GetService = function(_, name) assert(name == "Lighting"); return lighting end}
local workspace = {CurrentCamera = {ViewportSize = Vector2.new(1280,720), Changed = signal()}}
function workspace.CurrentCamera:GetPropertyChangedSignal(name)
    assert(name == "ViewportSize")
    return self.Changed
end
local T = {MainBG = {}, Accent = {}, Accent2 = {}, Accent3 = {}, TextSub = {}, TextMain = {}, SectionBG = {}, ControlBG = {}}
local LOGO = "test-logo"
local function Corner() end
local function Stroke() end
local function Gradient() end
local function Mix(a) return a end
local function Tween(object, _, properties)
    if not object or not object.Parent then return end
    for key, value in pairs(properties) do object[key] = value end
end
local function GetTargetScale() return .8 end
local warnings = {}
local function warn(message) table.insert(warnings, message) end
local function setup(theme, reduced, short, loadAnimation)
    now, queue, nodes, warnings = 0, {}, {}, {}
    lighting = New("Lighting", {})
    local root = New("Root", {})
    Screen = New("ScreenGui", {Parent = root})
    Window = New("CanvasGroup", {Parent = Screen, Visible = false, Active = false, GroupTransparency = 1})
    Scale = New("UIScale", {Parent = Window, Scale = .8})
    destroyed, themeName = false, theme or "Halloween"
    workspace.CurrentCamera.ViewportSize = Vector2.new(1280,720)
    workspace.CurrentCamera.Changed = signal()
    __KZ_UI_OPTIONS = {LoadAnimation = loadAnimation}
    local methods = {}
    for key, value in pairs(__KZ_Cozy) do if type(value) == "function" then methods[key] = value end end
    __KZ_Cozy = {Preferences = {}, Reduced = reduced, Short = short, Saves = 0}
    for key, value in pairs(methods) do __KZ_Cozy[key] = value end
    __KZ_Cozy.SavePreferences = function() __KZ_Cozy.Saves += 1 end
    RunService.RenderStepped = signal()
end

-- The runner inserts the actual lifecycle methods from UniversalUI.lua here.

