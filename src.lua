-- Nive Evade Creator Edition (Xeno Compatible)
-- Только для создателя. Введите пароль.
local CreatorPassword = 0908

-- ================= ПРОВЕРКА ПАРОЛЯ =================
local function checkCreator()
    local gui = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 260, 0, 120)
    frame.Position = UDim2.new(0.5, -130, 0.5, -60)
    frame.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(160, 80, 255)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Text = "NIVE CREATOR EDITION"
    label.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SciFi
    label.TextSize = 14

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1, -20, 0, 30)
    input.Position = UDim2.new(0, 10, 0, 40)
    input.Text = ""
    input.PlaceholderText = "Введите пароль создателя"
    input.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.SourceSans
    input.BorderSizePixel = 1
    input.BorderColor3 = Color3.fromRGB(120, 100, 180)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 80)
    btn.Text = "ВОЙТИ"
    btn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(160, 120, 220)

    local result = nil
    btn.MouseButton1Click:Connect(function()
        result = input.Text
        gui:Destroy()
    end)
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            result = input.Text
            gui:Destroy()
        end
    end)
    repeat task.wait() until result ~= nil
    return result == CreatorPassword
end

if not checkCreator() then
    game.Players.LocalPlayer:Kick("Только для создателя Nive")
    return
end

-- ================= НАСТРОЙКИ =================
local Settings = {
    -- Farm
    AutoFarm = true,
    AutoTrick = true,
    ESP = true,
    AutoDodge = true,
    -- Combat
    KillAura = false,
    SuperJump = false,
    -- Visual
    Speed = 50,
    InfJump = true,
    Flight = false,
    NoClip = true,
    GodMode = true,
    -- Teleport
    TeleportTarget = "Coin",
    CustomX = 0, CustomY = 0, CustomZ = 0,
    -- System
    AntiAFK = true,
    AntiBan = true,
    MenuOpen = true,
    LastAction = 0,
    ActionDelay = 0.3
}

-- ================= ГЛАВНЫЙ GUI (10 вкладок) =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NiveEvadeCreator"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 340, 0, 420)
main.Position = UDim2.new(0, 20, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
main.BorderSizePixel = 1
main.BorderColor3 = Color3.fromRGB(160, 80, 255)
main.Visible = Settings.MenuOpen

-- Пульсирующая рамка
spawn(function()
    while main and main.Parent do
        local r = math.sin(tick() * 5) * 0.3 + 0.7
        main.BorderColor3 = Color3.fromRGB(160 * r, 80 * r, 255)
        task.wait()
    end
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🌌 NIVE EVADE CREATOR"
title.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SciFi
title.TextSize = 16
title.BorderSizePixel = 0

-- Вкладки
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1, 0, 0, 28)
tabFrame.Position = UDim2.new(0, 0, 0, 32)
tabFrame.BackgroundTransparency = 1

local tabNames = {"Farm", "Combat", "Visual", "Defense", "Teleport", "Fun", "Server", "Settings", "Credits"}
local tabBtns = {}
local contents = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1 / #tabNames, -1, 1, 0)
    btn.Position = UDim2.new((i - 1) / #tabNames, 1, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(100, 50, 150) or Color3.fromRGB(50, 40, 80)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 9
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(120, 100, 180)
    table.insert(tabBtns, btn)

    local content = Instance.new("ScrollingFrame", main)
    content.Size = UDim2.new(1, 0, 1, -66)
    content.Position = UDim2.new(0, 0, 0, 64)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 4
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = i == 1
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 6)
    table.insert(contents, content)

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabBtns) do b.BackgroundColor3 = Color3.fromRGB(50, 40, 80) end
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
        for _, c in ipairs(contents) do c.Visible = false end
        content.Visible = true
    end)
end

local function addToggle(content, text, key)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -4, 0, 30)
    btn.Text = "  " .. text .. ": " .. (Settings[key] and "ON" or "OFF")
    btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80, 60, 120)
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = "  " .. text .. ": " .. (Settings[key] and "ON" or "OFF")
    end)
    content.CanvasSize += UDim2.new(0, 0, 0, 36)
    return btn
end

local function addButton(content, text, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -4, 0, 30)
    btn.Text = "  " .. text
    btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80, 60, 120)
    btn.MouseButton1Click:Connect(callback)
    content.CanvasSize += UDim2.new(0, 0, 0, 36)
    return btn
end

-- ===== ЗАПОЛНЕНИЕ ВКЛАДОК =====
-- Farm
addToggle(contents[1], "Auto Farm Coins", "AutoFarm")
addToggle(contents[1], "Auto Trick", "AutoTrick")
addToggle(contents[1], "ESP", "ESP")
addToggle(contents[1], "Auto Dodge", "AutoDodge")

-- Combat
addToggle(contents[2], "Kill Aura (Bots)", "KillAura")
addToggle(contents[2], "Super Jump", "SuperJump")

-- Visual
addToggle(contents[3], "Inf Jump", "InfJump")
addToggle(contents[3], "Flight", "Flight")
addToggle(contents[3], "NoClip", "NoClip")
local speedLabel = Instance.new("TextLabel", contents[3])
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Text = "Speed: " .. Settings.Speed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 13
contents[3].CanvasSize += UDim2.new(0, 0, 0, 26)
local speedInput = Instance.new("TextBox", contents[3])
speedInput.Size = UDim2.new(1, -4, 0, 28)
speedInput.Text = tostring(Settings.Speed)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.SourceSans
speedInput.PlaceholderText = "Speed"
speedInput.BorderSizePixel = 1
speedInput.BorderColor3 = Color3.fromRGB(80, 60, 120)
speedInput.FocusLost:Connect(function()
    local num = tonumber(speedInput.Text)
    if num then Settings.Speed = num; speedLabel.Text = "Speed: " .. num end
end)
contents[3].CanvasSize += UDim2.new(0, 0, 0, 36)

-- Defense
addToggle(contents[4], "God Mode", "GodMode")
addToggle(contents[4], "Anti Ban", "AntiBan")

-- Teleport
addButton(contents[5], "Teleport to Coin", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local nearest, ndist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj.Name == "Coin" or obj.Name:lower():find("coin")) and obj:IsA("BasePart") and obj.Transparency < 0.9 then
            local dist = (root.Position - obj.Position).Magnitude
            if dist < ndist then ndist = dist; nearest = obj end
        end
    end
    if nearest then root.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 2, 0)) end
end)
addButton(contents[5], "Teleport to Center", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(0, 10, 0) end
end)

-- Fun (пусто)

-- Server
addButton(contents[7], "Server Hop", function()
    local servers, cursor = {}, ""
    repeat
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100&cursor=" .. cursor
        local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(game:HttpGet(url)) end)
        if ok then
            for _, s in ipairs(data.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then table.insert(servers, s.id) end
            end
            cursor = data.nextPageCursor or ""
        else break end
    until cursor == "" or #servers >= 10
    if #servers > 0 then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer) end
end)

-- Settings
addToggle(contents[8], "Auto Load on Start", "AutoLoad")  -- добавим позже
addButton(contents[8], "Reset All Settings", function()
    for k in pairs(Settings) do if type(Settings[k]) == "boolean" then Settings[k] = false end end
    Settings.Speed = 16
end)

-- Credits
local cred = Instance.new("TextLabel", contents[9])
cred.Size = UDim2.new(1, 0, 0, 80)
cred.Text = "Nive Evade Creator Edition\nCreated by Nive\nSupport: donationalerts.com/r/nive"
cred.TextColor3 = Color3.new(0.8, 0.6, 1)
cred.BackgroundTransparency = 1
cred.Font = Enum.Font.SourceSans
cred.TextSize = 13
cred.TextWrapped = true
contents[9].CanvasSize += UDim2.new(0, 0, 0, 80)

-- ================= АНИМАЦИЯ СКРЫТИЯ (ALT) =================
local blackHole = Instance.new("Frame", gui)
blackHole.Size = UDim2.new(0, 0, 0, 0)
blackHole.Position = UDim2.new(0.5, 0, 0.5, 0)
blackHole.AnchorPoint = Vector2.new(0.5, 0.5)
blackHole.BackgroundColor3 = Color3.new(0, 0, 0)
blackHole.BorderSizePixel = 0
blackHole.Visible = false

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        Settings.MenuOpen = not Settings.MenuOpen
        if Settings.MenuOpen then
            main.Visible = true
            main.BackgroundTransparency = 1
            main.Position = UDim2.new(0, 20, 0, 70)
            game:GetService("TweenService"):Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                BackgroundTransparency = 0,
                Position = UDim2.new(0, 20, 0, 20)
            }):Play()
        else
            blackHole.Size = UDim2.new(0, 0, 0, 0)
            blackHole.BackgroundTransparency = 0
            blackHole.Visible = true
            local expand = game:GetService("TweenService"):Create(blackHole, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 300, 0, 300)
            })
            expand:Play()
            expand.Completed:Connect(function()
                local shrink = game:GetService("TweenService"):Create(blackHole, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 0, 0, 0)
                })
                shrink:Play()
                shrink.Completed:Connect(function()
                    blackHole.Visible = false
                end)
            end)
            game:GetService("TweenService"):Create(main, TweenInfo.new(0.2), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 20, 0, 50)
            }):Play()
            task.wait(0.2)
            main.Visible = false
        end
    end
end)

-- ================= ФУНКЦИИ =================
local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") end
local function canAct()
    if not Settings.AntiBan then return true end
    if tick() - Settings.LastAction >= Settings.ActionDelay then
        Settings.LastAction = tick()
        return true
    end
    return false
end

local function autoFarm()
    if not Settings.AutoFarm or not canAct() then return end
    local root = getRoot() if not root then return end
    local nearest, ndist = nil, 500
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj.Name == "Coin" or obj.Name:lower():find("coin")) and obj:IsA("BasePart") and obj.Transparency < 0.9 then
            local dist = (root.Position - obj.Position).Magnitude
            if dist < ndist then ndist = dist; nearest = obj end
        end
    end
    if nearest then
        game:GetService("TweenService"):Create(root, TweenInfo.new(0.5), {CFrame = CFrame.new(nearest.Position + Vector3.new(0, 2, 0))}):Play()
        task.wait(0.3)
        fireclickdetector(nearest)
    end
end

local function autoTrick()
    if not Settings.AutoTrick then return end
    local hum = getHum()
    if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.R, false, nil)
        task.wait(0.05)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.R, false, nil)
    end
end

local function esp()
    if not Settings.ESP then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "ESP_Tag" and v:IsA("BillboardGui") then v:Destroy() end
        end
        return
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("nextbot") or obj.Name:lower():find("bot")) and not obj:FindFirstChild("ESP_Tag") then
            local bb = Instance.new("BillboardGui", obj); bb.Name = "ESP_Tag"; bb.Adornee = obj; bb.Size = UDim2.new(0, 100, 0, 20); bb.AlwaysOnTop = true
            local tl = Instance.new("TextLabel", bb); tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = "BOT"; tl.TextColor3 = Color3.new(1, 0, 0); tl.Font = Enum.Font.SourceSansBold; tl.TextSize = 12
        end
        if (obj.Name == "Coin" or obj.Name:lower():find("coin")) and obj:IsA("BasePart") and not obj:FindFirstChild("ESP_Tag") then
            local bb = Instance.new("BillboardGui", obj); bb.Name = "ESP_Tag"; bb.Adornee = obj; bb.Size = UDim2.new(0, 100, 0, 20); bb.AlwaysOnTop = true
            local tl = Instance.new("TextLabel", bb); tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = "COIN"; tl.TextColor3 = Color3.new(0, 1, 0); tl.Font = Enum.Font.SourceSansBold; tl.TextSize = 12
        end
    end
end

local function autoDodge()
    if not Settings.AutoDodge or not canAct() then return end
    local root = getRoot() if not root then return end
    local nearest, ndist = nil, 30
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("nextbot") or obj.Name:lower():find("bot")) then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if hrp then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < ndist then ndist = dist; nearest = hrp end
            end
        end
    end
    if nearest then
        local dir = (root.Position - nearest.Position).Unit * 60 + Vector3.new(0, 20, 0)
        local bv = root:FindFirstChild("DodgeVel") or Instance.new("BodyVelocity", root)
        bv.Name = "DodgeVel"; bv.Velocity = dir; bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        task.delay(0.2, function() bv:Destroy() end)
    end
end

local function flight()
    if not Settings.Flight then return end
    local root = getRoot() local hum = getHum() if not root or not hum then return end
    hum.PlatformStand = true
    local bf = root:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", root)
    bf.Name = "FlyVel"; bf.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    local dir = Vector3.new() local cam = workspace.CurrentCamera
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then dir += Vector3.new(0, -1, 0) end
    bf.Velocity = dir * 50
end

local function godMode()
    if not Settings.GodMode then return end
    local char = LocalPlayer.Character if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.Health = hum.MaxHealth; hum.MaxHealth = 1e9; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
    for _, v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
end

local function noclip()
    if not Settings.NoClip then return end
    local char = LocalPlayer.Character if char then for _, v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
end

local function killAura()
    if not Settings.KillAura or not canAct() then return end
    local root = getRoot() if not root then return end
    local nearest, ndist = nil, 30
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("nextbot") or obj.Name:lower():find("bot")) then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if hrp then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < ndist then ndist = dist; nearest = hrp end
            end
        end
    end
    if nearest then
        root.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 2, 0))
        wait(0.1)
        fireclickdetector(nearest.Parent)
    end
end

local function superJump()
    if not Settings.SuperJump then return end
    local hum = getHum() if hum then hum.JumpPower = 100 end
end

-- Anti-AFK
game.Players.LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(0.1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

-- Main loop
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(autoFarm); pcall(autoTrick); pcall(esp); pcall(autoDodge); pcall(flight); pcall(godMode); pcall(noclip); pcall(killAura); pcall(superJump)
    if Settings.InfJump then local hum = getHum() if hum and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then hum.Jump = true end end
    local hum = getHum() if hum then hum.WalkSpeed = Settings.Speed end
end)

print("Nive Evade Creator Edition активирован!")
