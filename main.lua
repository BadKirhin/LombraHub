local p = game:GetService("Players").LocalPlayer
local pGui = p:WaitForChild("PlayerGui")
local rS = game:GetService("RunService")

if _G.EncerrarScriptCompleto then _G.EncerrarScriptCompleto() end
_G.ConfigData = {AntiAFK=false,FpsBoost=false,BlackScreen=false,AutoComprar=false,AutoAbrir=false,AutoStart=false,AutoPlay=false}

-- 🎨 PALETA DE CORES (PRETO ABSOLUTO E ROXO #3800FF)
local C_BG, C_TOP, C_SIDE, C_PURP, C_BRIG, C_WHT, C_DRK, C_ACT, C_INA = Color3.fromRGB(0,0,0), Color3.fromRGB(10,5,20), Color3.fromRGB(15,10,25), Color3.fromHex("#3800FF"), Color3.fromRGB(130,90,255), Color3.fromRGB(245,245,250), Color3.fromRGB(120,110,140), Color3.fromRGB(25,15,50), Color3.fromRGB(15,10,30)

local sGui = Instance.new("ScreenGui", pGui)
sGui.Name, sGui.ResetOnSpawn, sGui.ZIndexBehavior = "LombraHub", false, Enum.ZIndexBehavior.Sibling

local mF = Instance.new("Frame", sGui)
mF.Name, mF.Size, mF.Position, mF.BackgroundColor3, mF.BorderSizePixel, mF.Active, mF.ZIndex, mF.Draggable = "MainFrame", UDim2.new(0,580,0,320), UDim2.new(0.5,-290,0.5,-160), C_BG, 0, true, 1, true
Instance.new("UICorner", mF).CornerRadius = UDim.new(0,10)

-- 🌟 BORDA NEON EM LED (#3800FF) ATIVA E ATUALIZADA
local mainStroke = Instance.new("UIStroke", mF)
mainStroke.Name = "NeonBorda"
mainStroke.Color = C_PURP 
mainStroke.Thickness = 2.5 
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 😈 ROSTO NATIVO DO GENGAR LOMBRADO
local gFace = Instance.new("Frame", mF)
gFace.Name, gFace.Size, gFace.Position, gFace.BackgroundTransparency, gFace.ZIndex, gFace.Visible = "GengarFaceNativa", UDim2.new(0,300,0,180), UDim2.new(0,210,0,80), 1, 2, true

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

local tBtn = Instance.new("TextButton", sGui)
tBtn.Size, tBtn.Position, tBtn.BackgroundColor3, tBtn.Text, tBtn.TextColor3, tBtn.ZIndex = UDim2.new(0,90,0,32), UDim2.new(0,10,0,10), C_PURP, "LombraHub", C_WHT, 20
Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0,6)
tBtn.MouseButton1Click:Connect(function() mF.Visible = not mF.Visible tBtn.Text = mF.Visible and "Minimizar" or "LombraHub" end)

local tBar = Instance.new("Frame", mF)
tBar.Size, tBar.BackgroundColor3, tBar.ZIndex = UDim2.new(1,0,0,35), C_TOP, 2
Instance.new("UICorner", tBar).CornerRadius = UDim.new(0,10)

local bCls = Instance.new("TextButton", tBar)
bCls.Size, bCls.Position, bCls.BackgroundTransparency, bCls.BackgroundColor3, bCls.Text, bCls.TextColor3, bCls.ZIndex = UDim2.new(0,50,1,0), UDim2.new(1,-50,0,0), 0.85, Color3.fromRGB(255,0,0), "✕", Color3.fromRGB(240,60,60), 10

local sBar = Instance.new("Frame", mF)
sBar.Size, sBar.Position, sBar.BackgroundColor3, sBar.ZIndex = UDim2.new(0,150,1,-35), UDim2.new(0,0,0,35), C_SIDE, 2
Instance.new("UICorner", sBar).CornerRadius = UDim.new(0,10)

local lblT = Instance.new("TextLabel", sBar)
lblT.Size, lblT.Position, lblT.Text, lblT.TextColor3, lblT.TextSize, lblT.Font, lblT.BackgroundTransparency, lblT.ZIndex = UDim2.new(1,0,0,40), UDim2.new(0,15,0,5), "LombraHub", C_BRIG, 18, Enum.Font.SourceSansBold, 1, 3

local cV, cG, cM = Instance.new("Frame", mF), Instance.new("Frame", mF), Instance.new("Frame", mF)
for k,v in pairs({[cV]=true, [cG]=false, [cM]=false}) do k.Size, k.Position, k.BackgroundTransparency, k.ZIndex, k.Visible = UDim2.new(0,410,0,260), UDim2.new(0,160,0,45), 1, 2, v end

local function mtb(txt, pos, ctn)
    local b = Instance.new("TextButton", sBar)
    b.Size, b.Position, b.BackgroundColor3, b.Text, b.TextColor3, b.TextSize, b.Font, b.ZIndex = UDim2.new(1,-20,0,32), UDim2.new(0,10,0,pos), (ctn==cV and C_ACT or C_INA), txt, (ctn==cV and C_BRIG or C_DRK), 13, Enum.Font.SourceSansBold, 5
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end
local bV, bG, bM = mtb(" 👻 Visualizar", 45, cV), mtb(" 🎮 Game", 82, cG), mtb(" ⚙️ Misc", 119, cM)

local function tab(a)
    cV.Visible, cG.Visible, cM.Visible, gFace.Visible = (a==cV), (a==cG), (a==cM), (a==cV)
    bV.BackgroundColor3, bV.TextColor3 = (a==cV and C_ACT or C_INA), (a==cV and C_BRIG or C_DRK)
    bG.BackgroundColor3, bG.TextColor3 = (a==cG and C_ACT or C_INA), (a==cG and C_BRIG or C_DRK)
    bM.BackgroundColor3, bM.TextColor3 = (a==cM and C_ACT or C_INA), (a==cM and C_BRIG or C_DRK)
end
bV.MouseButton1Click:Connect(function() tab(cV) end)
bG.MouseButton1Click:Connect(function() tab(cG) end)
bM.MouseButton1Click:Connect(function() tab(cM) end)

_G.LombraActive = true
_G.LombraUI = {cG = cG, cM = cM, C_PURP = C_PURP, C_WHT = C_WHT}

local function close()
    _G.LombraActive = false _G.EncerrarScriptCompleto = nil
    rS:Set3dRenderingEnabled(true) if sGui then sGui:Destroy() end
end
_G.EncerrarScriptCompleto = close bCls.MouseButton1Click:Connect(close)

-- 🚀 CARREGAMENTO AUTOMÁTICO E SEGURO DOS SEUS MÓDULOS DE FUNÇÕES
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet(https://raw.githubusercontent.com/BadKirhin/LombraHub/main/modules/game.lua))

        loadstring(game:HttpGet(https://raw.githubusercontent.com/BadKirhin/LombraHub/main/modules/misc.lua))
    end)
end)
