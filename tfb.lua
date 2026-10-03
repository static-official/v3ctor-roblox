local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local GoalCorners = {
    A = {
        TopLeft = Vector3.new(-313.13, 15.0, 78.036),
        TopRight = Vector3.new(-313.13, 15.0, 107.715)
    },
    B = {
        TopLeft = Vector3.new(-115.936, 15.0, 78.036),
        TopRight = Vector3.new(-115.936, 15.0, 107.715)
    }
}

local CurrentGoal = "A"
local TopCornersEnabled = false
local BallFlyEnabled = false

local Themes = {
    {Main = Color3.fromRGB(25, 25, 25), Accent = Color3.fromRGB(90, 100, 255), Text = Color3.fromRGB(255, 255, 255)},
    {Main = Color3.fromRGB(15, 15, 15), Accent = Color3.fromRGB(255, 50, 100), Text = Color3.fromRGB(255, 255, 255)},
    {Main = Color3.fromRGB(245, 245, 245), Accent = Color3.fromRGB(40, 200, 110), Text = Color3.fromRGB(30, 30, 30)},
    {Main = Color3.fromRGB(30, 10, 40), Accent = Color3.fromRGB(180, 50, 255), Text = Color3.fromRGB(255, 255, 255)}
}
local CurrentTheme = 1

local function MakeDraggable(gui)
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperCoolUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Themes[CurrentTheme].Main
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Themes[CurrentTheme].Accent
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

MakeDraggable(MainFrame)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Themes[CurrentTheme].Accent
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 14)
TitleFix.Position = UDim2.new(0, 0, 1, -14)
TitleFix.BackgroundColor3 = Themes[CurrentTheme].Accent
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Aimbot Panel"
TitleLabel.TextColor3 = Themes[CurrentTheme].Text
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0, 7)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 24
MinBtn.Font = Enum.Font.GothamBlack
MinBtn.Parent = TitleBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

local MinCircle = Instance.new("TextButton")
MinCircle.Size = UDim2.new(0, 60, 0, 60)
MinCircle.Position = UDim2.new(0.5, -30, 0, 20)
MinCircle.BackgroundColor3 = Themes[CurrentTheme].Accent
MinCircle.Text = "UI"
MinCircle.TextColor3 = Themes[CurrentTheme].Text
MinCircle.TextSize = 22
MinCircle.Font = Enum.Font.GothamBlack
MinCircle.Visible = false
MinCircle.Parent = ScreenGui
local MinCircleCorner = Instance.new("UICorner")
MinCircleCorner.CornerRadius = UDim.new(1, 0)
MinCircleCorner.Parent = MinCircle
local MinCircleStroke = Instance.new("UIStroke")
MinCircleStroke.Color = Color3.fromRGB(255, 255, 255)
MinCircleStroke.Thickness = 2
MinCircleStroke.Parent = MinCircle

MakeDraggable(MinCircle)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinCircle.Visible = true
    MinCircle.Position = UDim2.new(0, MainFrame.AbsolutePosition.X, 0, MainFrame.AbsolutePosition.Y)
end)

MinCircle.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinCircle.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -65)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 5
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Content

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim.new(0, 5)
UIPadding.Parent = Content

local function CreateButton(text, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Themes[CurrentTheme].Main
    btn.Text = text
    btn.TextColor3 = Themes[CurrentTheme].Text
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Themes[CurrentTheme].Accent
    stroke.Thickness = 1.5
    stroke.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Themes[CurrentTheme].Accent}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Themes[CurrentTheme].Main}):Play()
    end)
    
    return btn
end

local ThemeBtn = CreateButton("Cycle Theme", Content)
local GoalBtn = CreateButton("Target Goal: A", Content)
local TopCornersBtn = CreateButton("Top Corners: OFF", Content)
local BallFlyBtn = CreateButton("Ball Fly On Top: OFF", Content)
local AutoScoreBtn = CreateButton("Auto Score", Content)

local Buttons = {ThemeBtn, GoalBtn, TopCornersBtn, BallFlyBtn, AutoScoreBtn}

local function UpdateTheme()
    local t = Themes[CurrentTheme]
    MainFrame.BackgroundColor3 = t.Main
    TitleBar.BackgroundColor3 = t.Accent
    TitleFix.BackgroundColor3 = t.Accent
    TitleLabel.TextColor3 = t.Text
    UIStroke.Color = t.Accent
    MinCircle.BackgroundColor3 = t.Accent
    MinCircle.TextColor3 = t.Text
    
    for _, btn in pairs(Buttons) do
        btn.BackgroundColor3 = t.Main
        btn.TextColor3 = t.Text
        local stroke = btn:FindFirstChild("UIStroke")
        if stroke then
            stroke.Color = t.Accent
        end
    end
end

ThemeBtn.MouseButton1Click:Connect(function()
    CurrentTheme = CurrentTheme + 1
    if CurrentTheme > #Themes then CurrentTheme = 1 end
    UpdateTheme()
end)

GoalBtn.MouseButton1Click:Connect(function()
    if CurrentGoal == "A" then
        CurrentGoal = "B"
    else
        CurrentGoal = "A"
    end
    GoalBtn.Text = "Target Goal: " .. CurrentGoal
end)

TopCornersBtn.MouseButton1Click:Connect(function()
    TopCornersEnabled = not TopCornersEnabled
    TopCornersBtn.Text = "Top Corners: " .. (TopCornersEnabled and "ON" or "OFF")
end)

BallFlyBtn.MouseButton1Click:Connect(function()
    BallFlyEnabled = not BallFlyEnabled
    BallFlyBtn.Text = "Ball Fly On Top: " .. (BallFlyEnabled and "ON" or "OFF")
end)

local function GetBall()
    return workspace:FindFirstChild("SoccerBall")
end

AutoScoreBtn.MouseButton1Click:Connect(function()
    local ball = GetBall()
    local char = LocalPlayer.Character
    if ball and ball:IsA("BasePart") and char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        ball.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 4
        
        local targetCorner = GoalCorners[CurrentGoal].TopLeft
        local dir = (targetCorner - ball.Position).Unit
        
        ball.AssemblyLinearVelocity = dir * 125
    end
end)

RunService.RenderStepped:Connect(function()
    local ball = GetBall()
    local char = LocalPlayer.Character
    local cam = workspace.CurrentCamera
    
    if ball and ball:IsA("BasePart") and char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        
        if BallFlyEnabled then
            ball.CFrame = hrp.CFrame + Vector3.new(0, 6, 0)
            ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            ball.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
        
        if TopCornersEnabled then
            local target1 = GoalCorners[CurrentGoal].TopLeft
            local target2 = GoalCorners[CurrentGoal].TopRight
            
            local dist1 = (hrp.Position - target1).Magnitude
            local dist2 = (hrp.Position - target2).Magnitude
            local chosenTarget = dist1 < dist2 and target1 or target2
            
            cam.CFrame = CFrame.new(cam.CFrame.Position, chosenTarget)
        end
    end
end)
