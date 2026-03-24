--[[ 
    FTAP RAYCAST METHOD (No Meta-Hook)
    Этот метод заменяет функцию Raycast в самом игровом мире.
--]]

local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Настройки
local FOV = 200
local Enabled = true

-- Функция поиска ближайшего
local function GetTarget()
    local target = nil
    local dist = FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local mPos = game:GetService("UserInputService"):GetMouseLocation()
                if (Vector2.new(pos.X, pos.Y) - mPos).Magnitude < dist then
                    target = p
                end
            end
        end
    end
    return target
end

-- ПОДМЕНА RAYCAST (Более стабильный метод)
local oldRaycast = workspace.Raycast
workspace.Raycast = function(self, origin, direction, params)
    local target = GetTarget()
    
    if Enabled and target and target.Character then
        -- Если мы нашли цель, "искривляем" луч в сторону её головы
        local newDirection = (target.Character.HumanoidRootPart.Position - origin).Unit * direction.Magnitude
        return oldRaycast(self, origin, newDirection, params)
    end
    
    return oldRaycast(self, origin, direction, params)
end

print("Raycast Method Loaded! Если цель в FOV, захват будет лететь в неё.")
