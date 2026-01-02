local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local REFLECTANCE = 0.2
local MATERIAL = Enum.Material.SmoothPlastic
local jaAplicado = {}
local maxNivel = 4
local reflectanceNiveis = {0.1,0.2,0.3,0.4}

local function aplicarReflexo(part)
    if not part:IsA("BasePart") then return end
    if jaAplicado[part] then
        part.Reflectance = REFLECTANCE
        return
    end
    if part:IsA("MeshPart") then
        pcall(function() part.Material = MATERIAL end)
    else
        part.Material = MATERIAL
    end
    part.Reflectance = REFLECTANCE
    jaAplicado[part] = true
end

local function aplicarRecursivo(obj)
    if obj:IsA("Model") then
        for _, child in ipairs(obj:GetDescendants()) do
            aplicarReflexo(child)
        end
    else
        aplicarReflexo(obj)
    end
end

for _, obj in ipairs(Workspace:GetDescendants()) do
    aplicarRecursivo(obj)
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then
        aplicarRecursivo(plr.Character)
    end
end

Workspace.DescendantAdded:Connect(aplicarRecursivo)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(aplicarRecursivo)
end)

-- GUI Delta
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,300,0,180)
frame.Position = UDim2.new(0.5,-150,0.5,-90)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0,12)
frameCorner.Parent = frame

local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)), ColorSequenceKeypoint.new(1,Color3.new(0,0,0))})
frameGradient.Rotation = 0
frameGradient.Parent = frame

-- animação gradiente lateral
RunService.RenderStepped:Connect(function(delta)
    frameGradient.Rotation = (frameGradient.Rotation + 30*delta)%360
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Best Shader"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0,100,0,30)
textBox.Position = UDim2.new(0,25,0,60)
textBox.Text = "2"
textBox.ClearTextOnFocus = false
textBox.TextColor3 = Color3.new(1,1,1)
textBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 16
textBox.BorderSizePixel = 0
textBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0,8)
boxCorner.Parent = textBox

local textGradient = Instance.new("UIGradient")
textGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,0)), ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))})
textGradient.Rotation = 0
textGradient.Parent = textBox

RunService.RenderStepped:Connect(function(delta)
    textGradient.Rotation = (textGradient.Rotation + 50*delta)%360
end)

local shaderButton = Instance.new("TextButton")
shaderButton.Size = UDim2.new(0,150,0,40)
shaderButton.Position = UDim2.new(0,25,0,110)
shaderButton.Text = "Aplicar Reflexo"
shaderButton.TextColor3 = Color3.new(1,1,1)
shaderButton.Font = Enum.Font.GothamBold
shaderButton.TextSize = 16
shaderButton.BorderSizePixel = 0
shaderButton.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0,10)
btnCorner.Parent = shaderButton

local btnGradient = Instance.new("UIGradient")
btnGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,0)), ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))})
btnGradient.Rotation = 0
btnGradient.Parent = shaderButton

RunService.RenderStepped:Connect(function(delta)
    btnGradient.Rotation = (btnGradient.Rotation + 100*delta)%360
end)

shaderButton.MouseButton1Click:Connect(function()
    local inputValue = tonumber(textBox.Text) or 1
    if inputValue > maxNivel then inputValue = maxNivel end
    if inputValue < 1 then inputValue = 1 end
    REFLECTANCE = reflectanceNiveis[inputValue]
    jaAplicado = {}
    aplicarRecursivo(Workspace)
    textBox.Text = tostring(inputValue)
end)