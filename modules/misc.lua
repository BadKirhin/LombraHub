local cM = _G.LombraUI.cM
local C_PURP = _G.LombraUI.C_PURP
local C_WHT = _G.LombraUI.C_WHT
local lit = game:GetService("Lighting")
local rS = game:GetService("RunService")
local vIM = game:GetService("VirtualInputManager")
local p = game:GetService("Players").LocalPlayer

local function cTgl(txt, posY, cKey, cb)
    local f = Instance.new("Frame", cM)
    f.Size, f.Position, f.BackgroundColor3, f.BorderSizePixel, f.ZIndex = UDim2.new(1,-10,0,28), UDim2.new(0,5,0,posY), Color3.fromRGB(24,20,32), 0, 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,5)
    
    local l = Instance.new("TextLabel", f)
    l.Size, l.Position, l.Text, l.TextColor3, l.TextSize, l.BackgroundTransparency, l.ZIndex = UDim2.new(0.7,0,1,0), UDim2.new(0,10,0,0), txt, C_WHT, 12, 1, 4
    l.Font = Enum.Font.SourceSansBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    
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

cTgl("Anti-AFK (Pulo Simulado)", 5, "AntiAFK", function(e)
    while e and _G.LombraActive and _G.ConfigData.AntiAFK do
        local chr = p.Character
        if chr and chr:FindFirstChildOfClass("Humanoid") and chr:FindFirstChildOfClass("Humanoid").Health > 0 then
            vIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game) task.wait(0.05)
            vIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end task.wait(10)
    end
end)

local fRej = Instance.new("Frame", cM)
fRej.Size, fRej.Position, fRej.BackgroundColor3, fRej.BorderSizePixel, fRej.ZIndex = UDim2.new(1,-10,0,28), UDim2.new(0,5,0,38), Color3.fromRGB(24,20,32), 0, 4
Instance.new("UICorner", fRej).CornerRadius = UDim.new(0,5)

local lRej = Instance.new("TextLabel", fRej)
lRej.Size, lRej.Position, lRej.Text, lRej.TextColor3, lRej.TextSize, lRej.BackgroundTransparency, lRej.ZIndex = UDim2.new(0.6,0,1,0), UDim2.new(0,10,0,0), "Reconectar ao Servidor", C_WHT, 12, 1, 4
lRej.Font = Enum.Font.SourceSansBold
lRej.TextXAlignment = Enum.TextXAlignment.Left

local bRej = Instance.new("TextButton", fRej)
bRej.Size, bRej.Position, bRej.BackgroundColor3, bRej.Text, bRej.TextColor3, bRej.TextSize, bRej.Font, bRej.ZIndex = UDim2.new(0,70,0,18), UDim2.new(1,-80,0.5,-9), C_PURP, "Rejoin", C_WHT, 11, Enum.Font.SourceSansBold, 4
Instance.new("UICorner", bRej).CornerRadius = UDim.new(0,4)
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
