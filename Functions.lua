-- Functions.lua
local F = {}
local p = game:GetService("Players").LocalPlayer
local vIM = game:GetService("VirtualInputManager")
local lit = game:GetService("Lighting")
local rS = game:GetService("RunService")

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

return F
