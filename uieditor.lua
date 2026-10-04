local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SampleGameUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "TestFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Parent = ScreenGui

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleLabel"
TitleText.Size = UDim2.new(1, 0, 0, 40)
TitleText.Position = UDim2.new(0, 0, 0, 0)
TitleText.Text = "Sample Game UI"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleText.Parent = MainFrame

local SampleImage = Instance.new("ImageLabel")
SampleImage.Name = "SampleDecal"
SampleImage.Size = UDim2.new(0, 80, 0, 80)
SampleImage.Position = UDim2.new(0.05, 0, 0.3, 0)
SampleImage.Image = "rbxassetid://6031075931"
SampleImage.BackgroundTransparency = 1
SampleImage.Parent = MainFrame

local SampleButton = Instance.new("TextButton")
SampleButton.Name = "ActionButton"
SampleButton.Size = UDim2.new(0, 150, 0, 40)
SampleButton.Position = UDim2.new(0.4, 0, 0.5, 0)
SampleButton.Text = "Click Me"
SampleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SampleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SampleButton.Parent = MainFrame

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "UI Inspector & Editor",
   LoadingTitle = "UI Editor Tool",
   LoadingSubtitle = "Rayfield UI",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("UI Editor", 4483362458)

local selectedObject = nil
local selecting = false

local SelectedLabel = MainTab:CreateLabel("Selected: None")

MainTab:CreateButton({
   Name = "Toggle Click-to-Select UI",
   Callback = function()
      selecting = not selecting
      Rayfield:Notify({
         Title = "Selection Tool",
         Content = selecting and "Click any UI element on screen to select it" or "Selection mode disabled",
         Duration = 2
      })
   end
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
   if selecting and input.UserInputType == Enum.UserInputType.MouseButton1 then
      local mousePos = UserInputService:GetMouseLocation()
      local guis = PlayerGui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y)
      for _, gui in ipairs(guis) do
         if not gui:IsDescendantOf(CoreGui) then
            selectedObject = gui
            SelectedLabel:Set("Selected: " .. gui.Name .. " [" .. gui.ClassName .. "]")
            selecting = false
            break
         end
      end
   end
end)

MainTab:CreateInput({
   Name = "Change Text / Name",
   PlaceholderText = "Enter text or name...",
   RemoveTextOnFocusLost = false,
   Callback = function(Text)
      if selectedObject then
         selectedObject.Name = Text
         if selectedObject:IsA("TextLabel") or selectedObject:IsA("TextButton") or selectedObject:IsA("TextBox") then
            selectedObject.Text = Text
         end
      end
   end,
})

MainTab:CreateInput({
   Name = "Set Image Asset ID",
   PlaceholderText = "Enter Decal / Image ID...",
   RemoveTextOnFocusLost = false,
   Callback = function(Text)
      if selectedObject and (selectedObject:IsA("ImageLabel") or selectedObject:IsA("ImageButton")) then
         local cleanedId = Text:match("%d+")
         if cleanedId then
            selectedObject.Image = "rbxassetid://" .. cleanedId
         else
            selectedObject.Image = Text
         end
      end
   end,
})

MainTab:CreateButton({
   Name = "Remove Image",
   Callback = function()
      if selectedObject and (selectedObject:IsA("ImageLabel") or selectedObject:IsA("ImageButton")) then
         selectedObject.Image = ""
      end
   end,
})

MainTab:CreateButton({
   Name = "Delete Selected Element",
   Callback = function()
      if selectedObject then
         selectedObject:Destroy()
         selectedObject = nil
         SelectedLabel:Set("Selected: None")
      end
   end,
})
