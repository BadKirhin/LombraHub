
local cG = _G.LombraUI.cG
local C_PURP = _G.LombraUI.C_PURP
local C_WHT = _G.LombraUI.C_WHT

local function buf(l)
    local b = buffer.create(#l)
    for i=1,#l do buffer.writeu8(b, i-1, l[i]) end return b
end

local function cTgl(txt, posY, cKey, cb)
    local f = Instance.new("Frame", cG)
    f.Size, f.Position, f.BackgroundColor3, f.ZIndex = UDim2.new(1,-10,0,28), UDim2.new(0,5,0,posY), Color3.fromRGB(24,20,32), 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,5)
    
    local l = Instance.new("TextLabel", f)
    l.Size, l.Position, l.Text, l.TextColor3, l.TextSize, l.BackgroundTransparency, l.ZIndex = UDim2.new(0.7,0,1,0), UDim2.new(0,10,0,0), txt, C_WHT, 12, 1, 4
    
    local btn = Instance.new("TextButton", f)
    btn.Size, btn.Position, btn.Text, btn.ZIndex = UDim2.new(0,40,0,16), UDim2.new(1,-50,0.5,-8), "", 4
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    
    local ind = Instance.new("Frame", btn)
    ind.Size, ind.ZIndex = UDim2.new(0,12,0,12), 4
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1,0)
    
    local function upd()
        if _G.ConfigData[cKey] then
            btn.BackgroundColor3, ind.Position, ind.BackgroundColor3 = C_PURP, UDim2.new(1,-14,0.5,-6), Color3.fromRGB(255,255,255)
        else
            btn.BackgroundColor3, ind.Position, ind.BackgroundColor3 = Color3.fromRGB(50,45,60), UDim2.new(0,2,0.5,-6), Color3.fromRGB(140,140,140)
        end
    end
    upd()
    
    btn.MouseButton1Click:Connect(function()
        if not _G.LombraActive then return end
        _G.ConfigData[cKey] = not _G.ConfigData[cKey]
        upd() task.spawn(cb, _G.ConfigData[cKey])
    end)
end

-- 🔁 MANTIDO: AUTO START PARTIDA
cTgl("Auto Start Partida (Waves)", 5, "AutoStart", function(e)
    while e and _G.LombraActive and _G.ConfigData.AutoStart do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_GAME_WAVES_V1_BLINK_RELIABLE_REMOTE")
        if r then r:FireServer(buf({2}), {}) end task.wait(2)
    end
end)

-- 🔁 MANTIDO: AUTO PLAY PARTIDA
cTgl("Auto Play Partida (Autoplay)", 38, "AutoPlay", function(e)
    while e and _G.LombraActive and _G.ConfigData.AutoPlay do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_GAME_AUTOPLAY_V1_BLINK_RELIABLE_REMOTE")
        if r then r:FireServer(buf({0}), {}) end task.wait(2)
    end
end)
