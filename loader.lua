-- Services de Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variables globales
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera
local targetPlayer = nil

-- Fonction pour activer l'aimbot
local function aimAt(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    local targetPosition = target.HumanoidRootPart.Position
    local ray = Ray.new(camera.CFrame.Position, (targetPosition - camera.CFrame.Position).unit * 1000)
    local hit, position = workspace:FindPartOnRay(ray, character)
    if hit then
        character.Humanoid:MoveTo(position)
    end
end

-- Fonction pour activer l'ESP
local function enableESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Size = UDim2.new(2, 0, 1, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.Parent = v.Character:WaitForChild("HumanoidRootPart")

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            frame.Parent = billboardGui

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Text = v.Name
            textLabel.TextScaled = true
            textLabel.Parent = frame
        end
    end
end

-- Interface Utilisateur
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(1, 0, 0.5, 0)
aimbotButton.Position = UDim2.new(0, 0, 0, 0)
aimbotButton.Text = "Activate Aimbot"
aimbotButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.Parent = frame

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(1, 0, 0.5, 0)
espButton.Position = UDim2.new(0, 0, 0.5, 0)
espButton.Text = "Activate ESP"
espButton.BackgroundColor3 = Color3.fromRGB(0, 0, 128)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Parent = frame

-- Connexion des boutons
aimbotButton.MouseButton1Click:Connect(function()
    if targetPlayer then
        aimAt(targetPlayer.Character)
    end
end)

espButton.MouseButton1Click:Connect(function()
    enableESP()
end)

-- Détection de la cible
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = player:GetMouse()
            local target = mouse.Target
            if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
                targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
            end
        end
    end
end)

-- Boucle principale pour mettre à jour le script
RunService.RenderStepped:Connect(function()
    if targetPlayer then
        aimAt(targetPlayer.Character)
    end
end)
