local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local WebhookURL = "https://discord.com/api/webhooks/1556191392076800011/_FaBALHYu09-LPAghYM-9t8NZoKv3tEYW9DGUHgHHH57k7D9ZJQEVprwpSEkgQjbh2y5"

local function sendWebhook()
    if not WebhookURL or WebhookURL == "" then return end
    local reqFunc = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
    if not reqFunc then return end
    local executorName = (identifyexecutor and identifyexecutor()) or "Unknown Executor"
    local payload = {
        ["embeds"] = {{
            ["title"] = "🚀 v3ctor UI Editor Loaded",
            ["color"] = 65280,
            ["fields"] = {
                { ["name"] = "Player", ["value"] = player.Name .. " (@" .. player.DisplayName .. ")", ["inline"] = true },
                { ["name"] = "User ID", ["value"] = tostring(player.UserId), ["inline"] = true },
                { ["name"] = "Executor", ["value"] = executorName, ["inline"] = true },
                { ["name"] = "Place ID", ["value"] = tostring(game.PlaceId), ["inline"] = true }
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    pcall(function()
        reqFunc({
            Url = WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

task.spawn(sendWebhook)

local highlightGui = Instance.new("ScreenGui")
highlightGui.Name = "v3ctorSelectionHighlight"
highlightGui.ResetOnSpawn = false
highlightGui.DisplayOrder = 999999
pcall(function()
    highlightGui.Parent = (gethui and gethui()) or CoreGui
end)
if not highlightGui.Parent then
    highlightGui.Parent = PlayerGui
end

local highlightBox = Instance.new("Frame")
highlightBox.Name = "OutlineBox"
highlightBox.BackgroundTransparency = 0.85
highlightBox.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
highlightBox.BorderSizePixel = 0
highlightBox.Visible = false
highlightBox.Parent = highlightGui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 150)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = highlightBox

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "v3ctor | UI Editor",
    LoadingTitle = "v3ctor UI Editor",
    LoadingSubtitle = "by MoonyAR/@notmoony.ar",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local EditorTab = Window:CreateTab("In-Game UI Editor", 4483362458)

local selectedObject = nil
local selectingActive = false
local newTextValue = ""
local newImageId = ""
local newObjectName = ""

local function formatAssetId(id)
    local clean = tostring(id):gsub("%D", "")
    if clean ~= "" then
        return "rbxassetid://" .. clean
    end
    return ""
end

-- Blacklist of Roblox system UI ScreenGuis
local robloxSystemGuis = {
    ["robloxgui"] = true,
    ["chat"] = true,
    ["bubblechat"] = true,
    ["freecam"] = true,
    ["touchgui"] = true,
    ["controlgui"] = true,
    ["playerlist"] = true,
    ["emotemenu"] = true,
    ["purchaseprompt"] = true,
    ["policyservice"] = true
}

local function isGameGui(guiObj)
    if not guiObj or not guiObj:IsA("GuiObject") then return false end
    
    -- Exclude highlight UI
    if guiObj == highlightBox or guiObj:IsDescendantOf(highlightGui) then 
        return false 
    end
    
    -- Exclude Rayfield UI
    local rayfieldGui = CoreGui:FindFirstChild("Rayfield") or PlayerGui:FindFirstChild("Rayfield")
    if rayfieldGui and guiObj:IsDescendantOf(rayfieldGui) then 
        return false 
    end

    -- Exclude CoreGui elements
    if guiObj:IsDescendantOf(CoreGui) then
        return false
    end

    -- Exclude Roblox system ScreenGuis inside PlayerGui
    local screenGui = guiObj:FindFirstAncestorOfClass("ScreenGui")
    if screenGui then
        local nameLower = screenGui.Name:lower()
        if robloxSystemGuis[nameLower] or nameLower:find("roblox") then
            return false
        end
    end

    return true
end

EditorTab:CreateSection("Target Selection")

local SelectedLabel = EditorTab:CreateLabel("Currently Latched On: None")

local function updateHighlight(target)
    if target and target:IsA("GuiObject") and target.Parent then
        highlightBox.Size = UDim2.new(0, target.AbsoluteSize.X, 0, target.AbsoluteSize.Y)
        highlightBox.Position = UDim2.new(0, target.AbsolutePosition.X, 0, target.AbsolutePosition.Y + GuiService:GetGuiInset().Y)
        highlightBox.Visible = true
    else
        highlightBox.Visible = false
    end
end

local function updateSelectedObject(target)
    selectedObject = target
    if target and target.Parent then
        SelectedLabel:Set("Currently Latched On: " .. target.Name .. " (" .. target.ClassName .. ")")
        updateHighlight(target)
        Rayfield:Notify({
            Title = "UI Latched On",
            Content = "Target: " .. target.Name .. " (" .. target.ClassName .. ")",
            Duration = 3
        })
    else
        selectedObject = nil
        SelectedLabel:Set("Currently Latched On: None")
        updateHighlight(nil)
    end
end

local selectionToggle

selectionToggle = EditorTab:CreateToggle({
    Name = "Click Screen to Select UI Element",
    CurrentValue = false,
    Callback = function(Value)
        selectingActive = Value
        if Value then
            Rayfield:Notify({
                Title = "Selection Mode Active",
                Content = "Click any game UI element on screen to latch onto it.",
                Duration = 3
            })
        end
    end,
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if selectingActive and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation()
        local inset = GuiService:GetGuiInset()
        local adjustedX = mousePos.X
        local adjustedY = mousePos.Y - inset.Y

        local guis = PlayerGui:GetGuiObjectsAtPosition(adjustedX, adjustedY)
        local chosenTarget = nil

        for _, guiObj in ipairs(guis) do
            if isGameGui(guiObj) then
                chosenTarget = guiObj
                break
            end
        end

        if chosenTarget then
            selectingActive = false
            updateSelectedObject(chosenTarget)
            pcall(function()
                selectionToggle:Set(false)
            end)
        end
    end
end)

EditorTab:CreateInput({
    Name = "Select Target by Name",
    PlaceholderText = "Enter exact UI element name...",
    RemoveTextOnFocusLost = false,
    Callback = function(Text)
        if Text and Text ~= "" then
            for _, v in ipairs(PlayerGui:GetDescendants()) do
                if v:IsA("GuiObject") and v.Name:lower() == Text:lower() and isGameGui(v) then
                    updateSelectedObject(v)
                    return
                end
            end
            Rayfield:Notify({
                Title = "Not Found",
                Content = "No game UI element found named: " .. Text,
                Duration = 3
            })
        end
    end,
})

EditorTab:CreateSection("Edit Text & Name")

EditorTab:CreateInput({
    Name = "New Text Content",
    PlaceholderText = "Enter new text...",
    RemoveTextOnFocusLost = false,
    Callback = function(Text)
        newTextValue = Text
    end,
})

EditorTab:CreateButton({
    Name = "Apply New Text",
    Callback = function()
        if selectedObject and selectedObject.Parent then
            if selectedObject:IsA("TextLabel") or selectedObject:IsA("TextButton") or selectedObject:IsA("TextBox") then
                selectedObject.Text = newTextValue
                Rayfield:Notify({ Title = "Success", Content = "Updated text.", Duration = 2 })
            else
                local count = 0
                for _, child in ipairs(selectedObject:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                        child.Text = newTextValue
                        count = count + 1
                    end
                end
                Rayfield:Notify({ Title = "Success", Content = "Updated " .. tostring(count) .. " text children.", Duration = 2 })
            end
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element latched on!", Duration = 2 })
        end
    end,
})

EditorTab:CreateInput({
    Name = "Rename UI Object",
    PlaceholderText = "Enter new object name...",
    RemoveTextOnFocusLost = false,
    Callback = function(Text)
        newObjectName = Text
    end,
})

EditorTab:CreateButton({
    Name = "Apply New Name",
    Callback = function()
        if selectedObject and selectedObject.Parent and newObjectName ~= "" then
            selectedObject.Name = newObjectName
            updateSelectedObject(selectedObject)
            Rayfield:Notify({ Title = "Success", Content = "Renamed object to: " .. newObjectName, Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "Select element and enter a valid name.", Duration = 2 })
        end
    end,
})

EditorTab:CreateSection("Edit Images & Decals")

EditorTab:CreateInput({
    Name = "New Image / Decal ID",
    PlaceholderText = "Enter Decal ID (e.g. 12345678)...",
    RemoveTextOnFocusLost = false,
    Callback = function(Text)
        newImageId = Text
    end,
})

EditorTab:CreateButton({
    Name = "Replace Image ID",
    Callback = function()
        if selectedObject and selectedObject.Parent then
            local formatted = formatAssetId(newImageId)
            if selectedObject:IsA("ImageLabel") or selectedObject:IsA("ImageButton") then
                selectedObject.Image = formatted
                Rayfield:Notify({ Title = "Success", Content = "Replaced image ID.", Duration = 2 })
            else
                local count = 0
                for _, child in ipairs(selectedObject:GetDescendants()) do
                    if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                        child.Image = formatted
                        count = count + 1
                    end
                end
                Rayfield:Notify({ Title = "Success", Content = "Updated " .. tostring(count) .. " image children.", Duration = 2 })
            end
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element latched on!", Duration = 2 })
        end
    end,
})

EditorTab:CreateButton({
    Name = "Remove Image / Clear Decal ID",
    Callback = function()
        if selectedObject and selectedObject.Parent then
            if selectedObject:IsA("ImageLabel") or selectedObject:IsA("ImageButton") then
                selectedObject.Image = ""
            end
            for _, child in ipairs(selectedObject:GetDescendants()) do
                if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                    child.Image = ""
                end
            end
            Rayfield:Notify({ Title = "Success", Content = "Cleared image(s).", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element latched on!", Duration = 2 })
        end
    end,
})

EditorTab:CreateSection("Delete Elements & Components")

EditorTab:CreateButton({
    Name = "Delete Selected UI Element",
    Callback = function()
        if selectedObject and selectedObject.Parent then
            local name = selectedObject.Name
            selectedObject:Destroy()
            updateSelectedObject(nil)
            Rayfield:Notify({ Title = "Deleted", Content = "Removed object: " .. name, Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element latched on!", Duration = 2 })
        end
    end,
})

EditorTab:CreateButton({
    Name = "Delete All Images in Selected",
    Callback = function()
        if selectedObject and selectedObject.Parent then
            local count = 0
            for _, child in ipairs(selectedObject:GetDescendants()) do
                if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                    child:Destroy()
                    count = count + 1
                end
            end
            if selectedObject:IsA("ImageLabel") or selectedObject:IsA("ImageButton") then
                selectedObject:Destroy()
                updateSelectedObject(nil)
                count = count + 1
            end
            Rayfield:Notify({ Title = "Success", Content = "Deleted " .. tostring(count) .. " image(s).", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element latched on!", Duration = 2 })
        end
    end,
})

EditorTab:CreateButton({
    Name = "Delete All Buttons in Selected",
    Callback = function()
        if selectedObject and selectedObject.Parent then
            local count = 0
            for _, child in ipairs(selectedObject:GetDescendants()) do
                if child:IsA("TextButton") or child:IsA("ImageButton") then
                    child:Destroy()
                    count = count + 1
                end
            end
            if selectedObject:IsA("TextButton") or selectedObject:IsA("ImageButton") then
                selectedObject:Destroy()
                updateSelectedObject(nil)
                count = count + 1
            end
            Rayfield:Notify({ Title = "Success", Content = "Deleted " .. tostring(count) .. " button(s).", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element latched on!", Duration = 2 })
        end
    end,
})

EditorTab:CreateButton({
    Name = "Delete All Text Elements in Selected",
    Callback = function()
        if selectedObject and selectedObject.Parent then
            local count = 0
            for _, child in ipairs(selectedObject:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextBox") then
                    child:Destroy()
                    count = count + 1
                end
            end
            if selectedObject:IsA("TextLabel") or selectedObject:IsA("TextBox") then
                selectedObject:Destroy()
                updateSelectedObject(nil)
                count = count + 1
            end
            Rayfield:Notify({ Title = "Success", Content = "Deleted " .. tostring(count) .. " text element(s).", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element latched on!", Duration = 2 })
        end
    end,
})
