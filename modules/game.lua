local cG = _G.LombraUI.cG
local C_PURP = _G.LombraUI.C_PURP
local C_WHT = _G.LombraUI.C_WHT
local function buf(l)
    local b = buffer.create(#l)
    for i=1,#l do buffer.writeu8(b, i-1, l[i]) end return b
end

local function cTgl(txt, posY, cKey, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 28)
    f.Position = UDim2.new(0, 5, 0, posY)
    f.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
    f.BorderSizePixel = 0
    f.ZIndex = 4
    f.Parent = cG
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 5)
    fCorner.Parent = f
    
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Text = txt
    l.TextColor3 = C_WHT
    l.TextSize = 12
    l.BackgroundTransparency = 1
    l.ZIndex = 4
    l.Font = Enum.Font.SourceSansBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 16)
    btn.Position = UDim2.new(1, -50, 0.5, -8)
    btn.Text = ""
    btn.ZIndex = 4
    btn.Parent = f
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn
    
    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 12, 0, 12)
    ind.ZIndex = 4
    ind.Parent = btn
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = ind
    
    local function upd()
        if _G.ConfigData[cKey] then
            btn.BackgroundColor3 = C_PURP
            ind.Position = UDim2.new(1, -14, 0.5, -6)
            ind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(50, 45, 60)
            ind.Position = UDim2.new(0, 2, 0.5, -6)
            ind.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
        end
    end
    upd()
    
    btn.MouseButton1Click:Connect(function()
        if not _G.LombraActive then return end
        _G.ConfigData[cKey] = not _G.ConfigData[cKey]
        upd() task.spawn(cb, _G.ConfigData[cKey])
    end)
end

cTgl("Auto Start Partida (Waves)", 5, "AutoStart", function(e)
    while e and _G.LombraActive and _G.ConfigData.AutoStart do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_GAME_WAVES_V1_BLINK_RELIABLE_REMOTE")
        if r then r:FireServer(buf({2}), {}) end task.wait(2)
    end
end)

cTgl("Auto Play Partida (Autoplay)", 38, "AutoPlay", function(e)
    while e and _G.LombraActive and _G.ConfigData.AutoPlay do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_GAME_AUTOPLAY_V1_BLINK_RELIABLE_REMOTE")
        if r then r:FireServer(buf({0}), {}) end task.wait(2)
    end
end)

cTgl("Comprar Fenda Temporal (Auto Shop)", 71, "AutoComprar", function(e)
    while e and _G.LombraActive and _G.ConfigData.AutoComprar do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_LOBBY_EVENT_SHOPS_V1_BLINK_RELIABLE_REMOTE")
        if r then r:FireServer(buf({4,13,1,0,84,101,109,112,111,114,97,108,32,82,105,102,116}), {}) end task.wait(3)
    end
end)

cTgl("Abrir Fenda (Auto The Almighty)", 104, "AutoAbrir", function(e)
    while e and _G.LombraActive and _G.ConfigData.AutoAbrir do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_LOBBY_SPECIAL_EVENTS_V1_BLINK_RELIABLE_REMOTE")
        if r then r:FireServer(buf({14,12,84,104,101,32,65,108,109,105,103,104,116,121}), {}) end task.wait(4)
    end
end)
