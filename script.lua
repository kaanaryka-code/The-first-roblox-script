local REACH_SIZE = 6 -- Радиус захвата
local MAX_DISTANCE = 30 -- Дальность в игре

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local Magnet = Instance.new("Part")
Magnet.Name = "SolaraMagnet"
Magnet.Transparency = 0.8
Magnet.Color = Color3.fromRGB(255, 0, 0)
Magnet.CanCollide = false
Magnet.Anchored = true
Magnet.CastShadow = false
Magnet.Parent = workspace

local function NoPhysics(part)
    part.Massless = true
    part.CanTouch = true 
    part.CanQuery = true 
end
NoPhysics(Magnet)

local function GetClosestTarget()
    local target = nil
    local minDist = math.huge

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                local worldDist = (LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                
                if dist < 300 and worldDist < MAX_DISTANCE then -- 300 - радиус наводки
                    if dist < minDist then
                        target = hrp
                        minDist = dist
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    local target = GetClosestTarget()
    if target then
        Magnet.Size = Vector3.new(REACH_SIZE, REACH_SIZE, REACH_SIZE)
        Magnet.CFrame = target.CFrame
    else
        Magnet.CFrame = CFrame.new(0, 5000, 0) -- Прячем, если никого нет
    end
end)
