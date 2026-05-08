local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- === НАСТРОЙКИ ===
local FRIEND_COLOR = Color3.fromRGB(0, 255, 0)
local DAMAGE_COLOR = Color3.fromRGB(255, 0, 0)
local FIGHT_COLOR = Color3.fromRGB(255, 200, 0)
local VICTORY_COLOR = Color3.fromRGB(0, 255, 255)
local DEAD_ENEMY_COLOR = Color3.fromRGB(255, 255, 0)
local ANTISPAM_TIME = 2

local cooldowns = {}

-- Ресурсы
local function getAsset(name)
    local s, res = pcall(function() return getcustomasset(name) end)
    return s and res or nil
end
local deathAsset, notifAsset = getAsset("death.mp3"), getAsset("notif.mp3")

local function playSnd(id)
    if not id then return end
    task.spawn(function()
        local s = Instance.new("Sound", game:GetService("SoundService"))
        s.SoundId = id; s.Volume = 0.5; s:Play()
        s.Ended:Connect(function() s:Destroy() end)
    end)
end

-- Плавная подсветка
local function flashHighlight(target, color, duration, isPulsing)
    if not target then return end
    local h = Instance.new("Highlight")
    h.Name = "TempHighlight"; h.FillColor = color; h.OutlineColor = Color3.new(1, 1, 1)
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; h.FillTransparency = 1; h.OutlineTransparency = 1
    h.Parent = target; h.Adornee = target

    TweenService:Create(h, TweenInfo.new(0.5), {FillTransparency = 0.5, OutlineTransparency = 0}):Play()
    
    if isPulsing then
        local ti = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        local tw = TweenService:Create(h, ti, {FillTransparency = 0.8}); tw:Play()
        task.delay(duration, function() if h then tw:Cancel(); h:Destroy() end end)
    else
        task.delay(duration, function()
            if h then
                local tw = TweenService:Create(h, TweenInfo.new(1), {FillTransparency = 1, OutlineTransparency = 1})
                tw:Play(); tw.Completed:Connect(function() h:Destroy() end)
            end
        end)
    end
end

-- Поиск цели
local function findTarget(victimChar, range)
    local closest, dist = nil, range or 60
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character ~= victimChar and p.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (p.Character.HumanoidRootPart.Position - victimChar.HumanoidRootPart.Position).Magnitude
            if mag < dist then closest = p.Character; dist = mag end
        end
    end
    return closest
end

-- === ИНТЕРФЕЙС ===
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "FinalGuard_Absolute"; ScreenGui.ResetOnSpawn = false
local Container = Instance.new("Frame", ScreenGui)
Container.Size = UDim2.new(0, 300, 1, 0); Container.Position = UDim2.new(1, -310, 0, 20); Container.BackgroundTransparency = 1
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 8)

local function createNotif(title, text, accentColor, userId)
    local key = tostring(userId or "0") .. tostring(title or "Log")
    if cooldowns[key] then return end
    cooldowns[key] = true; task.delay(ANTISPAM_TIME, function() if cooldowns then cooldowns[key] = nil end end)

    pcall(function()
        local targetPlayer = Players:GetPlayerByUserId(userId)
        local Group = Instance.new("CanvasGroup", Container)
        Group.Size = UDim2.new(1, 0, 0, 85); Group.BackgroundColor3 = Color3.fromRGB(30, 32, 35)
        Group.BorderSizePixel = 0; Group.Position = UDim2.new(1.5, 0, 0, 0)
        Instance.new("UICorner", Group).CornerRadius = UDim.new(0, 8)
        
        local Line = Instance.new("Frame", Group)
        Line.Size = UDim2.new(0, 4, 1, 0); Line.BackgroundColor3 = accentColor or Color3.fromRGB(80, 80, 80); Line.BorderSizePixel = 0

        local ClickBtn = Instance.new("TextButton", Group)
        ClickBtn.Size = UDim2.new(1, 0, 1, 0); ClickBtn.BackgroundTransparency = 1; ClickBtn.Text = ""; ClickBtn.ZIndex = 10
        ClickBtn.MouseButton1Click:Connect(function()
            if targetPlayer and targetPlayer.Character then
                local tool = targetPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then flashHighlight(tool, Color3.new(1, 0, 0), 3, true) end
            end
        end)

        task.spawn(function()
            local Av = Instance.new("ImageLabel", Group)
            Av.Size = UDim2.new(0, 42, 0, 42); Av.Position = UDim2.new(0, 12, 0, 10); Av.BackgroundTransparency = 1; Instance.new("UICorner", Av).CornerRadius = UDim.new(1, 0)
            local s, res = pcall(function() return Players:GetUserThumbnailAsync(userId or 1, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)
            if s then Av.Image = res end
        end)

        local function txt(t, p, b, sz, col)
            local l = Instance.new("TextLabel", Group); l.Text = t; l.Position = p; l.Size = UDim2.new(1, -70, 0, 20); l.Font = b and Enum.Font.GothamBold or Enum.Font.Gotham; l.TextColor3 = col or Color3.new(1,1,1); l.TextSize = sz or 12; l.TextXAlignment = Enum.TextXAlignment.Left; l.BackgroundTransparency = 1
        end
        txt(title, UDim2.new(0, 65, 0, 10), true, 14, accentColor)
        txt(text, UDim2.new(0, 65, 0, 28), false, 12, Color3.fromRGB(200, 200, 200))

        -- ИНВЕНТАРЬ (Исправлено ожидание предметов)
        local InvFrame = Instance.new("ScrollingFrame", Group)
        InvFrame.Size = UDim2.new(1, -75, 0, 22); InvFrame.Position = UDim2.new(0, 65, 0, 50); InvFrame.BackgroundTransparency = 1; InvFrame.ScrollBarThickness = 0; InvFrame.CanvasSize = UDim2.new(2, 0, 0, 0)
        local InvL = Instance.new("UIListLayout", InvFrame); InvL.FillDirection = Enum.FillDirection.Horizontal; InvL.Padding = UDim.new(0, 5)

        task.spawn(function()
            if targetPlayer then
                local tools = {}
                local bp = targetPlayer:FindFirstChild("Backpack")
                if bp then for _, x in pairs(bp:GetChildren()) do if x:IsA("Tool") then table.insert(tools, x.Name) end end end
                if targetPlayer.Character then for _, x in pairs(targetPlayer.Character:GetChildren()) do if x:IsA("Tool") then table.insert(tools, x.Name) end end end
                
                for _, name in pairs(tools) do
                    local b = Instance.new("TextLabel", InvFrame); b.Text = name; b.Size = UDim2.new(0, 60, 1, 0); b.BackgroundColor3 = Color3.fromRGB(45, 47, 50); b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.TextSize = 10; b.Font = Enum.Font.Gotham; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                end
            end
        end)

        playSnd(notifAsset)
        TweenService:Create(Group, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(5, function() pcall(function() TweenService:Create(Group, TweenInfo.new(0.4), {Position = UDim2.new(1.5, 0, 0, 0), GroupTransparency = 1}):Play(); task.wait(0.5); Group:Destroy() end) end)
    end)
end

-- === МОНИТОРИНГ ===

-- Исправленный детектор победы
local function monitorEnemies(player)
    local function onChar(char)
        local hum = char:WaitForChild("Humanoid", 15)
        hum.HealthChanged:Connect(function(hp)
            if hp <= 0 then
                -- Поиск друга рядом с умершим врагом (Радиус 100)
                for _, friend in pairs(Players:GetPlayers()) do
                    if friend ~= LocalPlayer and LocalPlayer:IsFriendsWith(friend.UserId) and friend.Character and friend.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (char.HumanoidRootPart.Position - friend.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 100 then
                            flashHighlight(char, DEAD_ENEMY_COLOR, 4)
                            createNotif("🏆 ПОБЕДА", "Ваш друг убил " .. player.DisplayName, VICTORY_COLOR, friend.UserId)
                            return
                        end
                    end
                end
            end
        end)
    end
    if player.Character then onChar(player.Character) end
    player.CharacterAdded:Connect(onChar)
end

local function monitorFriends(player)
    if player == LocalPlayer then return end
    local function setupChar(char)
        local hum = char:WaitForChild("Humanoid", 15)
        if not hum then return end
        createNotif("В СЕТИ", player.DisplayName, Color3.fromRGB(100, 100, 100), player.UserId)
        
        local h = Instance.new("Highlight", char); h.FillColor = FRIEND_COLOR; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; h.FillTransparency = 0.5
        local lastHP = hum.Health
        local colorTween = nil

        local function listen(part)
            part.ChildAdded:Connect(function(c)
                if c:IsA("Sound") then
                    createNotif("🔔 СИГНАЛ", "Видимо ваш друг начал файт!", FIGHT_COLOR, player.UserId)
                    if colorTween then colorTween:Cancel() end
                    h.FillColor = FIGHT_COLOR
                    colorTween = TweenService:Create(h, TweenInfo.new(3), {FillColor = FRIEND_COLOR}); colorTween:Play()
                end
            end)
        end
        task.spawn(function()
            local head = char:WaitForChild("Head", 5)
            if head then listen(head) end
            listen(char:WaitForChild("HumanoidRootPart", 5))
        end)

        hum.HealthChanged:Connect(function(hp)
            if hp < lastHP and hp > 0 then
                if colorTween then colorTween:Cancel() end
                createNotif("🚨 АТАКА", player.DisplayName .. " [" .. math.floor(hp) .. " HP]", DAMAGE_COLOR, player.UserId)
                h.FillColor = DAMAGE_COLOR
                colorTween = TweenService:Create(h, TweenInfo.new(0.6), {FillColor = FRIEND_COLOR}); colorTween:Play()
                local att = findTarget(char, 120); if att then flashHighlight(att, DAMAGE_COLOR, 2, false) end
            elseif hp <= 0 then
                local killer = findTarget(char, 120)
                if killer then
                    createNotif("💀 УБИЙЦА", "УБИТ ИГРОКОМ: " .. killer.Name, DAMAGE_COLOR, player.UserId)
                    flashHighlight(killer, DAMAGE_COLOR, 10, true)
                end
                if h then h:Destroy() end; playSnd(deathAsset)
            end
            lastHP = hp
        end)
        
        -- Мониторинг инвентаря для уведомлений
        task.spawn(function()
            local bp = player:WaitForChild("Backpack", 5)
            if bp then
                bp.ChildAdded:Connect(function(t) if t:IsA("Tool") then createNotif("ИНВЕНТАРЬ", player.DisplayName .. " взял " .. t.Name, Color3.fromRGB(40, 40, 60), player.UserId) end end)
            end
            char.ChildAdded:Connect(function(t) if t:IsA("Tool") then createNotif("ИНВЕНТАРЬ", player.DisplayName .. " экипировал " .. t.Name, Color3.fromRGB(40, 40, 60), player.UserId) end end)
        end)
    end
    
    local isFriend = false; pcall(function() isFriend = LocalPlayer:IsFriendsWith(player.UserId) end)
    if isFriend then
        if player.Character then task.spawn(setupChar, player.Character) end; player.CharacterAdded:Connect(setupChar)
    end
end

for _, p in pairs(Players:GetPlayers()) do 
    if LocalPlayer:IsFriendsWith(p.UserId) then monitorFriends(p) else monitorEnemies(p) end
end
Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    if LocalPlayer:IsFriendsWith(p.UserId) then monitorFriends(p) else monitorEnemies(p) end
end)

local function applyWorld()
    LocalPlayer.CameraMaxZoomDistance = 10000; Lighting.FogEnd = 100000; local atmo = Lighting:FindFirstChildOfClass("Atmosphere"); if atmo then atmo.Density = 0 end
end
applyWorld(); Lighting.Changed:Connect(applyWorld)
