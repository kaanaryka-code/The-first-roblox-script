local function GetTarget()
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera
    local dist = 150
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
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

-- Пытаемся сделать Silent Aim
local mt = getrawmetatable(game)
local old = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, idx)
    if self == game:GetService("Players").LocalPlayer:GetMouse() and (idx == "Hit" or idx == "Target") then
        local t = GetTarget()
        if t and t.Character then
            if idx == "Hit" then return t.Character.HumanoidRootPart.CFrame end
            if idx == "Target" then return t.Character.HumanoidRootPart end
        end
    end
    return old(self, idx)
end)
setreadonly(mt, true)

print("Script Loaded from GitHub!")
