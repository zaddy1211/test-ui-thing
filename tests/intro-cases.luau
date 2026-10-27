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
            if effect.Node.Visible then
                assert(y >= 56 and y <= __KZ_Cozy.SceneHeight - 56, "ghost glow crosses the mascot")
            end
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
    assert(__KZ_Cozy.Status.Text == "Applying settings  96%")
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
    assert(Window.Visible and not Window.Active and __KZ_Cozy.Active and __KZ_Cozy.Stage.Parent == Window)
    advance(4.4)
    assert(Window.Visible and Window.Active and not __KZ_Cozy.Blur)
end)
check("failure hides the incomplete window without recording a successful intro", function()
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
check("watchdog hides a stalled window without claiming readiness", function()
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
check("the cat is centered directly above the loading bar", function()
    setup(); __KZ_Cozy.Begin()
    local c = __KZ_Cozy
    assert(c.Host.Parent == c.Stage and c.Stage.Parent == Window and c.Host.Parent ~= c.LoadingStrip)
    assert(c.Host.AnchorPoint.X == .5 and c.Host.AnchorPoint.Y == 1)
    assert(c.Host.Position.X.Scale == .5 and c.Host.Position.X.Offset == 0)
    assert(c.Cat.AnchorPoint.X == .5 and c.Cat.Position.X.Scale == .5 and c.Cat.Position.X.Offset == 0)
    assert(c.Host.Position.Y.Offset + 12 == c.LoadingStrip.Position.Y.Offset - 44)
    local hostY = c.Host.Position.Y.Offset
    c.Stage.Position = UDim2.fromOffset(40,40)
    assert(c.Host.Position.X.Scale == .5 and c.Host.Position.Y.Offset == hostY)
end)
check("the mascot and loading bar stay centered inside the window at all viewport sizes", function()
    setup(); __KZ_Cozy.Begin()
    for _, dimensions in ipairs({{1920,1080},{1280,720},{844,390},{390,844},{320,568},{640,360}}) do
        workspace.CurrentCamera.ViewportSize = Vector2.new(dimensions[1],dimensions[2])
        workspace.CurrentCamera.Changed:Fire()
        local c = __KZ_Cozy
        local width, height = Window.Size.X.Offset, Window.Size.Y.Offset
        local hostScale = c.HostScale.Scale
        local hostLeft = (width - 300 * hostScale) * .5
        local hostTop = c.Host.Position.Y.Offset - 184 * hostScale
        local stripLeft = width * .5 - c.LoadingWidth * .5
        local stripRight = stripLeft + c.LoadingWidth
        local stripBottom = c.LoadingStrip.Position.Y.Offset
        local stripTop = stripBottom - 44
        assert(hostLeft >= 0 and hostTop >= 0, "host clips the viewport")
        assert(stripLeft >= 0 and stripRight <= width and stripTop >= 0 and stripBottom <= height,
            "loading line clips the viewport")
        assert(c.Host.Position.Y.Offset + 12 <= stripTop + .001, "mascot overlaps the loading line")
        assert(math.abs(hostTop - (height - stripBottom)) < .001, "loading group is off-center")
        now = 1.7; RunService.RenderStepped:Fire()
        for _, effect in ipairs(c.Decor) do
            if effect.Node.Visible then
                assert(effect.Node.Position.Y.Offset + 56 <= hostTop - 24 + .001,
                    "ghost glow overlaps the mascot")
            end
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
    setup("Halloween",true); __KZ_Cozy.Begin()
    local hostY = __KZ_Cozy.Host.Position.Y.Offset
    __KZ_Cozy.Finish(); advance(4.7)
    assert(__KZ_Cozy.Host.Position.Y.Offset == hostY)
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
check("the mascot uses a smooth image inside the window's loading scene", function()
    setup(); __KZ_Cozy.Begin()
    assert(__KZ_Cozy.LoadingStrip.ClassName == "Frame" and __KZ_Cozy.Host.ClassName == "Frame")
    assert(__KZ_Cozy.Cat.ResampleMode == "Default")
    for _, child in ipairs(__KZ_Cozy.Host:GetDescendants()) do
        assert(child.Name ~= "HostHeading", "the old host heading returned")
    end
end)
check("the window stays visible and controls remain covered until 100 percent", function()
    setup(); __KZ_Cozy.Begin(); __KZ_Cozy.Finish()
    advance(4.4)
    assert(Window.Visible and not Window.Active and __KZ_Cozy.Stage.Parent == Window)
    assert(__KZ_Cozy.DisplayFraction < 1)
    advance(.12)
    assert(__KZ_Cozy.Status.Text == "Ready!  100%")
    assert(Window.Visible and __KZ_Cozy.Stage and not Window.Active)
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
check("progress stays smooth while the status describes the loading sequence", function()
    setup(); __KZ_Cozy.Begin()
    __KZ_Cozy.Ready = true
    local previous = 0
    local messages = {}
    for tick = 0, 270 do
        now = tick / 60
        __KZ_Cozy.UpdateLoading()
        assert(__KZ_Cozy.DisplayFraction >= previous)
        assert(__KZ_Cozy.DisplayFraction - previous < .01)
        assert(__KZ_Cozy.Status.Text:match("%d+%%$"), "status lost the percentage")
        messages[__KZ_Cozy.Status.Text:match("^(.-)  %d+%%$")] = true
        previous = __KZ_Cozy.DisplayFraction
    end
    assert(__KZ_Cozy.Status.Text == "Ready!  100%")
    assert(messages["Loading images…"] and messages["Setting up your UI…"] and messages["Finishing up…"])
end)
check("ghosts use one smooth sprite rather than assembled body rectangles", function()
    setup(); __KZ_Cozy.Begin(); __KZ_Cozy.SetGhostAsset("test-ghost-sprite", "test-soft-halo")
    for _, ghost in ipairs(__KZ_Cozy.Decor) do
        assert(ghost.Sprite.ClassName == "ImageLabel" and ghost.Glow.ClassName == "ImageLabel")
        assert(ghost.Sprite.Image == "test-ghost-sprite" and not ghost.Fallback.Visible)
        assert(ghost.Glow.Image == "test-soft-halo" and ghost.Glow.Image ~= ghost.Sprite.Image)
        assert(ghost.Sprite.ResampleMode == "Default")
    end
end)
check("loading lives in the existing window without an extra card or center logo", function()
    setup(); __KZ_Cozy.Begin()
    local c = __KZ_Cozy
    assert(c.Panel == nil and c.Logo == nil)
    assert(c.Stage.Parent == Window and Window.Visible and Window.ClipsDescendants)
    assert(c.Stage.BackgroundTransparency == 0 and c.LoadingStrip.BackgroundTransparency == 1)
    assert(c.Stage.ClassName == "TextButton" and c.Stage.Active and c.Stage.Modal and c.Stage.ClipsDescendants)
    assert(c.LoadingStrip.Parent == c.Stage and c.Status.Parent == c.LoadingStrip)
    assert(c.LoadingStrip.AnchorPoint.X == .5 and c.LoadingStrip.AnchorPoint.Y == 1)
    assert(c.Status.TextXAlignment == "Center")
    for _, child in ipairs(c.Stage:GetDescendants()) do
        assert(child.Image ~= LOGO and child.Name ~= "FrostedLoader", "center branding returned")
    end
end)
check("the loading bar is centered, visible immediately and scales with the main window", function()
    setup(); __KZ_Cozy.Begin()
    local c = __KZ_Cozy
    local track = c.Fill.Parent
    assert(c.LoadingStrip.Position.X.Scale == .5 and c.LoadingStrip.Position.X.Offset == 0)
    assert(c.LoadingWidth == 420 and c.LoadingStrip.Position.Y.Offset == 390)
    assert(track.BackgroundTransparency <= .5 and track.Size.Y.Offset == 6)
    assert(c.Glint.Size.Y.Offset == 6)
    assert(c.Status.TextTransparency == 0 and c.Status.Text == "Loading images…  0%")
    assert(c.Fill.BackgroundTransparency == 0)
    workspace.CurrentCamera.ViewportSize = Vector2.new(320,568)
    workspace.CurrentCamera.Changed:Fire()
    assert(c.LoadingWidth == 420 and c.LoadingStrip.Size.X.Offset == 420)
    assert(track.Size.Y.Offset == 6 and c.Status.TextSize == 14 and c.StripScale == nil)
    now = 2.25; RunService.RenderStepped:Fire()
    assert(c.Status.Text == "Loading images…  50%")
    assert(math.abs(c.Glint.Position.X.Offset - 196) < .001)
end)
check("slow initialization displays its actual step while holding below 100 percent", function()
    setup(); __KZ_Cozy.Begin(); advance(6)
    __KZ_Cozy.Progress(2,"Loading interface…")
    assert(__KZ_Cozy.Status.Text == "Loading interface…  96%")
    __KZ_Cozy.Progress(3,"Loading settings…")
    assert(__KZ_Cozy.Status.Text == "Loading settings…  96%")
    assert(Window.Visible and not Window.Active and __KZ_Cozy.Stage.Parent == Window)
end)
check("the soft ghost halo pulses gently and fades with the sprite", function()
    setup(); __KZ_Cozy.Begin(); __KZ_Cozy.SetGhostAsset("ghost", "halo")
    now = 1; RunService.RenderStepped:Fire()
    for _, ghost in ipairs(__KZ_Cozy.Decor) do
        assert(ghost.Glow.Size.X.Offset == 88 and ghost.Glow.Size.Y.Offset == 110)
        assert(ghost.Glow.ImageTransparency >= .69 and ghost.Glow.ImageTransparency <= .75)
    end
    __KZ_Cozy.ExitStarted = now
    now += .5; RunService.RenderStepped:Fire()
    for _, ghost in ipairs(__KZ_Cozy.Decor) do
        assert(ghost.Glow.ImageTransparency == 1 and ghost.Sprite.ImageTransparency == 1)
    end
end)
check("the loading scene uses the current theme's artwork and follows late artwork updates", function()
    for _, theme in ipairs({"KZ Scripts","Halloween","Hello Kitty","Cherry Blossom"}) do
        setup(theme); __KZ_Cozy.Begin()
        local c = __KZ_Cozy
        assert(c.LoadingArtwork.Image == theme.."-background" and c.LoadingArtwork.Parent == c.Stage)
        assert(c.LoadingBackground ~= WindowFade and c.LoadingArtwork ~= Artwork)
        assert(c.LoadingBackground.BackgroundColor3 == WindowFade.BackgroundColor3)
        Artwork.Image, Artwork.ImageTransparency = theme.."-downloaded", .57
        windowFadeGradient.Color = "new-theme-gradient"
        ArtworkShade.BackgroundTransparency = .48
        RunService.RenderStepped:Fire()
        assert(c.LoadingArtwork.Image == theme.."-downloaded" and c.LoadingArtwork.ImageTransparency == .57)
        assert(c.LoadingGradient.Color == "new-theme-gradient" and c.LoadingShade.BackgroundTransparency == .48)
        assert(c.Veil == nil and c.Blur == nil)
        c.Cleanup(false)
        assert(Artwork.Parent == Window and Artwork.Image == theme.."-downloaded")
    end
end)
check("the sidebar logo stays hidden until the loading scene releases the controls", function()
    setup(); __KZ_Cozy.Begin()
    __KZ_Cozy.SyncBrandLogo()
    assert(Window.Visible and not BrandLogo.Visible)
    __KZ_Cozy.Finish(); advance(5.4)
    __KZ_Cozy.SyncBrandLogo()
    assert(Window.Visible and Window.Active and BrandLogo.Visible and not __KZ_Cozy.Stage)
end)
check("the reveal fades the loading contents while preserving the visible themed window", function()
    setup(); __KZ_Cozy.Begin(); __KZ_Cozy.Finish()
    advance(4.7)
    assert(__KZ_Cozy.Active and Window.Visible and Window.GroupTransparency == 0)
    assert(__KZ_Cozy.Stage and __KZ_Cozy.Stage.Parent == Window)
    local faded = __KZ_Cozy.LoadingArtwork.ImageTransparency
    RunService.RenderStepped:Fire()
    assert(__KZ_Cozy.LoadingArtwork.ImageTransparency == faded, "art sync cancelled the exit fade")
    advance(.7)
    assert(Window.Visible and Window.Active and Artwork.Parent == Window and not __KZ_Cozy.Stage)
end)
check("the initial loading window gets a responsive scale before controls exist", function()
    setup()
    local target = GetTargetScale
    GetTargetScale = nil
    workspace.CurrentCamera.ViewportSize = Vector2.new(390,844)
    __KZ_Cozy.Begin()
    assert(Scale.Scale == .55 and Window.Visible and not Window.Active)
    assert(__KZ_Cozy.Host.Parent == __KZ_Cozy.Stage and __KZ_Cozy.Stage.Parent == Window)
    __KZ_Cozy.Cleanup(false)
    GetTargetScale = target
end)
print(tostring(count) .. " lifecycle tests passed")
