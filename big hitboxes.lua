-- Настройки
local HITBOX_SIZE = 6
local HITBOX_TRANSPARENCY = 0.8

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            
            root.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
            

            root.Transparency = HITBOX_TRANSPARENCY
            root.Color = Color3.fromRGB(255, 0, 0)
            root.CanCollide = false
        end
    end
end)

print("Script is loaded")