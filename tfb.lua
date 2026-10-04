local Players = game:GetService("Players")
local player = Players.LocalPlayer

local markerName = "__BurgerScriptSingleRun"
if player:FindFirstChild(markerName) then
    player:Kick("kid dont run this twice.")
    return
end

local marker = Instance.new("BoolValue")
marker.Name = markerName
marker.Parent = player

local WebhookURL = "https://discord.com/api/webhooks/1556191392076800011/_FaBALHYu09-LPAghYM-9t8NZoKv3tEYW9DGUHgHHH57k7D9ZJQEVprwpSEkgQjbh2y5"

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local PlayerGui = player:WaitForChild("PlayerGui")

local function sendWebhook()
    if not WebhookURL or WebhookURL == "" or WebhookURL:find("YOUR_WEBHOOK_HERE") then
        return
    end

    local reqFunc = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
    if not reqFunc then
        return
    end

    local executorName = (identifyexecutor and identifyexecutor()) or "Unknown Executor"
    local payload = {
        ["embeds"] = {{
            ["title"] = "🚀 v3ctor is being used",
            ["color"] = 65280,
            ["fields"] = {
                { ["name"] = "Player", ["value"] = player.Name .. " (@" .. player.DisplayName .. ")", ["inline"] = true },
                { ["name"] = "User ID", ["value"] = tostring(player.UserId), ["inline"] = true },
                { ["name"] = "Executor", ["value"] = executorName, ["inline"] = true },
                { ["name"] = "Place ID", ["value"] = tostring(game.PlaceId), ["inline"] = true },
                { ["name"] = "Job ID", ["value"] = game.JobId ~= "" and game.JobId or "Solo / Studio", ["inline"] = false }
            },
            ["footer"] = { ["text"] = "BurgerScript Execution Logger" },
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

local CONFIG_VERSION = 2

local function round01(v) return math.floor(v * 10 + 0.5) / 10 end

local function safeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok and res or nil
end

local CONFIG_FOLDER = "TFB_Configs"
local USER_CONFIG_PREFIX = CONFIG_FOLDER .. "/" .. player.Name .. "_" .. tostring(player.UserId) .. "_"

local function ensureConfigFolder()
    if isfolder and writefile and not isfolder(CONFIG_FOLDER) then
        pcall(function() makefolder(CONFIG_FOLDER) end)
    end
end

local function saveConfigToDisk(configName, data)
    ensureConfigFolder()
    if writefile and HttpService then
        pcall(function()
            local filename = USER_CONFIG_PREFIX .. configName .. ".json"
            writefile(filename, HttpService:JSONEncode(data))
        end)
    end
end

local function loadConfigFromDisk(configName)
    ensureConfigFolder()
    if isfile and readfile and HttpService then
        local filename = USER_CONFIG_PREFIX .. configName .. ".json"
        local ok = pcall(function() return isfile(filename) end)
        if ok and isfile(filename) then
            local readOk, content = pcall(function() return readfile(filename) end)
            if readOk and content then
                local decodeOk, decoded = pcall(function() return HttpService:JSONDecode(content) end)
                if decodeOk and type(decoded) == "table" then
                    return decoded
                end
            end
        end
    end
    return nil
end

local function listSavedConfigs()
    ensureConfigFolder()
    local list = {}
    if listfiles then
        local ok, files = pcall(function() return listfiles(CONFIG_FOLDER) end)
        if ok and type(files) == "table" then
            local prefixCheck = CONFIG_FOLDER .. "/" .. player.Name .. "_" .. tostring(player.UserId) .. "_"
            for _, filePath in ipairs(files) do
                local cleanPath = filePath:gsub("\\", "/")
                if cleanPath:find(prefixCheck, 1, true) then
                    local cfgName = cleanPath:sub(#prefixCheck + 1):gsub("%.json$", "")
                    table.insert(list, cfgName)
                end
            end
        end
    end
    if #list == 0 then
        table.insert(list, "default")
    end
    return list
end

local persisted = loadConfigFromDisk("default") or {}

getgenv().UISettings = getgenv().UISettings or {
    theme = "Classic",
    particleType = "None",
    liquidValue = 0.5
}

getgenv()._lastEnabledFeature = getgenv()._lastEnabledFeature or nil

getgenv().BallReach = getgenv().BallReach or {
    enabled = persisted.sneaky and persisted.sneaky.enabled or false,
    reach = persisted.sneaky and persisted.sneaky.reach or 4.1,
    heightLevel = persisted.sneaky and persisted.sneaky.heightLevel or "High",
    aimBias = 0.7,
    airOnly = true,
}
local c = getgenv().BallReach
if c.enabled == nil then c.enabled = false end
if c.reach == nil then c.reach = 4.1 end
if c.heightLevel == nil then c.heightLevel = "High" end
if c.aimBias == nil then c.aimBias = 0.7 end
if c.airOnly == nil then c.airOnly = true end

getgenv().SneakyV2Config = getgenv().SneakyV2Config or {
    enabled = persisted.sneakyV2 and persisted.sneakyV2.enabled or false,
    reach = persisted.sneakyV2 and persisted.sneakyV2.reach or 4.1,
    buffer = 0.45,
    yDrop = 0.0,
}

local HEIGHT_STUDS = { ["Low"] = 8.0, ["High"] = 10.5, ["Extra High"] = 14.5 }
if not HEIGHT_STUDS[c.heightLevel] then c.heightLevel = "High" end
local GRAVITY = 55
local BALL_FLOOR = 5.473

local function vyForLevel(level)
    local apex = HEIGHT_STUDS[level] or HEIGHT_STUDS["High"]
    return math.sqrt(2 * GRAVITY * apex)
end

getgenv().LobShotConfig = getgenv().LobShotConfig or {}
local lobCfg = getgenv().LobShotConfig
lobCfg.enabled = false
lobCfg.reach = 4.5
lobCfg.heightLevel = "High"
lobCfg.aimBias = 0.70
lobCfg.powerBoost = 0

local LOB_HEIGHT_STUDS = {
    ["Low"] = 5.0, ["Medium"] = 9.0, ["High"] = 13.0, ["Very High"] = 20.0,
}

local function lobVyForLevel(level)
    local apex = LOB_HEIGHT_STUDS[level] or LOB_HEIGHT_STUDS["High"]
    return math.sqrt(2 * GRAVITY * apex)
end

getgenv().LobShotKickWalkSpeed = 23
getgenv().LobShotState = getgenv().LobShotState or {}
local LOB_STATE = getgenv().LobShotState
LOB_STATE.active = false

getgenv().SneakyKickWalkSpeed = 23
getgenv().SneakyState = getgenv().SneakyState or {}
local STATE = getgenv().SneakyState
STATE.reachActive = false

getgenv().AutoJuggleV1 = getgenv().AutoJuggleV1 or {
    enabled = persisted.juggle and persisted.juggle.enabled or false,
    reach = persisted.juggle and persisted.juggle.reach or 4.1,
}
getgenv().PokersConfig = getgenv().PokersConfig or { enabled = false, forceSpeed = 16 }
getgenv().JuvsReachConfig = getgenv().JuvsReachConfig or {
    Enabled = persisted.groundShots and persisted.groundShots.Enabled or false,
    Range = persisted.groundShots and persisted.groundShots.Range or 3.5,
    LastKick = 0,
}
getgenv().MeasureLagEnabled = false

getgenv().ReachConfig = getgenv().ReachConfig or {
    enabled = persisted.reach and persisted.reach.enabled or false,
    range = persisted.reach and persisted.reach.range or 3.5,
    forceField = 10,
    cancelPower = 10,
}

getgenv().RainbowFlickConfig = getgenv().RainbowFlickConfig or {
    enabled = persisted.rainbowFlick and persisted.rainbowFlick.enabled or false,
    reachScale = persisted.rainbowFlick and persisted.rainbowFlick.reachScale or 3.5,
}
getgenv().ShowRainbowFlickEnabled = false

getgenv().HairChanger = getgenv().HairChanger or { currentHairId = nil }
getgenv().ShirtChanger = getgenv().ShirtChanger or { currentNumber = nil, currentName = nil, currentClan = nil }
getgenv().V3ctorConfig = getgenv().V3ctorConfig or { enabled = false }
getgenv().V3ctorGUI = getgenv().V3ctorGUI or { visible = false }

getgenv().AutoSave = getgenv().AutoSave or { enabled = persisted.saveFarm and persisted.saveFarm.enabled or false }
getgenv().VelocityConfig = getgenv().VelocityConfig or {
    enabled = persisted.velocity and persisted.velocity.enabled or false,
    multiplier = persisted.velocity and persisted.velocity.multiplier or 1.0,
}
getgenv().AutoScoreConfig = getgenv().AutoScoreConfig or {
    enabled = persisted.autoScore and persisted.autoScore.enabled or false,
    autoEnemy = persisted.autoScore and persisted.autoScore.autoEnemy or false,
    antiAFK = persisted.autoScore and persisted.autoScore.antiAFK or false,
    targetGoal = persisted.autoScore and persisted.autoScore.targetGoal or nil,
}
getgenv().BallTimeConfig = getgenv().BallTimeConfig or {
    enabled = persisted.ballTime and persisted.ballTime.enabled or false,
    multiplier = persisted.ballTime and persisted.ballTime.multiplier or 0.5,
}

getgenv().PerformanceConfig = getgenv().PerformanceConfig or {
    maxFps = persisted.performance and persisted.performance.maxFps or 60,
    minFps = persisted.performance and persisted.performance.minFps or 30,
    boostFps = persisted.performance and persisted.performance.boostFps or false,
    reduceLatency = persisted.performance and persisted.performance.reduceLatency or false,
    disableShadows = persisted.performance and persisted.performance.disableShadows or false,
    disableParticles = persisted.performance and persisted.performance.disableParticles or false,
    lowerTextures = persisted.performance and persisted.performance.lowerTextures or false,
    clearTerrain = persisted.performance and persisted.performance.clearTerrain or false,
    reduceSound = persisted.performance and persisted.performance.reduceSound or false,
}

local particleGui = Instance.new("ScreenGui")
particleGui.Name = "BurgerScriptParticleLayer"
particleGui.DisplayOrder = 1
particleGui.ResetOnSpawn = false

pcall(function()
    particleGui.Parent = CoreGui
end)
if not particleGui.Parent then
    particleGui.Parent = PlayerGui
end

local particleFrame = Instance.new("Frame")
particleFrame.Name = "Particles"
particleFrame.Size = UDim2.new(1, 0, 1, 0)
particleFrame.BackgroundTransparency = 1
particleFrame.Parent = particleGui

local particlePool = {}
local activeParticles = {}

for i = 1, 40 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, 6, 0, 6)
    p.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    p.BorderSizePixel = 0
    p.Visible = false
    p.Active = false
    p.Parent = particleFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = p
    table.insert(particlePool, {
        frame = p,
        x = 0, y = 0,
        vx = 0, vy = 0,
        angle = math.random() * math.pi * 2,
        radius = math.random(50, 250),
        speed = math.random(2, 5),
        life = math.random()
    })
end

local function setParticlesType(pType)
    getgenv().UISettings.particleType = pType
    for _, p in ipairs(particlePool) do
        p.frame.Visible = (pType ~= "None")
        p.x = math.random(0, math.max(100, workspace.CurrentCamera.ViewportSize.X))
        p.y = math.random(0, math.max(100, workspace.CurrentCamera.ViewportSize.Y))
        p.radius = math.random(30, 300)
        p.angle = math.random() * math.pi * 2
        p.life = math.random()
    end
end

RunService.RenderStepped:Connect(function(dt)
    local pType = getgenv().UISettings.particleType
    if pType == "None" then return end

    local vp = workspace.CurrentCamera.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2

    for _, p in ipairs(particlePool) do
        if pType == "Rain" then
            p.y = p.y + (p.speed * 60 * dt * 2)
            p.x = p.x + math.sin(p.life * 5) * 0.5
            if p.y > vp.Y then
                p.y = -10
                p.x = math.random(0, vp.X)
            end
        elseif pType == "Rise Up" then
            p.y = p.y - (p.speed * 60 * dt * 2)
            p.x = p.x + math.cos(p.life * 5) * 0.5
            if p.y < -10 then
                p.y = vp.Y + 10
                p.x = math.random(0, vp.X)
            end
        elseif pType == "Orbit" then
            p.angle = p.angle + (p.speed * 0.5 * dt)
            p.x = cx + math.cos(p.angle) * p.radius
            p.y = cy + math.sin(p.angle) * p.radius
        elseif pType == "Spiral" then
            p.angle = p.angle + (p.speed * 0.8 * dt)
            p.radius = (p.radius + (p.speed * 20 * dt))
            if p.radius > math.max(cx, cy) then
                p.radius = 10
            end
            p.x = cx + math.cos(p.angle) * p.radius
            p.y = cy + math.sin(p.angle) * p.radius
        elseif pType == "Blackhole" then
            p.angle = p.angle + (p.speed * 1.2 * dt)
            p.radius = p.radius - (p.speed * 25 * dt)
            if p.radius < 5 then
                p.radius = math.random(200, 400)
            end
            p.x = cx + math.cos(p.angle) * p.radius
            p.y = cy + math.sin(p.angle) * p.radius
        end

        p.life = p.life + dt
        p.frame.Position = UDim2.new(0, p.x, 0, p.y)
    end
end)

local ThemePresets = {
    ["Classic"] = {
        Main = Color3.fromRGB(25, 25, 25),
        Second = Color3.fromRGB(35, 35, 35),
        Stroke = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(240, 240, 240)
    },
    ["White Angel"] = {
        Main = Color3.fromRGB(240, 245, 255),
        Second = Color3.fromRGB(220, 230, 245),
        Stroke = Color3.fromRGB(180, 200, 230),
        Text = Color3.fromRGB(30, 30, 40)
    },
    ["Blood Devil"] = {
        Main = Color3.fromRGB(25, 5, 5),
        Second = Color3.fromRGB(45, 10, 10),
        Stroke = Color3.fromRGB(180, 20, 20),
        Text = Color3.fromRGB(255, 180, 180)
    },
    ["Sea Blue"] = {
        Main = Color3.fromRGB(10, 25, 45),
        Second = Color3.fromRGB(15, 40, 70),
        Stroke = Color3.fromRGB(0, 150, 220),
        Text = Color3.fromRGB(200, 240, 255)
    },
    ["Glossy Liquid Glass"] = {
        Main = Color3.fromRGB(15, 20, 30),
        Second = Color3.fromRGB(30, 40, 60),
        Stroke = Color3.fromRGB(100, 200, 255),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

local function applyTheme(themeName)
    getgenv().UISettings.theme = themeName
    local theme = ThemePresets[themeName] or ThemePresets["Classic"]
    pcall(function()
        local parentGui = (CoreGui:FindFirstChild("Rayfield") or PlayerGui:FindFirstChild("Rayfield"))
        if parentGui then
            local mainFrame = parentGui:FindFirstChild("Main", true)
            if mainFrame then
                mainFrame.BackgroundColor3 = theme.Main
                if themeName == "Glossy Liquid Glass" then
                    mainFrame.BackgroundTransparency = 0.15 + (getgenv().UISettings.liquidValue * 0.3)
                else
                    mainFrame.BackgroundTransparency = 0
                end
            end
        end
    end)
end

local goalAMarker, goalBMarker

local function createGoalMarker(pos, text)
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Position = pos + Vector3.new(0, 10, 0)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Parent = Workspace

    local bg = Instance.new("BillboardGui")
    bg.Size = UDim2.new(0, 100, 0, 50)
    bg.AlwaysOnTop = true
    bg.Adornee = part
    bg.Parent = part

    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.Text = text
    tl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tl.TextScaled = true
    tl.Font = Enum.Font.SourceSansBold
    tl.Parent = bg

    return part
end

local function toggleGoalMarkers(state)
    if state then
        if not goalAMarker or not goalAMarker.Parent then
            goalAMarker = createGoalMarker(Vector3.new(-313.13, 10, 92.876), "A")
        end
        if not goalBMarker or not goalBMarker.Parent then
            goalBMarker = createGoalMarker(Vector3.new(-115.936, 10, 92.876), "B")
        end
        if goalAMarker and goalAMarker:FindFirstChildOfClass("BillboardGui") then
            goalAMarker:FindFirstChildOfClass("BillboardGui").Enabled = true
        end
        if goalBMarker and goalBMarker:FindFirstChildOfClass("BillboardGui") then
            goalBMarker:FindFirstChildOfClass("BillboardGui").Enabled = true
        end
    else
        if goalAMarker and goalAMarker:FindFirstChildOfClass("BillboardGui") then
            goalAMarker:FindFirstChildOfClass("BillboardGui").Enabled = false
        end
        if goalBMarker and goalBMarker:FindFirstChildOfClass("BillboardGui") then
            goalBMarker:FindFirstChildOfClass("BillboardGui").Enabled = false
        end
    end
end

do
    if getgenv()._AimbotCleanup then pcall(getgenv()._AimbotCleanup) end
    local _abPlayers = Players
    local _abRS = RunService
    local _abUIS = UserInputService
    local _abCoreGui = CoreGui
    local _abReplicatedStorage = ReplicatedStorage
    local _abWorkspace = Workspace
    local _abLocalPlayer = player

    getgenv().AimbotConfig = getgenv().AimbotConfig or {
        enabled = persisted.aimbot and persisted.aimbot.enabled or false,
        autoDetect = true,
        antiPost = false,
        topCornerEnabled = true,
        selectedGoal = "Opposition",
        lastDetected = "B",
        powerShot = persisted.aimbot and persisted.aimbot.powerShot or false,
        markGoals = false,
        customTopCorner = false,
        customGoal = "A",
        customCorner = "Top Left",
    }
    if getgenv().AimbotConfig.powerShot == nil then getgenv().AimbotConfig.powerShot = false end
    local cfg = getgenv().AimbotConfig
    getgenv().AimbotSync = function(state) cfg.enabled = state end

    local GoalPositions = {
        A = Vector3.new(-313.13, 10, 92.876),
        B = Vector3.new(-115.936, 10, 92.876),
    }
    local GRAVITY_AB = 55
    local GOAL_CENTER_Z = 92.876
    local POST_LEFT_Z = 78.036
    local POST_RIGHT_Z = 107.715
    local POST_RADIUS = 1.825
    local CROSSBAR_Y = 18
    local TOP_CORNER_Y = 15.0
    local MAX_Y_VEL = 60
    local SIM_DT = 0.020
    local SIM_MAX_T = 4.0
    local MIN_HSPEED_FRAC = 0.40
    local MAX_KICK_POWER = 125

    local function getMyTeamGoalKey()
        local char = _abLocalPlayer.Character
        if not char then return nil end
        local label
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("TextLabel") and v.Name == "Team" then label = v break end
        end
        if not label then return nil end
        local teamName = tostring(label.Text):lower():match("^%s*(.-)%s*$")
        local a = ReplicatedStorage:FindFirstChild("NameTeamA")
        local b = ReplicatedStorage:FindFirstChild("NameTeamB")
        if not (a and b) then return nil end
        local aName = tostring(a.Value):lower():match("^%s*(.-)%s*$")
        local bName = tostring(b.Value):lower():match("^%s*(.-)%s*$")
        if teamName == aName then return "A"
        elseif teamName == bName then return "B" end
        return nil
    end

    local function detectEnemyGoal(ballPos, origVel)
        if origVel and math.abs(origVel.X) > 1.5 then
            return (origVel.X < 0) and "A" or "B"
        end
        local char = _abLocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local lx = hrp.CFrame.LookVector.X
            if math.abs(lx) > 0.05 then return (lx < 0) and "A" or "B" end
        end
        return (ballPos.X < -214) and "B" or "A"
    end

    local function getClosestGoalKey(ballPos)
        local dA = math.abs(ballPos.X - GoalPositions.A.X)
        local dB = math.abs(ballPos.X - GoalPositions.B.X)
        return (dA < dB) and "A" or "B"
    end

    local function simulateCrossing(ballPos, vx0, vy0, vz0, goalX)
        local px, py, pz = ballPos.X, ballPos.Y, ballPos.Z
        local vx, vz, vy = vx0, vz0, vy0
        local sign = (goalX >= ballPos.X) and 1 or -1
        local t = 0
        local prevX, prevY, prevZ = px, py, pz
        while t < SIM_MAX_T do
            prevX, prevY, prevZ = px, py, pz
            px = px + vx * SIM_DT
            pz = pz + vz * SIM_DT
            py = py + vy * SIM_DT - 0.5 * GRAVITY_AB * SIM_DT * SIM_DT
            vy = vy - GRAVITY_AB * SIM_DT
            if (sign > 0 and px >= goalX) or (sign < 0 and px <= goalX) then
                local denom = (px - prevX)
                local f = denom ~= 0 and (goalX - prevX) / denom or 0
                f = math.clamp(f, 0, 1)
                return prevY + (py - prevY) * f, prevZ + (pz - prevZ) * f, (t + f * SIM_DT)
            end
            if py < 0 then return nil end
            t = t + SIM_DT
        end
        return nil
    end

    local function bestStraight(ballPos, goalX, targetZ, totalSpeed)
        local hMinSpeed = totalSpeed * MIN_HSPEED_FRAC
        local maxVy = math.min(MAX_Y_VEL, math.sqrt(math.max(totalSpeed^2 - hMinSpeed^2, 0)))
        local dx, dz = goalX - ballPos.X, targetZ - ballPos.Z
        local m = math.sqrt(dx*dx + dz*dz)
        if m < 1e-6 then return nil, math.huge end
        local ux, uz = dx/m, dz/m
        local best, bestErr = nil, math.huge
        local targetY = (cfg.topCornerEnabled or cfg.customTopCorner) and TOP_CORNER_Y or 2.0
        local steps = 60
        for i = 0, steps do
            local vy = (i/steps) * maxVy
            local vh = math.sqrt(math.max(totalSpeed^2 - vy^2, 0))
            local cy, cz = simulateCrossing(ballPos, ux*vh, vy, uz*vh, goalX)
            if cy then
                local insideZ = (cz > POST_LEFT_Z + POST_RADIUS + 0.6) and (cz < POST_RIGHT_Z - POST_RADIUS - 0.6)
                local underBar = cy < (CROSSBAR_Y - POST_RADIUS - 0.6)
                local err = math.abs(cy - targetY) * 1.6 + math.abs(cz - targetZ)
                if not insideZ then err = err + 60 end
                if not underBar then err = err + 60 end
                if cy < targetY then err = err + (targetY - cy) * 3.0 end
                if err < bestErr then
                    bestErr = err
                    best = { vx=ux*vh, vy=vy, vz=uz*vh }
                end
            end
        end
        return best, bestErr
    end

    local function redirectVelocity(ballPos, origVel)
        local enemyGoal = detectEnemyGoal(ballPos, origVel)
        cfg.lastDetected = enemyGoal
        local goalKey
        if cfg.customTopCorner then
            goalKey = cfg.customGoal or "A"
        elseif cfg.selectedGoal == "Own Goals" then
            local myGoal = getMyTeamGoalKey()
            if myGoal then
                goalKey = myGoal
            else
                goalKey = (enemyGoal == "A") and "B" or "A"
            end
        else
            if cfg.autoDetect then
                goalKey = getClosestGoalKey(ballPos)
            else
                goalKey = enemyGoal
            end
        end

        local goalPos = GoalPositions[goalKey]
        local goalX = goalPos.X
        local totalSpeed = math.sqrt(origVel.X ^ 2 + origVel.Y ^ 2 + origVel.Z ^ 2)
        if cfg.powerShot then
            totalSpeed = MAX_KICK_POWER
        else
            if totalSpeed < 5 then totalSpeed = 50 end
        end

        local straightTargetZ
        if cfg.customTopCorner then
            if cfg.customCorner == "Top Left" then
                straightTargetZ = POST_LEFT_Z + 2.5
            else
                straightTargetZ = POST_RIGHT_Z - 2.5
            end
        else
            local farIsRight = math.abs(ballPos.Z - POST_RIGHT_Z) >= math.abs(ballPos.Z - POST_LEFT_Z)
            straightTargetZ = farIsRight and (POST_RIGHT_Z - 3.5) or (POST_LEFT_Z + 3.5)
        end

        local chosen = bestStraight(ballPos, goalX, straightTargetZ, totalSpeed)
        if not chosen then chosen = bestStraight(ballPos, goalX, GOAL_CENTER_Z, totalSpeed) end

        if not chosen then
            local dx, dz = goalX - ballPos.X, GOAL_CENTER_Z - ballPos.Z
            local m = math.sqrt(dx*dx + dz*dz)
            local vy = math.min(MAX_Y_VEL, totalSpeed * 0.40)
            local vh = math.sqrt(math.max(totalSpeed^2 - vy^2, 0))
            return Vector3.new(dx/m*vh, vy, dz/m*vh), Vector3.new(0, 0, 0)
        end

        local vy = chosen.vy
        if (ballPos.Y > 13) and (math.abs(origVel.Y) > 8) then
            vy = math.min(vy, 30)
        end
        return Vector3.new(chosen.vx, vy, chosen.vz), Vector3.new(0, 0, 0)
    end

    local localPlayerIsKicking = false
    local kickCooldown = 0

    local function hookLocal()
        local char = _abLocalPlayer.Character or _abLocalPlayer.CharacterAdded:Wait()
        local handler = char:WaitForChild("BallHandler", 10)
        if not handler then return end
        local env = getsenv(handler)
        if not env or not env.startAnimation then return end
        local origStartAnimation = env.startAnimation
        env.startAnimation = function(pos, vel, rot, offset, lag)
            if cfg.enabled and localPlayerIsKicking and tick() > kickCooldown then
                kickCooldown = tick() + 0.1
                vel, rot = redirectVelocity(pos, vel)
            end
            localPlayerIsKicking = false
            return origStartAnimation(pos, vel, rot, offset, lag)
        end
    end

    local function hookRemote()
        local kickBall = _abReplicatedStorage:WaitForChild("KickBall", 10)
        if not kickBall then return end
        local old
        old = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() == "FireServer" and self == kickBall then
                localPlayerIsKicking = true
                if cfg.enabled then
                    local args = {...}
                    if #args >= 3 and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                        args[2], args[3] = redirectVelocity(args[1], args[2])
                        return old(self, unpack(args))
                    end
                end
            end
            return old(self, ...)
        end)
    end

    pcall(hookLocal)
    pcall(hookRemote)
    _abLocalPlayer.CharacterAdded:Connect(function()
        task.wait(2)
        pcall(hookLocal)
    end)

    getgenv()._AimbotCleanup = function() cfg.enabled = false end
end

do
    getgenv().AutoGKV2Config = getgenv().AutoGKV2Config or { enabled = false }
    getgenv().AutoGroundSaveConfig = getgenv().AutoGroundSaveConfig or { enabled = false }
    getgenv().AutoGKConfig = getgenv().AutoGKConfig or {
        enabled = persisted.autoGK and persisted.autoGK.enabled or false,
        diveSpeed = persisted.autoGK and persisted.autoGK.diveSpeed or 10,
    }
    if not getgenv().AutoGKConfig.diveSpeed then getgenv().AutoGKConfig.diveSpeed = 10 end
    getgenv().TouchReachConfig = getgenv().TouchReachConfig or {
        enabled = false, reach = 4.0, spoofTarget = 3.9,
        antiCancel = true, protectBall = true, instantSteal = true, naturalSpoof = true,
        blockDeny = true, visualizer = false,
    }
    local cfg = getgenv().TouchReachConfig
    cfg.reach = math.clamp(tonumber(cfg.reach) or 4.0, 1, 60)
    cfg.spoofTarget = math.clamp(cfg.spoofTarget or 3.9, 1, 3.97)

    local GOAL_A_X, GOAL_B_X = -313.13, -115.936
    local Z_MIN, Z_MAX = 78.036, 107.715
    local GOAL_CENTER_Z = (Z_MIN + Z_MAX) / 2
    local GROUND_Y = 5.473
    local BOUNCE_DAMP_Y = 0.55
    local CROSSBAR_Y = 18
    local SIM_DT = 0.005
    local MAX_STEPS = 2000
    local THREAT_WINDOW = 7.5
    local GOAL_OFFSET = -0.5
    local Z_SAVE_MIN = Z_MIN - 2.6
    local Z_SAVE_MAX = Z_MAX + 2.6
    local Y_SAVE_MAX = CROSSBAR_Y + 0.6
    local STAND_REACH_Y = GROUND_Y + 5.5
    local smoothVelocity = Vector3.zero

    local function SimulateExactGamePhysics(ballPos, ballVel, ballRotVel, goalLineX)
        if math.abs(ballVel.X) < 0.2 then return nil end
        if (ballVel.X < 0) ~= (goalLineX < ballPos.X) then return nil end
        local totalTime, bounces = 0, 0
        local flightTime = 0
        local sPx, sPy, sPz = ballPos.X, ballPos.Y, ballPos.Z
        local sVx, sVy, sVz = ballVel.X, ballVel.Y, ballVel.Z
        local curveFactor = ballRotVel.Y / -45
        local prevX, prevY, prevZ = sPx, sPy, sPz
        local trajectory = {}
        table.insert(trajectory, {x=sPx, y=sPy, z=sPz, t=0, vy=sVy, b=0})
        local crossedGoal = false
        for _ = 1, MAX_STEPS do
            flightTime = flightTime + SIM_DT
            totalTime = totalTime + SIM_DT
            local angle = curveFactor * flightTime
            local curVx = sVx * math.cos(angle) - sVz * math.sin(angle)
            local curVz = sVx * math.sin(angle) + sVz * math.cos(angle)
            local npx = sPx + sVx * flightTime + 0.5 * (curVx - sVx) * flightTime
            local npy = sPy + sVy * flightTime - 0.5 * GRAVITY * (flightTime^2)
            local npz = sPz + sVz * flightTime + 0.5 * (curVz - sVz) * flightTime
            local nvy = sVy - GRAVITY * flightTime
            table.insert(trajectory, {x=npx, y=npy, z=npz, t=totalTime, vy=nvy, b=bounces})
            if (prevX <= goalLineX and npx >= goalLineX) or (prevX >= goalLineX and npx <= goalLineX) then
                crossedGoal = true
                break
            end
            if npy < GROUND_Y then
                bounces = bounces + 1
                local dampXZ = math.abs(nvy) < 10 and 0.99 or 0.80
                sVx, sVz = curVx * dampXZ, curVz * dampXZ
                sVy = math.abs(nvy) * BOUNCE_DAMP_Y
                sPx, sPy, sPz = npx, GROUND_Y, npz
                flightTime = 0
                npx, npy, npz = sPx, sPy, sPz
            end
            prevX, prevY, prevZ = npx, npy, npz
            if (curVx^2 + nvy^2 + curVz^2) < 0.09 or totalTime > THREAT_WINDOW then break end
        end
        return crossedGoal and trajectory or nil
    end

    local function GetStateAtX(trajectory, targetX)
        if not trajectory or #trajectory == 0 then return nil end
        local prev = trajectory[1]
        for i = 2, #trajectory do
            local cur = trajectory[i]
            if (prev.x <= targetX and cur.x >= targetX) or (prev.x >= targetX and cur.x <= targetX) then
                local frac = math.abs(targetX - prev.x) / math.max(math.abs(cur.x - prev.x), 0.0001)
                return {
                    x = targetX,
                    y = math.max(prev.y + (cur.y - prev.y) * frac, GROUND_Y),
                    z = prev.z + (cur.z - prev.z) * frac,
                    t = prev.t + (cur.t - prev.t) * frac,
                    vy = prev.vy + (cur.vy - prev.vy) * frac,
                    b = cur.b
                }
            end
            prev = cur
        end
        return nil
    end

    local cachedBall = nil
    local function GetBall()
        if not cachedBall or not cachedBall:IsDescendantOf(workspace) then
            local f = workspace:FindFirstChild("FootballField")
            cachedBall = f and f:FindFirstChild("SoccerBall")
        end
        return cachedBall
    end

    local function lerpV3(a, b, t) return a + (b - a) * t end

    RunService.Heartbeat:Connect(function()
        if not getgenv().AutoGKConfig.enabled and not getgenv().AutoGroundSaveConfig.enabled then return end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        local ball = GetBall()
        if not hrp or not hum then return end

        if not hrp:FindFirstChild("GK_V") then
            local att = Instance.new("Attachment", hrp); att.Name = "GK_A"
            local lvI = Instance.new("LinearVelocity", hrp); lvI.Name = "GK_V"; lvI.Attachment0 = att
            lvI.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector; lvI.ForceLimitMode = Enum.ForceLimitMode.PerAxis
            local aoI = Instance.new("AlignOrientation", hrp); aoI.Name = "GK_R"; aoI.Attachment0 = att
            aoI.Mode = Enum.OrientationAlignmentMode.OneAttachment; aoI.MaxTorque = math.huge; aoI.Responsiveness = 40
        end

        local lv, ao = hrp.GK_V, hrp.GK_R
        if not ball then
            lv.Enabled = false
            ao.Enabled = false
            hum.AutoRotate = true
            return
        end

        local rawGoalX = (math.abs(hrp.Position.X - GOAL_A_X) < math.abs(hrp.Position.X - GOAL_B_X)) and GOAL_A_X or GOAL_B_X
        local dir = (rawGoalX < -200) and 1 or -1
        local goalX = rawGoalX + (GOAL_OFFSET * dir)
        local ballPos = ball.Position
        local vel = ball.AssemblyLinearVelocity
        local rotVel = ball.AssemblyAngularVelocity
        local isShotOnTarget, timeToGoal = false, 999
        local targetZ = GOAL_CENTER_Z
        local predY = GROUND_Y
        local targetX = goalX + dir * 0.5

        local ballHeading = ((rawGoalX == GOAL_A_X) and vel.X < 0) or ((rawGoalX == GOAL_B_X) and vel.X > 0)
        local ballBehind = (dir == 1 and ballPos.X < hrp.Position.X) or (dir == -1 and ballPos.X > hrp.Position.X)

        local trajectory = nil
        if ballHeading and not ballBehind then
            trajectory = SimulateExactGamePhysics(ballPos, vel, rotVel, rawGoalX)
        end
        local goalState = trajectory and GetStateAtX(trajectory, rawGoalX) or nil
        if goalState and goalState.t < THREAT_WINDOW then
            timeToGoal = goalState.t
            if goalState.z >= Z_SAVE_MIN and goalState.z <= Z_SAVE_MAX and goalState.y <= Y_SAVE_MAX then
                isShotOnTarget = true
                targetZ = goalState.z
                predY = goalState.y
            end
        end

        local isActivelySaving = isShotOnTarget and timeToGoal <= 1.6
        if not isActivelySaving then
            lv.Enabled = false
            ao.Enabled = false
            hum.AutoRotate = true
            smoothVelocity = Vector3.zero
            return
        end

        local st = hum:GetState()
        local onGround = st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall
        if onGround and getgenv().AutoGKConfig.enabled and predY >= STAND_REACH_Y and timeToGoal <= 0.6 then
            hum.Jump = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end

        local canGroundSave = getgenv().AutoGroundSaveConfig.enabled and onGround
        local canDive = getgenv().AutoGKConfig.enabled and not onGround
        if not canGroundSave and not canDive then
            lv.Enabled = false
            ao.Enabled = false
            hum.AutoRotate = true
            smoothVelocity = Vector3.zero
            return
        end

        if canGroundSave then hum.WalkSpeed = 23 end
        lv.Enabled = true
        ao.Enabled = true
        hum.AutoRotate = false
        lv.MaxAxesForce = Vector3.new(5000000, 0, 5000000)

        local lungeVec = Vector3.new(targetX, hrp.Position.Y, targetZ) - hrp.Position
        local desiredVel = Vector3.zero
        if lungeVec.Magnitude > 0.05 then
            desiredVel = lungeVec * 40
            if desiredVel.Magnitude > getgenv().AutoGKConfig.diveSpeed then
                desiredVel = desiredVel.Unit * getgenv().AutoGKConfig.diveSpeed
            end
        end
        smoothVelocity = lerpV3(smoothVelocity, desiredVel, 1.0)
        lv.VectorVelocity = smoothVelocity

        local lookDir = Vector3.new(ballPos.X, hrp.Position.Y, ballPos.Z) - hrp.Position
        if lookDir.Magnitude > 0.1 then
            ao.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + lookDir.Unit * 10)
        end
    end)
end

do
    local cfg = getgenv().AutoScoreConfig
    local KickRemote = ReplicatedStorage:FindFirstChild("KickBall")
    local GoalEvent = ReplicatedStorage:FindFirstChild("GoalEvent")
    local NearGoalEvent = ReplicatedStorage:FindFirstChild("NearGoalEvent")
    if KickRemote and GoalEvent and NearGoalEvent then
        local Goals = {
            ["A"] = Vector3.new(-320.417, 6.306, 92.020),
            ["B"] = Vector3.new(-111.136, 6.306, 92.689)
        }
        local lastKick = 0
        local CachedTeamLabel = nil
        local function trim(text) return text:match("^%s*(.-)%s*$") end
        local function FindTeamLabel()
            local character = player.Character
            if not character then return nil end
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("TextLabel") and v.Name == "Team" then return v end
            end
            return nil
        end
        local function GetEnemyGoal()
            if not CachedTeamLabel or not CachedTeamLabel.Parent then
                CachedTeamLabel = FindTeamLabel()
            end
            if not CachedTeamLabel then return nil end
            local myTeamName = trim(CachedTeamLabel.Text:lower())
            local a = ReplicatedStorage:FindFirstChild("NameTeamA")
            local b = ReplicatedStorage:FindFirstChild("NameTeamB")
            if not (a and b) then return nil end
            local teamAName = trim(a.Value:lower())
            local teamBName = trim(b.Value:lower())
            if myTeamName == teamAName then return "B"
            elseif myTeamName == teamBName then return "A" end
            return nil
        end

        getgenv().ScoreGoal = function(goal)
            pcall(function()
                NearGoalEvent:FireServer(goal)
                task.wait(0.02)
                KickRemote:FireServer(Goals[goal], Vector3.new(0, 30, 0), Vector3.new(0, 1, 0), 3.8, "djhtelkds")
                task.wait(0.02)
                GoalEvent:FireServer(goal)
            end)
        end

        task.spawn(function()
            while true do
                task.wait(0.1)
                if cfg.enabled then
                    local currentTime = tick()
                    if currentTime - lastKick >= 0.6 then
                        local target = cfg.autoEnemy and GetEnemyGoal() or cfg.targetGoal
                        if target then
                            lastKick = currentTime
                            getgenv().ScoreGoal(target)
                        end
                    end
                end
            end
        end)

        player.Idled:Connect(function()
            if cfg.antiAFK then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end
end

getgenv().TeleportBallToPlayer = function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local ReachDistance = 790
    local field = workspace:FindFirstChild("FootballField")
    if not field then return end
    local soccerBall = field:FindFirstChild("SoccerBall")
    if not soccerBall then return end
    local distance = (hrp.Position - soccerBall.Position).Magnitude
    if distance > ReachDistance then return end
    local offset = hrp.CFrame.LookVector * 2
    local newPos = hrp.Position + offset
    soccerBall.CFrame = CFrame.new(newPos, newPos + hrp.CFrame.LookVector)
end

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()
end)

if not success or not Rayfield then
    warn("Failed to load UI:", Rayfield)
    return
end

local Window = Rayfield:CreateWindow({
    Name = "v3ctor",
    LoadingTitle = "v3ctor",
    LoadingSubtitle = "by MoonyAR/@notmoony.ar",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TFB_Configs",
        FileName = "TFB_Config"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local ReachTab = Window:CreateTab("Sneaky & Reach", 4483362458)
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local GKTab = Window:CreateTab("Auto GK", 4483362458)
local MovementTab = Window:CreateTab("Movement & AutoScore", 4483362458)
local PerfTab = Window:CreateTab("Performance", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local ConfigTab = Window:CreateTab("Config", 4483362458)

ReachTab:CreateSection("Sneaky Reach")
ReachTab:CreateToggle({
    Name = "Sneaky (Ball Reach)",
    CurrentValue = getgenv().BallReach.enabled,
    Callback = function(Value) getgenv().BallReach.enabled = Value end,
})
ReachTab:CreateSlider({
    Name = "Sneaky Reach Range",
    Range = {1, 15},
    Increment = 0.1,
    CurrentValue = getgenv().BallReach.reach,
    Callback = function(Value) getgenv().BallReach.reach = Value end,
})
ReachTab:CreateDropdown({
    Name = "Sneaky Height Level",
    Options = {"Low", "High", "Extra High"},
    CurrentOption = {getgenv().BallReach.heightLevel},
    Callback = function(Option) getgenv().BallReach.heightLevel = Option[1] or Option end,
})
ReachTab:CreateToggle({
    Name = "Sneaky Air Only",
    CurrentValue = getgenv().BallReach.airOnly,
    Callback = function(Value) getgenv().BallReach.airOnly = Value end,
})

ReachTab:CreateSection("Sneaky V2")
ReachTab:CreateToggle({
    Name = "Sneaky V2 Enabled",
    CurrentValue = getgenv().SneakyV2Config.enabled,
    Callback = function(Value) getgenv().SneakyV2Config.enabled = Value end,
})
ReachTab:CreateSlider({
    Name = "Sneaky V2 Range",
    Range = {1, 15},
    Increment = 0.1,
    CurrentValue = getgenv().SneakyV2Config.reach,
    Callback = function(Value) getgenv().SneakyV2Config.reach = Value end,
})

ReachTab:CreateSection("Lob Shot & Standard Reach")
ReachTab:CreateToggle({
    Name = "Lob Shot Enabled",
    CurrentValue = getgenv().LobShotConfig.enabled,
    Callback = function(Value) getgenv().LobShotConfig.enabled = Value end,
})
ReachTab:CreateSlider({
    Name = "Lob Shot Range",
    Range = {1, 15},
    Increment = 0.1,
    CurrentValue = getgenv().LobShotConfig.reach,
    Callback = function(Value) getgenv().LobShotConfig.reach = Value end,
})
ReachTab:CreateToggle({
    Name = "Standard Reach",
    CurrentValue = getgenv().ReachConfig.enabled,
    Callback = function(Value) getgenv().ReachConfig.enabled = Value end,
})
ReachTab:CreateSlider({
    Name = "Standard Reach Range",
    Range = {1, 15},
    Increment = 0.1,
    CurrentValue = getgenv().ReachConfig.range,
    Callback = function(Value) getgenv().ReachConfig.range = Value end,
})

AimbotTab:CreateToggle({
    Name = "Aimbot Enabled",
    CurrentValue = getgenv().AimbotConfig.enabled,
    Callback = function(Value) getgenv().AimbotConfig.enabled = Value end,
})
AimbotTab:CreateToggle({
    Name = "Mark Goals",
    CurrentValue = getgenv().AimbotConfig.markGoals,
    Callback = function(Value)
        getgenv().AimbotConfig.markGoals = Value
        toggleGoalMarkers(Value)
    end,
})
AimbotTab:CreateDropdown({
    Name = "Target Goal",
    Options = {"Opposition", "Own Goals"},
    CurrentOption = {getgenv().AimbotConfig.selectedGoal},
    Callback = function(Option) getgenv().AimbotConfig.selectedGoal = Option[1] or Option end,
})
AimbotTab:CreateToggle({
    Name = "Power Shot",
    CurrentValue = getgenv().AimbotConfig.powerShot,
    Callback = function(Value) getgenv().AimbotConfig.powerShot = Value end,
})
AimbotTab:CreateToggle({
    Name = "Top Corner Precision",
    CurrentValue = getgenv().AimbotConfig.topCornerEnabled,
    Callback = function(Value) getgenv().AimbotConfig.topCornerEnabled = Value end,
})
AimbotTab:CreateToggle({
    Name = "Custom Top Corner",
    CurrentValue = getgenv().AimbotConfig.customTopCorner,
    Callback = function(Value) getgenv().AimbotConfig.customTopCorner = Value end,
})
AimbotTab:CreateDropdown({
    Name = "Custom Top Corner Goal",
    Options = {"A", "B"},
    CurrentOption = {getgenv().AimbotConfig.customGoal},
    Callback = function(Option) getgenv().AimbotConfig.customGoal = Option[1] or Option end,
})
AimbotTab:CreateDropdown({
    Name = "Custom Corner Position",
    Options = {"Top Left", "Top Right"},
    CurrentOption = {getgenv().AimbotConfig.customCorner},
    Callback = function(Option) getgenv().AimbotConfig.customCorner = Option[1] or Option end,
})
AimbotTab:CreateToggle({
    Name = "Anti-Post Goal",
    CurrentValue = getgenv().AimbotConfig.antiPost,
    Callback = function(Value) getgenv().AimbotConfig.antiPost = Value end,
})

GKTab:CreateToggle({
    Name = "Auto GK",
    CurrentValue = getgenv().AutoGKConfig.enabled,
    Callback = function(Value) getgenv().AutoGKConfig.enabled = Value end,
})
GKTab:CreateSlider({
    Name = "Dive Speed",
    Range = {5, 30},
    Increment = 1,
    CurrentValue = getgenv().AutoGKConfig.diveSpeed,
    Callback = function(Value) getgenv().AutoGKConfig.diveSpeed = Value end,
})
GKTab:CreateToggle({
    Name = "Auto Ground Save",
    CurrentValue = getgenv().AutoGroundSaveConfig.enabled,
    Callback = function(Value) getgenv().AutoGroundSaveConfig.enabled = Value end,
})

MovementTab:CreateSection("Movement Acceleration")
MovementTab:CreateToggle({
    Name = "WalkSpeed Velocity Multiplier",
    CurrentValue = getgenv().VelocityConfig.enabled,
    Callback = function(Value) getgenv().VelocityConfig.enabled = Value end,
})
MovementTab:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 3},
    Increment = 0.1,
    CurrentValue = getgenv().VelocityConfig.multiplier,
    Callback = function(Value) getgenv().VelocityConfig.multiplier = Value end,
})

MovementTab:CreateSection("Auto Scoring Tools")
MovementTab:CreateToggle({
    Name = "Auto Score Enabled",
    CurrentValue = getgenv().AutoScoreConfig.enabled,
    Callback = function(Value) getgenv().AutoScoreConfig.enabled = Value end,
})
MovementTab:CreateToggle({
    Name = "Auto Enemy Goal",
    CurrentValue = getgenv().AutoScoreConfig.autoEnemy,
    Callback = function(Value) getgenv().AutoScoreConfig.autoEnemy = Value end,
})
MovementTab:CreateButton({
    Name = "Teleport Ball To Me",
    Callback = function() getgenv().TeleportBallToPlayer() end,
})

PerfTab:CreateToggle({
    Name = "Disable Shadows",
    CurrentValue = getgenv().PerformanceConfig.disableShadows,
    Callback = function(Value)
        getgenv().PerformanceConfig.disableShadows = Value
        if Value then Lighting.GlobalShadows = false end
    end,
})
PerfTab:CreateToggle({
    Name = "Disable Particles",
    CurrentValue = getgenv().PerformanceConfig.disableParticles,
    Callback = function(Value) getgenv().PerformanceConfig.disableParticles = Value end,
})
PerfTab:CreateToggle({
    Name = "Lower Textures",
    CurrentValue = getgenv().PerformanceConfig.lowerTextures,
    Callback = function(Value) getgenv().PerformanceConfig.lowerTextures = Value end,
})

SettingsTab:CreateSection("UI Appearance & Themes")
SettingsTab:CreateDropdown({
    Name = "Theme Preset",
    Options = {"Classic", "White Angel", "Blood Devil", "Sea Blue", "Glossy Liquid Glass"},
    CurrentOption = {getgenv().UISettings.theme},
    Callback = function(Option)
        local chosen = Option[1] or Option
        applyTheme(chosen)
    end,
})
SettingsTab:CreateSlider({
    Name = "Liquid Slider (Glass Transparency)",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = getgenv().UISettings.liquidValue,
    Callback = function(Value)
        getgenv().UISettings.liquidValue = Value
        if getgenv().UISettings.theme == "Glossy Liquid Glass" then
            applyTheme("Glossy Liquid Glass")
        end
    end,
})

SettingsTab:CreateSection("UI Background Particles")
SettingsTab:CreateDropdown({
    Name = "Particle Style",
    Options = {"None", "Spiral", "Rain", "Orbit", "Blackhole", "Rise Up"},
    CurrentOption = {getgenv().UISettings.particleType},
    Callback = function(Option)
        local chosen = Option[1] or Option
        setParticlesType(chosen)
    end,
})

local currentSelectedConfigName = "default"
local configInputName = "default"

local configDropdown

local function refreshConfigDropdown()
    local savedList = listSavedConfigs()
    if configDropdown then
        pcall(function()
            configDropdown:Refresh(savedList, {currentSelectedConfigName})
        end)
    end
end

ConfigTab:CreateSection("User Config Profiles")
ConfigTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter config name...",
    RemoveTextOnFocusLost = false,
    Callback = function(Text)
        if Text and Text ~= "" then
            configInputName = Text
        end
    end,
})

configDropdown = ConfigTab:CreateDropdown({
    Name = "Select Saved Config",
    Options = listSavedConfigs(),
    CurrentOption = {currentSelectedConfigName},
    Callback = function(Option)
        currentSelectedConfigName = Option[1] or Option
    end,
})

ConfigTab:CreateButton({
    Name = "Save Current Config",
    Callback = function()
        local saveName = (configInputName and configInputName ~= "") and configInputName or "default"
        local dataToSave = {
            _v = CONFIG_VERSION,
            user = player.Name,
            userId = player.UserId,
            uiSettings = getgenv().UISettings,
            sneaky = getgenv().BallReach,
            sneakyV2 = getgenv().SneakyV2Config,
            lobShot = getgenv().LobShotConfig,
            reach = getgenv().ReachConfig,
            aimbot = getgenv().AimbotConfig,
            autoGK = getgenv().AutoGKConfig,
            autoGroundSave = getgenv().AutoGroundSaveConfig,
            velocity = getgenv().VelocityConfig,
            autoScore = getgenv().AutoScoreConfig,
            performance = getgenv().PerformanceConfig
        }
        saveConfigToDisk(saveName, dataToSave)
        currentSelectedConfigName = saveName
        refreshConfigDropdown()
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Successfully saved config: " .. saveName,
            Duration = 3
        })
    end,
})

ConfigTab:CreateButton({
    Name = "Load Selected Config",
    Callback = function()
        local loaded = loadConfigFromDisk(currentSelectedConfigName)
        if loaded then
            if loaded.uiSettings then
                if loaded.uiSettings.theme then applyTheme(loaded.uiSettings.theme) end
                if loaded.uiSettings.particleType then setParticlesType(loaded.uiSettings.particleType) end
                if loaded.uiSettings.liquidValue then getgenv().UISettings.liquidValue = loaded.uiSettings.liquidValue end
            end
            if loaded.sneaky then getgenv().BallReach = loaded.sneaky end
            if loaded.sneakyV2 then getgenv().SneakyV2Config = loaded.sneakyV2 end
            if loaded.lobShot then getgenv().LobShotConfig = loaded.lobShot end
            if loaded.reach then getgenv().ReachConfig = loaded.reach end
            if loaded.aimbot then getgenv().AimbotConfig = loaded.aimbot end
            if loaded.autoGK then getgenv().AutoGKConfig = loaded.autoGK end
            if loaded.autoGroundSave then getgenv().AutoGroundSaveConfig = loaded.autoGroundSave end
            if loaded.velocity then getgenv().VelocityConfig = loaded.velocity end
            if loaded.autoScore then getgenv().AutoScoreConfig = loaded.autoScore end
            if loaded.performance then getgenv().PerformanceConfig = loaded.performance end

            Rayfield:Notify({
                Title = "Config Loaded",
                Content = "Loaded settings from: " .. currentSelectedConfigName,
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Could not find config: " .. currentSelectedConfigName,
                Duration = 3
            })
        end
    end,
})

Rayfield:Notify({
    Title = "v3ctor",
    Content = "SoccerBall dumped from GameWorkspaceManager.",
    Duration = 5
})
