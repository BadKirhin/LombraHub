-- Functions.lua
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

function F.AutoArise(e)
    while e and _G.LombraHubAtivo and _G.ConfigData.AutoArise do
        local r = game:GetService("ReplicatedStorage"):FindFirstChild("AV_GAME_MONARCH_ARISE_V1_BLINK_RELIABLE_REMOTE")
        if r then
            -- Busca dinâmica por prompts ativos de Arise no mapa
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and (obj.ObjectText == "Arise" or obj.ActionText == "Arise") then
                    local parentModel = obj.Parent
                    if parentModel then
                        -- Tenta extrair o UID de Atributos, Valores de String ou do nome do objeto
                        local uuid = parentModel:GetAttribute("UID") or 
                                     parentModel:FindFirstChild("UID") and parentModel.UID.Value or 
                                     parentModel.Name
                        
                        -- Valida o formato mínimo de string de identificação (UUIDs possuem mais de 30 caracteres)
                        if type(uuid) == "string" and #uuid >= 30 then
                            -- Estrutura inicial gravada nos logs: 4 (ação), sequenciador, indexadores
                            local bytesTable = {4, arisePacketSequence, 0, 0, 0, 2}
                            
                            -- Injeta o UUID convertido caractere por caractere para formato numérico ASCII
                            for i = 1, #uuid do
                                table.insert(bytesTable, string.byte(uuid, i))
                            end
                            
                            -- Constrói o buffer físico e dispara o Remote
                            local finalBuffer = buffer.create(#bytesTable)
                            for i = 1, #bytesTable do
                                buffer.writeu8(finalBuffer, i - 1, bytesTable[i])
                            end
                            
                            r:FireServer(finalBuffer, nil)
                            
                            -- Incrementa de forma rotativa o contador de sequência para validar as próximas chamadas
                            arisePacketSequence = (arisePacketSequence >= 255) and 1 or (arisePacketSequence + 1)
                            task.wait(0.1) -- Proteção rápida anti-kick por spam de rede
                        end
                    end
                end
            end
        end
        task.wait(0.8) -- Varre o mapa periodicamente à procura de novos abates
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
