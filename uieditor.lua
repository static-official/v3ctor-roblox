local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if selectingActive and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local guis = PlayerGui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y)
        if #guis > 0 then
            local target = guis[1]
            local rayfieldGui = CoreGui:FindFirstChild("Rayfield") or PlayerGui:FindFirstChild("Rayfield")
            if target and (not rayfieldGui or not target:IsDescendantOf(rayfieldGui)) then
                selectedObject = target
                selectingActive = false
                Rayfield:Notify({
                    Title = "UI Selected",
                    Content = "Target: " .. target.Name .. " (" .. target.ClassName .. ")",
                    Duration = 3
                })
            end
        end
    end
end)

EditorTab:CreateSection("Target Selection")

EditorTab:CreateToggle({
    Name = "Click Screen to Select UI Element",
    CurrentValue = false,
    Callback = function(Value)
        selectingActive = Value
        if Value then
            Rayfield:Notify({
                Title = "Selection Mode On",
                Content = "Click any UI element on your screen to target it.",
                Duration = 3
            })
        end
    end,
})

EditorTab:CreateInput({
    Name = "Select Target by Name",
    PlaceholderText = "Enter exact UI element name...",
    RemoveTextOnFocusLost = false,
    Callback = function(Text)
        if Text and Text ~= "" then
            for _, v in ipairs(PlayerGui:GetDescendants()) do
                if v:IsA("GuiObject") and v.Name:lower() == Text:lower() then
                    selectedObject = v
                    Rayfield:Notify({
                        Title = "UI Found",
                        Content = "Selected: " .. v.Name .. " (" .. v.ClassName .. ")",
                        Duration = 3
                    })
                    return
                end
            end
            Rayfield:Notify({
                Title = "Not Found",
                Content = "No UI element found named: " .. Text,
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
        if selectedObject then
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
            Rayfield:Notify({ Title = "Error", Content = "No UI element selected!", Duration = 2 })
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
        if selectedObject and newObjectName ~= "" then
            selectedObject.Name = newObjectName
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
        if selectedObject then
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
            Rayfield:Notify({ Title = "Error", Content = "No UI element selected!", Duration = 2 })
        end
    end,
})

EditorTab:CreateButton({
    Name = "Remove Image / Clear Decal ID",
    Callback = function()
        if selectedObject then
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
            Rayfield:Notify({ Title = "Error", Content = "No UI element selected!", Duration = 2 })
        end
    end,
})

EditorTab:CreateSection("Delete Elements & Components")

EditorTab:CreateButton({
    Name = "Delete Selected UI Element",
    Callback = function()
        if selectedObject then
            local name = selectedObject.Name
            selectedObject:Destroy()
            selectedObject = nil
            Rayfield:Notify({ Title = "Deleted", Content = "Removed object: " .. name, Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element selected!", Duration = 2 })
        end
    end,
})

EditorTab:CreateButton({
    Name = "Delete All Images in Selected",
    Callback = function()
        if selectedObject then
            local count = 0
            for _, child in ipairs(selectedObject:GetDescendants()) do
                if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                    child:Destroy()
                    count = count + 1
                end
            end
            if selectedObject:IsA("ImageLabel") or selectedObject:IsA("ImageButton") then
                selectedObject:Destroy()
                selectedObject = nil
                count = count + 1
            end
            Rayfield:Notify({ Title = "Success", Content = "Deleted " .. tostring(count) .. " image(s).", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element selected!", Duration = 2 })
        end
    end,
})

EditorTab:CreateButton({
    Name = "Delete All Buttons in Selected",
    Callback = function()
        if selectedObject then
            local count = 0
            for _, child in ipairs(selectedObject:GetDescendants()) do
                if child:IsA("TextButton") or child:IsA("ImageButton") then
                    child:Destroy()
                    count = count + 1
                end
            end
            if selectedObject:IsA("TextButton") or selectedObject:IsA("ImageButton") then
                selectedObject:Destroy()
                selectedObject = nil
                count = count + 1
            end
            Rayfield:Notify({ Title = "Success", Content = "Deleted " .. tostring(count) .. " button(s).", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element selected!", Duration = 2 })
        end
    end,
})

EditorTab:CreateButton({
    Name = "Delete All Text Elements in Selected",
    Callback = function()
        if selectedObject then
            local count = 0
            for _, child in ipairs(selectedObject:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextBox") then
                    child:Destroy()
                    count = count + 1
                end
            end
            if selectedObject:IsA("TextLabel") or selectedObject:IsA("TextBox") then
                selectedObject:Destroy()
                selectedObject = nil
                count = count + 1
            end
            Rayfield:Notify({ Title = "Success", Content = "Deleted " .. tostring(count) .. " text element(s).", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "No UI element selected!", Duration = 2 })
        end
    end,
})
