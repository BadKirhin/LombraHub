-- UiLibrary.lua
local UI = {}

local p = game:GetService("Players").LocalPlayer
local pGui = p:WaitForChild("PlayerGui")

local C_BG = Color3.fromRGB(0, 0, 0) 
local C_TOP = Color3.fromRGB(10, 5, 20)
local C_SIDE = Color3.fromRGB(15, 10, 25)
local C_PURP = Color3.fromHex("#3800FF") 
local C_BRIG = Color3.fromRGB(130, 90, 255) 
local C_WHT = Color3.fromRGB(245, 245, 250)
local C_DRK = Color3.fromRGB(120, 110, 140)

function UI:CreateWindow()
    local sGui = Instance.new("ScreenGui", pGui)
    sGui.Name, sGui.ResetOnSpawn, sGui.ZIndexBehavior = "LombraHub", false, Enum.ZIndexBehavior.Sibling
    UI.ScreenGui = sGui

    local mF = Instance.new("Frame", sGui)
    mF.Name, mF.Size, mF.Position, mF.BackgroundColor3, mF.BorderSizePixel, mF.Active, mF.ZIndex, mF.Draggable = "MainFrame", UDim2.new(0,580,0,320), UDim2.new(0.5,-290,0.5,-160), C_BG, 0, true, 1, true
    Instance.new("UICorner", mF).CornerRadius = UDim.new(0,10)
    UI.MainFrame = mF

    local mainStroke = Instance.new("UIStroke", mF)
    mainStroke.Name = "NeonBorda"
    mainStroke.Color = C_PURP 
    mainStroke.Thickness = 2.5 
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local tBar = Instance.new("Frame", mF)
    tBar.Name, tBar.Size, tBar.BackgroundColor3, tBar.ZIndex = "TopBar", UDim2.new(1,0,0,35), C_TOP, 2
    Instance.new("UICorner", tBar).CornerRadius = UDim.new(0,10)

    local bCls = Instance.new("TextButton", tBar)
    bCls.Name, bCls.Size, bCls.Position, bCls.BackgroundTransparency, bCls.BackgroundColor3, bCls.Text, bCls.TextColor3, bCls.TextSize, bCls.Font, bCls.ZIndex = "CloseX", UDim2.new(0,50,1,0), UDim2.new(1,-50,0,0), 0.85, Color3.fromRGB(255,0,0), "✕", Color3.fromRGB(240,60,60), 16, Enum.Font.SourceSansBold, 10
    UI.CloseButton = bCls

    local sBar = Instance.new("Frame", mF)
    sBar.Name, sBar.Size, sBar.Position, sBar.BackgroundColor3, sBar.ZIndex = "Sidebar", UDim2.new(0,150,1,-35), UDim2.new(0,0,0,35), C_SIDE, 2
    Instance.new("UICorner", sBar).CornerRadius = UDim.new(0,10)
    UI.Sidebar = sBar

    local lblT = Instance.new("TextLabel", sBar)
    lblT.Size, lblT.Position, lblT.Text, lblT.TextColor3, lblT.TextSize, lblT.Font, lblT.TextXAlignment, lblT.BackgroundTransparency, lblT.ZIndex = UDim2.new(1,0,0,40), UDim2.new(0,15,0,5), "LombraHub", C_BRIG, 18, Enum.Font.SourceSansBold, Enum.TextXAlignment.Left, 1, 3

    local tBtn = Instance.new("TextButton", sGui)
    tBtn.Name, tBtn.Size, tBtn.Position, tBtn.BackgroundColor3, tBtn.Text, tBtn.TextColor3, tBtn.TextSize, tBtn.Font, tBtn.ZIndex = "ToggleMenu", UDim2.new(0,90,0,32), UDim2.new(0,10,0,10), C_PURP, "Minimizar", C_WHT, 12, Enum.Font.SourceSansBold, 20
    Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0,6)
    tBtn.MouseButton1Click:Connect(function() mF.Visible = not mF.Visible tBtn.Text = mF.Visible and "Minimizar" or "LombraHub" end)

    UI.Abas = {}
    UI.BotoesAba = {}
    UI.UltimaPosBotao = 45
    return mF
end

function UI:CreateTab(nome, icone)
    local ctn = Instance.new("Frame", UI.MainFrame)
    ctn.Name = nome .. "Container"
    ctn.Size, ctn.Position, ctn.BackgroundTransparency, ctn.ZIndex = UDim2.new(0,410,0,260), UDim2.new(0,160,0,45), 1, 2
    ctn.Visible = (#UI.Abas == 0)

    local b = Instance.new("TextButton", UI.Sidebar)
    b.Size, b.Position, b.BackgroundColor3, b.Text, b.TextColor3, b.TextSize, b.Font, b.TextXAlignment, b.ZIndex = UDim2.new(1,-20,0,32), UDim2.new(0,10,0, UI.UltimaPosBotao), (ctn.Visible and Color3.fromRGB(25, 15, 50) or Color3.fromRGB(15, 10, 30)), icone .. " " .. nome, (ctn.Visible and Color3.fromRGB(130, 90, 255) or Color3.fromRGB(120, 110, 140)), 13, Enum.Font.SourceSansBold, Enum.TextXAlignment.Left, 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    
    UI.UltimaPosBotao = UI.UltimaPosBotao + 37

    table.insert(UI.Abas, ctn)
    table.insert(UI.BotoesAba, b)

    -- Se for a aba "Visualizar", injeta o rosto nativo do Gengar dentro dela
    if nome == "Visualizar" then
        local gFace = Instance.new("Frame", ctn)
        gFace.Name, gFace.Size, gFace.Position, gFace.BackgroundTransparency, gFace.ZIndex = "GengarFace", UDim2.new(0, 300, 0, 180), UDim2.new(0, 50, 0, 40), 1, 2

        local function cEye(pos, rot)
            local e = Instance.new("Frame", gFace)
            e.Size, e.Position, e.BackgroundColor3, e.BorderSizePixel, e.Rotation, e.ZIndex = UDim2.new(0,50,0,24), pos, Color3.fromRGB(255,10,50), 0, rot, 3
            Instance.new("UICorner", e).CornerRadius = UDim.new(0,12)
            local pu = Instance.new("Frame", e)
            pu.Size, pu.Position, pu.BackgroundColor3, pu.ZIndex = UDim2.new(0,10,0,10), UDim2.new(0.5,2,0.2,0), Color3.fromRGB(255,255,255), 4
            Instance.new("UICorner", pu).CornerRadius = UDim.new(1,0)
        end
        cEye(UDim2.new(0,40,0,40), -20) cEye(UDim2.new(1,-90,0,40), 20)

        local function cMth(txt, y)
            local m = Instance.new("TextLabel", gFace)
            m.Size, m.Position, m.BackgroundTransparency, m.Text, m.TextColor3, m.TextSize, m.Font, m.ZIndex = UDim2.new(0,160,0,30), UDim2.new(0.5,-80,0,y), 1, txt, Color3.fromRGB(35,20,60), 28, Enum.Font.SourceSansBold, 3
        end
        cMth("▼▼▼▼▼▼▼", 85) cMth("▲▲▲▲▲▲▲", 100)
    end

    b.MouseButton1Click:Connect(function()
        for i, aba in ipairs(UI.Abas) do
            aba.Visible = (aba == ctn)
            UI.BotoesAba[i].BackgroundColor3 = (aba == ctn and Color3.fromRGB(25, 15, 50) or Color3.fromRGB(15, 10, 30))
            UI.BotoesAba[i].TextColor3 = (aba == ctn and Color3.fromRGB(130, 90, 255) or Color3.fromRGB(120, 110, 140))
        end
    end)

    return ctn
end

function UI:CreateToggle(par, txt, posY, cKey, cb)
    local f = Instance.new("Frame", par)
    f.Size, f.Position, f.BackgroundColor3, f.BorderSizePixel, f.ZIndex = UDim2.new(1,-10,0,28), UDim2.new(0,5,0,posY), Color3.fromRGB(24,20,32), 0, 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,5)
    
    local l = Instance.new("TextLabel", f)
    l.Size, l.Position, l.Text, l.TextColor3, l.TextSize, l.BackgroundTransparency, l.ZIndex, l.TextXAlignment = UDim2.new(0.7,0,1,0), UDim2.new(0,10,0,0), txt, Color3.fromRGB(245, 245, 250), 12, 1, 4, Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton", f)
    btn.Size, btn.Position, btn.Text, btn.ZIndex = UDim2.new(0,40,0,16), UDim2.new(1,-50,0.5,-8), "", 4
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    
    local ind = Instance.new("Frame", btn)
    ind.Size, ind.ZIndex = UDim2.new(0,12,0,12), 4
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1,0)
    
    local function upd()
        if _G.ConfigData[cKey] then
            btn.BackgroundColor3, ind.Position, ind.BackgroundColor3 = Color3.fromHex("#3800FF"), UDim2.new(1,-14,0.5,-6), Color3.fromRGB(255,255,255)
        else
            btn.BackgroundColor3, ind.Position, ind.BackgroundColor3 = Color3.fromRGB(50,45,60), UDim2.new(0,2,0.5,-6), Color3.fromRGB(140,140,140)
        end
    end
    upd()
    
    btn.MouseButton1Click:Connect(function()
        if _G.LombraHubAtivo == false then return end
        _G.ConfigData[cKey] = not _G.ConfigData[cKey]
        upd()
        task.spawn(cb, _G.ConfigData[cKey])
    end)
end

-- Função para criar botões simples de ação direta (como o Rejoin)
function UI:CreateButton(par, txt, posY, cb)
    local f = Instance.new("Frame", par)
    f.Size, f.Position, f.BackgroundColor3, f.BorderSizePixel, f.ZIndex = UDim2.new(1,-10,0,28), UDim2.new(0,5,0,posY), Color3.fromRGB(24,20,32), 0, 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,5)
    
    local l = Instance.new("TextLabel", f)
    l.Size, l.Position, l.Text, l.TextColor3, l.TextSize, l.BackgroundTransparency, l.ZIndex, l.TextXAlignment = UDim2.new(0.6,0,1,0), UDim2.new(0,10,0,0), txt, Color3.fromRGB(245, 245, 250), 12, 1, 4, Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton", f)
    btn.Size, btn.Position, btn.BackgroundColor3, btn.Text, btn.TextColor3, btn.TextSize, btn.Font, btn.ZIndex = UDim2.new(0,70,0,18), UDim2.new(1,-80,0.5,-9), C_PURP, "Executar", C_WHT, 11, Enum.Font.SourceSansBold, 4
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    
    btn.MouseButton1Click:Connect(function()
        if _G.LombraHubAtivo == false then return end
        task.spawn(cb)
    end)
end

return UI
