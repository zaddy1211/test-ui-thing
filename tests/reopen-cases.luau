-- Exercise the actual reopen-button drag and click handlers with both event orders.
do
    local connections, opens = {}, 0
    local UserInputService = {InputChanged = signal()}
    local OpenButton = New("ImageButton", {Parent = Screen, Position = UDim2.new(0,20,.5,0)})
    OpenButton.InputBegan, OpenButton.InputChanged, OpenButton.MouseButton1Click = signal(), signal(), signal()
    local function __KZ_SetOpen(value) assert(value == true); opens += 1 end
    local function point(x,y)
        return setmetatable({X=x,Y=y}, {__sub = function(a,b) return {X=a.X-b.X,Y=a.Y-b.Y} end})
    end
    -- INSERT REOPEN HANDLERS
    local function press(kind)
        local input = {UserInputType = kind, UserInputState = "Begin", Position = point(50,50), Changed = signal()}
        OpenButton.InputBegan:Fire(input)
        return input
    end
    local function move(input,x,y)
        local movement = input
        if input.UserInputType == "MouseButton1" then movement = {UserInputType="MouseMovement"} end
        movement.Position = point(x,y)
        OpenButton.InputChanged:Fire(movement)
        UserInputService.InputChanged:Fire(movement)
    end
    local function release(input,clickFirst)
        if clickFirst then OpenButton.MouseButton1Click:Fire() end
        input.UserInputState = "End"; input.Changed:Fire()
        if not clickFirst then OpenButton.MouseButton1Click:Fire() end
    end
    check("a mouse click still reopens the UI", function()
        local before = opens
        release(press("MouseButton1"))
        assert(opens == before + 1)
    end)
    check("small pointer jitter still counts as a click", function()
        local before, oldX = opens, OpenButton.Position.X.Offset
        local input = press("MouseButton1"); move(input,53,52); release(input)
        assert(opens == before + 1 and OpenButton.Position.X.Offset == oldX)
    end)
    check("releasing a mouse drag moves the button without opening", function()
        local before, oldX = opens, OpenButton.Position.X.Offset
        local input = press("MouseButton1"); move(input,90,80); release(input)
        assert(opens == before and OpenButton.Position.X.Offset == oldX + 40)
    end)
    check("drag suppression also survives a click delivered before End", function()
        local before = opens
        local input = press("MouseButton1"); move(input,90,80); release(input,true)
        assert(opens == before)
    end)
    check("dragging back to the starting point still suppresses opening", function()
        local before = opens
        local input = press("MouseButton1"); move(input,100,80); move(input,50,50); release(input)
        assert(opens == before)
    end)
    check("a touch drag never opens on release, and the next tap works", function()
        local before, oldY = opens, OpenButton.Position.Y.Offset
        local input = press("Touch"); move(input,50,95); release(input)
        assert(opens == before and OpenButton.Position.Y.Offset == oldY + 45)
        release(press("Touch"))
        assert(opens == before + 1)
    end)
    check("the drag service connection is tracked for cleanup", function()
        assert(#connections == 1 and connections[1].Connected)
        connections[1]:Disconnect()
        assert(not connections[1].Connected)
    end)
end
print(tostring(count) .. " total lifecycle and input tests passed")
