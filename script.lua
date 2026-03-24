--[[
    FTAP CUSTOM SIMPLE HUB (JJSploit Friendly)
    Никаких внешних ссылок, всё в одном коде.
]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Настройки
_G.SilentAim = false
_G.FOV = 150

-- 1. СОЗДАЕМ МЕНЮ (РУЧНАЯ РАБОТА)
local Gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.1, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true -- Можно двигать мышкой

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "FTAP HUB (Press M to Hide)"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

local ToggleBtn = Instance.new("TextButton", Frame)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 30)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleBtn.Text = "Silent Aim: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

local FOVBtn = Instance.new("TextButton", Frame)
FOVBtn.Size = UDim2.new(0.8, 0, 0, 30)
FOVBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
FOVBtn.Text = "FOV: 150 (+/-)"
FOVBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- 2. ЛОГИКА КНОПОК
ToggleBtn.MouseButton1Click:Connect(function()
    _G.SilentAim = not _G.SilentAim
    ToggleBtn.Text = _G.SilentAim and "Silent Aim: ON" or "Silent Aim: OFF"
    ToggleBtn.BackgroundColor3 = _G.SilentAim and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- Скрытие меню на M
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        Gui.Enabled = not Gui.Enabled
    end
end)

-- 3. ПОИСК ЦЕЛИ
local function GetTarget()
    local target = nil
    local dist = _G.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local mPos = game:GetService("UserInputService"):GetMouseLocation()
                local mag = (Vector2.new(pos.X, pos.Y) - mPos).Magnitude
                if mag < dist then
                    dist = mag
                    target = p
                end
            end
        end
    end
    return target
end

-- 4. ПОДМЕНА (БЕЗОПАСНАЯ)
local mt = getrawmetatable(game)
local old = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, idx)
    if _G.SilentAim and self == Mouse and (idx == "Hit" or idx == "Target") then
        local t = GetTarget()
        if t and t.Character then
            if idx == "Hit" then return t.Character.HumanoidRootPart.CFrame end
            if idx == "Target" then return t.Character.HumanoidRootPart end
        end
    end
    return old(self, idx)
end)
setreadonly(mt, true)

print("Скрипт полностью переписан без внешних библиотек!")
