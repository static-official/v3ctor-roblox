local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "v3ctor_panel"
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999
gui.Parent = player:WaitForChild("PlayerGui")

local currentTheme = "Liquid Glass"
local currentTint = Color3.fromRGB(80, 150, 255)
local activeCategory = "Main"
local uiFont = Enum.Font.RobotoMono

local themeObjects = {
	Panels = {},
	Strokes = {},
	Gradients = {},
	Buttons = {},
	ToggleBGs = {},
	Accents = {},
	Texts = {}
}

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 80, 0, 50)
openBtn.Position = UDim2.new(0.5, -40, 0.5, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
openBtn.Text = "v3ctor"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = uiFont
openBtn.TextSize = 16
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
mainFrame.Size = UDim2.new(0, 550, 0, 380)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
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
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "v3ctor"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
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
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = uiFont
closeBtn.TextSize = 14
closeBtn.ZIndex = 5
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local minBtn = Instance.new("TextButton", mainFrame)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -74, 0, 7)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = uiFont
minBtn.TextSize = 18
minBtn.ZIndex = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local categoryContainer = Instance.new("Frame", mainFrame)
categoryContainer.Size = UDim2.new(0, 140, 1, -45)
categoryContainer.Position = UDim2.new(0, 0, 0, 45)
categoryContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
categoryContainer.BackgroundTransparency = 0.5
categoryContainer.BorderSizePixel = 0
categoryContainer.ZIndex = 3

local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Size = UDim2.new(1, -140, 1, -45)
contentContainer.Position = UDim2.new(0, 140, 0, 45)
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
	btn.Size = UDim2.new(0.85, 0, 0, 35)
	btn.Font = uiFont
	btn.TextSize = 14
	btn.Text = name
	btn.AutoButtonColor = false
	btn:SetAttribute("IsCategory", true)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	table.insert(themeObjects.Buttons, btn)

	local page = Instance.new("ScrollingFrame", contentContainer)
	page.Size = UDim2.new(1, -20, 1, -20)
	page.Position = UDim2.new(0, 10, 0, 10)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 4
	page.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
	page.Visible = false
	page.BorderSizePixel = 0

	local pageLayout = Instance.new("UIListLayout", page)
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, 10)

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
	frame.Size = UDim2.new(1, 0, 0, 45)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
	local str = Instance.new("UIStroke", frame)
	
	table.insert(themeObjects.ToggleBGs, frame)
	table.insert(themeObjects.Strokes, str)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Position = UDim2.new(0, 15, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = uiFont
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	table.insert(themeObjects.Texts, label)

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 60, 0, 26)
	btn.Position = UDim2.new(1, -75, 0.5, -13)
	btn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	btn.Text = "OFF"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = uiFont
	btn.TextSize = 12
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 13)

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
	btn.Size = UDim2.new(1, 0, 0, 45)
	btn.Text = text
	btn.Font = uiFont
	btn.TextSize = 13
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local str = Instance.new("UIStroke", btn)
	
	table.insert(themeObjects.Buttons, btn)
	table.insert(themeObjects.Strokes, str)
	table.insert(themeObjects.Texts, btn)
	
	btn.MouseButton1Click:Connect(callback)
end

local function createSlider(page, text, min, max, default, callback)
	local frame = Instance.new("Frame", page)
	frame.Size = UDim2.new(1, 0, 0, 55)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
	local str = Instance.new("UIStroke", frame)
	
	table.insert(themeObjects.ToggleBGs, frame)
	table.insert(themeObjects.Strokes, str)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(0.5, 0, 0, 25)
	label.Position = UDim2.new(0, 15, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = uiFont
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	table.insert(themeObjects.Texts, label)

	local valLabel = Instance.new("TextLabel", frame)
	valLabel.Size = UDim2.new(0.3, 0, 0, 25)
	valLabel.Position = UDim2.new(1, -45, 0, 5)
	valLabel.BackgroundTransparency = 1
	valLabel.Text = tostring(default)
	valLabel.Font = uiFont
	valLabel.TextSize = 13
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	table.insert(themeObjects.Texts, valLabel)

	local sliderBg = Instance.new("TextButton", frame)
	sliderBg.Size = UDim2.new(1, -30, 0, 10)
	sliderBg.Position = UDim2.new(0, 15, 0, 35)
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

local function createTextBox(page, placeholder, btnText, callback)
	local frame = Instance.new("Frame", page)
	frame.Size = UDim2.new(1, 0, 0, 45)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
	local str = Instance.new("UIStroke", frame)
	
	table.insert(themeObjects.ToggleBGs, frame)
	table.insert(themeObjects.Strokes, str)

	local tb = Instance.new("TextBox", frame)
	tb.Size = UDim2.new(0.6, 0, 0, 30)
	tb.Position = UDim2.new(0, 10, 0.5, -15)
	tb.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	tb.TextColor3 = Color3.fromRGB(255, 255, 255)
	tb.PlaceholderText = placeholder
	tb.Font = uiFont
	tb.TextSize = 13
	tb.TextXAlignment = Enum.TextXAlignment.Left
	tb.ClearTextOnFocus = false
	Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 4)

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 75, 0, 26)
	btn.Position = UDim2.new(1, -85, 0.5, -13)
	btn.BackgroundColor3 = currentTint
	btn.Text = btnText
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = uiFont
	btn.TextSize = 12
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 13)
	table.insert(themeObjects.Accents, btn)

	btn.MouseButton1Click:Connect(function()
		callback(tb.Text)
		tb.Text = ""
	end)
end

local mainPage = createCategory("Main")
local combatPage = createCategory("Combat")
local playerPage = createCategory("Player")
local visualsPage = createCategory("Visuals")
local miscPage = createCategory("Misc")
local themePage = createCategory("Themes")
local particlePage = createCategory("Particles")

pages["Main"].Page.Visible = true

local infJump = false
UIS.JumpRequest:Connect(function()
	if infJump and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
createToggle(mainPage, "Infinite Jump", function(s) infJump = s end)

local flying = false
local flySpeed = 50
local bVel, bGyro, flyConn
local function stopFly()
	if bVel then bVel:Destroy() end
	if bGyro then bGyro:Destroy() end
	if flyConn then flyConn:Disconnect() end
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

	flyConn = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		bGyro.CFrame = cam.CFrame
		local md = Vector3.new()
		if UIS:IsKeyDown(Enum.KeyCode.W) then md = md + cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then md = md - cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then md = md - cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then md = md + cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then md = md - Vector3.new(0,1,0) end
		bVel.Velocity = md.Magnitude > 0 and md.Unit * flySpeed or Vector3.new(0,0,0)
	end)
end

createToggle(mainPage, "Fly (WASD)", function(s)
	flying = s
	if flying then startFly() else stopFly() end
end)

createSlider(mainPage, "Fly Speed", 10, 200, 50, function(v) flySpeed = v end)

local noclip = false
RunService.Stepped:Connect(function()
	if noclip and player.Character then
		for _, p in pairs(player.Character:GetDescendants()) do
			if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
		end
	end
end)
createToggle(mainPage, "Noclip", function(s) noclip = s end)

local clickTp = false
local mouse = player:GetMouse()
UIS.InputBegan:Connect(function(input, gp)
	if not gp and clickTp and input.UserInputType == Enum.UserInputType.MouseButton1 then
		if mouse.Hit and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
		end
	end
end)
createToggle(mainPage, "Click Teleport", function(s) clickTp = s end)

local camlock = false
local function getNearest()
	local dist = math.huge
	local target = nil
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local p, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
			if vis then
				local mag = (Vector2.new(p.X, p.Y) - UIS:GetMouseLocation()).Magnitude
				if mag < dist then
					dist = mag
					target = v.Character.HumanoidRootPart
				end
			end
		end
	end
	return target
end

RunService.RenderStepped:Connect(function()
	if camlock and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local t = getNearest()
		if t then
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, t.Position)
		end
	end
end)
createToggle(combatPage, "Aimbot (Hold Right Click)", function(s) camlock = s end)

local expandHitboxes = false
RunService.RenderStepped:Connect(function()
	if expandHitboxes then
		for _, v in pairs(Players:GetPlayers()) do
			if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
				v.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15)
				v.Character.HumanoidRootPart.Transparency = 0.5
				v.Character.HumanoidRootPart.CanCollide = false
				v.Character.HumanoidRootPart.Material = Enum.Material.Neon
				v.Character.HumanoidRootPart.Color = Color3.fromRGB(200, 50, 50)
			end
		end
	end
end)
createToggle(combatPage, "Expand Hitboxes", function(s) expandHitboxes = s end)

local wsEnabled = false
local currentWS = 16
RunService.RenderStepped:Connect(function()
	if wsEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = currentWS
	end
end)
createToggle(playerPage, "Enable Custom Speed", function(s) 
	wsEnabled = s 
	if not s and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = 16
	end
end)
createSlider(playerPage, "WalkSpeed", 16, 250, 16, function(v) currentWS = v end)

local jpEnabled = false
local currentJP = 50
RunService.RenderStepped:Connect(function()
	if jpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.UseJumpPower = true
		player.Character.Humanoid.JumpPower = currentJP
	end
end)
createToggle(playerPage, "Enable Custom Jump", function(s) jpEnabled = s end)
createSlider(playerPage, "JumpPower", 50, 300, 50, function(v) currentJP = v end)

createActionButton(playerPage, "Teleport to Spawn", function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local spawns = workspace:FindFirstChildWhichIsA("SpawnLocation", true)
		if spawns then
			player.Character.HumanoidRootPart.CFrame = spawns.CFrame + Vector3.new(0, 5, 0)
		end
	end
end)

createActionButton(playerPage, "Get BTools", function()
	local b1 = Instance.new("HopperBin", player.Backpack)
	b1.BinType = Enum.BinType.Clone
	local b2 = Instance.new("HopperBin", player.Backpack)
	b2.BinType = Enum.BinType.Hammer
	local b3 = Instance.new("HopperBin", player.Backpack)
	b3.BinType = Enum.BinType.Grab
end)

local esp = false
local function doESP()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			if esp then
				if not p.Character:FindFirstChild("v3_esp") then
					local hl = Instance.new("Highlight", p.Character)
					hl.Name = "v3_esp"
					hl.FillColor = currentTint
					hl.OutlineColor = Color3.new(1,1,1)
					hl.FillTransparency = 0.5
				else
					p.Character.v3_esp.FillColor = currentTint
				end
			else
				if p.Character:FindFirstChild("v3_esp") then p.Character.v3_esp:Destroy() end
			end
		end
	end
end
RunService.RenderStepped:Connect(function() if esp then doESP() end end)
createToggle(visualsPage, "Player ESP", function(s) esp = s; if not s then doESP() end end)

local fov = 70
RunService.RenderStepped:Connect(function()
	workspace.CurrentCamera.FieldOfView = fov
end)
createSlider(visualsPage, "Field of View", 70, 120, 70, function(v) fov = v end)

local defTime = Lighting.ClockTime
createToggle(visualsPage, "Night Mode", function(s) Lighting.ClockTime = s and 0 or defTime end)

local defaultFogEnd = Lighting.FogEnd
createToggle(visualsPage, "Remove Fog", function(s) 
	Lighting.FogEnd = s and 100000 or defaultFogEnd 
end)

createToggle(visualsPage, "Add Thick Fog", function(s)
	if s then
		Lighting.FogEnd = 40
		Lighting.FogColor = Color3.fromRGB(150, 150, 150)
	else
		Lighting.FogEnd = defaultFogEnd
	end
end)

createTextBox(miscPage, "Enter announcement...", "Broadcast", function(txt)
	if txt ~= "" then
		pcall(function()
			if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
				TextChatService.TextChannels.RBXGeneral:SendAsync("[ANNOUNCEMENT]: " .. txt)
			else
				ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("[ANNOUNCEMENT]: " .. txt, "All")
			end
		end)

		local ann = Instance.new("TextLabel", gui)
		ann.Size = UDim2.new(1, 0, 0, 50)
		ann.Position = UDim2.new(0, 0, -0.1, 0)
		ann.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
		ann.Text = "[ SERVER ANNOUNCEMENT ]\n" .. txt
		ann.TextColor3 = Color3.fromRGB(255, 255, 255)
		ann.Font = uiFont
		ann.TextSize = 18
		ann.ZIndex = 9999
		ann.BorderSizePixel = 0
		
		TweenService:Create(ann, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.delay(4, function()
			TweenService:Create(ann, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, -0.1, 0)}):Play()
			task.delay(0.5, function() ann:Destroy() end)
		end)
	end
end)

local spin = false
RunService.RenderStepped:Connect(function()
	if spin and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(30), 0)
	end
end)
createToggle(miscPage, "Spinbot", function(s) spin = s end)

createActionButton(miscPage, "Force Sit", function()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Sit = true
	end
end)

local defGrav = workspace.Gravity
createToggle(miscPage, "Low Gravity", function(s) workspace.Gravity = s and 40 or defGrav end)

createActionButton(themePage, "Theme: Dark (Default)", function() currentTheme = "Dark"; applyTheme() end)
createActionButton(themePage, "Theme: Glass", function() currentTheme = "Glass"; applyTheme() end)
createActionButton(themePage, "Theme: Glossy", function() currentTheme = "Glossy"; applyTheme() end)
createActionButton(themePage, "Theme: Liquid Glass", function() currentTheme = "Liquid Glass"; applyTheme() end)

local function createColorBtn(name, col)
	createActionButton(themePage, "Color: " .. name, function()
		currentTint = col
		applyTheme()
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
