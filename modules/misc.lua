local cM = _G.LombraUI.cM
local C_PURP = _G.LombraUI.C_PURP
local C_WHT = _G.LombraUI.C_WHT
local lit = game:GetService("Lighting")
local rS = game:GetService("RunService")
local vIM = game:GetService("VirtualInputManager")
local p = game:GetService("Players").LocalPlayer

local function cTgl(txt, posY, cKey, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -10, 0, 28)
    f.Position = UDim2.new(0, 5, 0, posY)
    f.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
    f.BorderSizePixel = 0
    f.ZIndex = 4
    f.Parent = cM
    
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

cTgl("Anti-AFK (Pulo Simulado)", 5, "AntiAFK", function(e)
    while e and _G.LombraActive and _G.ConfigData.AntiAFK do
        local chr = p.Character
        if chr and chr:FindFirstChildOfClass("Humanoid") and chr:FindFirstChildOfClass("Humanoid").Health > 0 then
            vIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game) task.wait(0.05)
            vIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end task.wait(10)
    end
end)

-- Painel Rejoin Customizado e Corrigido
local fRej = Instance.new("Frame")
fRej.Size = UDim2.new(1, -10, 0, 28)
fRej.Position = UDim2.new(0, 5, 0, 38)
fRej.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
fRej.BorderSizePixel = 0
fRej.ZIndex = 4
fRej.Parent = cM

local fRejCorner = Instance.new("UICorner")
fRejCorner.CornerRadius = UDim.new(0, 5)
fRejCorner.Parent = fRej

local lRej = Instance.new("TextLabel")
lRej.Size = UDim2.new(0.6, 0, 1, 0)
lRej.Position = UDim2.new(0, 10, 0, 0)
lRej.Text = "Reconectar ao Servidor"
lRej.TextColor3 = C_WHT
lRej.TextSize = 12
lRej.BackgroundTransparency = 1
lRej.ZIndex = 4
lRej.Font = Enum.Font.SourceSansBold
lRej.TextXAlignment = Enum.TextXAlignment.Left
lRej.Parent = fRej

local bRej = Instance.new("TextButton")
bRej.Size = UDim2.new(0, 70, 0, 18)
bRej.Position = UDim2.new(1, -80, 0.5, -9)
bRej.BackgroundColor3 = C_PURP
bRej.Text = "Rejoin"
bRej.TextColor3 = C_WHT
bRej.TextSize = 11
bRej.Font = Enum.Font.SourceSansBold
bRej.ZIndex = 4
bRej.Parent = fRej

local bRejCorner = Instance.new("UICorner")
bRejCorner.CornerRadius = UDim.new(0, 4)
bRejCorner.Parent = bRej

bRej.MouseButton1Click:Connect(function()
    local ts = game:GetService("TeleportService")
    if game.JobId == "" then ts:Teleport(game.PlaceId, p) else ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p) end
end)

cTgl("FPS Booster (Remover Texturas)", 71, "FpsBoost", function(e)
    lit.GlobalShadows = not e
    if e then
        for _, o in pairs(workspace:GetDescendants()) do
            if o:IsA("BasePart") and not o:IsA("MeshPart") then o.Material = Enum.Material.SmoothPlastic
            elseif o:IsA("Texture") or o:IsA("Decal") then o.Transparency = 1
            elseif o:IsA("ParticleEmitter") then o.Enabled = false end
        end
    end
end)

cTgl("Black Screen (Reduzir Render 3D)", 104, "BlackScreen", function(e) rS:Set3dRenderingEnabled(not e) end)
