local count = 0
local function check(name, test)
    test()
    count += 1
    print("PASS " .. name)
end
check("two ghosts drift within the open scene above the loading line", function()
    setup(); __KZ_Cozy.Begin()
    assert(#__KZ_Cozy.Decor == 2)
    for step = 0, 100 do
        now = step / 2
        RunService.RenderStepped:Fire()
        for _, effect in ipairs(__KZ_Cozy.Decor) do
            local x, y = effect.Node.Position.X.Offset, effect.Node.Position.Y.Offset
            assert(x >= 40 and x <= __KZ_Cozy.SceneWidth - 40, "ghost clips the screen")
            assert(y >= 44 and y <= __KZ_Cozy.SceneHeight - 44, "ghost crosses the loading line")
        end
    end
    __KZ_Cozy.Cleanup(false)
end)
check("each theme has two sparse matching scene motifs", function()
    for _, theme in ipairs({"Hello Kitty", "Cherry Blossom", "KZ Scripts", "Midnight"}) do
        setup(theme); __KZ_Cozy.Begin()
        assert(#__KZ_Cozy.Decor == 2)
        local expected = theme == "Hello Kitty" and "♡" or theme == "Cherry Blossom" and "❀" or "✧"
        assert(__KZ_Cozy.Decor[1].Node.Children[1].Text == expected)
    end
end)
check("reduced motion removes ghosts and cat travel", function()
    setup("Halloween", true); __KZ_Cozy.Begin()
    __KZ_Cozy.Say("Hello from KZ")
    assert(#__KZ_Cozy.Decor == 0)
    now = 4; RunService.RenderStepped:Fire()
    assert(__KZ_Cozy.Cat.Position.Y.Offset == -8)
    assert(__KZ_Cozy.Speech.MaxVisibleGraphemes == -1)
end)
check("progress waits for real milestones and success cleans up", function()
    setup(); __KZ_Cozy.Begin()
    __KZ_Cozy.Progress(3, "Applying settings")
    advance(6)
    __KZ_Cozy.UpdateLoading()
    assert(__KZ_Cozy.Fill.Size.X.Scale == .96)
    assert(__KZ_Cozy.Status.Text == "Loading 96%")
    assert(not Window.Active and __KZ_Cozy.Active)
    local motion = __KZ_Cozy.Motion
    __KZ_Cozy.Finish(); advance(4.2)
    assert(Window.Active and Window.Visible and Window.GroupTransparency == 0)
    assert(not __KZ_Cozy.Blur and not __KZ_Cozy.Stage and not __KZ_Cozy.Veil and not __KZ_Cozy.LoadingStrip)
    assert(not motion.Connected and __KZ_Cozy.Preferences.SeenIntro)
end)
check("the loader has no skip button", function()
    setup(); __KZ_Cozy.Begin()
    assert(__KZ_Cozy.Skip == nil)
    for _, node in ipairs(nodes) do assert(node.Text ~= "Skip intro") end
end)
check("readiness cannot bypass the loading animation", function()
    setup(); __KZ_Cozy.Begin(); __KZ_Cozy.Finish()
    advance(1)
    assert(not Window.Visible and not Window.Active and __KZ_Cozy.Active)
    advance(4.4)
    assert(Window.Visible and Window.Active and not __KZ_Cozy.Blur)
end)
check("failure clears blur without recording a successful intro", function()
    setup(); __KZ_Cozy.Begin(); __KZ_Cozy.Finish(true); advance(5)
    assert(not __KZ_Cozy.Blur and not __KZ_Cozy.Preferences.SeenIntro)
    assert(not Window.Visible and not Window.Active and not __KZ_Cozy.Ready)
end)
check("closing during loading releases every owned effect", function()
    setup(); __KZ_Cozy.Begin()
    local motion = __KZ_Cozy.Motion
    Screen:Destroy(); advance(35)
    assert(not __KZ_Cozy.Active and not motion.Connected and not __KZ_Cozy.Blur)
    assert(not Window.Parent)
end)
check("watchdog clears a stalled initialization without claiming readiness", function()
    setup(); __KZ_Cozy.Begin(); advance(31)
    assert(not __KZ_Cozy.Active and not __KZ_Cozy.Blur and not Window.Active)
    assert(#warnings == 1)
end)
check("the old disabled-animation option cannot skip loading", function()
    setup("KZ Scripts", false, false, false); __KZ_Cozy.Begin()
    assert(__KZ_Cozy.Stage)
    __KZ_Cozy.Finish(); advance(1)
    assert(not Window.Active)
    advance(4.4)
    assert(Window.Active and Window.Visible)
end)
check("repeat launch keeps the same short 0–100 sequence", function()
    setup("KZ Scripts", false, true); __KZ_Cozy.Begin(); __KZ_Cozy.Finish()
    advance(.8)
    assert(not __KZ_Cozy.Speech.Text:find("bye!!!!",1,true))
    advance(3.6)
    assert(__KZ_Cozy.Speech.Text:find("bye!!!!",1,true))
    assert(not Window.Active)
    advance(.8)
    assert(not __KZ_Cozy.Active and Window.Active)
end)
check("the host is attached to the screen's bottom-right corner, outside the loader", function()
    setup(); __KZ_Cozy.Begin()
    local c = __KZ_Cozy
    assert(c.Host.Parent == Screen and c.Host.Parent ~= c.Stage and c.Host.Parent ~= c.LoadingStrip)
    assert(c.Host.AnchorPoint.X == 1 and c.Host.AnchorPoint.Y == 1)
    assert(c.Host.Position.X.Scale == 1 and c.Host.Position.Y.Scale == 1)
    assert(c.Host.Position.X.Offset == -16 and c.Host.Position.Y.Offset == -16)
    c.Stage.Position = UDim2.fromOffset(40,40)
    assert(c.Host.Position.X.Scale == 1 and c.Host.Position.Y.Scale == 1)
end)
check("the loading line and corner host fit without overlap at all supported viewport sizes", function()
    setup(); __KZ_Cozy.Begin()
    for _, dimensions in ipairs({{1920,1080},{1280,720},{844,390},{390,844},{320,568},{640,360}}) do
        local width, height = dimensions[1], dimensions[2]
        workspace.CurrentCamera.ViewportSize = Vector2.new(width,height)
        workspace.CurrentCamera.Changed:Fire()
        local c = __KZ_Cozy
        local hostScale, stripScale = c.HostScale.Scale, c.StripScale.Scale
        local hostLeft, hostTop = width - 16 - 420 * hostScale, height - 16 - 138 * hostScale
        local stripLeft = c.LoadingStrip.Position.X.Offset
        local stripRight = stripLeft + 304 * stripScale
        local stripBottom = height + c.LoadingStrip.Position.Y.Offset
        local stripTop = stripBottom - 44 * stripScale
        assert(hostLeft >= 0 and hostTop >= 0, "host clips the viewport")
        assert(stripLeft >= 0 and stripRight <= width and stripTop >= 0 and stripBottom <= height,
            "loading line clips the viewport")
        assert(stripRight + 32 <= hostLeft or stripBottom + 32 <= hostTop + .001,
            "loading line overlaps the corner host")
        now = 1.7; RunService.RenderStepped:Fire()
        for _, effect in ipairs(c.Decor) do
            assert(effect.Node.Position.Y.Offset + 44 <= math.min(hostTop, stripTop) - 24 + .001,
                "ghost overlaps the loading line or host")
        end
    end
end)
check("a late asset download does not cut off the cat's welcome", function()
    setup(); __KZ_Cozy.Begin(); advance(8)
    __KZ_Cozy.WelcomeStarted = now
    __KZ_Cozy.Say("Thanks for picking KZ!")
    __KZ_Cozy.Finish(); advance(.3)
    assert(not __KZ_Cozy.Speech.Text:find("bye!!!!",1,true))
    advance(3.1)
    assert(Window.Visible and Window.Active)
end)
check("reduced motion also keeps the farewell still", function()
    setup("Halloween",true); __KZ_Cozy.Begin(); __KZ_Cozy.Finish(); advance(4.7)
    assert(__KZ_Cozy.Host.Position.Y.Offset == -16)
    advance(.8)
    assert(Window.Active)
end)
check("applying reduced motion during initialization stops existing motifs", function()
    setup(); __KZ_Cozy.Begin()
    __KZ_Cozy.Reduced = true
    RunService.RenderStepped:Fire()
    for _, effect in ipairs(__KZ_Cozy.Decor) do assert(effect.Node.Visible == false) end
    assert(__KZ_Cozy.Cat.Rotation == 0 and __KZ_Cozy.Cat.Position.Y.Offset == -8)
end)
check("intro images and speech use direct rendering instead of flattened textures", function()
    setup(); __KZ_Cozy.Begin()
    assert(__KZ_Cozy.LoadingStrip.ClassName == "Frame" and __KZ_Cozy.Host.ClassName == "Frame")
    assert(__KZ_Cozy.Cat.ResampleMode == "Default")
    for _, child in ipairs(__KZ_Cozy.Host:GetDescendants()) do
        assert(child.Name ~= "HostHeading", "the old host heading returned")
    end
end)
check("the UI opens only after 100 percent, around five seconds", function()
    setup(); __KZ_Cozy.Begin(); __KZ_Cozy.Finish()
    advance(4.4)
    assert(not Window.Visible and not Window.Active)
    assert(__KZ_Cozy.DisplayFraction < 1)
    advance(.12)
    assert(__KZ_Cozy.Status.Text == "Loading 100%")
    assert(not Window.Visible)
    advance(.15)
    assert(not Window.Active)
    advance(.6)
    assert(Window.Active)
end)
check("the crisp main logo follows the window at whole screen pixels", function()
    setup()
    Window.Visible = true
    __KZ_Cozy.SyncBrandLogo()
    assert(BrandLogo.Parent == Screen and BrandLogo.Visible)
    assert(BrandLogo.Position.X.Offset == 124 and BrandLogo.Position.Y.Offset == 69)
    assert(BrandLogo.Size.X.Offset == 42 and BrandLogo.Size.Y.Offset == 42)
    BrandLogoShell.AbsolutePosition = Vector2.new(120.4,100.6)
    __KZ_Cozy.SyncBrandLogo()
    assert(BrandLogo.Position.X.Offset == 144 and BrandLogo.Position.Y.Offset == 89)
end)
check("the direct main logo respects fades and hiding", function()
    setup()
    Window.Visible, Window.GroupTransparency = true, .4
    __KZ_Cozy.BrandFade.Value = .2
    __KZ_Cozy.SyncBrandLogo()
    assert(math.abs(BrandLogo.ImageTransparency - .52) < .0001)
    Window.Visible = false; __KZ_Cozy.SyncBrandLogo(); assert(not BrandLogo.Visible)
    Window.Visible, BrandLogoShell.Visible = true, false
    __KZ_Cozy.SyncBrandLogo(); assert(not BrandLogo.Visible)
end)
check("progress is smooth and monotonic and says Loading throughout", function()
    setup(); __KZ_Cozy.Begin()
    __KZ_Cozy.Ready = true
    local previous = 0
    for tick = 0, 270 do
        now = tick / 60
        __KZ_Cozy.UpdateLoading()
        assert(__KZ_Cozy.DisplayFraction >= previous)
        assert(__KZ_Cozy.DisplayFraction - previous < .01)
        assert(__KZ_Cozy.Status.Text:sub(1,8) == "Loading ")
        previous = __KZ_Cozy.DisplayFraction
    end
    assert(__KZ_Cozy.Status.Text == "Loading 100%")
end)
check("ghosts use one smooth sprite rather than assembled body rectangles", function()
    setup(); __KZ_Cozy.Begin(); __KZ_Cozy.SetGhostAsset("test-ghost-sprite")
    for _, ghost in ipairs(__KZ_Cozy.Decor) do
        assert(ghost.Sprite.ClassName == "ImageLabel" and ghost.Glow.ClassName == "ImageLabel")
        assert(ghost.Sprite.Image == "test-ghost-sprite" and not ghost.Fallback.Visible)
        assert(ghost.Sprite.ResampleMode == "Default")
    end
end)
check("the loader has no center card or center logo", function()
    setup(); __KZ_Cozy.Begin()
    local c = __KZ_Cozy
    assert(c.Panel == nil and c.Logo == nil)
    assert(c.Stage.BackgroundTransparency == 1 and c.LoadingStrip.BackgroundTransparency == 1)
    assert(c.LoadingStrip.Parent == Screen and c.Status.Parent == c.LoadingStrip)
    assert(c.LoadingStrip.AnchorPoint.X == 0 and c.LoadingStrip.AnchorPoint.Y == 1)
    assert(c.Status.TextXAlignment == "Left")
    for _, child in ipairs(c.Stage:GetDescendants()) do
        assert(child.Image ~= LOGO and child.Name ~= "FrostedLoader", "center branding returned")
    end
end)
print(tostring(count) .. " lifecycle tests passed")
