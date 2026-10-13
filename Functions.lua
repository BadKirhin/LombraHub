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

function F.AutoComprar(e)
    while e and _G.LombraHubAtivo and _G.ConfigData.AutoComprar do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_LOBBY_EVENT_SHOPS_V1_BLINK_RELIABLE_REMOTE")
        if r then r:FireServer(buf({4,13,1,0,84,101,109,112,111,114,97,108,32,82,105,102,116}), {}) end
        task.wait(3)
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
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_GAME_MONARCH_ARISE_V1_BLINK_RELIABLE_REMOTE")
        if r then
            -- Mapeia o caminho exato descoberto no Dex Explorer dentro da câmera ativa
            local cam = workspace:FindFirstChildOfClass("Camera")
            local clientWorld = cam and cam:FindFirstChild("ClientWorld")
            local mapEffects = clientWorld and clientWorld:FindFirstChild("MapEffects")
            
            if mapEffects then
                for _, obj in pairs(mapEffects:GetChildren()) do
                    -- Verifica se o nome do modelo começa com o prefixo do Arise
                    if string.sub(obj.Name, 1, 13) == "MonarchArise_" then
                        -- Corta o prefixo e isola apenas o UUID (Ex: 2478ae8a-be67...)
                        local uuid = string.sub(obj.Name, 14)
                        
                        -- Garante que o ProximityPrompt ainda existe e está ativo na hierarquia interna
                        local hrp = obj:FindFirstChild("HumanoidRootPart")
                        local anchor = hrp and hrp:FindFirstChild("ArisePromptAnchor")
                        local prompt = anchor and anchor:FindFirstChild("MonarchArise")
                        
                        if prompt and type(uuid) == "string" and #uuid >= 30 then
                            -- Estrutura inicial do buffer gravada pelo Cobalt: 4 (ação), contador de pacotes, zeros, indexador (2)
                            local bytesTable = {4, arisePacketSequence, 0, 0, 0, 2}
                            
                            -- Injeta o UUID convertido caractere por caractere para formato ASCII
                            for i = 1, #uuid do
                                table.insert(bytesTable, string.byte(uuid, i))
                            end
                            
                            -- Constrói o objeto de buffer físico e envia ao servidor
                            local finalBuffer = buffer.create(#bytesTable)
                            for i = 1, #bytesTable do
                                buffer.writeu8(finalBuffer, i - 1, bytesTable[i])
                            end
                            
                            r:FireServer(finalBuffer, nil)
                            
                            -- Incrementa o contador de forma rotativa (Blink Protocol requirements)
                            arisePacketSequence = (arisePacketSequence >= 255) and 1 or (arisePacketSequence + 1)
                            task.wait(0.1) -- Proteção rápida anti-kick por spam de rede
                        end
                    end
                end
            end
        end
        task.wait(0.8) -- Varre a pasta de efeitos periodicamente à procura de novos abates
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
