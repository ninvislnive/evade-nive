-- Nive Evade ULTIMATE BIG MENU (Horizontal, больше функций, Auto Revive, Bunny Hop + Emote, Flight, Tricks)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/ninvislnive/evade-nive/main/src.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- ==================== НАСТРОЙКИ ====================
local Settings = {
    -- Farm
    AutoRescue = false,
    AutoRevive = false,        -- новое: авто‑возрождение упавших игроков
    AutoBunnyHop = false,
    BunnyHopEmote = false,     -- прыжок с эмоцией
    KeepSpeedOnEmote = false,  -- не терять скорость при эмоции во время бега
    AutoQuest = false,
    AutoFarmLevels = false,
    SafeZoneEnabled = false,
    SafeZoneHeight = 100,
    -- Movement
    Flight = false,
    NoClip = false,
    InfJump = false,
    Speed = 50,
    -- Tricks
    AutoTrick = false,
    TrickMode = "Random",      -- Random, Slide, Dash, Spin
    -- Nive
    AutoLoad = false,
    AutoEmote = false,
    EmoteInterval = 3,
    HideKey = "RightAlt",
    -- Visual
    ESP = false,
    -- Defense
    AntiBan = true,
    ActionDelay = 0.3,
    LastAction = 0,
    MenuOpen = true
}

-- ==================== ЧЁРНАЯ ДЫРА (ИНТРО) ====================
spawn(function()
    local bg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", bg)
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundColor3 = Color3.new(0,0,0)
    f.BackgroundTransparency = 1
    TweenService:Create(f, TweenInfo.new(1.5), {BackgroundTransparency = 0.2}):Play()
    for _=1,20 do
        local p = Instance.new("Frame", bg)
        p.Size = UDim2.new(0,4,0,4)
        p.BackgroundColor3 = Color3.new(1,1,1)
        p.Position = UDim2.new(0.5, math.random(-200,200), 0.5, math.random(-200,200))
        p.AnchorPoint = Vector2.new(0.5,0.5)
        local t = TweenService:Create(p, TweenInfo.new(2, Enum.EasingStyle.InQuad), {
            Position = UDim2.new(0.5,0,0.5,0),
            Size = UDim2.new(0,0,0,0),
            BackgroundTransparency = 1
        })
        t:Play()
        task.delay(2.5, function() p:Destroy() end)
    end
    local logo = Instance.new("TextLabel", bg)
    logo.Size = UDim2.new(0,200,0,50)
    logo.Position = UDim2.new(0.5,-100,0.4,-25)
    logo.Text = "NIVE"
    logo.TextColor3 = Color3.fromRGB(180,100,255)
    logo.Font = Enum.Font.SciFi
    logo.TextSize = 24
    logo.BackgroundTransparency = 1
    logo.TextTransparency = 1
    TweenService:Create(logo, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
    wait(2.5)
    bg:Destroy()
end)

-- ==================== ГЛАВНОЕ МЕНЮ (БОЛЬШОЕ) ====================
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "NiveEvade"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 720, 0, 400)   -- стало ещё больше
main.Position = UDim2.new(0.5, -360, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15,10,30)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(160,80,255)
main.Visible = Settings.MenuOpen
main.Active = true

-- Анимация появления
main.BackgroundTransparency = 1
main.Position = UDim2.new(0.5, -360, 0.5, -150)
TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    BackgroundTransparency = 0,
    Position = UDim2.new(0.5, -360, 0.5, -200)
}):Play()

-- Пульсирующая рамка
spawn(function()
    while main and main.Parent do
        local r = math.sin(tick() * 3) * 0.2 + 0.8
        main.BorderColor3 = Color3.fromRGB(160 * r, 80 * r, 255)
        task.wait()
    end
end)

-- Перетаскивание
local titleBar = Instance.new("TextButton", main)
titleBar.Size = UDim2.new(1, 0, 0, 24)
titleBar.Text = "🌌 NIVE EVADE"
titleBar.BackgroundColor3 = Color3.fromRGB(18, 12, 35)
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SciFi
titleBar.TextSize = 14
titleBar.AutoButtonColor = false

local dragging, dragStart, startPos = false, nil, nil
titleBar.MouseButton1Down:Connect(function()
    dragging = true
    dragStart = UserInputService:GetMouseLocation()
    startPos = main.Position
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = UserInputService:GetMouseLocation() - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ОБЛАСТЬ ВКЛАДОК (слева)
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(0, 140, 1, -24)
tabFrame.Position = UDim2.new(0, 0, 0, 24)
tabFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
tabFrame.BorderSizePixel = 1
tabFrame.BorderColor3 = Color3.fromRGB(100, 50, 150)

local uiListLayout = Instance.new("UIListLayout", tabFrame)
uiListLayout.Padding = UDim.new(0, 4)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ОБЛАСТЬ КОНТЕНТА (справа)
local contentArea = Instance.new("Frame", main)
contentArea.Size = UDim2.new(1, -144, 1, -24)
contentArea.Position = UDim2.new(0, 144, 0, 24)
contentArea.BackgroundTransparency = 1

-- Табы и контент
local tabs = {
    ["Farm"] = {icon = "🚜", funcs = {}},
    ["Movement"] = {icon = "🏃", funcs = {}},
    ["Tricks"] = {icon = "🛹", funcs = {}},
    ["Nive"] = {icon = "🌟", funcs = {}},
    ["Visual"] = {icon = "👁", funcs = {}},
    ["Defense"] = {icon = "🛡", funcs = {}}
}
local tabBtns = {}
local contents = {}

for i, (name, data) in pairs(tabs) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1, -8, 0, 32)
    btn.Text = data.icon .. "  " .. name
    btn.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(120,100,180)
    btn.AutoButtonColor = false
    table.insert(tabBtns, btn)

    local content = Instance.new("ScrollingFrame", contentArea)
    content.Size = UDim2.new(1, 0, 1, 0)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 3
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = i == 1
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 4)
    table.insert(contents, content)

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabBtns) do b.BackgroundColor3 = Color3.fromRGB(30, 25, 50) end
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
        for _, c in ipairs(contents) do c.Visible = false end
        content.Visible = true
    end)
end

-- Помощники UI
local function addToggle(content, text, key)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -4, 0, 28)
    btn.Text = "  " .. text .. ": " .. (Settings[key] and "ON" or "OFF")
    btn.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80,60,120)
    btn.AutoButtonColor = false
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = "  " .. text .. ": " .. (Settings[key] and "ON" or "OFF")
    end)
    content.CanvasSize += UDim2.new(0,0,0,32)
end

local function addSlider(content, text, key, min, max)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, -4, 0, 48)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 16)
    label.Text = text .. ": " .. Settings[key]
    label.TextColor3 = Color3.new(0.8,0.8,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 12
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1, 0, 0, 22)
    input.Position = UDim2.new(0, 0, 0, 18)
    input.Text = tostring(Settings[key])
    input.BackgroundColor3 = Color3.fromRGB(35,25,55)
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = Enum.Font.SourceSans
    input.BorderSizePixel = 1
    input.BorderColor3 = Color3.fromRGB(80,60,120)
    input.FocusLost:Connect(function()
        local num = tonumber(input.Text)
        if num then
            num = math.clamp(num, min, max)
            Settings[key] = num
            input.Text = tostring(num)
            label.Text = text .. ": " .. num
        end
    end)
    content.CanvasSize += UDim2.new(0,0,0,52)
end

local function addButton(content, text, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -4, 0, 28)
    btn.Text = "  " .. text
    btn.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80,60,120)
    btn.AutoButtonColor = false
    btn.MouseButton1Click:Connect(callback)
    content.CanvasSize += UDim2.new(0,0,0,32)
end

-- ==================== ЗАПОЛНЕНИЕ ВКЛАДОК ====================
-- Farm
addToggle(contents[1], "Auto Rescue", "AutoRescue")
addToggle(contents[1], "Auto Revive", "AutoRevive")
addToggle(contents[1], "Auto Bunny Hop", "AutoBunnyHop")
addToggle(contents[1], "Bunny Hop + Emote", "BunnyHopEmote")
addToggle(contents[1], "Keep Speed on Emote", "KeepSpeedOnEmote")
addToggle(contents[1], "Auto Quest", "AutoQuest")
addToggle(contents[1], "Auto Farm Levels", "AutoFarmLevels")
addToggle(contents[1], "Safe Zone (Air)", "SafeZoneEnabled")
addSlider(contents[1], "Safe Zone Height", "SafeZoneHeight", 20, 300)

-- Movement
addToggle(contents[2], "Flight", "Flight")
addToggle(contents[2], "NoClip", "NoClip")
addToggle(contents[2], "Infinite Jump", "InfJump")
addSlider(contents[2], "Walk Speed", "Speed", 16, 200)

-- Tricks
addToggle(contents[3], "Auto Trick", "AutoTrick")
-- здесь можно добавить выбор режима трюка, но для простоты сделаем Random

-- Nive
addToggle(contents[4], "Auto Load (All ON)", "AutoLoad")
addToggle(contents[4], "Auto Emote", "AutoEmote")
addSlider(contents[4], "Emote Interval", "EmoteInterval", 1, 10)
addButton(contents[4], "Set Hide Key", function()
    local conn
    conn = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightAlt or input.KeyCode == Enum.KeyCode.LeftAlt or
           input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.LeftControl then
            Settings.HideKey = input.KeyCode.Name
            conn:Disconnect()
        end
    end)
end)

-- Visual
addToggle(contents[5], "ESP", "ESP")

-- Defense
addToggle(contents[6], "Anti-Ban System", "AntiBan")
addSlider(contents[6], "Action Delay", "ActionDelay", 0.1, 2.0)

-- ==================== ЧЁРНАЯ ДЫРА (СКРЫТИЕ МЕНЮ) ====================
local blackHole = Instance.new("Frame", gui)
blackHole.Size = UDim2.new(0,0,0,0)
blackHole.Position = UDim2.new(0.5,0,0.5,0)
blackHole.AnchorPoint = Vector2.new(0.5,0.5)
blackHole.BackgroundColor3 = Color3.new(0,0,0)
blackHole.BorderSizePixel = 0
blackHole.Visible = false

local function toggleMenu()
    Settings.MenuOpen = not Settings.MenuOpen
    if Settings.MenuOpen then
        main.Visible = true
        main.BackgroundTransparency = 1
        main.Position = UDim2.new(0.5, -360, 0.5, -150)
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            BackgroundTransparency = 0,
            Position = UDim2.new(0.5, -360, 0.5, -200)
        }):Play()
        blackHole.Visible = false
    else
        blackHole.Size = UDim2.new(0,0,0,0)
        blackHole.BackgroundTransparency = 0
        blackHole.Visible = true
        local expand = TweenService:Create(blackHole, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0,300,0,300)
        })
        expand:Play()
        expand.Completed:Connect(function()
            local shrink = TweenService:Create(blackHole, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0,0,0,0)
            })
            shrink:Play()
            shrink.Completed:Connect(function() blackHole.Visible = false end)
        end)
        TweenService:Create(main, TweenInfo.new(0.2), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -360, 0.5, -150)
        }):Play()
        task.wait(0.2)
        main.Visible = false
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local keyName = input.KeyCode.Name
    if keyName == Settings.HideKey then
        toggleMenu()
    end
end)

-- ==================== УТИЛИТЫ ====================
local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") end
local function canAct()
    if not Settings.AntiBan then return true end
    local now = tick()
    if now - Settings.LastAction >= Settings.ActionDelay then
        Settings.LastAction = now + (math.random() * 0.2 - 0.1)
        return true
    end
    return false
end

local function findRescueTarget()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("survivor") then
            local head = obj:FindFirstChild("Head") or obj.PrimaryPart
            if head and head.Position.Y > -100 then
                return head
            end
        end
    end
    return nil
end

-- Поиск упавшего игрока (для возрождения)
local function findDownedPlayer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health <= 0 then -- мёртв/упал
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    return root
                end
            end
        end
    end
    return nil
end

local function findQuestGiver()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local part = obj.Parent
            if part:IsA("BasePart") and part.Position.Y > -100 then
                return part
            end
        end
    end
    return nil
end

local function applySafeZone()
    if not Settings.SafeZoneEnabled then return end
    local root = getRoot() if not root then return end
    local safePos = Vector3.new(0, Settings.SafeZoneHeight, 0)
    if (root.Position - safePos).Magnitude > 5 then
        root.CFrame = CFrame.new(safePos)
    end
end

-- ==================== ФУНКЦИИ ====================
-- Auto Rescue
local lastRescue = 0
local function autoRescue()
    if not Settings.AutoRescue or not canAct() then return end
    if tick() - lastRescue < 1.5 then return end
    local target = findRescueTarget()
    if not target then return end
    lastRescue = tick()
    local root = getRoot() if not root then return end
    root.CFrame = CFrame.new(target.Position + Vector3.new(0,3,0))
    task.wait(0.2)
    fireclickdetector(target)
end

-- Auto Revive (телепорт к упавшему игроку и взаимодействие)
local lastRevive = 0
local function autoRevive()
    if not Settings.AutoRevive or not canAct() then return end
    if tick() - lastRevive < 2 then return end
    local target = findDownedPlayer()
    if not target then return end
    lastRevive = tick()
    local root = getRoot() if not root then return end
    root.CFrame = CFrame.new(target.Position + Vector3.new(0,2,0))
    task.wait(0.2)
    -- взаимодействие (обычно клик)
    fireclickdetector(target.Parent) -- клик по персонажу
end

-- Auto Bunny Hop + Emote
local function autoBunnyHop()
    if not Settings.AutoBunnyHop then return end
    local hum = getHum() if not hum then return end
    local root = getRoot() if not root then return end

    if hum:GetState() == Enum.HumanoidStateType.Running or hum:GetState() == Enum.HumanoidStateType.Landed then
        -- прыжок
        hum.Jump = true

        -- рывок для эффекта dash
        if root then
            local vel = Instance.new("BodyVelocity")
            vel.Velocity = root.CFrame.LookVector * 30
            vel.MaxForce = Vector3.new(1e5, 0, 1e5)
            vel.Parent = root
            game.Debris:AddItem(vel, 0.1)
        end

        -- если включён режим с эмоцией
        if Settings.BunnyHopEmote then
            -- сохраняем скорость если нужно
            if Settings.KeepSpeedOnEmote then
                local humSpeed = hum.WalkSpeed
                -- при эмоции скорость не сбрасывается (уже установлена)
                hum.WalkSpeed = humSpeed
            end
            -- автоматическая эмоция (случайная)
            local emoteKeys = {Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three}
            VIM:SendKeyEvent(true, emoteKeys[math.random(#emoteKeys)], false, nil)
            VIM:SendKeyEvent(false, emoteKeys[math.random(#emoteKeys)], false, nil)
        end
    end
end

-- Auto Quest
local lastQuest = 0
local function autoQuest()
    if not Settings.AutoQuest or not canAct() then return end
    if tick() - lastQuest < 3 then return end
    local npc = findQuestGiver()
    if not npc then return end
    lastQuest = tick()
    local root = getRoot() if not root then return end
    root.CFrame = CFrame.new(npc.Position + Vector3.new(0,3,0))
    task.wait(0.3)
    local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt")
    if prompt then
        fireproximityprompt(prompt)
    end
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local questFrame = playerGui:FindFirstChild("QuestsFrame") or playerGui:FindFirstChild("QuestGui")
    if questFrame then
        for _, child in ipairs(questFrame:GetDescendants()) do
            if child:IsA("TextButton") and (child.Text:lower():find("claim") or child.Text:lower():find("complete")) then
                fireclickdetector(child)
            end
        end
    end
end

-- Auto Farm Levels
local function autoFarmLevels()
    if not Settings.AutoFarmLevels or not canAct() then return end
    local root = getRoot() if not root then return end
    local nearest, ndist = nil, 50
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("nextbot") or obj.Name:lower():find("bot")) and obj:FindFirstChild("Head") then
            local head = obj.Head
            local dist = (root.Position - head.Position).Magnitude
            if dist < ndist then ndist = dist; nearest = head end
        end
    end
    if nearest then
        root.CFrame = CFrame.new(nearest.Position + Vector3.new(0,2,0))
        task.wait(0.1)
        fireclickdetector(nearest)
        Settings.LastAction = tick()
    end
end

-- Flight
local function flight()
    if not Settings.Flight then return end
    local root = getRoot() local hum = getHum() if not root or not hum then return end
    hum.PlatformStand = true
    local bf = root:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", root)
    bf.Name = "FlyVel"; bf.MaxForce = Vector3.new(1e5,1e5,1e5)
    local dir = Vector3.new() local cam = Workspace.
