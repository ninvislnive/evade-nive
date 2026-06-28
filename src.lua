-- Nive Evade BIG CENTER MENU (Xeno Compatible)
-- Все функции включены по умолчанию
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

local Settings = {
    AutoFarm = true,
    AutoTrick = true,
    ESP = true,
    AutoDodge = true,
    GodMode = true,
    NoClip = true,
    Flight = false,
    InfJump = true,
    Speed = 50,
    MenuOpen = true
}

-- ==================== БОЛЬШОЕ МЕНЮ ПО ЦЕНТРУ ====================
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "NiveEvadeBIG"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 380)
main.Position = UDim2.new(0.5, -150, 0.5, -190) -- ЦЕНТР
main.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(200, 100, 255)
main.Visible = Settings.MenuOpen

-- Пульсирующая рамка
spawn(function()
    while main and main.Parent do
        local r = math.sin(tick() * 5) * 0.3 + 0.7
        main.BorderColor3 = Color3.fromRGB(200 * r, 100 * r, 255)
        task.wait()
    end
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🌌 NIVE EVADE"
title.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SciFi
title.TextSize = 20
title.BorderSizePixel = 0

local list = Instance.new("ScrollingFrame", main)
list.Size = UDim2.new(1, -10, 1, -50)
list.Position = UDim2.new(0, 5, 0, 45)
list.CanvasSize = UDim2.new(0, 0, 0, 320)
list.ScrollBarThickness = 4
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0, 6)

local function addToggle(text, key)
    local btn = Instance.new("TextButton", list)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Text = "  " .. text .. ": ON"
    btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80, 60, 120)
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = "  " .. text .. ": " .. (Settings[key] and "ON" or "OFF")
    end)
    return btn
end

addToggle("Auto Farm Coins", "AutoFarm")
addToggle("Auto Trick", "AutoTrick")
addToggle("ESP (Highlight)", "ESP")
addToggle("Auto Dodge", "AutoDodge")
addToggle("God Mode", "GodMode")
addToggle("NoClip", "NoClip")
addToggle("Flight", "Flight")
addToggle("Inf Jump", "InfJump")

-- SPEED
local speedFrame = Instance.new("Frame", list)
speedFrame.Size = UDim2.new(1, 0, 0, 36)
speedFrame.BackgroundTransparency = 1
local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0, 80, 1, 0)
speedLabel.Text = "Speed: " .. Settings.Speed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 14
local speedInput = Instance.new("TextBox", speedFrame)
speedInput.Size = UDim2.new(1, -85, 1, 0)
speedInput.Position = UDim2.new(0, 85, 0, 0)
speedInput.Text = tostring(Settings.Speed)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.SourceSans
speedInput.BorderSizePixel = 1
speedInput.BorderColor3 = Color3.fromRGB(80, 60, 120)
speedInput.FocusLost:Connect(function()
    local num = tonumber(speedInput.Text)
    if num then Settings.Speed = num; speedLabel.Text = "Speed: " .. num end
end)

-- ==================== ФУНКЦИИ ====================
local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") end

local function autoFarm()
    if not Settings.AutoFarm then return end
    local root = getRoot() if not root then return end
    local nearest, ndist = nil, 500
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj.Name == "Coin" or obj.Name:lower():find("coin")) and obj:IsA("BasePart") and obj.Transparency < 0.9 then
            local dist = (root.Position - obj.Position).Magnitude
            if dist < ndist then ndist = dist; nearest = obj end
        end
    end
    if nearest then root.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 2, 0)); task.wait(0.2); fireclickdetector(nearest) end
end

local function autoTrick()
    if not Settings.AutoTrick then return end
    local hum = getHum()
    if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
        VIM:SendKeyEvent(true, Enum.KeyCode.R, false, nil); task.wait(0.05)
        VIM:SendKeyEvent(false, Enum.KeyCode.R, false, nil)
    end
end

local function esp()
    if not Settings.ESP then
        for _, v in ipairs(Workspace:GetDescendants()) do if v.Name=="ESP_Tag" and v:IsA("BillboardGui") then v:Destroy() end end
        return
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("nextbot") or obj.Name:lower():find("bot")) and not obj:FindFirstChild("ESP_Tag") then
            local bb = Instance.new("BillboardGui", obj); bb.Name="ESP_Tag"; bb.Adornee=obj; bb.Size=UDim2.new(0,100,0,20); bb.AlwaysOnTop=true
            local tl = Instance.new("TextLabel", bb); tl.Size=UDim2.new(1,0,1,0); tl.BackgroundTransparency=1; tl.Text="BOT"; tl.TextColor3=Color3.new(1,0,0); tl.Font=Enum.Font.SourceSansBold; tl.TextSize=12
        end
        if (obj.Name=="Coin" or obj.Name:lower():find("coin")) and obj:IsA("BasePart") and not obj:FindFirstChild("ESP_Tag") then
            local bb = Instance.new("BillboardGui", obj); bb.Name="ESP_Tag"; bb.Adornee=obj; bb.Size=UDim2.new(0,100,0,20); bb.AlwaysOnTop=true
            local tl = Instance.new("TextLabel", bb); tl.Size=UDim2.new(1,0,1,0); tl.BackgroundTransparency=1; tl.Text="COIN"; tl.TextColor3=Color3.new(0,1,0); tl.Font=Enum.Font.SourceSansBold; tl.TextSize=12
        end
    end
end

local function autoDodge()
    if not Settings.AutoDodge then return end
    local root = getRoot() if not root then return end
    local nearest, ndist = nil, 30
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("nextbot") or obj.Name:lower():find("bot")) then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if hrp then local dist = (root.Position - hrp.Position).Magnitude; if dist < ndist then ndist = dist; nearest = hrp end end
        end
    end
    if nearest then
        local dir = (root.Position - nearest.Position).Unit * 60 + Vector3.new(0, 20, 0)
        local bv = Instance.new("BodyVelocity", root); bv.Velocity = dir; bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        game.Debris:AddItem(bv, 0.2)
    end
end

local function flight()
    if not Settings.Flight then return end
    local root = getRoot(); local hum = getHum() if not root or not hum then return end
    hum.PlatformStand = true
    local bf = root:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", root)
    bf.Name = "FlyVel"; bf.MaxForce = Vector3.new(1e5,1e5,1e5)
    local dir = Vector3.new(); local cam = Workspace.CurrentCamera
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir += Vector3.new(0,-1,0) end
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

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- Main loop
RunService.Heartbeat:Connect(function()
    pcall(autoFarm); pcall(autoTrick); pcall(esp); pcall(autoDodge); pcall(flight); pcall(godMode); pcall(noclip)
    if Settings.InfJump then local hum = getHum() if hum and UserInputService:IsKeyDown(Enum.KeyCode.Space) then hum.Jump = true end end
    local hum = getHum() if hum then hum.WalkSpeed = Settings.Speed end
end)

print("Nive Evade BIG CENTER MENU загружен!")
