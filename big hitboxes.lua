-- Настройки
local HITBOX_SIZE = 15 -- Размер хитбокса (стандарт 2, попробуй 15-20)
local HITBOX_TRANSPARENCY = 0.7 -- Прозрачность (0.5 - видно, 1 - невидимо)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        -- Проверяем, что это не мы и персонаж существует
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            
            -- Увеличиваем размер
            root.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
            

            root.Transparency = HITBOX_TRANSPARENCY
            root.Color = Color3.fromRGB(255, 0, 0)
            root.CanCollide = false
        end
    end
end)

print("Script is loaded")