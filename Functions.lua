local F = {}
local p = game:GetService("Players").LocalPlayer
local vIM = game:GetService("VirtualInputManager")
local lit = game:GetService("Lighting")
local rS = game:GetService("RunService")

-- Sequenciador de pacotes dinâmicos exigido pelo protocolo Blink
local arisePacketSequence = 33

local function buf(l)
    local b = buffer.create(#l)
    for i=1,#l do buffer.writeu8(b, i-1, l[i]) end
    return b
end

function F.AutoStart(e)
    while e and _G.LombraHubAtivo and _G.ConfigData.AutoStart do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_GAME_WAVES_V1_BLINK_RELIABLE_REMOTE")
        if r then r:FireServer(buf({2}), {}) end
        task.wait(2)
    end
end

function F.AutoPlay(e)
    while e and _G.LombraHubAtivo and _G.ConfigData.AutoPlay do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_GAME_AUTOPLAY_V1_BLINK_RELIABLE_REMOTE")
        if r then r:FireServer(buf({0}), {}) end
        task.wait(2)
    end
end

function F.AutoAbrir(e)
    while e and _G.LombraHubAtivo and _G.ConfigData.AutoAbrir do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_LOBBY_SPECIAL_EVENTS_V1_BLINK_RELIABLE_REMOTE")
        if r then r:FireServer(buf({14,12,84,104,101,32,65,108,109,105,103,104,116,121}), {}) end
        task.wait(4)
    end
end

function F.AutoArise(e)
    while e and _G.LombraHubAtivo and _G.ConfigData.AutoArise do
        -- Acessa com segurança a hierarquia da Câmera descoberta no Dex
        local cam = workspace:FindFirstChildOfClass("Camera")
        local clientWorld = cam and cam:FindFirstChild("ClientWorld")
        local mapEffects = clientWorld and clientWorld:FindFirstChild("MapEffects")
        
        if mapEffects then
            for _, obj in pairs(mapEffects:GetChildren()) do
                -- Alvo: Modelos dos NPCs mortos (MonarchArise_...)
                if string.sub(obj.Name, 1, 13) == "MonarchArise_" then
                    
                    -- Localiza o ProximityPrompt na estrutura interna exata
                    local hrp = obj:FindFirstChild("HumanoidRootPart")
                    local anchor = hrp and hrp:FindFirstChild("ArisePromptAnchor")
                    local prompt = anchor and anchor:FindFirstChild("MonarchArise")
                    
                    -- Se o prompt existir e estiver habilitado para cliques
                    if prompt and prompt:IsA("ProximityPrompt") then
                        -- Força o prompt a ficar visível e ativo independente da distância do jogador
                        prompt.RequiresLineOfSight = false
                        prompt.MaxActivationDistance = 9999
                        
                        -- EXECUÇÃO NATIVA: Usa a função interna do executor para simular a interação física
                        -- Isso faz com que o próprio jogo gere o Buffer perfeito e assinado para o servidor.
                        if fireproximityprompt then
                            fireproximityprompt(prompt, 1)
                        else
                            -- Fallback caso o seu executor use a nomenclatura alternativa
                            prompt:InputHoldBegin()
                            task.wait(0.05)
                            prompt:InputHoldEnd()
                        end
                    end
                end
            end
        end
        task.wait(0.3) -- Varredura ultra rápida (300ms) para limpar os monstros mortos da tela
    end
end


function F.AntiAFK(e)
    while e and _G.LombraHubAtivo and _G.ConfigData.AntiAFK do
        local chr = p.Character
        if chr and chr:FindFirstChildOfClass("Humanoid") and chr:FindFirstChildOfClass("Humanoid").Health > 0 then
            vIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game) task.wait(0.05)
            vIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
        task.wait(10)
    end
end

function F.FpsBoost(e)
    lit.GlobalShadows = not e
    if e then
        for _, o in pairs(workspace:GetDescendants()) do
            if o:IsA("BasePart") and not o:IsA("MeshPart") then o.Material = Enum.Material.SmoothPlastic
            elseif o:IsA("Texture") or o:IsA("Decal") then o.Transparency = 1
            elseif o:IsA("ParticleEmitter") then o.Enabled = false end
        end
    end
end

function F.BlackScreen(e)
    rS:Set3dRenderingEnabled(not e)
end

function F.Rejoin()
    local ts = game:GetService("TeleportService")
    if game.JobId == "" then 
        ts:Teleport(game.PlaceId, p) 
    else 
        ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p) 
    end
end

return F
