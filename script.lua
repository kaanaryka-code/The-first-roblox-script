--[[
    FTAP ULTIMATE HUB (Solara Edition)
    Разработчик: kaanaryka-code
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "FTAP: Silent Aim Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "FTAP_Solara"})

-- Глобальные переменные
local Settings = {
    SilentAim = false,
    FOV = 150,
    ShowFOV = false,
    FOVColor = Color3.fromRGB(0, 255, 255)
}

-- Создание FOV круга через Drawing API (В Solara это работает!)
local Circle = Drawing.new("Circle")
Circle.Visible = false
Circle.Thickness = 1.5
Circle.Radius = Settings.FOV
Circle.Color = Settings.FOVColor
Circle.Filled = false
Circle.Transparency = 1

-- Функция поиска ближайшего игрока
local function GetClosestTarget()
    local target = nil
    local shortestDistance = math.huge
    local MousePos = game:GetService("UserInputService"):GetMouseLocation()

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - MousePos).Magnitude
                if distance < shortestDistance and distance <= Settings.FOV then
                    shortestDistance = distance
                    target = player
                end
            end
        end
    end
    return target
end

-- ТИХИЙ АИМ (Silent Aim через HookMetamethod)
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, index)
    if Settings.SilentAim and self == game:GetService("Players").LocalPlayer:GetMouse() and (index == "Hit" or index == "Target") and not checkcaller() then
        local target = GetClosestTarget()
        if target and target.Character then
            if index == "Hit" then return target.Character.HumanoidRootPart.CFrame end
            if index == "Target" then return target.Character.HumanoidRootPart end
        end
    end
    return oldIndex(self, index)
end)

-- Создание вкладок
local MainTab = Window:MakeTab({
 Name = "Main Settings",
 Icon = "rbxassetid://4483345998",
 PremiumOnly = false
})

MainTab:AddToggle({
 Name = "Enable Silent Aim",
 Default = false,
 Callback = function(Value)
  Settings.SilentAim = Value
 end    
})

MainTab:AddToggle({
 Name = "Show FOV Circle",
 Default = false,
 Callback = function(Value)
  Settings.ShowFOV = Value
        Circle.Visible = Value
 end    
})

MainTab:AddSlider({
 Name = "FOV Radius",
 Min = 50,
 Max = 600,
 Default = 150,
 Color = Color3.fromRGB(255, 255, 255),
 Increment = 1,
 ValueName = "Pixels",
 Callback = function(Value)
  Settings.FOV = Value
        Circle.Radius = Value
 end    
})

-- Цикл обновления круга
game:GetService("RunService").RenderStepped:Connect(function()
    if Settings.ShowFOV then
        Circle.Position = game:GetService("UserInputService"):GetMouseLocation()
    end
end)

OrionLib:Init()
