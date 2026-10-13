local F = {}
local p = game:GetService("Players").LocalPlayer
local vIM = game:GetService("VirtualInputManager")
local lit = game:GetService("Lighting")
local rS = game:GetService("RunService")
local tS = game:GetService("TweenService") -- Serviço de movimentação suave

local function buf(l)
    local b = buffer.create(#l)
    for i=1,#l do buffer.writeu8(b, i-1, l[i]) end
    return b
end

-- Função auxiliar interna para realizar o deslocamento via Tween suave
local function tweenTo(targetCFrame)
    local char = p.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Velocidade de deslocamento equilibrada (Studs por segundo) para não dar kick
    local velocidade = 250 
    local distancia = (hrp.Position - targetCFrame.Position).Magnitude
    local duracao = distancia / velocidade

    -- Garante que se estiver muito perto, não demore nada
    if duracao < 0.1 then duracao = 0.1 end 

    local ti = TweenInfo.new(duracao, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local t = tS:Create(hrp, ti, {CFrame = targetCFrame})
    t:Play()
    t.Completed:Wait() -- Aguarda o personagem concluir a chegada física
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
    task.spawn(function()
        while e and _G.LombraHubAtivo and _G.ConfigData.AutoArise do
            local cam = workspace:FindFirstChildOfClass("Camera")
            local clientWorld = cam and cam:FindFirstChild("ClientWorld")
            local mapEffects = clientWorld and clientWorld:FindFirstChild("MapEffects")
            
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if mapEffects and hrp then
                for _, obj in pairs(mapEffects:GetChildren()) do
                    -- Alvo: Verifica os modelos que começam com o padrão de monarca morto
                    if string.sub(obj.Name, 1, 13) == "MonarchArise_" then
                        
                        local npcHrp = obj:FindFirstChild("HumanoidRootPart")
                        local anchor = npcHrp and npcHrp:FindFirstChild("ArisePromptAnchor")
                        local prompt = anchor and anchor:FindFirstChild("MonarchArise")
                        
                        -- Se o prompt e a parte física do NPC existirem no frame atual
                        if prompt and prompt:IsA("ProximityPrompt") and npcHrp and prompt.Enabled then
                            -- Guarda onde você estava defendendo a rota originalmente
                            local posicaoOriginal = hrp.CFrame
                            
                            -- Garante visibilidade e ativação máxima do gatilho
                            prompt.RequiresLineOfSight = false
                            prompt.MaxActivationDistance = 30
                            
                            -- 1. TWEEN DE IDA: Desloca o personagem suavemente até o monstro
                            tweenTo(npcHrp.CFrame + Vector3.new(0, 3, 0))
                            task.wait(0.1) -- Tempo de acomodação física da rede (100ms)
                            
                            -- 2. INTERAÇÃO NATIVA: Ativa o gatilho físico
                            if fireproximityprompt then
                                fireproximityprompt(prompt, 1)
                            else
                                prompt:InputHoldBegin()
                                task.wait(0.1)
                                prompt:InputHoldEnd()
                            end
                            
                            task.wait(0.1) -- Aguarda o servidor computar o Arise
                            
                            -- 3. TWEEN DE VOLTA: Retorna o jogador para sua posição de origem de forma limpa
                            tweenTo(posicaoOriginal)
                            
                            task.wait(0.3) -- Pequena folga anti-glitch antes de ir para o próximo alvo
                        end
                    end
                end
            end
            task.wait(0.5) -- Nova varredura de corpos na tela a cada 500ms
        end
    end)
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
