local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "v3ctor_panel"
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999
gui.Parent = player:WaitForChild("PlayerGui")

local currentTheme = "Liquid Glass"
local currentTint = Color3.fromRGB(80, 150, 255)
local activeCategory = "Aimbot"
local uiFont = Enum.Font.GothamMedium

local themeObjects = {
	Panels = {},
	Strokes = {},
	Gradients = {},
	Buttons = {},
	ToggleBGs = {},
	Accents = {},
	Texts = {}
}

local function pushNotification(txt)
	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 280, 0, 48)
	frame.Position = UDim2.new(0.5, -140, 0, -60)
	frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	frame.BackgroundTransparency = 0.15
	frame.BorderSizePixel = 0
	frame.ZIndex = 10000
	
	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 8)
	
	local stroke = Instance.new("UIStroke", frame)
	stroke.Thickness = 1.5
	stroke.Color = currentTint
	
	local grad = Instance.new("UIGradient", frame)
	grad.Enabled = false
	
	table.insert(themeObjects.Panels, frame)
	table.insert(themeObjects.Strokes, stroke)
	table.insert(themeObjects.Gradients, grad)
	
	local lbl = Instance.new("TextLabel", frame)
	lbl.Size = UDim2.new(1, -20, 1, 0)
	lbl.Position = UDim2.new(0, 10, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = txt
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.Font = uiFont
	lbl.TextSize = 13
	lbl.TextWrapped = true
	lbl.ZIndex = 10001
	table.insert(themeObjects.Texts, lbl)
	
	TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -140, 0, 20)}):Play()
	
	task.delay(3.5, function()
		local tw = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -140, 0, -60)})
		tw:Play()
		tw.Completed:Connect(function()
			frame:Destroy()
		end)
	end)
end

local dumpedBall = nil
local touchConn = nil
local topCornersAim = false
local lastShootTime = 0

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

local targetGoal = "A"
local targetCorner = "TopLeft"

local function teleportToCorner(ball)
	if not ball or not ball.Parent then return end
	if tick() - lastShootTime < 0.2 then return end
	lastShootTime = tick()

	local targetPos = GoalCorners[targetGoal][targetCorner]
	local targetCF = CFrame.new(targetPos)

	if ball:IsA("Model") then
		ball:PivotTo(targetCF)
	elseif ball:IsA("BasePart") then
		ball.CFrame = targetCF
	end

	local bPart = ball:IsA("BasePart") and ball or (ball:IsA("Model") and (ball.PrimaryPart or ball:FindFirstChildWhichIsA("BasePart", true)))
	if bPart then
		pcall(function()
			bPart.AssemblyLinearVelocity = Vector3.zero
			bPart.AssemblyAngularVelocity = Vector3.zero
		end)
	end
end

local function bindBallTouch(ball)
	if touchConn then touchConn:Disconnect() touchConn = nil end
	if not ball then return end
	
	local bPart = ball:IsA("BasePart") and ball or (ball:IsA("Model") and (ball.PrimaryPart or ball:FindFirstChildWhichIsA("BasePart", true)))
	if bPart then
		touchConn = bPart.Touched:Connect(function(hit)
			if topCornersAim and hit and hit.Parent and player.Character and hit:IsDescendantOf(player.Character) then
				teleportToCorner(ball)
			end
		end)
	end
end

task.spawn(function()
	while task.wait(0.5) do
		if not dumpedBall or not dumpedBall.Parent then
			local ball = workspace:FindFirstChild("SoccerBall", true)
			if ball and (ball:IsA("BasePart") or ball:IsA("Model")) then
				dumpedBall = ball
				bindBallTouch(ball)
				pushNotification('"SoccerBall" dumped from game assets.')
			end
		end
	end
end)

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 70, 0, 40)
openBtn.Position = UDim2.new(0.5, -35, 0.5, -20)
openBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
openBtn.Text = "v3ctor"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = uiFont
openBtn.TextSize = 14
openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local openBtnStroke = Instance.new("UIStroke", openBtn)
local openBtnGrad = Instance.new("UIGradient", openBtn)
openBtnGrad.Enabled = false

table.insert(themeObjects.Panels, openBtn)
table.insert(themeObjects.Strokes, openBtnStroke)
table.insert(themeObjects.Gradients, openBtnGrad)
table.insert(themeObjects.Texts, openBtn)

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 480, 0, 320)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.ClipsDescendants = true
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 2
local gradient = Instance.new("UIGradient", mainFrame)
gradient.Enabled = false

table.insert(themeObjects.Panels, mainFrame)
table.insert(themeObjects.Strokes, stroke)
table.insert(themeObjects.Gradients, gradient)

local particleContainer = Instance.new("Frame", mainFrame)
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.ZIndex = 1
particleContainer.ClipsDescendants = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "v3ctor"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = uiFont
title.ZIndex = 3
table.insert(themeObjects.Texts, title)

local line = Instance.new("Frame", title)
line.Size = UDim2.new(1, 0, 0, 1)
line.Position = UDim2.new(0, 0, 1, 0)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BackgroundTransparency = 0.8
line.BorderSizePixel = 0
line.ZIndex = 3

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -32, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = uiFont
closeBtn.TextSize = 12
closeBtn.ZIndex = 5
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local minBtn = Instance.new("TextButton", mainFrame)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -62, 0, 8)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = uiFont
minBtn.TextSize = 16
minBtn.ZIndex = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local categoryContainer = Instance.new("Frame", mainFrame)
categoryContainer.Size = UDim2.new(0, 120, 1, -40)
categoryContainer.Position = UDim2.new(0, 0, 0, 40)
categoryContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
categoryContainer.BackgroundTransparency = 0.5
categoryContainer.BorderSizePixel = 0
categoryContainer.ZIndex = 3

local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Size = UDim2.new(1, -120, 1, -40)
contentContainer.Position = UDim2.new(0, 120, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.ZIndex = 3

local categoryLayout = Instance.new("UIListLayout", categoryContainer)
categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
categoryLayout.Padding = UDim.new(0, 6)
categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", categoryContainer).PaddingTop = UDim.new(0, 10)

local function applyTheme()
	local t = TweenInfo.new(0.4)
	local panelBg, panelTrans, strokeColor, strokeTrans
	local btnBg, btnTrans, textCol = Color3.fromRGB(30, 30, 30), 0, Color3.fromRGB(200, 200, 200)
	
	if currentTheme == "Dark" then
		panelBg, panelTrans = Color3.fromRGB(15, 15, 15), 0.1
		strokeColor, strokeTrans = Color3.fromRGB(50, 50, 50), 0
		btnBg, btnTrans = Color3.fromRGB(30, 30, 30), 0
		textCol = Color3.fromRGB(220, 220, 220)
	elseif currentTheme == "Glass" then
		panelBg, panelTrans = Color3.fromRGB(255, 255, 255), 0.85
		strokeColor, strokeTrans = Color3.fromRGB(255, 255, 255), 0.5
		btnBg, btnTrans = Color3.fromRGB(255, 255, 255), 0.7
		textCol = Color3.fromRGB(30, 30, 30)
	elseif currentTheme == "Glossy" then
		panelBg, panelTrans = Color3.fromRGB(255, 255, 255), 0
		strokeColor, strokeTrans = currentTint, 0
		btnBg, btnTrans = Color3.fromRGB(40, 40, 45), 0
		textCol = Color3.fromRGB(255, 255, 255)
	elseif currentTheme == "Liquid Glass" then
		panelBg, panelTrans = currentTint, 0.65
		strokeColor, strokeTrans = Color3.fromRGB(255, 255, 255), 0.2
		btnBg, btnTrans = currentTint, 0.4
		textCol = Color3.fromRGB(255, 255, 255)
	end
	
	for _, p in pairs(themeObjects.Panels) do
		TweenService:Create(p, t, {BackgroundColor3 = panelBg, BackgroundTransparency = panelTrans}):Play()
	end
	
	for _, s in pairs(themeObjects.Strokes) do
		TweenService:Create(s, t, {Color = strokeColor, Transparency = strokeTrans}):Play()
	end
	
	for _, g in pairs(themeObjects.Gradients) do
		if currentTheme == "Glossy" or currentTheme == "Liquid Glass" then
			g.Enabled = true
			if currentTheme == "Glossy" then
				g.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
					ColorSequenceKeypoint.new(0.5, currentTint),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
				}
			else
				g.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
					ColorSequenceKeypoint.new(1, currentTint)
				}
			end
			g.Rotation = 45
		else
			g.Enabled = false
		end
	end
	
	for _, b in pairs(themeObjects.Buttons) do
		local isActiveCat = b:GetAttribute("IsCategory") and b.Name == activeCategory
		local finalBg = isActiveCat and currentTint or btnBg
		local finalTrans = isActiveCat and 0 or btnTrans
		local finalTxt = isActiveCat and Color3.new(1,1,1) or textCol
		
		TweenService:Create(b, t, {BackgroundColor3 = finalBg, BackgroundTransparency = finalTrans, TextColor3 = finalTxt}):Play()
	end
	
	for _, tb in pairs(themeObjects.ToggleBGs) do
		TweenService:Create(tb, t, {BackgroundColor3 = btnBg, BackgroundTransparency = btnTrans}):Play()
	end
	
	for _, txt in pairs(themeObjects.Texts) do
		TweenService:Create(txt, t, {TextColor3 = textCol}):Play()
	end
	
	for _, acc in pairs(themeObjects.Accents) do
		TweenService:Create(acc, t, {BackgroundColor3 = currentTint}):Play()
	end
end

local pages = {}

local function createCategory(name)
	local btn = Instance.new("TextButton", categoryContainer)
	btn.Name = name
	btn.Size = UDim2.new(0.85, 0, 0, 30)
	btn.Font = uiFont
	btn.TextSize = 12
	btn.Text = name
	btn.AutoButtonColor = false
	btn:SetAttribute("IsCategory", true)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	table.insert(themeObjects.Buttons, btn)

	local page = Instance.new("ScrollingFrame", contentContainer)
	page.Size = UDim2.new(1, -20, 1, -20)
	page.Position = UDim2.new(0, 10, 0, 10)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
	page.Visible = false
	page.BorderSizePixel = 0

	local pageLayout = Instance.new("UIListLayout", page)
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, 8)

	pages[name] = {Button = btn, Page = page}

	btn.MouseButton1Click:Connect(function()
		activeCategory = name
		for k, v in pairs(pages) do
			v.Page.Visible = (k == name)
		end
		applyTheme()
	end)
	
	pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
	end)
	
	return page
end

local function createToggle(page, text, callback)
	local frame = Instance.new("Frame", page)
	frame.Size = UDim2.new(1, 0, 0, 35)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
	local str = Instance.new("UIStroke", frame)
	
	table.insert(themeObjects.ToggleBGs, frame)
	table.insert(themeObjects.Strokes, str)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = uiFont
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	table.insert(themeObjects.Texts, label)

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 50, 0, 22)
	btn.Position = UDim2.new(1, -60, 0.5, -11)
	btn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	btn.Text = "OFF"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = uiFont
	btn.TextSize = 10
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)

	local toggled = false
	btn.MouseButton1Click:Connect(function()
		toggled = not toggled
		btn.Text = toggled and "ON" or "OFF"
		
		if toggled then
			table.insert(themeObjects.Accents, btn)
			TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = currentTint}):Play()
		else
			for i, v in ipairs(themeObjects.Accents) do
				if v == btn then table.remove(themeObjects.Accents, i) break end
			end
			TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
		end
		
		callback(toggled)
	end)
end

local function createActionButton(page, text, callback)
	local btn = Instance.new("TextButton", page)
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.Text = text
	btn.Font = uiFont
	btn.TextSize = 12
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local str = Instance.new("UIStroke", btn)
	
	table.insert(themeObjects.Buttons, btn)
	table.insert(themeObjects.Strokes, str)
	table.insert(themeObjects.Texts, btn)
	
	btn.MouseButton1Click:Connect(function()
		callback(btn)
	end)
	return btn
end

local function createSlider(page, text, min, max, default, callback)
	local frame = Instance.new("Frame", page)
	frame.Size = UDim2.new(1, 0, 0, 45)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
	local str = Instance.new("UIStroke", frame)
	
	table.insert(themeObjects.ToggleBGs, frame)
	table.insert(themeObjects.Strokes, str)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(0.5, 0, 0, 20)
	label.Position = UDim2.new(0, 10, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = uiFont
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	table.insert(themeObjects.Texts, label)

	local valLabel = Instance.new("TextLabel", frame)
	valLabel.Size = UDim2.new(0.3, 0, 0, 20)
	valLabel.Position = UDim2.new(1, -40, 0, 5)
	valLabel.BackgroundTransparency = 1
	valLabel.Text = tostring(default)
	valLabel.Font = uiFont
	valLabel.TextSize = 12
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	table.insert(themeObjects.Texts, valLabel)

	local sliderBg = Instance.new("TextButton", frame)
	sliderBg.Size = UDim2.new(1, -20, 0, 8)
	sliderBg.Position = UDim2.new(0, 10, 0, 30)
	sliderBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	sliderBg.Text = ""
	Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
	
	local fill = Instance.new("Frame", sliderBg)
	fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
	fill.BackgroundColor3 = currentTint
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
	table.insert(themeObjects.Accents, fill)

	local dragging = false
	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)
	
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local mousePos = UIS:GetMouseLocation().X
			local rel = math.clamp((mousePos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
			fill.Size = UDim2.new(rel, 0, 1, 0)
			local val = math.floor(min + ((max - min) * rel))
			valLabel.Text = tostring(val)
			callback(val)
		end
	end)
end

local aimbotPage = createCategory("Aimbot")
local funPage = createCategory("Fun")
local themePage = createCategory("Themes")
local particlePage = createCategory("Particles")

pages["Aimbot"].Page.Visible = true

createActionButton(aimbotPage, "Target Goal: A", function(btn)
	targetGoal = targetGoal == "A" and "B" or "A"
	btn.Text = "Target Goal: " .. targetGoal
end)

createActionButton(aimbotPage, "Target Corner: TopLeft", function(btn)
	targetCorner = targetCorner == "TopLeft" and "TopRight" or "TopLeft"
	btn.Text = "Target Corner: " .. targetCorner
end)

RunService.Heartbeat:Connect(function()
	if topCornersAim and dumpedBall and dumpedBall.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		local ballPos = dumpedBall:IsA("Model") and dumpedBall:GetPivot().Position or dumpedBall.Position
		local dist = (ballPos - hrp.Position).Magnitude
		
		if dist <= 6.0 then
			teleportToCorner(dumpedBall)
		end
	end
end)

createToggle(aimbotPage, "Top Goal Corners", function(s)
	topCornersAim = s
	if dumpedBall then bindBallTouch(dumpedBall) end
end)

local markGoals = false
local goalMarkers = {}

local function updateGoalMarkers()
	for _, m in pairs(goalMarkers) do
		if m then m:Destroy() end
	end
	table.clear(goalMarkers)
	
	if markGoals then
		for gName, corners in pairs(GoalCorners) do
			local p = Instance.new("Part")
			p.Anchored = true
			p.CanCollide = false
			p.Transparency = 1
			p.Position = (corners.TopLeft + corners.TopRight) / 2 + Vector3.new(0, 5, 0)
			
			local bg = Instance.new("BillboardGui", p)
			bg.Size = UDim2.new(0, 100, 0, 50)
			bg.AlwaysOnTop = true
			
			local tl = Instance.new("TextLabel", bg)
			tl.Size = UDim2.new(1, 0, 1, 0)
			tl.BackgroundTransparency = 1
			tl.Text = "Goal " .. gName
			tl.TextColor3 = currentTint
			tl.TextSize = 24
			tl.Font = uiFont
			table.insert(themeObjects.Texts, tl)
			
			p.Parent = workspace
			table.insert(goalMarkers, p)
		end
	end
end
createToggle(aimbotPage, "Mark Goals", function(s) markGoals = s; updateGoalMarkers() end)

createActionButton(aimbotPage, "TP Ball to Player", function()
	if dumpedBall and dumpedBall.Parent then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
			local frontPos = hrp.CFrame * CFrame.new(0, 0, -4)
			
			if dumpedBall:IsA("Model") then
				dumpedBall:PivotTo(frontPos)
			else
				dumpedBall.CFrame = frontPos
			end
			
			pcall(function()
				local bPart = dumpedBall:IsA("Model") and (dumpedBall.PrimaryPart or dumpedBall:FindFirstChildWhichIsA("BasePart", true)) or dumpedBall
				if bPart then
					bPart.AssemblyLinearVelocity = Vector3.zero
					bPart.AssemblyAngularVelocity = Vector3.zero
				end
			end)
		end
	else
		pushNotification("No ball dumped yet.")
	end
end)

local juggleEnabled = false
createToggle(aimbotPage, "Juggle Above Head", function(s)
	juggleEnabled = s
end)

RunService.RenderStepped:Connect(function()
	if juggleEnabled and dumpedBall and dumpedBall.Parent and player.Character and player.Character:FindFirstChild("Head") then
		local head = player.Character.Head
		local headCFrame = head.CFrame * CFrame.new(0, 3, 0)
		
		if dumpedBall:IsA("Model") then
			dumpedBall:PivotTo(headCFrame)
		else
			dumpedBall.CFrame = headCFrame
		end
		
		pcall(function()
			local bPart = dumpedBall:IsA("Model") and (dumpedBall.PrimaryPart or dumpedBall:FindFirstChildWhichIsA("BasePart", true)) or dumpedBall
			if bPart then
				bPart.AssemblyLinearVelocity = Vector3.zero
				bPart.AssemblyAngularVelocity = Vector3.zero
			end
		end)
	end
end)

local flyEnabled = false
local flySpeed = 50
local bVel, bGyro

local function getMoveVector()
	local pModule = require(player.PlayerScripts:WaitForChild("PlayerModule"))
	return pModule:GetControls():GetMoveVector()
end

local function stopFly()
	if bVel then bVel:Destroy() end
	if bGyro then bGyro:Destroy() end
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.PlatformStand = false
	end
end

local function startFly()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	char.Humanoid.PlatformStand = true
	bVel = Instance.new("BodyVelocity", char.HumanoidRootPart)
	bVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bVel.Velocity = Vector3.new(0, 0, 0)
	bGyro = Instance.new("BodyGyro", char.HumanoidRootPart)
	bGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bGyro.P = 15000
end

RunService.RenderStepped:Connect(function()
	if flyEnabled and bVel and bGyro and player.Character then
		local cam = workspace.CurrentCamera
		bGyro.CFrame = cam.CFrame
		local moveVec = getMoveVector()
		local md = (cam.CFrame.LookVector * moveVec.Z * -1) + (cam.CFrame.RightVector * moveVec.X)
		if UIS:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3.new(0, 1, 0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then md = md - Vector3.new(0, 1, 0) end
		if md.Magnitude > 0 then
			bVel.Velocity = md.Unit * flySpeed
		else
			bVel.Velocity = Vector3.new(0, 0, 0)
		end
	end
end)

createToggle(funPage, "Fly", function(s)
	flyEnabled = s
	if s then startFly() else stopFly() end
end)

createSlider(funPage, "Flyspeed", 10, 200, 50, function(v) flySpeed = v end)

local wsEnabled = true
local currentWS = 16
local jpEnabled = true
local currentJP = 50

local function applyMovementStats()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		local hum = player.Character.Humanoid
		if wsEnabled then
			hum.WalkSpeed = currentWS
		end
		if jpEnabled then
			hum.UseJumpPower = true
			hum.JumpPower = currentJP
		end
	end
end

createSlider(funPage, "Walkspeed", 16, 250, 16, function(v)
	currentWS = v
	applyMovementStats()
end)

createSlider(funPage, "Jumppower", 50, 300, 50, function(v)
	currentJP = v
	applyMovementStats()
end)

player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	task.wait(0.1)
	applyMovementStats()
end)

createActionButton(themePage, "Theme: Dark (Default)", function() currentTheme = "Dark"; applyTheme() end)
createActionButton(themePage, "Theme: Glass", function() currentTheme = "Glass"; applyTheme() end)
createActionButton(themePage, "Theme: Glossy", function() currentTheme = "Glossy"; applyTheme() end)
createActionButton(themePage, "Theme: Liquid Glass", function() currentTheme = "Liquid Glass"; applyTheme() end)

local function createColorBtn(name, col)
	createActionButton(themePage, "Color: " .. name, function()
		currentTint = col
		applyTheme()
		updateGoalMarkers()
	end)
end
createColorBtn("Blue", Color3.fromRGB(80, 150, 255))
createColorBtn("Red", Color3.fromRGB(255, 60, 60))
createColorBtn("Purple", Color3.fromRGB(180, 80, 255))
createColorBtn("Green", Color3.fromRGB(60, 255, 100))
createColorBtn("White", Color3.fromRGB(255, 255, 255))

local partsEnabled = false
local partType = "Spiral"
local pColor = "Theme"
local activeParticles = {}

createToggle(particlePage, "Enable Particles", function(s) partsEnabled = s end)
createActionButton(particlePage, "Type: Float", function() partType = "Float" end)
createActionButton(particlePage, "Type: Spiral", function() partType = "Spiral" end)
createActionButton(particlePage, "Type: Rain", function() partType = "Rain" end)
createActionButton(particlePage, "Type: Orbit", function() partType = "Orbit" end)

local function setPCol(name, col)
	createActionButton(particlePage, "Particle Color: " .. name, function() pColor = col end)
end
setPCol("White", Color3.new(1,1,1))
setPCol("Theme Color", "Theme")
setPCol("Rainbow", "Rainbow")

local tickCounter = 0
RunService.RenderStepped:Connect(function(dt)
	tickCounter = tickCounter + dt
	if partsEnabled and math.random() < 0.3 then
		local p = Instance.new("Frame")
		local size = math.random(4, 10)
		p.Size = UDim2.new(0, size, 0, size)
		Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
		p.BorderSizePixel = 0
		
		local actualCol = pColor
		if type(pColor) == "string" then
			if pColor == "Theme" then actualCol = currentTint
			elseif pColor == "Rainbow" then actualCol = Color3.fromHSV(tickCounter % 5 / 5, 1, 1) end
		end
		p.BackgroundColor3 = actualCol
		p.Parent = particleContainer
		
		table.insert(activeParticles, {
			UI = p,
			Age = 0,
			Life = math.random(3, 7),
			StartX = math.random(),
			Offset = math.random() * math.pi * 2,
			Speed = math.random(5, 15) / 10
		})
	end
	
	for i = #activeParticles, 1, -1 do
		local pt = activeParticles[i]
		pt.Age = pt.Age + dt
		
		if pt.Age >= pt.Life then
			pt.UI:Destroy()
			table.remove(activeParticles, i)
		else
			local prog = pt.Age / pt.Life
			pt.UI.BackgroundTransparency = prog
			
			if partType == "Float" then
				pt.UI.Position = UDim2.new(pt.StartX, math.sin(pt.Age*2)*20, 1.1 - prog, 0)
			elseif partType == "Spiral" then
				local cx, cy = 0.5, 0.5
				local angle = pt.Age * math.pi * pt.Speed + pt.Offset
				local rad = prog * 0.8
				pt.UI.Position = UDim2.new(cx + math.cos(angle)*rad, 0, cy + math.sin(angle)*rad, 0)
			elseif partType == "Orbit" then
				local cx, cy = 0.5, 0.5
				local angle = pt.Age * math.pi * 2 + pt.Offset
				local rad = 0.2 + math.sin(prog * math.pi) * 0.2
				pt.UI.Position = UDim2.new(cx + math.cos(angle)*rad, 0, cy + math.sin(angle)*rad, 0)
			elseif partType == "Rain" then
				pt.UI.Position = UDim2.new(pt.StartX, 0, -0.1 + prog * 1.3, 0)
			end
		end
	end
end)

applyTheme()

local function makeDraggable(dragArea, moveTarget)
	local dragging, dragStart, startPos
	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = moveTarget.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			moveTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

makeDraggable(title, mainFrame)
makeDraggable(openBtn, openBtn)

local openClickTime = 0
openBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		openClickTime = tick()
	end
end)

openBtn.MouseButton1Click:Connect(function()
	if tick() - openClickTime < 0.25 then
		openBtn.Visible = false
		mainFrame.Visible = true
	end
end)

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
minBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	openBtn.Visible = true
end)
