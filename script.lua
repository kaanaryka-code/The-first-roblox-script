--[[
    FTAP Custom Hub v1.0
    Разработчик: kaanaryka-code
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "FTAP Silent Aim Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "FTAPConfig"})

-- Переменные для настроек
local Settings = {
    SilentAim = false,
    FOV = 150,
    ShowFOV = false
}

-- Рисование круга FOV (Drawing API)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Filled = false
FOVCircle.Radius = Settings.FOV

-- Логика поиска цели
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

-- Хук для Silent Aim (Защищенный pcall)
pcall(function()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__index = newcclosure(function(self, index)
        if Settings.SilentAim and self == game:GetService("Players").LocalPlayer:GetMouse() and (index == "Hit" or index == "Target") then
            local target = GetClosestTarget()
            if target and target.Character then
                if index == "Hit" then return target.Character.HumanoidRootPart.CFrame end
                if index == "Target" then return target.Character.HumanoidRootPart end
            end
        end
        return oldIndex(self, index)
    end)
    setreadonly(mt, true)
end)

-- Создание вкладок в меню
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
        FOVCircle.Visible = Value
 end    
})

MainTab:AddSlider({
 Name = "FOV Radius",
 Min = 50,
 Max = 500,
 Default = 150,
 Color = Color3.fromRGB(0, 255, 255),
 Increment = 1,
 ValueName = "pixels",
 Callback = function(Value)
  Settings.FOV = Value
        FOVCircle.Radius = Value
 end    
})

-- Обновление позиции круга
game:GetService("RunService").RenderStepped:Connect(function()
    if Settings.ShowFOV then
        FOVCircle.Position = game:GetService("UserInputService"):GetMouseLocation()
    end
end)

OrionLib:Init()
print("FTAP Hub Loaded!")
