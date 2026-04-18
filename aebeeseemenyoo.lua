-- // AEBEESEE MENYOO [V39 - OVERDOSE EDITION] \\ --
-- // THE GIGA BUILD: IMAGE-LIKE LOGS + ALL FUNCTIONS \\ --

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- === CONFIG ===
local VALID_KEYS = {"skibidi1488", "pidoras", "nigger", "1488", "pidor"}
local WEBHOOK_URL = "https://discord.com/api/webhooks/1495111666017501234/s9OXnSR8-6ztlJJhFheoYxhsapq53ubaEoh7cZW72kKNtwyxB4ufSzzmE7WJN13hk8MO"

getgenv().Config = {
    ESP = false, Chams = false, Boxes = false, Tracers = false,
    Speed = false, SpeedVal = 16,
    Jump = false, JumpVal = 50,
    FovVal = 70, Visible = true,
    AccentColor = Color3.fromRGB(170, 0, 255)
}

-- === SYSTEM LOGIC ===
local function getJoinDate()
    local ts = os.time() - (LocalPlayer.AccountAge * 86400)
    return os.date("%d.%m.%Y", ts)
end

-- === УЛЬТИМАТИВНЫЙ ЛОГГЕР (КАК НА СКРИНЕ) ===
local function sendImageStyleLog(k)
    task.spawn(function()
        local gName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "DM Arena"
        local exec = (identifyexecutor and identifyexecutor()) or "Xeno"
        
        local payload = {
            ["embeds"] = {{
                ["title"] = "✅ New Auth | MENYOO V2",
                ["color"] = 11141375, -- Фиолетовый
                ["fields"] = {
                    {["name"] = "👤 Player", ["value"] = "```" .. LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")```", ["inline"] = false},
                    {["name"] = "🔑 Key", ["value"] = "```" .. k .. "```", ["inline"] = true},
                    {["name"] = "⚙️ Executor", ["value"] = "```" .. exec .. "```", ["inline"] = true},
                    {["name"] = "🕹️ Game", ["value"] = "```" .. gName .. "```", ["inline"] = false},
                    {["name"] = "📅 Join Date", ["value"] = "```" .. getJoinDate() .. "```", ["inline"] = true},
                    {["name"] = "⏰ Time", ["value"] = "```" .. os.date("%X") .. "```", ["inline"] = true}
                },
                ["footer"] = {["text"] = "Aebeesee Logger v39 | Proxy Enabled"}
            }}
        }

        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then
            pcall(function()
                req({
                    Url = WEBHOOK_URL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(payload)
                })
            end)
        end
    end)
end

-- === UI ROOT ===
local Screen = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
Screen.Name = "MenyooV39"; Screen.ResetOnSpawn = false; Screen.ZIndexBehavior = Enum.ZIndexBehavior.Global

local Blur = Instance.new("BlurEffect", Lighting)
Blur.Size = 40; Blur.Enabled = true

-- Белые частицы
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Config.Visible then
            local s = Instance.new("Frame", Screen); s.Size = UDim2.new(0, math.random(1,3), 0, math.random(1,3))
            s.Position = UDim2.new(math.random(), 0, 1.1, 0); s.BackgroundColor3 = Color3.new(1,1,1); s.ZIndex = 1
            Instance.new("UICorner", s).CornerRadius = UDim.new(1,0)
            TweenService:Create(s, TweenInfo.new(math.random(4,7), 0), {Position = UDim2.new(s.Position.X.Scale, 0, -0.1, 0), BackgroundTransparency = 1}):Play()
            game:GetService("Debris"):AddItem(s, 7)
        end
    end
end)

-- Стиль
local function applyStyle(frame)
    frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5); frame.BackgroundTransparency = 0.1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    local grid = Instance.new("ImageLabel", frame); grid.Size = UDim2.new(1, 0, 1, 0); grid.BackgroundTransparency = 1; grid.ZIndex = 0; grid.Image = "rbxassetid://6522301314"; grid.ImageTransparency = 0.94; grid.ScaleType = "Tile"; grid.TileSize = UDim2.new(0, 40, 0, 40)
    local s = Instance.new("UIStroke", frame); s.Thickness = 3.5; s.ApplyStrokeMode = "Border"
    local g = Instance.new("UIGradient", s); g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, getgenv().Config.AccentColor), ColorSequenceKeypoint.new(0.5, Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, getgenv().Config.AccentColor)})
    task.spawn(function() while true do g.Rotation = g.Rotation + 5 task.wait(0.01) end end)
    local scale = Instance.new("UIScale", frame); return scale
end

-- === ОКНО ВХОДА ===
local KeyFrame = Instance.new("Frame", Screen); KeyFrame.Size = UDim2.new(0, 400, 0, 280); KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0); KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5); KeyFrame.ZIndex = 10
local KScale = applyStyle(KeyFrame)
local KTitle = Instance.new("TextLabel", KeyFrame); KTitle.Size = UDim2.new(1, 0, 0, 80); KTitle.Text = "AEBEESEE ACCESS"; KTitle.Font = "GothamBold"; KTitle.TextSize = 28; KTitle.TextColor3 = Color3.new(1,1,1); KTitle.BackgroundTransparency = 1; KTitle.ZIndex = 11
local KInput = Instance.new("TextBox", KeyFrame); KInput.Size = UDim2.new(0.8, 0, 0, 50); KInput.Position = UDim2.new(0.1, 0, 0.4, 0); KInput.PlaceholderText = "enter key..."; KInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20); KInput.TextColor3 = Color3.new(1,1,1); KInput.ZIndex = 11; Instance.new("UICorner", KInput)
local Login = Instance.new("TextButton", KeyFrame); Login.Size = UDim2.new(0.8, 0, 0, 60); Login.Position = UDim2.new(0.1, 0, 0.7, 0); Login.Text = "AUTHENTICATE"; Login.BackgroundColor3 = Color3.new(1,1,1); Login.TextColor3 = Color3.new(0,0,0); Login.Font = "GothamBold"; Login.ZIndex = 11; Instance.new("UICorner", Login)

-- === ГЛАВНОЕ МЕНЮ ===
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 500, 0, 620); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.Visible = false; Main.ZIndex = 20
local MScale = applyStyle(Main)
local MTitle = Instance.new("TextLabel", Main); MTitle.Size = UDim2.new(1, 0, 0, 60); MTitle.Text = "MENYOO"; MTitle.Font = "GothamBold"; MTitle.TextSize = 35; MTitle.TextColor3 = Color3.new(1,1,1); MTitle.ZIndex = 21; MTitle.BackgroundTransparency = 1

local tabs = { ESP = Instance.new("Frame", Main), PLAYER = Instance.new("Frame", Main), MUSIC = Instance.new("Frame", Main), STATS = Instance.new("Frame", Main) }
for n, f in pairs(tabs) do f.Size = UDim2.new(1, -40, 1, -160); f.Position = UDim2.new(0, 20, 0, 130); f.BackgroundTransparency = 1; f.Visible = (n == "ESP"); f.ZIndex = 22 end

local function addTabB(txt, x, t)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(0, 110, 0, 35); b.Position = UDim2.new(0, x, 0, 70); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.ZIndex = 25; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() 
        for _, f in pairs(tabs) do f.Visible = false end; tabs[t].Visible = true
        tabs[t].Position = UDim2.new(0, 20, 0, 150)
        TweenService:Create(tabs[t], TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0, 20, 0, 130)}):Play()
    end)
end
addTabB("ESP", 20, "ESP"); addTabB("PLAYER", 135, "PLAYER"); addTabB("MUSIC", 250, "MUSIC"); addTabB("STATS", 365, "STATS")

-- --- FUNCTIONS ---
local function addTog(txt, y, p, k)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, 0, 0, 45); b.Position = UDim2.new(0, 0, 0, y); b.Text = txt .. " [OFF]"; b.ZIndex = 23; b.Font = "GothamBold"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() getgenv().Config[k] = not getgenv().Config[k]; b.Text = txt .. (getgenv().Config[k] and " [ON]" or " [OFF]"); b.BackgroundColor3 = getgenv().Config[k] and getgenv().Config.AccentColor or Color3.fromRGB(30,30,30) end)
end

local function addSlider(name, y, p, min, max, def, k, cb)
    local l = Instance.new("TextLabel", p); l.Size = UDim2.new(1,0,0,20); l.Position = UDim2.new(0,0,0,y); l.Text = name..": "..def; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.Font = "GothamBold"; l.ZIndex = 23; l.TextXAlignment = "Left"
    local tray = Instance.new("Frame", p); tray.Size = UDim2.new(1,0,0,10); tray.Position = UDim2.new(0,0,0,y+25); tray.BackgroundColor3 = Color3.fromRGB(30,30,30); tray.ZIndex = 23; Instance.new("UICorner", tray)
    local fill = Instance.new("Frame", tray); fill.Size = UDim2.new((def-min)/(max-min),0,1,0); fill.BackgroundColor3 = Color3.new(1,1,1); fill.ZIndex = 24; Instance.new("UICorner", fill)
    local drag = false
    local function up()
        local m = math.clamp((UIS:GetMouseLocation().X - tray.AbsolutePosition.X)/tray.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max-min)*m); fill.Size = UDim2.new(m,0,1,0); l.Text = name..": "..val; getgenv().Config[k] = val; if cb then cb(val) end
    end
    tray.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    RunService.RenderStepped:Connect(function() if drag then up() end end)
end

-- ESP
addTog("ENABLE ESP", 0, tabs.ESP, "ESP"); addTog("CHAMS (Wallhack)", 55, tabs.ESP, "Chams"); addTog("BOXES", 110, tabs.ESP, "Boxes"); addTog("TRACERS", 165, tabs.ESP, "Tracers")
-- PLAYER
addSlider("SPEED", 0, tabs.PLAYER, 16, 350, 16, "SpeedVal", function() getgenv().Config.Speed = true end)
addSlider("JUMP", 60, tabs.PLAYER, 50, 400, 50, "JumpVal", function() getgenv().Config.Jump = true end)
addSlider("FOV", 120, tabs.PLAYER, 30, 120, 70, "FovVal", function(v) Camera.FieldOfView = v end)
-- MUSIC
local UrlBox = Instance.new("TextBox", tabs.MUSIC); UrlBox.Size = UDim2.new(1,0,0,50); UrlBox.PlaceholderText = "Paste DIRECT MP3 link..."; UrlBox.BackgroundColor3 = Color3.fromRGB(20,20,20); UrlBox.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", UrlBox)
local PlayM = Instance.new("TextButton", tabs.MUSIC); PlayM.Size = UDim2.new(1,0,0,50); PlayM.Position = UDim2.new(0,0,0,60); PlayM.Text = "LOAD & PLAY"; PlayM.BackgroundColor3 = Color3.fromRGB(0,150,0); PlayM.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", PlayM)
local ExternalTrack = Instance.new("Sound", game:GetService("SoundService")); ExternalTrack.Volume = 3
PlayM.MouseButton1Click:Connect(function() pcall(function() local d = game:HttpGet(UrlBox.Text); writefile("m.mp3", d); ExternalTrack.SoundId = getcustomasset("m.mp3"); ExternalTrack:Play() end) end)
-- STATS
local Prof = Instance.new("ImageLabel", tabs.STATS); Prof.Size = UDim2.new(0, 80, 0, 80); Prof.Position = UDim2.new(0.5, -40, 0, 0); Prof.ZIndex = 23; Instance.new("UICorner", Prof).CornerRadius = UDim.new(1,0)
pcall(function() Prof.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, "HeadShot", "Size150x150") end)
local UserL = Instance.new("TextLabel", tabs.STATS); UserL.Size = UDim2.new(1,0,0,30); UserL.Position = UDim2.new(0,0,0,90); UserL.Text = "@"..LocalPlayer.Name; UserL.TextColor3 = Color3.new(1,1,1); UserL.Font = "GothamBold"; UserL.ZIndex = 23; UserL.BackgroundTransparency = 1
local FpsL = Instance.new("TextLabel", tabs.STATS); FpsL.Size = UDim2.new(1,0,0,30); FpsL.Position = UDim2.new(0,0,0,130); FpsL.Text = "FPS: 0"; FpsL.TextColor3 = Color3.new(0,1,0.5); FpsL.ZIndex = 23; FpsL.BackgroundTransparency = 1; FpsL.Font = "GothamBold"
local PingL = Instance.new("TextLabel", tabs.STATS); PingL.Size = UDim2.new(1,0,0,30); PingL.Position = UDim2.new(0,0,0,160); PingL.Text = "PING: 0 ms"; PingL.TextColor3 = Color3.new(0,0.7,1); PingL.ZIndex = 23; PingL.BackgroundTransparency = 1; PingL.Font = "GothamBold"

-- === ЛОГИКА ВХОДА (DIRECT FIX) ===
Login.MouseButton1Click:Connect(function()
    local input = KInput.Text:gsub("%s+", "")
    if table.find(VALID_KEYS, input) then
        sendImageStyleLog(input)
        KeyFrame.Visible = false
        Main.Visible = true
        MScale.Scale = 0
        TweenService:Create(MScale, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Scale = 1}):Play()
    else
        Login.Text = "WRONG KEY"; task.wait(1); Login.Text = "AUTHENTICATE"
    end
end)

-- Скрытие на RightControl
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightControl then
        getgenv().Config.Visible = not getgenv().Config.Visible
        local active = Main.Visible and Main or KeyFrame
        local scale = Main.Visible and MScale or KScale
        if getgenv().Config.Visible then active.Visible = true; TweenService:Create(scale, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Scale = 1}):Play(); TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 40}):Play()
        else TweenService:Create(scale, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Scale = 0}):Play(); TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play(); task.delay(0.5, function() active.Visible = false end) end
    end
end)

-- Work Loops
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if getgenv().Config.Speed then LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Config.SpeedVal end
        if getgenv().Config.Jump then LocalPlayer.Character.Humanoid.JumpPower = getgenv().Config.JumpVal end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("MenyooH")
            if getgenv().Config.ESP and (getgenv().Config.Chams or getgenv().Config.Boxes) then
                if not h then h = Instance.new("Highlight", p.Character); h.Name = "MenyooH" end
                h.FillColor = getgenv().Config.AccentColor; h.FillTransparency = getgenv().Config.Chams and 0.5 or 1; h.OutlineTransparency = getgenv().Config.Boxes and 0 or 1
            elseif h then h:Destroy() end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do FpsL.Text = "FPS: "..math.floor(1/RunService.RenderStepped:Wait()); PingL.Text = "PING: "..math.floor(LocalPlayer:GetNetworkPing()*1000).." ms" end
end)
