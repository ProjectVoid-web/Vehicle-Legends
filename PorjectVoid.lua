-- Vehicle Legends – Project Void (Speed + Fly + Walk + Rejoin)
-- Insert toggles UI, W = speed boost, WASD + Space/Shift = car fly.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
repeat task.wait() until player
local placeId = game.PlaceId

-- settings
local Settings = {
    SpeedBoost = false,
    SpeedMultiplier = 2.0,
    MaxMultiplier = 10.0,
    MinMultiplier = 1.0,
    BaseSpeed = 70,
    DownForce = -2500,
    Damping = 0.85,
    WalkSpeed = 16,
    CarFly = false,
    FlyPower = 300,
}

-- UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VoidUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parent = player:FindFirstChild("PlayerGui") or CoreGui
if not parent then error("No GUI parent") end
screenGui.Parent = parent

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 290, 0, 340)
mainFrame.Position = UDim2.new(0.5, -145, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
mainFrame.BackgroundTransparency = 0.25
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 10

local glow = Instance.new("UIStroke")
glow.Parent = mainFrame
glow.Color = Color3.fromRGB(255, 0, 0)
glow.Thickness = 2
glow.Transparency = 0.4
glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = mainFrame

local innerBg = Instance.new("Frame")
innerBg.Parent = mainFrame
innerBg.Size = UDim2.new(1, -4, 1, -4)
innerBg.Position = UDim2.new(0, 2, 0, 2)
innerBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
innerBg.BackgroundTransparency = 0.5
innerBg.BorderSizePixel = 0
innerBg.ZIndex = 1
local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 12)
innerCorner.Parent = innerBg

-- Title
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 34)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "💋 PROJECT VOID"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeTransparency = 0.3
title.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 11

local subtitle = Instance.new("TextLabel")
subtitle.Parent = mainFrame
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 44)
subtitle.BackgroundTransparency = 1
subtitle.Text = "VEHICLE LEGENDS"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 220)
subtitle.TextStrokeTransparency = 0.5
subtitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.TextXAlignment = Enum.TextXAlignment.Center
subtitle.ZIndex = 11

-- Speed Boost
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(0.5, 0, 0, 18)
speedLabel.Position = UDim2.new(0.05, 0, 0, 74)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "🚀 Speed Boost"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 13
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.ZIndex = 12

local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = mainFrame
toggleBtn.Size = UDim2.new(0.22, 0, 0, 26)
toggleBtn.Position = UDim2.new(0.75, 0, 0, 72)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.BorderSizePixel = 1
toggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.ZIndex = 13
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Parent = mainFrame
sliderLabel.Size = UDim2.new(0.3, 0, 0, 16)
sliderLabel.Position = UDim2.new(0.05, 0, 0, 104)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "2.0x"
sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 12
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.ZIndex = 12

local speedSliderBg = Instance.new("Frame")
speedSliderBg.Parent = mainFrame
speedSliderBg.Size = UDim2.new(0.6, 0, 0, 8)
speedSliderBg.Position = UDim2.new(0.3, 0, 0, 104)
speedSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedSliderBg.BorderSizePixel = 0
speedSliderBg.ZIndex = 11
local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = speedSliderBg

local speedFill = Instance.new("Frame")
speedFill.Parent = speedSliderBg
speedFill.Size = UDim2.new(0.5, 0, 1, 0)
speedFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
speedFill.BorderSizePixel = 0
speedFill.ZIndex = 12
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = speedFill

local speedHandle = Instance.new("TextButton")
speedHandle.Parent = speedSliderBg
speedHandle.Size = UDim2.new(0, 20, 0, 20)
speedHandle.AnchorPoint = Vector2.new(0.5, 0.5)  -- center of knob
speedHandle.Position = UDim2.new(0.5, 0, 0.5, 0) -- centered on track
speedHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedHandle.BorderSizePixel = 0
speedHandle.Text = ""
speedHandle.ZIndex = 13
local handleCorner = Instance.new("UICorner")
handleCorner.CornerRadius = UDim.new(1, 0)
handleCorner.Parent = speedHandle
local handleStroke = Instance.new("UIStroke")
handleStroke.Parent = speedHandle
handleStroke.Color = Color3.fromRGB(0, 0, 0)
handleStroke.Thickness = 2
handleStroke.Transparency = 0.5

-- Walk Boost
local walkLabel = Instance.new("TextLabel")
walkLabel.Parent = mainFrame
walkLabel.Size = UDim2.new(0.5, 0, 0, 18)
walkLabel.Position = UDim2.new(0.05, 0, 0, 134)
walkLabel.BackgroundTransparency = 1
walkLabel.Text = "🏃 Walk Boost"
walkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
walkLabel.Font = Enum.Font.GothamBold
walkLabel.TextSize = 13
walkLabel.TextXAlignment = Enum.TextXAlignment.Left
walkLabel.ZIndex = 12

local walkSliderLabel = Instance.new("TextLabel")
walkSliderLabel.Parent = mainFrame
walkSliderLabel.Size = UDim2.new(0.3, 0, 0, 16)
walkSliderLabel.Position = UDim2.new(0.05, 0, 0, 160)
walkSliderLabel.BackgroundTransparency = 1
walkSliderLabel.Text = "16"
walkSliderLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
walkSliderLabel.Font = Enum.Font.Gotham
walkSliderLabel.TextSize = 12
walkSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
walkSliderLabel.ZIndex = 12

local walkSliderBg = Instance.new("Frame")
walkSliderBg.Parent = mainFrame
walkSliderBg.Size = UDim2.new(0.6, 0, 0, 8)
walkSliderBg.Position = UDim2.new(0.3, 0, 0, 160)
walkSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
walkSliderBg.BorderSizePixel = 0
walkSliderBg.ZIndex = 11
local walkCorner = Instance.new("UICorner")
walkCorner.CornerRadius = UDim.new(1, 0)
walkCorner.Parent = walkSliderBg

local walkFill = Instance.new("Frame")
walkFill.Parent = walkSliderBg
walkFill.Size = UDim2.new(0.5, 0, 1, 0)
walkFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
walkFill.BorderSizePixel = 0
walkFill.ZIndex = 12
local walkFillCorner = Instance.new("UICorner")
walkFillCorner.CornerRadius = UDim.new(1, 0)
walkFillCorner.Parent = walkFill

local walkHandle = Instance.new("TextButton")
walkHandle.Parent = walkSliderBg
walkHandle.Size = UDim2.new(0, 20, 0, 20)
walkHandle.AnchorPoint = Vector2.new(0.5, 0.5)
walkHandle.Position = UDim2.new(0.5, 0, 0.5, 0)
walkHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
walkHandle.BorderSizePixel = 0
walkHandle.Text = ""
walkHandle.ZIndex = 13
local walkHandleCorner = Instance.new("UICorner")
walkHandleCorner.CornerRadius = UDim.new(1, 0)
walkHandleCorner.Parent = walkHandle
local walkHandleStroke = Instance.new("UIStroke")
walkHandleStroke.Parent = walkHandle
walkHandleStroke.Color = Color3.fromRGB(0, 0, 0)
walkHandleStroke.Thickness = 2
walkHandleStroke.Transparency = 0.5

-- Car Fly
local flyLabel = Instance.new("TextLabel")
flyLabel.Parent = mainFrame
flyLabel.Size = UDim2.new(0.5, 0, 0, 18)
flyLabel.Position = UDim2.new(0.05, 0, 0, 192)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "✈️ Car Fly"
flyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyLabel.Font = Enum.Font.GothamBold
flyLabel.TextSize = 13
flyLabel.TextXAlignment = Enum.TextXAlignment.Left
flyLabel.ZIndex = 12

local flyToggleBtn = Instance.new("TextButton")
flyToggleBtn.Parent = mainFrame
flyToggleBtn.Size = UDim2.new(0.22, 0, 0, 26)
flyToggleBtn.Position = UDim2.new(0.75, 0, 0, 190)
flyToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
flyToggleBtn.BackgroundTransparency = 0.3
flyToggleBtn.BorderSizePixel = 1
flyToggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
flyToggleBtn.Text = "OFF"
flyToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggleBtn.Font = Enum.Font.GothamBold
flyToggleBtn.TextSize = 12
flyToggleBtn.ZIndex = 13
local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyToggleBtn

-- Rejoin
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Parent = mainFrame
rejoinBtn.Size = UDim2.new(0.8, 0, 0, 32)
rejoinBtn.Position = UDim2.new(0.1, 0, 0, 228)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
rejoinBtn.BackgroundTransparency = 0.2
rejoinBtn.BorderSizePixel = 1
rejoinBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
rejoinBtn.Text = "♻️ REJOIN SERVER"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = 14
rejoinBtn.ZIndex = 13
local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 8)
rejoinCorner.Parent = rejoinBtn

-- Reset
local resetBtn = Instance.new("TextButton")
resetBtn.Parent = mainFrame
resetBtn.Size = UDim2.new(0.8, 0, 0, 24)
resetBtn.Position = UDim2.new(0.1, 0, 0, 274)
resetBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
resetBtn.BackgroundTransparency = 0.4
resetBtn.BorderSizePixel = 0
resetBtn.Text = "RESTART"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 11
resetBtn.ZIndex = 13
local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetBtn

-- Dragging
local dragStart, frameStart, dragging
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Slider update functions
local function updateSpeedSlider(val)
    local clamped = math.clamp(val, Settings.MinMultiplier, Settings.MaxMultiplier)
    Settings.SpeedMultiplier = clamped
    sliderLabel.Text = string.format("%.1f", clamped) .. "x"
    local pct = (clamped - Settings.MinMultiplier) / (Settings.MaxMultiplier - Settings.MinMultiplier)
    speedFill.Size = UDim2.new(pct, 0, 1, 0)
    speedHandle.Position = UDim2.new(pct, 0, 0.5, 0)  -- anchor is centered, so only X changes
end

local function updateWalkSlider(val)
    local clamped = math.clamp(val, 16, 200)
    Settings.WalkSpeed = clamped
    walkSliderLabel.Text = math.floor(clamped)
    local pct = (clamped - 16) / (200 - 16)
    walkFill.Size = UDim2.new(pct, 0, 1, 0)
    walkHandle.Position = UDim2.new(pct, 0, 0.5, 0)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = clamped end
    end
end

updateSpeedSlider(Settings.SpeedMultiplier)
updateWalkSlider(Settings.WalkSpeed)

-- Slider dragging
local speedDragging = false
speedHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then speedDragging = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then speedDragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if speedDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local absPos = speedSliderBg.AbsolutePosition
        local absSize = speedSliderBg.AbsoluteSize
        if absSize.X > 0 then
            local pct = math.clamp((input.Position.X - absPos.X) / absSize.X, 0, 1)
            local val = Settings.MinMultiplier + (Settings.MaxMultiplier - Settings.MinMultiplier) * pct
            updateSpeedSlider(val)
        end
    end
end)

local walkDragging = false
walkHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then walkDragging = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then walkDragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if walkDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local absPos = walkSliderBg.AbsolutePosition
        local absSize = walkSliderBg.AbsoluteSize
        if absSize.X > 0 then
            local pct = math.clamp((input.Position.X - absPos.X) / absSize.X, 0, 1)
            local val = 16 + (200 - 16) * pct
            updateWalkSlider(val)
        end
    end
end)

-- Buttons
local function toggleSpeedBoost()
    Settings.SpeedBoost = not Settings.SpeedBoost
    toggleBtn.Text = Settings.SpeedBoost and "ON" or "OFF"
    toggleBtn.BackgroundColor3 = Settings.SpeedBoost and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 0, 0)
    toggleBtn.BorderColor3 = Settings.SpeedBoost and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 0, 0)
    showNotification(Settings.SpeedBoost and "🚀 Speed Boost ON" or "⛔ Speed Boost OFF", 1.5)
end
toggleBtn.MouseButton1Click:Connect(toggleSpeedBoost)

local function toggleCarFly()
    Settings.CarFly = not Settings.CarFly
    flyToggleBtn.Text = Settings.CarFly and "ON" or "OFF"
    flyToggleBtn.BackgroundColor3 = Settings.CarFly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 0, 0)
    flyToggleBtn.BorderColor3 = Settings.CarFly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 0, 0)
    showNotification(Settings.CarFly and "✈️ Car Fly ON" or "⛔ Car Fly OFF", 1.5)
end
flyToggleBtn.MouseButton1Click:Connect(toggleCarFly)

rejoinBtn.MouseButton1Click:Connect(function()
    showNotification("♻️ Rejoining...", 2)
    task.wait(0.5)
    pcall(function()
        TeleportService:Teleport(placeId, player)
    end)
end)

resetBtn.MouseButton1Click:Connect(function()
    updateSpeedSlider(2.0)
    updateWalkSlider(16)
    if Settings.SpeedBoost then toggleSpeedBoost() end
    if Settings.CarFly then toggleCarFly() end
    showNotification("↺ Restarted defaults", 1.5)
end)

-- Notification
local notif = Instance.new("TextLabel")
notif.Parent = screenGui
notif.Size = UDim2.new(0, 300, 0, 30)
notif.Position = UDim2.new(0.5, -150, 1, -50)
notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
notif.BackgroundTransparency = 0.6
notif.BorderSizePixel = 1
notif.BorderColor3 = Color3.fromRGB(255, 0, 0)
notif.Text = ""
notif.TextColor3 = Color3.fromRGB(255, 255, 255)
notif.Font = Enum.Font.GothamBold
notif.TextSize = 14
notif.TextScaled = true
notif.Visible = false
notif.ZIndex = 20
local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notif

function showNotification(msg, dur)
    dur = dur or 2
    notif.Text = msg
    notif.Visible = true
    notif.TextTransparency = 0
    task.spawn(function()
        task.wait(dur)
        for i = 0, 1, 0.05 do
            notif.TextTransparency = i
            task.wait(0.03)
        end
        notif.Visible = false
    end)
end

-- Speed boost logic
local bodyVel = nil
local bodyForce = nil
local currentSpeed = 0

local function applySpeedBoost()
    if not Settings.SpeedBoost then return end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.Sit then
        if bodyVel then bodyVel:Destroy(); bodyVel = nil end
        if bodyForce then bodyForce:Destroy(); bodyForce = nil end
        currentSpeed = 0
        return
    end

    if not UserInputService:IsKeyDown(Enum.KeyCode.W) then
        if bodyVel then bodyVel:Destroy(); bodyVel = nil end
        if bodyForce then bodyForce:Destroy(); bodyForce = nil end
        currentSpeed = 0
        return
    end

    local forward = root.CFrame.LookVector
    local targetSpeed = Settings.BaseSpeed * Settings.SpeedMultiplier
    currentSpeed = currentSpeed + (targetSpeed - currentSpeed) * Settings.Damping

    if not bodyVel then
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(150000, 150000, 150000)
        bodyVel.P = 20000
        bodyVel.Parent = root
    end
    bodyVel.Velocity = forward * currentSpeed

    if not bodyForce then
        bodyForce = Instance.new("BodyForce")
        bodyForce.Force = Vector3.new(0, Settings.DownForce, 0)
        bodyForce.Parent = root
    end

    local vel = root.Velocity
    if vel.Y > 5 then
        root.Velocity = Vector3.new(vel.X, 0, vel.Z)
    end
end

-- Car fly logic
local flyVel = nil
local flyForce = nil

local function applyCarFly()
    if not Settings.CarFly then
        if flyVel then flyVel:Destroy(); flyVel = nil end
        if flyForce then flyForce:Destroy(); flyForce = nil end
        return
    end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.Sit then
        if flyVel then flyVel:Destroy(); flyVel = nil end
        if flyForce then flyForce:Destroy(); flyForce = nil end
        return
    end

    local dir = Vector3.new()
    local forward = root.CFrame.LookVector
    local right = root.CFrame.RightVector

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + forward end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - forward end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - right end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + right end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir + Vector3.new(0, -1, 0) end

    if dir.Magnitude > 0 then
        dir = dir.Unit
    else
        if flyVel then flyVel:Destroy(); flyVel = nil end
        if flyForce then flyForce:Destroy(); flyForce = nil end
        return
    end

    if not flyVel then
        flyVel = Instance.new("BodyVelocity")
        flyVel.MaxForce = Vector3.new(100000, 100000, 100000)
        flyVel.P = 50000
        flyVel.Parent = root
    end
    flyVel.Velocity = dir * Settings.FlyPower

    if not flyForce then
        flyForce = Instance.new("BodyForce")
        flyForce.Force = Vector3.new(0, 500, 0)
        flyForce.Parent = root
    end
end

-- Walk speed persistence
local function applyWalkSpeed()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and not hum.Sit then
        hum.WalkSpeed = Settings.WalkSpeed
    end
end

-- Main loop
RunService.RenderStepped:Connect(function()
    applySpeedBoost()
    applyCarFly()
    applyWalkSpeed()
end)

-- UI toggle (Insert)
local uiVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        uiVisible = not uiVisible
        mainFrame.Visible = uiVisible
        if not uiVisible then notif.Visible = false end
        showNotification(uiVisible and "UI shown" or "UI hidden", 1)
    end
end)

showNotification("💋 PROJECT VOID – Loaded! (Insert toggle UI)", 3)
