-- MAZER HUB Arsenal v5 - Enhanced GUI với giao diện hiện đại và nhiều tính năng mới

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local Drawing = Drawing
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Anti-ban nâng cao
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local namecall = mt.__namecall
    local banned = {"Kick", "crash", "Shutdown", "Ban"}
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if table.find(banned, method) or tostring(self):lower():find("log") or tostring(self):lower():find("anti") then
            return nil
        end
        return namecall(self, ...)
    end)
    LocalPlayer.Kick = function() return nil end
    hookfunction(LocalPlayer.Kick, function() return nil end)
end)

-- Notification System
local function createNotification(title, text, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(1, -320, 0, 20)
    notif.BackgroundColor3 = Color3.fromRGB(25, 35, 45)
    notif.BorderSizePixel = 0
    notif.Parent = CoreGui
    
    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 8)
    
    local titleLabel = Instance.new("TextLabel", notif)
    titleLabel.Size = UDim2.new(1, -10, 0, 25)
    titleLabel.Position = UDim2.new(0, 5, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local textLabel = Instance.new("TextLabel", notif)
    textLabel.Size = UDim2.new(1, -10, 0, 45)
    textLabel.Position = UDim2.new(0, 5, 0, 25)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 12
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    
    -- Animation
    notif:TweenPosition(UDim2.new(1, -320, 0, 20), "Out", "Quad", 0.5, true)
    
    game:GetService("Debris"):AddItem(notif, duration or 3)
    
    spawn(function()
        wait((duration or 3) - 0.5)
        notif:TweenPosition(UDim2.new(1, 10, 0, 20), "In", "Quad", 0.5, true)
    end)
end

-- GUI Setup với thiết kế hiện đại
local gui = Instance.new("ScreenGui")
gui.Name = "MazerHubUI_v5"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

-- Backdrop blur effect
local backdrop = Instance.new("Frame", gui)
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.new(0, 0, 0)
backdrop.BackgroundTransparency = 0.3
backdrop.Visible = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 650, 0, 520)
main.Position = UDim2.new(0.5, -325, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(18, 25, 35)
main.BorderSizePixel = 0
main.ClipsDescendants = true

-- Gradient background
local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 35, 50))
}
gradient.Rotation = 45

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 15)

-- Animated border
local border = Instance.new("UIStroke", main)
border.Color = Color3.fromRGB(0, 255, 127)
border.Thickness = 2
border.Transparency = 0.7

-- Title bar với gradient
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
local titleGradient = Instance.new("UIGradient", titleBar)
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 127)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
}
titleGradient.Rotation = 90

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 15)

-- Icon và title
local iconLabel = Instance.new("TextLabel", titleBar)
iconLabel.Size = UDim2.new(0, 60, 1, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "⚡"
iconLabel.Font = Enum.Font.GothamBlack
iconLabel.TextSize = 32
iconLabel.TextColor3 = Color3.new(1, 1, 1)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 60, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MAZER HUB Arsenal v5 - PREMIUM"
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Status indicator
local statusDot = Instance.new("Frame", titleBar)
statusDot.Size = UDim2.new(0, 12, 0, 12)
statusDot.Position = UDim2.new(1, -80, 0.5, -6)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
statusDot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner", statusDot)
dotCorner.CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel", titleBar)
statusLabel.Size = UDim2.new(0, 60, 1, 0)
statusLabel.Position = UDim2.new(1, -60, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "ONLINE"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 10
statusLabel.TextColor3 = Color3.new(1, 1, 1)

-- Close và minimize buttons
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 15)

local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
minimizeBtn.Text = "−"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.AutoButtonColor = false
local minCorner = Instance.new("UICorner", minimizeBtn)
minCorner.CornerRadius = UDim.new(0, 15)

local isMinimized = false
closeBtn.MouseButton1Click:Connect(function()
    createNotification("MAZER HUB", "Đã đóng MAZER HUB Arsenal v5", 2)
    gui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 650, 0, 60) or UDim2.new(0, 650, 0, 520)
    main:TweenSize(targetSize, "Out", "Quad", 0.3, true)
    backdrop.Visible = not isMinimized
end)

-- Sidebar navigation
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 150, 1, -60)
sidebar.Position = UDim2.new(0, 0, 0, 60)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
local sidebarCorner = Instance.new("UICorner", sidebar)
sidebarCorner.CornerRadius = UDim.new(0, 10)

-- Content area
local contentArea = Instance.new("Frame", main)
contentArea.Size = UDim2.new(1, -160, 1, -70)
contentArea.Position = UDim2.new(0, 160, 0, 60)
contentArea.BackgroundTransparency = 1

-- Navigation buttons và pages
local navButtons = {}
local pages = {}
local currentPage = nil

local navData = {
    {name = "ESP", icon = "👁️", desc = "Wallhack & Visual"},
    {name = "Combat", icon = "⚔️", desc = "Aimbot & Weapons"},
    {name = "Movement", icon = "🏃", desc = "Speed & Teleport"},
    {name = "Misc", icon = "🔧", desc = "Utilities"},
    {name = "VIP", icon = "💎", desc = "Premium Features"},
    {name = "Settings", icon = "⚙️", desc = "Configuration"}
}

-- Function tạo navigation button
local function createNavButton(data, index)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.Position = UDim2.new(0, 5, 0, 10 + (index - 1) * 55)
    btn.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
    btn.AutoButtonColor = false
    btn.Text = ""
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    local icon = Instance.new("TextLabel", btn)
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = data.icon
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 18
    icon.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, -50, 0, 20)
    label.Position = UDim2.new(0, 40, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = data.name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local desc = Instance.new("TextLabel", btn)
    desc.Size = UDim2.new(1, -50, 0, 15)
    desc.Position = UDim2.new(0, 40, 0, 25)
    desc.BackgroundTransparency = 1
    desc.Text = data.desc
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 10
    desc.TextColor3 = Color3.fromRGB(120, 120, 120)
    desc.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Page tương ứng
    local page = Instance.new("ScrollingFrame", contentArea)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 127)
    page.CanvasSize = UDim2.new(0, 0, 0, 800)
    page.Visible = false
    
    navButtons[data.name] = {btn = btn, icon = icon, label = label, desc = desc}
    pages[data.name] = page
    
    btn.MouseButton1Click:Connect(function()
        switchPage(data.name)
    end)
    
    return page
end

-- Function chuyển page
function switchPage(pageName)
    for name, elements in pairs(navButtons) do
        if name == pageName then
            elements.btn.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
            elements.icon.TextColor3 = Color3.new(0, 0, 0)
            elements.label.TextColor3 = Color3.new(0, 0, 0)
            elements.desc.TextColor3 = Color3.fromRGB(50, 50, 50)
        else
            elements.btn.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
            elements.icon.TextColor3 = Color3.fromRGB(150, 150, 150)
            elements.label.TextColor3 = Color3.fromRGB(200, 200, 200)
            elements.desc.TextColor3 = Color3.fromRGB(120, 120, 120)
        end
    end
    
    for name, page in pairs(pages) do
        page.Visible = (name == pageName)
    end
    
    currentPage = pageName
end

-- Tạo tất cả pages
for i, data in ipairs(navData) do
    createNavButton(data, i)
end

-- Enhanced Toggle với animation
local function createEnhancedToggle(parent, text, desc, callback, yPos)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -20, 0, 70)
    container.Position = UDim2.new(0, 10, 0, yPos or 10)
    container.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
    container.BorderSizePixel = 0
    local containerCorner = Instance.new("UICorner", container)
    containerCorner.CornerRadius = UDim.new(0, 10)
    
    local titleLabel = Instance.new("TextLabel", container)
    titleLabel.Size = UDim2.new(1, -80, 0, 25)
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local descLabel = Instance.new("TextLabel", container)
    descLabel.Size = UDim2.new(1, -80, 0, 20)
    descLabel.Position = UDim2.new(0, 15, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle switch
    local toggleFrame = Instance.new("Frame", container)
    toggleFrame.Size = UDim2.new(0, 50, 0, 25)
    toggleFrame.Position = UDim2.new(1, -65, 0, 22)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    local toggleCorner = Instance.new("UICorner", toggleFrame)
    toggleCorner.CornerRadius = UDim.new(0, 12)
    
    local toggleButton = Instance.new("Frame", toggleFrame)
    toggleButton.Size = UDim2.new(0, 21, 0, 21)
    toggleButton.Position = UDim2.new(0, 2, 0, 2)
    toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)
    local buttonCorner = Instance.new("UICorner", toggleButton)
    buttonCorner.CornerRadius = UDim.new(0, 10)
    
    local state = false
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if state then
            TweenService:Create(toggleFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 255, 127)}):Play()
            TweenService:Create(toggleButton, tweenInfo, {Position = UDim2.new(0, 27, 0, 2)}):Play()
            titleLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
        else
            TweenService:Create(toggleFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(toggleButton, tweenInfo, {Position = UDim2.new(0, 2, 0, 2)}):Play()
            titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        callback(state)
        createNotification("Feature Toggle", text .. " " .. (state and "enabled" or "disabled"), 2)
    end)
    
    return container
end

-- Enhanced Slider
local function createEnhancedSlider(parent, text, desc, min, max, default, callback, yPos)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -20, 0, 80)
    container.Position = UDim2.new(0, 10, 0, yPos or 10)
    container.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
    local containerCorner = Instance.new("UICorner", container)
    containerCorner.CornerRadius = UDim.new(0, 10)
    
    local titleLabel = Instance.new("TextLabel", container)
    titleLabel.Size = UDim2.new(0.7, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel", container)
    valueLabel.Size = UDim2.new(0.3, -15, 0, 25)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 10)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local descLabel = Instance.new("TextLabel", container)
    descLabel.Size = UDim2.new(1, -30, 0, 20)
    descLabel.Position = UDim2.new(0, 15, 0, 30)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderFrame = Instance.new("Frame", container)
    sliderFrame.Size = UDim2.new(1, -30, 0, 6)
    sliderFrame.Position = UDim2.new(0, 15, 0, 55)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 50, 65)
    local sliderCorner = Instance.new("UICorner", sliderFrame)
    sliderCorner.CornerRadius = UDim.new(0, 3)
    
    local fill = Instance.new("Frame", sliderFrame)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(0, 3)
    
    local dragging = false
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            local percentage = pos / sliderFrame.AbsoluteSize.X
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            local value = min + percentage * (max - min)
            valueLabel.Text = string.format("%.1f", value)
            callback(value)
        end
    end)
    
    return container
end

-- VARIABLES
local espEnabled, tracerEnabled, hitboxEnabled, nametagEnabled = false, false, false, false
local aimbotEnabled, silentAimEnabled, triggerBotEnabled = false, false, false
local speedEnabled, jumpPowerEnabled, noclipEnabled, teleportEnabled = false, false, false, false
local infiniteAmmoEnabled, noRecoilEnabled, rapidFireEnabled = false, false, false, false

local hitboxSize = 8
local aimFOV = 100
local aimSensitivity = 0.4
local walkSpeed = 50
local jumpPower = 100

-- ESP System
local espObjects = {}

local function createESPForPlayer(player)
    if espObjects[player] then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Filled = false
    box.Thickness = 2
    box.Color = Color3.fromRGB(0, 255, 127)
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1.5
    tracer.Color = Color3.fromRGB(255, 255, 0)
    
    local nametag = Drawing.new("Text")
    nametag.Visible = false
    nametag.Size = 16
    nametag.Color = Color3.fromRGB(255, 255, 255)
    nametag.Font = 2
    nametag.Text = player.Name
    
    espObjects[player] = {
        box = box,
        tracer = tracer,
        nametag = nametag
    }
end

local function removeESPForPlayer(player)
    if espObjects[player] then
        espObjects[player].box:Remove()
        espObjects[player].tracer:Remove()
        espObjects[player].nametag:Remove()
        espObjects[player] = nil
    end
end

-- Update ESP
RunService.RenderStepped:Connect(function()
    for player, objects in pairs(espObjects) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local humanoidRootPart = character.HumanoidRootPart
            local head = character:FindFirstChild("Head")
            
            local pos, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if onScreen and player.Team ~= LocalPlayer.Team then
                -- ESP Box
                if espEnabled then
                    local headPos = Camera:WorldToViewportPoint(head.Position)
                    local legPos = Camera:WorldToViewportPoint((humanoidRootPart.CFrame * CFrame.new(0, -3, 0)).Position)
                    
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height * 0.6
                    
                    objects.box.Size = Vector2.new(width, height)
                    objects.box.Position = Vector2.new(pos.X - width/2, headPos.Y)
                    objects.box.Visible = true
                else
                    objects.box.Visible = false
                end
                
                -- Tracer
                if tracerEnabled then
                    objects.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    objects.tracer.To = Vector2.new(pos.X, pos.Y)
                    objects.tracer.Visible = true
                else
                    objects.tracer.Visible = false
                end
                
                -- Nametag
                if nametagEnabled then
                    objects.nametag.Position = Vector2.new(pos.X, pos.Y - 40)
                    objects.nametag.Visible = true
                else
                    objects.nametag.Visible = false
                end
                
                -- Hitbox expansion
                if hitboxEnabled then
                    humanoidRootPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    humanoidRootPart.Transparency = 0.7
                    humanoidRootPart.CanCollide = false
                else
                    humanoidRootPart.Size = Vector3.new(2, 2, 1)
                    humanoidRootPart.Transparency = 0
                    humanoidRootPart.CanCollide = true
                end
            else
                objects.box.Visible = false
                objects.tracer.Visible = false
                objects.nametag.Visible = false
            end
        else
            removeESPForPlayer(player)
        end
    end
end)

-- Player connections
Players.PlayerAdded:Connect(createESPForPlayer)
Players.PlayerRemoving:Connect(removeESPForPlayer)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESPForPlayer(player)
    end
end

-- Aimbot system
local fovCircle = Drawing.new("Circle")
fovCircle.Radius = aimFOV
fovCircle.Color = Color3.fromRGB(0, 255, 127)
fovCircle.Transparency = 0.8
fovCircle.Thickness = 2
fovCircle.Visible = false

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = aimFOV
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Aimbot update
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    fovCircle.Position = mousePos
    
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local targetPos = head.Position
            local direction = (targetPos - Camera.CFrame.Position).Unit
            local newCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
            Camera.CFrame = Camera.CFrame:Lerp(newCFrame, aimSensitivity)
        end
    end
    
    if silentAimEnabled then
        local target = getClosestPlayer()
        if target and target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:TakeDamage(20)
            end
        end
    end
end)

-- Movement enhancements
local function updateMovement()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        
        if speedEnabled then
            humanoid.WalkSpeed = walkSpeed
        else
            humanoid.WalkSpeed = 16
        end
        
        if jumpPowerEnabled then
            humanoid.JumpPower = jumpPower
        else
            humanoid.JumpPower = 50
        end
    end
end

RunService.Heartbeat:Connect(updateMovement)

-- Noclip
local noclipConnection
local function toggleNoclip(enabled)
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if enabled and LocalPlayer.Character then
        noclipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
    elseif LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Teleport to mouse
local function teleportToMouse()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Hit then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
        end
    end
end

-- Weapon modifications
local function modifyWeapons()
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                -- Infinite ammo
                if infiniteAmmoEnabled then
                    local ammoValue = tool:FindFirstChild("Ammo")
                    if ammoValue and ammoValue:IsA("IntValue") then
                        ammoValue.Value = 999
                    end
                end
                
                -- No recoil
                if noRecoilEnabled then
                    local recoilScript = tool:FindFirstChild("RecoilScript")
                    if recoilScript then
                        recoilScript.Disabled = true
                    end
                end
                
                -- Rapid fire
                if rapidFireEnabled then
                    local fireRate = tool:FindFirstChild("FireRate")
                    if fireRate and fireRate:IsA("NumberValue") then
                        fireRate.Value = 0.01
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(modifyWeapons)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T and teleportEnabled then
        teleportToMouse()
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, 650, 0, 60) or UDim2.new(0, 650, 0, 520)
        main:TweenSize(targetSize, "Out", "Quad", 0.3, true)
    end
end)

-- ESP PAGE
local yOffset = 10
createEnhancedToggle(pages["ESP"], "ESP Boxes", "Hiển thị hộp viền xung quanh kẻ địch", function(state)
    espEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedToggle(pages["ESP"], "Tracer Lines", "Vẽ đường thẳng từ giữa màn hình đến kẻ địch", function(state)
    tracerEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedToggle(pages["ESP"], "Name Tags", "Hiển thị tên người chơi phía trên đầu", function(state)
    nametagEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedToggle(pages["ESP"], "Hitbox Expansion", "Mở rộng hitbox của kẻ địch để dễ bắn hơn", function(state)
    hitboxEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedSlider(pages["ESP"], "Hitbox Size", "Kích thước hitbox mở rộng", 2, 20, hitboxSize, function(value)
    hitboxSize = value
end, yOffset)

-- COMBAT PAGE
yOffset = 10
createEnhancedToggle(pages["Combat"], "Aimbot", "Tự động nhắm mục tiêu gần nhất", function(state)
    aimbotEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedToggle(pages["Combat"], "Silent Aim", "Bắn trúng mục tiêu mà không cần nhắm", function(state)
    silentAimEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedToggle(pages["Combat"], "Show FOV Circle", "Hiển thị vòng tròn phạm vi aimbot", function(state)
    fovCircle.Visible = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedSlider(pages["Combat"], "Aim FOV", "Phạm vi tự động nhắm", 20, 300, aimFOV, function(value)
    aimFOV = value
    fovCircle.Radius = value
end, yOffset)
yOffset = yOffset + 90

createEnhancedSlider(pages["Combat"], "Aim Sensitivity", "Độ mượt của aimbot", 0.1, 1, aimSensitivity, function(value)
    aimSensitivity = value
end, yOffset)

-- MOVEMENT PAGE
yOffset = 10
createEnhancedToggle(pages["Movement"], "Speed Hack", "Tăng tốc độ di chuyển", function(state)
    speedEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedToggle(pages["Movement"], "Jump Power", "Tăng lực nhảy", function(state)
    jumpPowerEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedToggle(pages["Movement"], "Noclip", "Đi xuyên tường", function(state)
    noclipEnabled = state
    toggleNoclip(state)
end, yOffset)
yOffset = yOffset + 80

createEnhancedToggle(pages["Movement"], "Teleport (T)", "Nhấn T để teleport đến vị trí chuột", function(state)
    teleportEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedSlider(pages["Movement"], "Walk Speed", "Tốc độ di chuyển", 16, 200, walkSpeed, function(value)
    walkSpeed = value
end, yOffset)
yOffset = yOffset + 90

createEnhancedSlider(pages["Movement"], "Jump Power", "Lực nhảy", 50, 300, jumpPower, function(value)
    jumpPower = value
end, yOffset)

-- MISC PAGE
yOffset = 10
createEnhancedToggle(pages["Misc"], "Infinite Ammo", "Đạn không giới hạn", function(state)
    infiniteAmmoEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedToggle(pages["Misc"], "No Recoil", "Loại bỏ giật súng", function(state)
    noRecoilEnabled = state
end, yOffset)
yOffset = yOffset + 80

createEnhancedToggle(pages["Misc"], "Rapid Fire", "Bắn siêu nhanh", function(state)
    rapidFireEnabled = state
end, yOffset)
yOffset = yOffset + 80

-- VIP PAGE
yOffset = 10
local vipLabel = Instance.new("TextLabel", pages["VIP"])
vipLabel.Size = UDim2.new(1, -20, 0, 100)
vipLabel.Position = UDim2.new(0, 10, 0, yOffset)
vipLabel.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
vipLabel.Text = "💎 VIP FEATURES 💎\n\nCác tính năng VIP sẽ được cập nhật trong phiên bản tiếp theo!\nHãy theo dõi để có những tính năng độc quyền."
vipLabel.Font = Enum.Font.GothamBold
vipLabel.TextSize = 16
vipLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
vipLabel.TextWrapped = true
local vipCorner = Instance.new("UICorner", vipLabel)
vipCorner.CornerRadius = UDim.new(0, 10)

-- SETTINGS PAGE
yOffset = 10
local settingsLabel = Instance.new("TextLabel", pages["Settings"])
settingsLabel.Size = UDim2.new(1, -20, 0, 150)
settingsLabel.Position = UDim2.new(0, 10, 0, yOffset)
settingsLabel.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
settingsLabel.Text = "⚙️ MAZER HUB SETTINGS ⚙️\n\nHotkeys:\n• Ctrl - Toggle GUI\n• T - Teleport to mouse (khi bật)\n\nTính năng:\n• Anti-ban tích hợp\n• Giao diện hiện đại\n• Hiệu ứng mượt mà\n• Tối ưu hiệu suất"
settingsLabel.Font = Enum.Font.Gotham
settingsLabel.TextSize = 14
settingsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
settingsLabel.TextWrapped = true
settingsLabel.TextYAlignment = Enum.TextYAlignment.Top
local settingsCorner = Instance.new("UICorner", settingsLabel)
settingsCorner.CornerRadius = UDim.new(0, 10)

-- Mở trang ESP mặc định
switchPage("ESP")

-- Tạo hiệu ứng draggable cho GUI
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Startup notification
createNotification("MAZER HUB", "Arsenal v5 đã được tải thành công!", 3)

print("🚀 MAZER HUB Arsenal v5 - Enhanced GUI loaded successfully!")
print("📧 Features: ESP, Combat, Movement, Misc, VIP")
print("🔧 Press Ctrl to toggle GUI, T for teleport")
print("💡 Made with ❤️ by MAZER TEAM")
