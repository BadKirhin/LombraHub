if _G.EncerrarScriptCompleto then _G.EncerrarScriptCompleto() end

_G.LombraHubAtivo = true
_G.ConfigData = {AntiAFK=false, FpsBoost=false, BlackScreen=false, AutoStart=false, AutoPlay=false, AutoArise=false}

local buster = "?cache=" .. math.random(1, 99999)

local UiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/BadKirhin/LombraHub/main/UiLibrary.lua"))()
local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/BadKirhin/LombraHub/main/Functions.lua"))()

UiLibrary:CreateWindow()

local tabVisual = UiLibrary:CreateTab("Visualizar", "👻")
local tabGame = UiLibrary:CreateTab("Game", "🎮")
local tabMisc = UiLibrary:CreateTab("Misc", "⚙️")

_G.ConfigData = {
    AntiAFK = false, 
    FpsBoost = false, 
    BlackScreen = false, 
    AutoStart = false, 
    AutoPlay = false, 
    AutoArise = false, 
    AutoQuestDante = false, -- Novo estado
    AutoSpawnDante = false  -- Novo estado
}

-- ... (código intermediário de carregamento das tabelas e criação das abas) ...

-- 🎮 Elementos da Aba Game
-- Sessão 1: Automações gerais da partida
UiLibrary:CreateSection(tabGame, "AUTOMAÇÕES DA PARTIDA", 5)
UiLibrary:CreateToggle(tabGame, "Auto Start Partida (Waves)", 30, "AutoStart", Functions.AutoStart)
UiLibrary:CreateToggle(tabGame, "Auto Play Partida (Autoplay)", 63, "AutoPlay", Functions.AutoPlay)
UiLibrary:CreateToggle(tabGame, "Auto Arise Monarca (Hold Tween)", 96, "AutoArise", Functions.AutoArise)

-- Sessão 2: Separador visual para o evento/chefão Dante
UiLibrary:CreateSection(tabGame, "BOSS & MISSÕES (DANTE)", 134)
UiLibrary:CreateToggle(tabGame, "Auto Aceitar Quest Dante", 159, "AutoQuestDante", Functions.AutoQuestDante)
UiLibrary:CreateToggle(tabGame, "Auto Spawn Dante (Medium)", 192, "AutoSpawnDante", Functions.AutoSpawnDante)

-- ⚙️ Elementos da Aba Misc
UiLibrary:CreateToggle(tabMisc, "Anti-AFK (Pulo Simulado)", 5, "AntiAFK", Functions.AntiAFK)
UiLibrary:CreateToggle(tabMisc, "FPS Booster (Remover Texturas)", 38, "FpsBoost", Functions.FpsBoost)
UiLibrary:CreateToggle(tabMisc, "Black Screen (Reduzir Render 3D)", 71, "BlackScreen", Functions.BlackScreen)
UiLibrary:CreateButton(tabMisc, "Reconectar ao Servidor", 104, Functions.Rejoin)

local function close()
    _G.LombraHubAtivo = false
    game:GetService("RunService"):Set3dRenderingEnabled(true)
    if UiLibrary.ScreenGui then UiLibrary.ScreenGui:Destroy() end
    _G.EncerrarScriptCompleto = nil
end

_G.EncerrarScriptCompleto = close
UiLibrary.CloseButton.MouseButton1Click:Connect(close)
