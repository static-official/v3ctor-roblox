if _G.v3ctor_Loaded or (getgenv and getgenv().v3ctor_Loaded) then
   game:GetService("Players").LocalPlayer:Kick("rejoin, load the script only 1 time.")
   return
end

if getgenv then
   getgenv().v3ctor_Loaded = true
else
   _G.v3ctor_Loaded = true
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "v3ctor Freecam",
   LoadingTitle = "v3ctor Freecam Suite",
   LoadingSubtitle = "by v3ctor",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false,
   Theme = "Default"
})

local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local FreecamEnabled = false
local TargetPartName = ""
local TargetDistance = 15
local CameraPosition = Camera.CFrame.Position
local FreecamConnection = nil
local SelectedCountry = "United States"

local FreecamTab = Window:CreateTab("Freecam", 4483362458)

FreecamTab:CreateToggle({
   Name = "Enable Freecam",
   CurrentValue = false,
   Flag = "FreecamToggle",
   Callback = function(Value)
      FreecamEnabled = Value
      if not FreecamEnabled then
         if FreecamConnection then
            FreecamConnection:Disconnect()
            FreecamConnection = nil
         end
         Camera.CameraType = Enum.CameraType.Custom
         local player = Players.LocalPlayer
         if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
         end
      else
         Camera.CameraType = Enum.CameraType.Scriptable
         CameraPosition = Camera.CFrame.Position
         if FreecamConnection then FreecamConnection:Disconnect() end
         
         FreecamConnection = RunService.RenderStepped:Connect(function()
            if TargetPartName ~= "" then
               local target = workspace:FindFirstChild(TargetPartName, true)
               if target then
                  local targetPos = target:IsA("Model") and target:GetPivot().Position or (target:IsA("BasePart") and target.Position or nil)
                  if targetPos then
                     Camera.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, TargetDistance), targetPos)
                  end
               end
            else
               local moveVector = Vector3.new()
               if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveVector = moveVector + Vector3.new(0, 1, 0) end
               if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveVector = moveVector - Vector3.new(0, 1, 0) end
               
               CameraPosition = CameraPosition + (moveVector * 1.5)
               Camera.CFrame = CFrame.new(CameraPosition, CameraPosition + Camera.CFrame.LookVector)
            end
         end)
      end
   end,
})

FreecamTab:CreateInput({
   Name = "Target Model or Part Name",
   PlaceholderText = "e.g. Football",
   RemoveTextOnFocusLost = false,
   Callback = function(Text)
      TargetPartName = Text
   end,
})

FreecamTab:CreateSlider({
   Name = "Target Zoom Distance",
   Range = {5, 150},
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 15,
   Flag = "ZoomDistanceSlider",
   Callback = function(Value)
      TargetDistance = Value
   end,
})

FreecamTab:CreateSlider({
   Name = "Field of View (FOV)",
   Range = {30, 120},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 70,
   Flag = "FOVSlider",
   Callback = function(Value)
      Camera.FieldOfView = Value
   end,
})

local PingTab = Window:CreateTab("Ping", 4483362458)

local countriesList = {
   "United States",
   "United Kingdom",
   "Germany",
   "Japan",
   "Singapore",
   "Australia",
   "Brazil",
   "India"
}

PingTab:CreateDropdown({
   Name = "Countries",
   Options = countriesList,
   CurrentOption = {"United States"},
   MultipleOptions = false,
   Flag = "CountrySelector",
   Callback = function(Option)
      SelectedCountry = type(Option) == "table" and Option[1] or Option
   end,
})

PingTab:CreateButton({
   Name = "Switch Country",
   Callback = function()
      TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
   end,
})

local ThemesTab = Window:CreateTab("Themes", 4483362458)

local availableThemes = {
   "Default",
   "Ocean",
   "AmberGlow",
   "Amethyst",
   "Bloom",
   "DarkBlue",
   "Green",
   "Light",
   "Serenity"
}

ThemesTab:CreateDropdown({
   Name = "Select UI Theme",
   Options = availableThemes,
   CurrentOption = {"Default"},
   MultipleOptions = false,
   Flag = "ThemeSelector",
   Callback = function(Option)
      local themeName = type(Option) == "table" and Option[1] or Option
      if themeName and Rayfield then
         pcall(function()
            Rayfield:ModifyTheme(themeName)
         end)
      end
   end,
})
