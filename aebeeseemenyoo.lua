local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- === ДАННЫЕ (ВШИТЫ) ===
local DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/1495111666017501234/s9OXnSR8-6ztlJJhFheoYxhsapq53ubaEoh7cZW72kKNtwyxB4ufSzzmE7WJN13hk8MO"
local VALID_KEYS = {"skibidi1488", "pidoras", "nigger"}

getgenv().Config = {
    Chams = false, Tracers = false, Health = false,
    Speed = false, SpeedVal = 16,
    FlyEnabled = false, NoclipEnabled = false,
    Transparency = 0.4, Blur = false, RgbCycle = false,
    MenuKey = Enum.KeyCode.Insert, CycleSpeed = 2
}
getgenv().AeeActive = true

-- Кэш
local TracerCache = {}
local Blur = Lighting:FindFirstChild("Aee_Blur") or Instance.new("BlurEffect", Lighting)
Blur.Name = "Aee_Blur"; Blur.Size = 0; Blur.Enabled = false

-- === КРАСИВЫЙ ЛОГГЕР (DISCORD STYLE) ===
local function sendLog(keyUsed)
    task.spawn(function()
        local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request
        if not requestFunc then return end
        local data = {
            ["embeds"] = {{
                ["title"] = "✅ Login Log | Aeebeesee Menyoo",
                ["description"] = "Пользователь зашел в чит",
                ["color"] = 65280,
                ["fields"] = {
                    {["name"] = "👤 Никнейм", ["value"] = "```" .. tostring(LocalPlayer.Name) .. "```", ["inline"] = true},
                    {["name"] = "🔑 Ключ", ["value"] = "```" .. tostring(keyUsed) .. "```", ["inline"] = true},
                    {["name"] = "📅 Дата и время", ["value"] = os.date("%d.%m.%Y | %H:%M:%S"), ["inline"] = false},
                    {["name"] = "🎮 Ссылка на игру", ["value"] = "https://roblox.com" .. tostring(game.PlaceId), ["inline"] = false}
                },
                ["footer"] = {["text"] = "Simple Version Logger"}
            }}
        }
        pcall(function() requestFunc({Url = DISCORD_WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)}) end)
    end)
end

-- === GUI SETUP ===
local Screen = Instance.new("ScreenGui", CoreGui); Screen.Name = "AeePro"
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 280, 0, 480); Main.Position = UDim2.new(0.5, -140, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.BackgroundTransparency = 0.4
Main.Visible = false; Main.BorderSizePixel = 0; Main.Active = true; Main.ClipsDescendants = true
Instance.new("UICorner", Main)

-- Drag
local dS, sP, drag; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dS = i.Position; sP = Main.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end) end end)
UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dS; Main.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y) end end)

-- Headers
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 30); Title.Position = UDim2.new(0,0,0,5); Title.Text = "Aeebeesee Menyoo"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBold"; Title.TextSize = 18; Title.BackgroundTransparency = 1
local Sub = Instance.new("TextLabel", Main); Sub.Size = UDim2.new(1, 0, 0, 15); Sub.Position = UDim2.new(0,0,0,25); Sub.Text = "(simple version)"; Sub.TextColor3 = Color3.fromRGB(200,200,200); Sub.Font = "Gotham"; Sub.TextSize = 12; Sub.BackgroundTransparency = 1

-- Вкладки
local tabs = { ESP = Instance.new("CanvasGroup", Main), PLAYER = Instance.new("CanvasGroup", Main), GUI = Instance.new("CanvasGroup", Main) }
for n, f in pairs(tabs) do f.Size = UDim2.new(1, -20, 1, -110); f.Position = UDim2.new(0, 10, 0, 95); f.BackgroundTransparency = 1; f.GroupTransparency = (n == "ESP" and 0 or 1); f.Visible = (n == "ESP") end

local curT = "ESP"
local function switchTab(t)
    if curT == t then return end
    local old, new = tabs[curT], tabs[t]; curT = t
    TweenService:Create(old, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {GroupTransparency = 1, Position = UDim2.new(0, -10, 0, 95)}):Play()
    task.wait(0.15); old.Visible = false; new.Visible = true; new.Position = UDim2.new(0, 25, 0, 95)
    TweenService:Create(new, TweenInfo.new(0.3, Enum.EasingStyle.Back), {GroupTransparency = 0, Position = UDim2.new(0, 10, 0, 95)}):Play()
end

local function cTabB(txt, x, t) 
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(0, 85, 0, 30); b.Position = UDim2.new(0, x, 0, 55); b.Text = txt; b.Font = "GothamBold"; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() switchTab(t) end) 
end
cTabB("ESP", 5, "ESP"); cTabB("PLAYER", 95, "PLAYER"); cTabB("GUI", 185, "GUI")

local function cTog(txt, y, p, k, cb) 
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, 0, 0, 35); b.Position = UDim2.new(0, 0, 0, y); b.Text = txt .. ": OFF"; b.Font = "GothamBold"; b.TextColor3 = Color3.new(1,1,1); b.BackgroundColor3 = Color3.fromRGB(150, 0, 0); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() getgenv().Config[k] = not getgenv().Config[k]; b.Text = txt .. (getgenv().Config[k] and ": ON" or ": OFF"); TweenService:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = getgenv().Config[k] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)}):Play(); if cb then cb() end end) 
end

-- [ESP]
cTog("CHAMS", 0, tabs.ESP, "Chams"); cTog("TRACERS", 40, tabs.ESP, "Tracers"); cTog("HEALTH", 80, tabs.ESP, "Health")

-- [PLAYER - REJOIN ВЕРНУЛАСЬ]
cTog("SPEED HACK", 0, tabs.PLAYER, "Speed"); cTog("FLY", 40, tabs.PLAYER, "FlyEnabled"); cTog("NOCLIP", 80, tabs.PLAYER, "NoclipEnabled")

local rj = Instance.new("TextButton", tabs.PLAYER)
rj.Size = UDim2.new(1, 0, 0, 35); rj.Position = UDim2.new(0, 0, 0, 125)
rj.Text = "REJOIN SERVER"; rj.Font = "GothamBold"; rj.BackgroundColor3 = Color3.fromRGB(60, 60, 60); rj.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", rj)
rj.MouseButton1Click:Connect(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)

local sInp = Instance.new("TextBox", tabs.PLAYER); sInp.Size = UDim2.new(1,0,0,30); sInp.Position = UDim2.new(0,0,0,165); sInp.PlaceholderText="Speed Value..."; sInp.Text="16"; sInp.BackgroundColor3=Color3.fromRGB(45,45,45); sInp.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", sInp); sInp.FocusLost:Connect(function() getgenv().Config.SpeedVal = tonumber(sInp.Text) or 16 end)

-- [GUI]
local function upB() if getgenv().Config.Blur and Main.Visible then Blur.Enabled = true; TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 20}):Play() else TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play() end end
cTog("BLUR", 0, tabs.GUI, "Blur", upB)

local function cCol(c, x, n) local b = Instance.new("TextButton", tabs.GUI); b.Size = UDim2.new(0, 75, 0, 30); b.Position = UDim2.new(0, x, 0, 45); b.Text = n; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 10; Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() getgenv().Config.RgbCycle = false; TweenService:Create(Main, TweenInfo.new(0.5), {BackgroundColor3 = c}):Play() end) end
cCol(Color3.fromRGB(20,20,20), 0, "Dark"); cCol(Color3.fromRGB(30,40,70), 87, "Blue"); cCol(Color3.fromRGB(50,50,50), 175, "Grey")

cTog("RGB CYCLE", 85, tabs.GUI, "RgbCycle", function() if getgenv().Config.RgbCycle then task.spawn(function() local h = 0 while getgenv().Config.RgbCycle and getgenv().AeeActive do h = h + (1/360); if h > 1 then h = 0 end; Main.BackgroundColor3 = Color3.fromHSV(h, 0.6, 0.7); task.wait(0.05) end end) end end)
local trInp = Instance.new("TextBox", tabs.GUI); trInp.Size = UDim2.new(1,0,0,30); trInp.Position = UDim2.new(0,0,0,130); trInp.PlaceholderText="Transparency 0-100"; trInp.Text="40"; trInp.BackgroundColor3=Color3.fromRGB(45,45,45); trInp.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", trInp); trInp.FocusLost:Connect(function() local v = (tonumber(trInp.Text) or 40)/100; Main.BackgroundTransparency = v; Title.BackgroundTransparency = v; end)
local kill = Instance.new("TextButton", tabs.GUI); kill.Size = UDim2.new(1,0,0,40); kill.Position = UDim2.new(0,0,0,240); kill.Text = "KILL SCRIPT"; kill.BackgroundColor3 = Color3.fromRGB(150,0,0); kill.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", kill); kill.MouseButton1Click:Connect(function() getgenv().AeeActive = false; Blur:Destroy(); Screen:Destroy(); for _,l in pairs(TracerCache) do pcall(function() l:Remove() end) end end)

-- === KEY SYSTEM ===
local KeyFrame = Instance.new("Frame", Screen); KeyFrame.Size = UDim2.new(0, 260, 0, 160); KeyFrame.Position = UDim2.new(0.5, -130, 0.4, 0); KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", KeyFrame)
local kInp = Instance.new("TextBox", KeyFrame); kInp.Size = UDim2.new(0, 220, 0, 35); kInp.Position = UDim2.new(0, 20, 0, 50); kInp.PlaceholderText = "Enter Key..."; kInp.BackgroundColor3 = Color3.fromRGB(40, 40, 40); kInp.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", kInp)
local kBtn = Instance.new("TextButton", KeyFrame); kBtn.Size = UDim2.new(0, 220, 0, 35); kBtn.Position = UDim2.new(0, 20, 0, 100); kBtn.Text = "Login"; kBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); kBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", kBtn)

kBtn.MouseButton1Click:Connect(function()
    for _, k in pairs(VALID_KEYS) do
        if kInp.Text == k then
            sendLog(k); KeyFrame:Destroy(); Main.Visible = true; 
            TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -140, 0.3, 0)}):Play();
            upB(); return
        end
    end
    kBtn.Text = "Wrong Key!"; task.wait(1); kBtn.Text = "Login"
end)

-- === ЛОГИКА ===
RunService.Stepped:Connect(function()
    if not getgenv().AeeActive or not LocalPlayer.Character then return end
    if getgenv().Config.NoclipEnabled then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().AeeActive or not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if root and hum then
        if getgenv().Config.FlyEnabled then
            hum.PlatformStand = true; local fD = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then fD += Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then fD -= Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then fD += Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then fD -= Vector3.new(0,1,0) end
            root.CFrame += fD * (getgenv().Config.SpeedVal / 45); root.Velocity = Vector3.zero
        else hum.PlatformStand = false end
        if getgenv().Config.Speed and not getgenv().Config.FlyEnabled and hum.MoveDirection.Magnitude > 0 then root.CFrame += hum.MoveDirection * (getgenv().Config.SpeedVal / 55) end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pc = p.Character; local pr = pc.HumanoidRootPart; local sP, onS = Camera:WorldToViewportPoint(pr.Position)
            local h = pc:FindFirstChild("Aee_H"); if getgenv().Config.Chams then if not h then h = Instance.new("Highlight", pc); h.Name = "Aee_H"; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end; h.Enabled, h.FillColor = true, p.TeamColor.Color elseif h then h.Enabled = false end
            local l = TracerCache[p] or Drawing.new("Line"); TracerCache[p] = l; if getgenv().Config.Tracers and onS then l.Visible, l.From, l.To, l.Color = true, Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y), Vector2.new(sP.X, sP.Y), p.TeamColor.Color else l.Visible = false end
            local t = pc:FindFirstChild("Aee_T"); if getgenv().Config.Health then if not t then t = Instance.new("BillboardGui", pc); t.Name = "Aee_T"; t.Size = UDim2.new(0,50,0,6); t.AlwaysOnTop = true; t.StudsOffset = Vector3.new(0,3,0); local f = Instance.new("Frame", t); f.Name = "Fill"; f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.new(0,1,0); Instance.new("UICorner", f).CornerRadius = UDim.new(1,0) end; t.Enabled = true; t.Fill.Size = UDim2.new(math.clamp(pc.Humanoid.Health/pc.Humanoid.MaxHealth, 0, 1), 0, 1, 0) elseif t then t.Enabled = false end
        else if TracerCache[p] then TracerCache[p].Visible = false end end
    end
end)

UIS.InputBegan:Connect(function(i,p) if not p and i.KeyCode == getgenv().Config.MenuKey and Main.Visible then Main.Visible = not Main.Visible; upB() end end)
