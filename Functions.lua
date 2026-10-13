local F = {}
local p = game:GetService("Players").LocalPlayer
local vIM = game:GetService("VirtualInputManager")
local lit = game:GetService("Lighting")
local rS = game:GetService("RunService")
local tS = game:GetService("TweenService")

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

    local velocidade = 230 -- Velocidade segura para não acionar detecções de rubberbanding
    local distancia = (hrp.Position - targetCFrame.Position).Magnitude
    local duracao = distancia / velocidade

    if duracao < 0.1 then duracao = 0.1 end 

    local ti = TweenInfo.new(duracao, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local t = tS:Create(hrp, ti, {CFrame = targetCFrame})
    t:Play()
    t.Completed:Wait()
    hrp.Velocity = Vector3.new(0,0,0) -- Zera a inércia imediatamente após a chegada para não passar direto
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

-- REMOVIDAS: F.AutoComprar e F.AutoAbrir foram completamente deletadas

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
                    if string.sub(obj.Name, 1, 13) == "MonarchArise_" then
                        
                        local npcHrp = obj:FindFirstChild("HumanoidRootPart")
                        local anchor = npcHrp and npcHrp:FindFirstChild("ArisePromptAnchor")
                        local prompt = anchor and anchor:FindFirstChild("MonarchArise")
                        
                        -- Verifica se o corpo ainda é válido e se o prompt está ativo e visível
                        if prompt and prompt:IsA("ProximityPrompt") and npcHrp and prompt.Enabled and obj.Parent then
                            local posicaoOriginal = hrp.CFrame
                            
                            prompt.RequiresLineOfSight = false
                            prompt.MaxActivationDistance = 35
                            
                            -- 1. IDA: Executa o Tween até o NPC morto
                            tweenTo(npcHrp.CFrame + Vector3.new(0, 3, 0))
                            task.wait(0.15) -- Delay de ancoragem (aguarda o motor de física reconhecer a posição)
                            
                            -- 2. INTERAÇÃO ROBUSTA: Simula o clique segurado dinamicamente baseado na HoldDuration
                            if fireproximityprompt then
                                fireproximityprompt(prompt, 1)
                            else
                                -- Fallback simulando a pressão contínua exigida pelo prompt nativo
                                prompt:InputHoldBegin()
                                -- Se o prompt exigir tempo de espera, segura pelo tempo necessário + margem de rede
                                local duration = prompt.HoldDuration > 0 and (prompt.HoldDuration + 0.1) or 0.25
                                task.wait(duration)
                                prompt:InputHoldEnd()
                            end
                            
                            task.wait(0.2) -- Janela de confirmação: Tempo necessário para o servidor processar e sumir com o corpo
                            
                            -- 3. VOLTA: Retorna o jogador para o ponto inicial de defesa
                            tweenTo(posicaoOriginal)
                            
                            task.wait(0.4) -- Delay de respiro pós-interpolação antes de buscar o próximo alvo
                        end
                    end
                end
            end
            task.wait(0.4)
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
