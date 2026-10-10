-- Evita duplicação limpando a execução anterior de forma segura
if _G.EncerrarScriptCompleto then _G.EncerrarScriptCompleto() end

-- Configurações Globais
_G.LombraHubAtivo = true
_G.ConfigData = {AntiAFK=false, FpsBoost=false, BlackScreen=false, AutoComprar=false, AutoAbrir=false, AutoStart=false, AutoPlay=false}

-- 🔄 CARREGAMENTO SEGURO E SÍNCRONO DO GITHUB RAW
-- (Substitua "SeuUsuario" pelo seu nome correto do GitHub)
local UiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/BadKirhin/LombraHub/main/UiLibrary.lua"))()
local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/BadKirhin/LombraHub/main/Functions.lua"))()

-- 🎨 Inicializa a Interface Principal
UiLibrary:CreateWindow()

-- 📂 Criação Automatizada de Abas (Sem risco de tabs em branco!)
local tabVisual = UiLibrary:CreateTab("Visualizar", "👻")
local tabGame = UiLibrary:CreateTab("Game", "🎮")
local tabMisc = UiLibrary:CreateTab("Misc", "⚙️")

-- ⚙️ Adicionando os Elementos na Aba Game
UiLibrary:CreateToggle(tabGame, "Auto Start Partida (Waves)", 5, "AutoStart", Functions.AutoStart)
UiLibrary:CreateToggle(tabGame, "Auto Play Partida (Autoplay)", 38, "AutoPlay", Functions.AutoPlay)
UiLibrary:CreateToggle(tabGame, "Comprar Fenda Temporal (Auto Shop)", 71, "AutoComprar", Functions.AutoComprar)
UiLibrary:CreateToggle(tabGame, "Abrir Fenda (Auto The Almighty)", 104, "AutoAbrir", Functions.AutoAbrir)

-- ⚙️ Adicionando os Elementos na Aba Misc
UiLibrary:CreateToggle(tabMisc, "Anti-AFK (Pulo Simulado)", 5, "AntiAFK", Functions.AntiAFK)
UiLibrary:CreateToggle(tabMisc, "FPS Booster (Remover Texturas)", 38, "FpsBoost", Functions.FpsBoost)
UiLibrary:CreateToggle(tabMisc, "Black Screen (Reduzir Render 3D)", 71, "BlackScreen", Functions.BlackScreen)

-- ✕ Função de Fechamento Integrada
local function close()
    _G.LombraHubAtivo = false
    game:GetService("RunService"):Set3dRenderingEnabled(true)
    if UiLibrary.ScreenGui then UiLibrary.ScreenGui:Destroy() end
    _G.EncerrarScriptCompleto = nil
end

_G.EncerrarScriptCompleto = close
UiLibrary.CloseButton.MouseButton1Click:Connect(close)
