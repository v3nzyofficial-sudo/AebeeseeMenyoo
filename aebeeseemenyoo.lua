-- // AEBEESEE MENYOO [V50 - SERVER MASTER BUILD] \\ --
-- // BIND: INSERT | GIGA STATS | PLAYER RESTORED \\ --

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- === CONFIG ===
local VALID_KEYS = {"skibidi1488", "pidoras", "nigger", "1488", "pidor"}
local WEBHOOK_URL = "https://lewisakura.moe"

getgenv().Config = {
    ESP = false, Chams = false, Boxes = false,
    Speed = false, SpeedVal = 16,
    Jump = false, JumpVal = 50,
    FovVal = 70, Visible = true,
    Fling = false, Bang = false,
    AccentColor = Color3.fromRGB(170, 0, 255)
}

-- === SYSTEM FUNCTIONS ===
local function getJoinDate(p)
    local ts = os.time() - (p.AccountAge * 86400)
    return os.date("%d.%m.%y", ts)
end

local function sendLog(k)
    task.spawn(function()
        local payload = {["embeds"] = {{["title"] = "🚀 LOGIN V50", ["color"] = 0xAA00FF, ["fields"] = {{["name"] = "👤 Player", ["value"] = LocalPlayer.Name, ["inline"] = true},{["name"] = "🔑 Key", ["value"] = k, ["inline"] = true}}}}}
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then pcall(function() req({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)}) end) end
    end)
end

-- === UI ROOT ===
local Screen = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
Screen.Name = "MenyooV50"; Screen.ZIndexBehavior = Enum.ZIndexBehavior.Global

local Blur = Instance.new("BlurEffect", Lighting)
Blur.Size = 40; Blur.Enabled = true

-- White Stardust
task.spawn(function()
    while task.wait(0.12) do
        if getgenv().Config.Visible then
            local s = Instance.new("Frame", Screen); s.Size = UDim2.new(0, math.random(1,2), 0, math.random(1,2))
            s.Position = UDim2.new(math.random(), 0, 1.1, 0); s.BackgroundColor3 = Color3.new(1,1,1); s.ZIndex = 1; Instance.new("UICorner", s).CornerRadius = UDim.new(1,0)
            TweenService:Create(s, TweenInfo.new(math.random(5,8), 0), {Position = UDim2.new(s.Position.X.Scale, 0, -0.1, 0), BackgroundTransparency = 1}):Play()
            game:GetService("Debris"):AddItem(s, 8)
        end
    end
end)

local function applyStyle(frame)
    frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8); frame.BackgroundTransparency = 0.05; frame.ZIndex = 5
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    local grid = Instance.new("ImageLabel", frame); grid.Size = UDim2.new(1, 0, 1, 0); grid.BackgroundTransparency = 1; grid.ZIndex = 6; grid.Image = "rbxassetid://6522301314"; grid.ImageTransparency = 0.95; grid.ScaleType = "Tile"; grid.TileSize = UDim2.new(0, 40, 0, 40)
    local s = Instance.new("UIStroke", frame); s.Thickness = 3; s.ApplyStrokeMode = "Border"
    local g = Instance.new("UIGradient", s); g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, getgenv().Config.AccentColor), ColorSequenceKeypoint.new(0.5, Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, getgenv().Config.AccentColor)})
    task.spawn(function() while true do g.Rotation = g.Rotation + 4 task.wait(0.01) end end)
    return Instance.new("UIScale", frame)
end

-- === KEY SYSTEM ===
local KeyFrame = Instance.new("Frame", Screen); KeyFrame.Size = UDim2.new(0, 400, 0, 280); KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0); KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5); KeyFrame.ZIndex = 10
local KScale = applyStyle(KeyFrame)
local KTitle = Instance.new("TextLabel", KeyFrame); KTitle.Size = UDim2.new(1, 0, 0, 80); KTitle.Text = "AEBEESEE ACCESS"; KTitle.Font = "GothamBold"; KTitle.TextSize = 28; KTitle.TextColor3 = Color3.new(1,1,1); KTitle.BackgroundTransparency = 1; KTitle.ZIndex = 11
local KInput = Instance.new("TextBox", KeyFrame); KInput.Size = UDim2.new(0.8, 0, 0, 50); KInput.Position = UDim2.new(0.1, 0, 0.4, 0); KInput.PlaceholderText = "enter key..."; KInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20); KInput.TextColor3 = Color3.new(1,1,1); KInput.ZIndex = 11; Instance.new("UICorner", KInput)
local Login = Instance.new("TextButton", KeyFrame); Login.Size = UDim2.new(0.8, 0, 0, 60); Login.Position = UDim2.new(0.1, 0, 0.7, 0); Login.Text = "AUTHENTICATE"; Login.BackgroundColor3 = Color3.new(1,1,1); Login.TextColor3 = Color3.new(0,0,0); Login.Font = "GothamBold"; Login.ZIndex = 11; Instance.new("UICorner", Login)

-- === MAIN MENU ===
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 540, 0, 650); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.Visible = false; Main.ZIndex = 20
local MScale = applyStyle(Main)
local MTitle = Instance.new("TextLabel", Main); MTitle.Size = UDim2.new(1, 0, 0, 60); MTitle.Text = "MENYOO"; MTitle.Font = "GothamBold"; MTitle.TextSize = 35; MTitle.TextColor3 = Color3.new(1,1,1); MTitle.ZIndex = 21; MTitle.BackgroundTransparency = 1

local tabs = { ESP = Instance.new("Frame", Main), PLAYER = Instance.new("Frame", Main), TP = Instance.new("Frame", Main), TROLL = Instance.new("Frame", Main), STATS = Instance.new("Frame", Main) }
for n, f in pairs(tabs) do f.Size = UDim2.new(1, -40, 1, -160); f.Position = UDim2.new(0, 20, 0, 130); f.BackgroundTransparency = 1; f.Visible = (n == "ESP"); f.ZIndex = 22 end

local function addTabB(txt, x, t)
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(0, 95, 0, 35); b.Position = UDim2.new(0, x, 0, 70); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(20,20,20); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 12; b.ZIndex = 25; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, f in pairs(tabs) do f.Visible = false end; tabs[t].Visible = true end)
end
addTabB("ESP", 20, "ESP"); addTabB("PLAYER", 120, "PLAYER"); addTabB("TELEPORT", 220, "TP"); addTabB("TROLL", 320, "TROLL"); addTabB("STATS", 420, "STATS")

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

-- ESP / PLAYER (RESTORED)
addTog("CHAMS", 0, tabs.ESP, "Chams"); addTog("BOXES", 55, tabs.ESP, "Boxes")
addSlider("SPEED", 0, tabs.PLAYER, 16, 350, 16, "SpeedVal", function() getgenv().Config.Speed = true end)
addSlider("JUMP", 60, tabs.PLAYER, 50, 400, 50, "JumpVal", function() getgenv().Config.Jump = true end)
addSlider("FOV", 120, tabs.PLAYER, 30, 120, 70, "FovVal", function(v) Camera.FieldOfView = v end)
addTog("FLING", 0, tabs.TROLL, "Fling"); addTog("BANG", 55, tabs.TROLL, "Bang")

-- TELEPORT
local TpList = Instance.new("ScrollingFrame", tabs.TP); TpList.Size = UDim2.new(1, 0, 1, 0); TpList.BackgroundTransparency = 1; TpList.ScrollBarThickness = 2; TpList.ZIndex = 23
local UIList = Instance.new("UIListLayout", TpList); UIList.Padding = UDim.new(0, 8)
local function refreshTp()
    for _,v in pairs(TpList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then
        local b = Instance.new("TextButton", TpList); b.Size = UDim2.new(0.98,0,0,35); b.Text = "  " .. p.Name; b.BackgroundColor3 = Color3.fromRGB(25,25,30); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextXAlignment = "Left"; b.ZIndex = 25; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() if p.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end end)
    end end
    TpList.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y + 10)
end
refreshTp(); Players.PlayerAdded:Connect(refreshTp); Players.PlayerRemoving:Connect(refreshTp)

-- GIGA STATS (NEW PLAYER INFO)
local StatsList = Instance.new("ScrollingFrame", tabs.STATS); StatsList.Size = UDim2.new(1, 0, 1, 0); StatsList.BackgroundTransparency = 1; StatsList.ScrollBarThickness = 2; StatsList.ZIndex = 23
local UIList2 = Instance.new("UIListLayout", StatsList); UIList2.Padding = UDim.new(0, 5)
local function refreshStats()
    for _,v in pairs(StatsList:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
    local sInfo = Instance.new("TextLabel", StatsList); sInfo.Size = UDim2.new(1,0,0,30); sInfo.Text = "PLAYERS: "..#Players:GetPlayers().." | SERVER MASTER V50"; sInfo.TextColor3 = Color3.new(1,1,1); sInfo.Font = "GothamBold"; sInfo.BackgroundTransparency = 1; sInfo.ZIndex = 24
    for _,p in pairs(Players:GetPlayers()) do
        local l = Instance.new("TextLabel", StatsList); l.Size = UDim2.new(1,0,0,25); l.Text = string.format("[%s] | Ping: %sms | Joined: %s", p.Name:sub(1,10), math.floor(p:GetNetworkPing()*1000), getJoinDate(p))
        l.TextColor3 = (p == LocalPlayer) and Color3.new(0,1,0.5) or Color3.new(0.8,0.8,0.8); l.Font = "Gotham"; l.BackgroundTransparency = 1; l.ZIndex = 24; l.TextSize = 12
    end
    StatsList.CanvasSize = UDim2.new(0,0,0,UIList2.AbsoluteContentSize.Y + 10)
end
task.spawn(function() while task.wait(3) do refreshStats() end end)

-- === LOGIC ВХОДА ===
Login.MouseButton1Click:Connect(function()
    local input = KInput.Text:gsub("%s+", "")
    if table.find(VALID_KEYS, input) then
        local sound = Instance.new("Sound", SoundService); sound.SoundId = "rbxassetid://138097048"; sound.Volume = 2; sound:Play()
        sendLog(input); KeyFrame:Destroy(); Main.Position = UDim2.new(0.5, 0, 0.5, 0); MScale.Scale = 0
        TweenService:Create(MScale, TweenInfo.new(0.6, Enum.EasingStyle.Elastic), {Scale = 1}):Play()
    else Login.Text = "WRONG KEY"; task.wait(1); Login.Text = "AUTHENTICATE" end
end)

-- BIND: INSERT
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Insert then
        getgenv().Config.Visible = not getgenv().Config.Visible
        local active = Main.Parent and Main or KeyFrame
        local scale = Main.Parent and MScale or KScale
        if getgenv().Config.Visible then active.Visible = true; TweenService:Create(scale, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Scale = 1}):Play(); TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 40}):Play()
        else TweenService:Create(scale, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Scale = 0}):Play(); TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play() end
    end
end)

-- WORK CYCLES
RunService.Heartbeat:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if getgenv().Config.Speed then LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().Config.SpeedVal end
            if getgenv().Config.Jump then LocalPlayer.Character.Humanoid.JumpPower = getgenv().Config.JumpVal end
            if getgenv().Config.Fling then LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0); LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,5000,0) end
            if getgenv().Config.Bang then LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-0.5); task.wait(0.01); LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,0.5) end
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("MenyooH")
                if getgenv().Config.Chams or getgenv().Config.Boxes then
                    if not h then h = Instance.new("Highlight", p.Character); h.Name = "MenyooH" end
                    h.FillColor = getgenv().Config.AccentColor; h.FillTransparency = getgenv().Config.Chams and 0.5 or 1; h.OutlineTransparency = getgenv().Config.Boxes and 0 or 1
                elseif h then h:Destroy() end
            end
        end
    end)
end)
