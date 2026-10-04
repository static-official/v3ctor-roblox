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

print("ok sure bud")

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

local CONFIG_VERSION = 2

local function round01(v) return math.floor(v * 10 + 0.5) / 10 end

local function safeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok and res or nil
end

local CONFIG_FOLDER = "TFB_Configs"
local CONFIG_FILE = CONFIG_FOLDER .. "/default.json"

local function ensureConfigFolder()
    if isfolder and writefile and not isfolder(CONFIG_FOLDER) then
        pcall(function() makefolder(CONFIG_FOLDER) end)
    end
end

local function saveConfigToDisk(data)
    ensureConfigFolder()
    if writefile and HttpService then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(data))
        end)
    end
end

local function loadConfigFromDisk()
    ensureConfigFolder()
    if isfile and readfile and HttpService then
        local ok = pcall(function() return isfile(CONFIG_FILE) end)
        if ok and isfile(CONFIG_FILE) then
            local readOk, content = pcall(function() return readfile(CONFIG_FILE) end)
            if readOk and content then
                local decodeOk, decoded = pcall(function() return HttpService:JSONDecode(content) end)
                if decodeOk and type(decoded) == "table" then
                    if decoded._v == CONFIG_VERSION then
                        return decoded
                    end
                end
            end
        end
    end
    return nil
end

local persisted = loadConfigFromDisk() or {}

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
local sneakyV2 = getgenv().SneakyV2Config

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
local HairConfig = getgenv().HairChanger

getgenv().ShirtChanger = getgenv().ShirtChanger or { currentNumber = nil, currentName = nil, currentClan = nil }
local ShirtConfig = getgenv().ShirtChanger

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

local perf = getgenv().PerformanceConfig

do
    if getgenv()._AimbotCleanup then pcall(getgenv()._AimbotCleanup) end
    local _abPlayers = Players
    local _abRS = RunService
    local _abUIS = UserInputService
    local _abCoreGui = CoreGui
    local _abReplicatedStorage = ReplicatedStorage
    local _abWorkspace = Workspace
    local _abLocalPlayer = player
    local _abCamera = _abWorkspace.CurrentCamera

    getgenv().AimbotConfig = getgenv().AimbotConfig or {
        enabled = persisted.aimbot and persisted.aimbot.enabled or false,
        autoDetect = true,
        antiPost = false,
        topCornerEnabled = true,
        selectedGoal = "Opposition",
        lastDetected = "B",
        powerShot = persisted.aimbot and persisted.aimbot.powerShot or false,
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
        local targetY = cfg.topCornerEnabled and TOP_CORNER_Y or 2.0
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
        if cfg.selectedGoal == "Own Goals" then
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

        local farIsRight = math.abs(ballPos.Z - POST_RIGHT_Z) >= math.abs(ballPos.Z - POST_LEFT_Z)
        local straightTargetZ = farIsRight and (POST_RIGHT_Z - 3.5) or (POST_LEFT_Z + 3.5)

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

    task.spawn(function()
        local hooked = false
        local attempts = 0
        while not hooked and attempts < 30 do
            attempts = attempts + 1
            for _, v in pairs(getgc(true)) do
                if typeof(v) == "function" and islclosure(v) then
                    local ok, info = pcall(debug.getinfo, v)
                    if ok and info.name == "ballHitsGoalFrame" then
                        hooked = true
                        local old
                        old = hookfunction(v, newcclosure(function(...)
                            if cfg.antiPost then
                                local pos = select(1, ...)
                                local vel = select(2, ...)
                                return false, pos, { X = vel.X, Y = vel.Y, Z = vel.Z }, ""
                            end
                            return old(...)
                        end))
                        break
                    end
                end
            end
            task.wait(1)
        end
    end)

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

    getgenv()._AimbotCleanup = function()
        cfg.enabled = false
    end
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
    cfg.reach = tonumber(cfg.reach) or 4.0
    if cfg.reach == math.huge or cfg.reach <= 0 then cfg.reach = 4.0 end
    cfg.reach = math.clamp(cfg.reach, 1, 60)
    cfg.spoofTarget = math.clamp(cfg.spoofTarget or 3.9, 1, 3.97)

    local newcclosure_fn = newcclosure or function(f) return f end
    local checkcaller_fn = checkcaller
    local getrawmetatable_fn = getrawmetatable
    local setreadonly_fn = setreadonly
    local getgc_fn = getgc
    local islclosure_fn = islclosure
    local getnamecallmethod_fn = getnamecallmethod
    local getconnections_fn = getconnections
    local hookfunction_fn = hookfunction

    if getgenv()._UR_Connections then
        for _, cc in pairs(getgenv()._UR_Connections) do
            pcall(function() cc:Disconnect() end)
        end
    end
    getgenv()._UR_Connections = {}
    local conns = getgenv()._UR_Connections
    getgenv()._UR_LoopID = (getgenv()._UR_LoopID or 0) + 1
    local currentLoopID = getgenv()._UR_LoopID

    local GOAL_A_X, GOAL_B_X = -313.13, -115.936
    local Z_MIN, Z_MAX = 78.036, 107.715
    local GOAL_CENTER_Z = (Z_MIN + Z_MAX) / 2
    local GRAVITY = 55
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
    local GK_Settings = { AntiPhase = false }
    local smoothVelocity = Vector3.zero
    local getcallingscript = getcallingscript or function() return nil end

    pcall(function()
        local oldTick
        oldTick = hookfunction(tick, function(...)
            if GK_Settings.AntiPhase then
                local caller = getcallingscript()
                if caller and caller.Name == "BallHandler" then return oldTick(...) * 0.6 end
                local ok, src = pcall(debug.info, 2, "s")
                if ok and src and string.find(src, "BallHandler") then return oldTick(...) * 0.6 end
            end
            return oldTick(...)
        end)
    end)

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
                local rotImpact = (Vector3.new(0, 1, 0)):Cross(Vector3.new(curVx, 0, curVz).Unit).Unit * (math.sqrt(curVx^2 + curVz^2) * 0.8 / 1.5)
                curveFactor = (rotImpact.Y + (curveFactor * -45 * 0.8)) / -45
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
        if not hrp or not hum then
            if hrp and hrp:FindFirstChild("GK_V") then
                hrp.GK_V.Enabled = false
                hrp.GK_R.Enabled = false
                hum.AutoRotate = true
            end
            return
        end
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
        local targetZ, predY = GOAL_CENTER_Z, GROUND_Y
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

    local state = {
        FAKE_DIST = 3.2, cachedBall = nil, ballAlive = false, partMode = {}, limbPriority = {},
        kickBallRemote = nil, blockedRemotes = {}, cacheDirty = true, lastCharModel = nil,
    }
    local BANISH_VEC = Vector3.new(0, 9e8, 0)
    local HITBOXES = {
        ["UpperTorso"] = 0.4, ["RightFoot"] = 0.3, ["LeftFoot"] = 0.3,
        ["RightLowerLeg"] = 0.2, ["LeftLowerLeg"] = 0.2, ["RightUpperLeg"] = 0.2,
        ["LeftUpperLeg"] = 0.2, ["HumanoidRootPart"] = 0.1, ["Torso"] = 0.4,
        ["Right Leg"] = 0.3, ["Left Leg"] = 0.3,
    }
    local BALL_NAMES = { "SoccerBall", "Ball", "Football" }
    local SAFE_REMOTE_NAMES = {
        ["KickBall"] = true, ["DropBallEvent"] = true, ["RemoveBallEvent"] = true,
        ["BallPositionEvent"] = true, ["KickBallEvent"] = true, ["MeasureLag"] = true,
        ["MeasureLagEvent"] = true, ["GoalEvent"] = true, ["NearGoalEvent"] = true,
    }

    local function findBall()
        local field = workspace:FindFirstChild("FootballField")
        if field then
            for _, name in ipairs(BALL_NAMES) do
                local b = field:FindFirstChild(name)
                if b then
                    if b:IsA("BasePart") then return b end
                    if b:IsA("Model") then return b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart") end
                end
            end
        end
        for _, name in ipairs(BALL_NAMES) do
            local b = workspace:FindFirstChild(name)
            if b then
                if b:IsA("BasePart") then return b end
                if b:IsA("Model") then return b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart") end
            end
        end
        return nil
    end

    local function validateBall()
        if not state.cachedBall then return false end
        local ok, result = pcall(function() return state.cachedBall:IsDescendantOf(game) end)
        return ok and result == true
    end

    local function refreshCache()
        if validateBall() then
            state.ballAlive = true
        else
            state.cachedBall = findBall()
            state.ballAlive = (state.cachedBall ~= nil)
        end
        if not state.kickBallRemote then
            local r = ReplicatedStorage:FindFirstChild("KickBall")
            if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
                state.kickBallRemote = r
            end
        end
        local char = player.Character
        if char ~= state.lastCharModel then
            state.lastCharModel = char
            for k in pairs(state.partMode) do state.partMode[k] = nil end
            for k in pairs(state.limbPriority) do state.limbPriority[k] = nil end
            if char then
                for name, prio in pairs(HITBOXES) do
                    local part = char:FindFirstChild(name)
                    if part and part:IsA("BasePart") then
                        state.partMode[part] = 1
                        state.limbPriority[part] = prio
                    end
                end
            end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp:IsA("BasePart") then
                        state.partMode[hrp] = 2
                    end
                end
            end
        end
        state.cacheDirty = false
    end

    local hbTimer = 0
    table.insert(conns, RunService.Heartbeat:Connect(function(dt)
        if state.ballAlive then
            if not validateBall() then
                state.ballAlive = false
                state.cacheDirty = true
            end
        end
        hbTimer = hbTimer + dt
        if state.cacheDirty and hbTimer >= 0.3 then
            hbTimer = 0
            pcall(refreshCache)
        elseif hbTimer >= 3 then
            hbTimer = 0
            state.cacheDirty = true
        end
    end))

    local function onBallChildAdded(child)
        for _, name in ipairs(BALL_NAMES) do
            if child.Name == name then
                if child:IsA("BasePart") then
                    state.cachedBall = child
                    state.ballAlive = true
                    return
                elseif child:IsA("Model") then
                    state.cachedBall = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                    state.ballAlive = (state.cachedBall ~= nil)
                    return
                end
            end
        end
    end

    task.spawn(function()
        local field = workspace:FindFirstChild("FootballField")
        if not field then field = workspace:WaitForChild("FootballField", 30) end
        if field then
            table.insert(conns, field.ChildAdded:Connect(function(child) onBallChildAdded(child) end))
            for _, name in ipairs(BALL_NAMES) do
                local b = field:FindFirstChild(name)
                if b then
                    if b:IsA("BasePart") then
                        state.cachedBall = b
                        state.ballAlive = true
                    elseif b:IsA("Model") then
                        state.cachedBall = b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart")
                        state.ballAlive = (state.cachedBall ~= nil)
                    end
                    break
                end
            end
        end
    end)

    table.insert(conns, workspace.ChildAdded:Connect(function(child)
        for _, name in ipairs(BALL_NAMES) do
            if child.Name == name then
                onBallChildAdded(child)
                return
            end
        end
        if child.Name == "FootballField" then
            state.cacheDirty = true
            task.spawn(function()
                table.insert(conns, child.ChildAdded:Connect(function(cc) onBallChildAdded(cc) end))
            end)
        end
    end))

    table.insert(conns, Players.PlayerAdded:Connect(function() state.cacheDirty = true end))
    table.insert(conns, Players.PlayerRemoving:Connect(function() state.cacheDirty = true end))

    task.spawn(function()
        while task.wait(2) do
            if getgenv()._UR_LoopID ~= currentLoopID then break end
            local ping = 0
            pcall(function() ping = player:GetNetworkPing() end)
            local base = math.clamp(3.50 - (ping * 1.5), 2.80, 3.50)
            state.FAKE_DIST = base
        end
    end)

    local cancelBlockCount = 0
    local DENIED_SUBSTRINGS = { "denied", "cancel", "blocked", "reject", "refuse", "failed" }
    local DENIED_EVENT_NAMES = {
        "KickBallDeniedEvent", "KickBallDenied", "KickDenied", "TouchDenied", "KickCancel", "CancelKick", "KickBlocked", "BallDenied", "KickFailed", "OnKickDenied", "KickCancelled", "KickRefused", "DenyKick", "RejectKick", "KickRejected", "BallTouchDenied", "TouchCancelled", "TouchBlocked", "OnDenyKick", "ServerDenyKick", "CancelTouch",
    }

    local function nameIsDenied(name)
        local lower = name:lower()
        for _, s in ipairs(DENIED_SUBSTRINGS) do
            if lower:find(s, 1, true) then return true end
        end
        for _, exact in ipairs(DENIED_EVENT_NAMES) do
            if name == exact then return true end
        end
        return false
    end

    local function blockDeniedEvent(ev)
        if not ev or not ev:IsA("RemoteEvent") then return end
        if state.blockedRemotes[ev] then return end
        state.blockedRemotes[ev] = true
        if getconnections_fn then
            pcall(function()
                for _, cc in pairs(getconnections_fn(ev.OnClientEvent)) do
                    pcall(function() cc:Disable() end)
                end
            end)
        end
    end

    local function blockAllDeniedEvents()
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if not SAFE_REMOTE_NAMES[child.Name] and child:IsA("RemoteEvent") and nameIsDenied(child.Name) then
                blockDeniedEvent(child)
            end
        end
    end

    task.delay(1, function() if getgenv()._UR_LoopID == currentLoopID then pcall(blockAllDeniedEvents) end end)
    task.delay(5, function() if getgenv()._UR_LoopID == currentLoopID then pcall(blockAllDeniedEvents) end end)

    table.insert(conns, ReplicatedStorage.ChildAdded:Connect(function(child)
        if not cfg.blockDeny then return end
        if not SAFE_REMOTE_NAMES[child.Name] and child:IsA("RemoteEvent") and nameIsDenied(child.Name) then
            task.defer(function() pcall(blockDeniedEvent, child) end)
        end
    end))

    if not getgenv()._V22MetaHooked then
        local hookOK = false
        pcall(function()
            if not getrawmetatable_fn or not setreadonly_fn then return end
            local mt = getrawmetatable_fn(game)
            local oldIndex = mt.__index
            local oldNamecall = mt.__namecall
            setreadonly_fn(mt, false)
            mt.__index = newcclosure_fn(function(self, key)
                if key ~= "Position" then return oldIndex(self, key) end
                if not cfg.enabled then return oldIndex(self, key) end
                if checkcaller_fn and checkcaller_fn() then return oldIndex(self, key) end
                if not state.ballAlive then return oldIndex(self, key) end
                local mode = state.partMode[self]
                if not mode then return oldIndex(self, key) end
                if mode == 2 then return BANISH_VEC end
                local ok, result = pcall(function()
                    local realPos = oldIndex(self, "Position")
                    local ball = state.cachedBall
                    if not ball then return realPos end
                    local ballPos = oldIndex(ball, "Position")
                    if not ballPos then return realPos end
                    local dX = ballPos.X - realPos.X
                    local dY = ballPos.Y - realPos.Y
                    local dZ = ballPos.Z - realPos.Z
                    local distSq = dX * dX + dY * dY + dZ * dZ
                    local fakeDist = state.FAKE_DIST
                    if distSq <= fakeDist * fakeDist then return realPos end
                    local reachDist = cfg.reach
                    if distSq > reachDist * reachDist then return realPos end
                    local dist = math.sqrt(distSq)
                    if dist < 0.01 then return realPos end
                    local priorityOffset = state.limbPriority[self] or 0
                    local targetSpoofDist = math.max(0.5, fakeDist - priorityOffset)
                    local invDist = 1 / dist
                    return Vector3.new(
                        ballPos.X - dX * invDist * targetSpoofDist,
                        ballPos.Y - dY * invDist * targetSpoofDist,
                        ballPos.Z - dZ * invDist * targetSpoofDist
                    )
                end)
                return ok and result or oldIndex(self, key)
            end)
            mt.__namecall = newcclosure_fn(function(self, ...)
                if not getnamecallmethod_fn then return oldNamecall(self, ...) end
                local method = getnamecallmethod_fn()
                if cfg.enabled and state.kickBallRemote and self == state.kickBallRemote and method == "FireServer" then
                    local args = { ... }
                    if type(args[4]) == "number" then args[4] = state.FAKE_DIST end
                    return oldNamecall(self, table.unpack(args))
                end
                if cfg.blockDeny and (method == "FireServer" or method == "InvokeServer") then
                    local t = typeof(self)
                    if t == "Instance" then
                        local isSafe = false
                        local isDenied = false
                        pcall(function()
                            isSafe = SAFE_REMOTE_NAMES[self.Name] or false
                            if not isSafe then isDenied = nameIsDenied(self.Name) end
                        end)
                        if not isSafe and isDenied then
                            cancelBlockCount = cancelBlockCount + 1
                            return
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
            setreadonly_fn(mt, true)
            hookOK = true
        end)
        if hookOK then getgenv()._V22MetaHooked = true end
    end

    local hookedFuncs = {}
    local GC_HOOK_NAMES = {
        ["getClosestPlayerName"] = "closest",
        ["onBallPositionEvent"] = "ballpos",
        ["onKickDenied"] = "cancel",
        ["showCancelled"] = "cancel",
        ["cancelKick"] = "cancel",
        ["onKickCancelled"] = "cancel",
        ["kickDenied"] = "cancel",
        ["kickCancelled"] = "cancel",
        ["kickBlocked"] = "cancel",
        ["handleDenied"] = "cancel",
        ["handleCancel"] = "cancel",
    }

    local function tryHookFunctions()
        if not getgc_fn or not islclosure_fn or not hookfunction_fn then return end
        local ok, list = pcall(getgc_fn, true)
        if not ok then return end
        for _, v in pairs(list) do
            if type(v) == "function" and islclosure_fn(v) and not hookedFuncs[v] then
                local funcName = nil
                pcall(function()
                    local info = debug.getinfo(v)
                    if info then pcall(function() funcName = info.name end) end
                end)
                if funcName then
                    local hookType = GC_HOOK_NAMES[funcName]
                    if hookType == "closest" then
                        local orig
                        local hOK, hOrig = pcall(hookfunction_fn, v, newcclosure_fn(function(...)
                            if cfg.enabled and cfg.blockDeny then return player.Name end
                            return orig(...)
                        end))
                        if hOK and hOrig then orig = hOrig; hookedFuncs[v] = true end
                    elseif hookType == "ballpos" then
                        local orig
                        local hOK, hOrig = pcall(hookfunction_fn, v, newcclosure_fn(function(lag, names, positions, ...)
                            if cfg.enabled and cfg.blockDeny and type(names) == "table" and type(positions) == "table" then
                                for i, name in pairs(names) do
                                    if name ~= player.Name then positions[i] = BANISH_VEC end
                                end
                            end
                            return orig(lag, names, positions, ...)
                        end))
                        if hOK and hOrig then orig = hOrig; hookedFuncs[v] = true end
                    elseif hookType == "cancel" then
                        local orig
                        local hOK, hOrig = pcall(hookfunction_fn, v, newcclosure_fn(function(...)
                            if cfg.enabled and cfg.blockDeny then
                                cancelBlockCount = cancelBlockCount + 1
                                return
                            end
                            return orig(...)
                        end))
                        if hOK and hOrig then orig = hOrig; hookedFuncs[v] = true end
                    end
                end
            end
        end
    end

    task.spawn(function()
        tryHookFunctions()
        task.wait(2)
        tryHookFunctions()
    end)

    getgenv()._AutoGKV2Cleanup = function()
        getgenv().AutoGKV2Config.enabled = false
        getgenv().AutoGroundSaveConfig.enabled = false
        getgenv().AutoGKConfig.enabled = false
        cfg.enabled = false
        local charNode = player.Character
        if charNode then
            local hrp = charNode:FindFirstChild("HumanoidRootPart")
            if hrp then
                local v = hrp:FindFirstChild("GK_V")
                local r = hrp:FindFirstChild("GK_R")
                local a = hrp:FindFirstChild("GK_A")
                if v then v:Destroy() end
                if r then r:Destroy() end
                if a then a:Destroy() end
            end
            local hum = charNode:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end
    end
end

do
    local cfg = getgenv().AutoSave
    local ballPos = Vector3.new(-311, 6, 92)
    local kickDir = Vector3.new(50, 5, 0)
    task.spawn(function()
        while true do
            if cfg.enabled then
                local KickBall = ReplicatedStorage:FindFirstChild("KickBall")
                if KickBall then
                    local field = workspace:FindFirstChild("FootballField")
                    local ball = field and field:FindFirstChild("SoccerBall")
                    if ball then
                        ball.CFrame = CFrame.new(ballPos)
                        pcall(function()
                            KickBall:FireServer(ballPos, kickDir, Vector3.new(0,0,0), 3, "djhtelkds")
                        end)
                    end
                end
            end
            task.wait()
        end
    end)
end

do
    local cfg = getgenv().VelocityConfig
    local humanoid, root
    local baseWalkSpeed = 16
    local _weAreWriting = false
    local function setupCharacter(char)
        humanoid = char:WaitForChild("Humanoid")
        root = char:WaitForChild("HumanoidRootPart")
        baseWalkSpeed = humanoid.WalkSpeed
    end
    if player.Character then setupCharacter(player.Character) end
    player.CharacterAdded:Connect(setupCharacter)
    if not getgenv()._AccelBypassHooked2 then
        getgenv()._AccelBypassHooked2 = true
        local oldNewIndex
        oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
            if key == "WalkSpeed" and self == humanoid then
                if _weAreWriting then return oldNewIndex(self, key, value) end
                baseWalkSpeed = value
                if cfg.enabled then return oldNewIndex(self, key, value * cfg.multiplier) end
                return oldNewIndex(self, key, value)
            end
            return oldNewIndex(self, key, value)
        end))
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
            if key == "WalkSpeed" and self == humanoid then
                if _weAreWriting then return oldIndex(self, key) end
                if cfg.enabled then return baseWalkSpeed end
            end
            return oldIndex(self, key)
        end))
    end
    pcall(function() RunService:UnbindFromRenderStep("AccelerationBypass") end)
    RunService:BindToRenderStep("AccelerationBypass", Enum.RenderPriority.Camera.Value + 1, function()
        if not cfg.enabled or not humanoid then return end
        _weAreWriting = true
        local target = baseWalkSpeed * cfg.multiplier
        if math.abs(humanoid.WalkSpeed - target) > 0.01 then
            humanoid.WalkSpeed = target
        end
        _weAreWriting = false
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

do
    local cfg = getgenv().BallTimeConfig
    local timeOffset = 0
    local realTick = tick
    getgenv()._BallTimeOffset = 0
    getgenv()._BallTimeSuppress = false
    local lastReal = realTick()
    local wasEnabled = false
    RunService.RenderStepped:Connect(function()
        local now = realTick()
        local dt = now - lastReal
        lastReal = now
        if cfg.enabled then
            if not getgenv()._BallTimeSuppress then
                timeOffset = timeOffset + dt * (cfg.multiplier - 1)
            end
            wasEnabled = true
        elseif wasEnabled then
            wasEnabled = false
        end
        getgenv()._BallTimeOffset = timeOffset
    end)
    if not getgenv()._BallTimeHooked then
        getgenv()._BallTimeHooked = true
        local oldTick
        oldTick = hookfunction(tick, newcclosure(function(...)
            if getgenv()._BallTimeSuppress then return oldTick(...) end
            if timeOffset == 0 then return oldTick(...) end
            local env = getfenv(2)
            if env and env.script and env.script.Name == "BallHandler" then return oldTick(...) + timeOffset end
            env = getfenv(3)
            if env and env.script and env.script.Name == "BallHandler" then return oldTick(...) + timeOffset end
            return oldTick(...)
        end))
    end
end

do
    if perf.disableShadows then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.Brightness = 2
            for _, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("PostEffect") then v.Enabled = false end
            end
        end)
    end
    if perf.disableParticles then
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end
        end)
    end
    if perf.lowerTextures then
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                elseif v:IsA("BasePart") and v.Material ~= Enum.Material.SmoothPlastic then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
    end
    if perf.reduceSound then
        pcall(function()
            for _, v in pairs(game:GetService("SoundService"):GetDescendants()) do
                if v:IsA("Sound") then v.Volume = 0 end
            end
        end)
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if perf.disableParticles then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                        v.Enabled = false
                    end
                end
            end)
        end
        if perf.reduceLatency then
            pcall(function()
                local char = player.Character
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then v.CastShadow = false end
                    end
                end
            end)
        end
        if perf.clearTerrain then
            pcall(function()
                workspace.Terrain.WaterWaveSize = 0
                workspace.Terrain.WaterWaveSpeed = 0
                workspace.Terrain.WaterReflectance = 0
                workspace.Terrain.WaterTransparency = 1
            end)
        end
    end
end)

task.spawn(function()
    if setfpscap and perf.maxFps then
        pcall(function() setfpscap(perf.maxFps) end)
    end
end)

local function isAirborne()
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.FloorMaterial == Enum.Material.Air then return true end
    local s = hum:GetState()
    return s == Enum.HumanoidStateType.Freefall or s == Enum.HumanoidStateType.Jumping
end

local cachedFieldForJuggle, cachedBallForJuggle, lastCacheCheckJuggle = nil, nil, 0
local function getBallDirect()
    local now = os.clock()
    if now - lastCacheCheckJuggle > 0.3 then
        lastCacheCheckJuggle = now
        cachedFieldForJuggle = workspace:FindFirstChild("FootballField")
        cachedBallForJuggle = cachedFieldForJuggle and cachedFieldForJuggle:FindFirstChild("SoccerBall")
        if not cachedBallForJuggle then
            cachedBallForJuggle = workspace:FindFirstChild("SoccerBall")
        end
    end
    return cachedBallForJuggle
end

local function LobShotComputeSpoof(realPos)
    LOB_STATE.active = false
    if not lobCfg.enabled then return realPos end
    local char = player.Character
    if not char then return realPos end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return realPos end
    local field = workspace:FindFirstChild("FootballField")
    local ball = field and field:FindFirstChild("SoccerBall")
    if not ball or not ball:IsA("BasePart") then return realPos end
    local ballPos = ball.Position
    if ballPos.Y < BALL_FLOOR - 1 then return realPos end
    local dist = (ballPos - realPos).Magnitude
    if dist <= 0 or dist > lobCfg.reach then return realPos end
    local flat = Vector3.new(ballPos.X - realPos.X, 0, ballPos.Z - realPos.Z)
    local look = hrp.CFrame.LookVector
    local flatLook = Vector3.new(look.X, 0, look.Z)
    local contactDir
    if flat.Magnitude > 0.05 then contactDir = flat.Unit
    elseif flatLook.Magnitude > 0.05 then contactDir = flatLook.Unit
    else contactDir = Vector3.new(0, 0, 1) end
    if flatLook.Magnitude > 0.05 then
        flatLook = flatLook.Unit
        if (contactDir.X * flatLook.X + contactDir.Z * flatLook.Z) < -0.1 then return realPos end
    end
    local dir = contactDir
    if flatLook.Magnitude > 0.05 then
        local bias = math.clamp(lobCfg.aimBias or 0.70, 0, 1)
        local mixed = Vector3.new((1 - bias) * contactDir.X + bias * flatLook.X, 0, (1 - bias) * contactDir.Z + bias * flatLook.Z)
        if mixed.Magnitude > 0.01 then dir = mixed.Unit end
    end
    local targetVy = math.clamp(lobVyForLevel(lobCfg.heightLevel), 0, 40)
    local U = flatLook
    if U.Magnitude < 0.5 then U = dir end
    local cosTheta = math.clamp(dir.X * U.X + dir.Z * U.Z, -1, 1)
    local merges = cosTheta >= 0.93969
    local bv = ball.Velocity
    local horiz = math.sqrt(bv.X * bv.X + bv.Z * bv.Z)
    local needed = targetVy * (merges and 1.49 or 1.05)
    local baseWanted = math.clamp(needed - horiz, 40, 80)
    getgenv().LobShotKickWalkSpeed = 19 + (baseWanted - 40) / 10
    local power = math.min(baseWanted + horiz, 85)
    if power < 1 then power = 1 end
    local q = math.clamp(targetVy / power, 0, 0.999)
    local s
    if merges then
        local lo, hi = 0.0, 0.999
        for _ = 1, 30 do
            local mid = (lo + hi) * 0.5
            local c_val = math.sqrt(math.max(1 - mid * mid, 0))
            if (mid / math.sqrt(2 + 2 * cosTheta * c_val)) < q then lo = mid else hi = mid end
        end
        s = (lo + hi) * 0.5
    else
        s = q
    end
    local cosP = math.sqrt(math.max(1 - s * s, 0))
    local launchDir = Vector3.new(dir.X * cosP, s, dir.Z * cosP)
    local k = 1.8
    local spoofTorso = (ballPos - launchDir * k) - Vector3.new(0, 1.3, 0)
    if (ballPos - spoofTorso).Magnitude > 3.9 then
        spoofTorso = (ballPos - launchDir * 1.2) - Vector3.new(0, 1.3, 0)
    end
    LOB_STATE.active = true
    return spoofTorso
end

local function SneakyComputeSpoof(realPos)
    STATE.reachActive = false
    if not c.enabled then return realPos end
    if c.airOnly and not isAirborne() then return realPos end
    local char = player.Character
    if not char then return realPos end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return realPos end
    local field = workspace:FindFirstChild("FootballField")
    local ball = field and field:FindFirstChild("SoccerBall")
    if not ball or not ball:IsA("BasePart") then return realPos end
    local ballPos = ball.Position
    if ballPos.Y < BALL_FLOOR - 1 then return realPos end
    local dist = (ballPos - realPos).Magnitude
    if dist <= 0 or dist > c.reach then return realPos end
    local flat = Vector3.new(ballPos.X - realPos.X, 0, ballPos.Z - realPos.Z)
    local look = hrp.CFrame.LookVector
    local flatLook = Vector3.new(look.X, 0, look.Z)
    local contactDir
    if flat.Magnitude > 0.05 then contactDir = flat.Unit
    elseif flatLook.Magnitude > 0.05 then contactDir = flatLook.Unit
    else contactDir = Vector3.new(0, 0, 1) end
    if flatLook.Magnitude > 0.05 then
        flatLook = flatLook.Unit
        if (contactDir.X * flatLook.X + contactDir.Z * flatLook.Z) < -0.1 then return realPos end
    end
    local dir = contactDir
    if flatLook.Magnitude > 0.05 then
        local bias = math.clamp(c.aimBias or 0.7, 0, 1)
        local mixed = Vector3.new((1 - bias) * contactDir.X + bias * flatLook.X, 0, (1 - bias) * contactDir.Z + bias * flatLook.Z)
        if mixed.Magnitude > 0.01 then dir = mixed.Unit end
    end
    local targetVy = math.clamp(vyForLevel(c.heightLevel), 0, 40)
    local U = flatLook
    if U.Magnitude < 0.5 then U = dir end
    local cosTheta = math.clamp(dir.X * U.X + dir.Z * U.Z, -1, 1)
    local merges = cosTheta >= 0.93969
    local bv = ball.Velocity
    local horiz = math.sqrt(bv.X * bv.X + bv.Z * bv.Z)
    local needed = targetVy * (merges and 1.49 or 1.05)
    local baseWanted = math.clamp(needed - horiz, 40, 80)
    getgenv().SneakyKickWalkSpeed = 19 + (baseWanted - 40) / 10
    local power = math.min(baseWanted + horiz, 85)
    if power < 1 then power = 1 end
    local q = math.clamp(targetVy / power, 0, 0.999)
    local s
    if merges then
        local lo, hi = 0.0, 0.999
        for _ = 1, 30 do
            local mid = (lo + hi) * 0.5
            local c_val = math.sqrt(math.max(1 - mid * mid, 0))
            if (mid / math.sqrt(2 + 2 * cosTheta * c_val)) < q then lo = mid else hi = mid end
        end
        s = (lo + hi) * 0.5
    else
        s = q
    end
    local cosP = math.sqrt(math.max(1 - s * s, 0))
    local launchDir = Vector3.new(dir.X * cosP, s, dir.Z * cosP)
    local k = 1.8
    local spoofTorso = (ballPos - launchDir * k) - Vector3.new(0, 1.3, 0)
    if (ballPos - spoofTorso).Magnitude > 3.9 then
        spoofTorso = (ballPos - launchDir * 1.2) - Vector3.new(0, 1.3, 0)
    end
    STATE.reachActive = true
    return spoofTorso
end

do
    local oldIndex, hooked = nil, false
    local function shouldSpoofPulse(part)
        if not part or not part:IsA("BasePart") then return false end
        local name = part.Name
        if name == "Torso" or name == "UpperTorso" or name == "LowerTorso" or name == "HumanoidRootPart" or name == "Head" then return true end
        if name:find("Leg") or name:find("Foot") or name:find("Hand") or name:find("Arm") then return true end
        return false
    end
    local function reachPositionOverride(part, realPos)
        local rc = getgenv().ReachConfig
        if not rc.enabled then return nil end
        local ball = getBallDirect()
        if not ball or not ball.Parent then return nil end
        local ok, ballPos = pcall(function() return ball.Position end)
        if not ok or not ballPos then return nil end
        local dx = ballPos.X - realPos.X
        local dy = ballPos.Y - realPos.Y
        local dz = ballPos.Z - realPos.Z
        local magnitude = math.sqrt(dx*dx + dy*dy + dz*dz)
        if magnitude > rc.range or magnitude <= 0.01 then return nil end
        local standoff = 0.55
        local flatMag = math.sqrt(dx*dx + dz*dz)
        if flatMag <= standoff then return nil end
        local flatX, flatZ = dx/flatMag, dz/flatMag
        local excess = flatMag - standoff
        local pullFrac = 0.45 + (rc.cancelPower / 10) * 0.25
        local newFlat = flatMag - excess * pullFrac
        if newFlat < standoff then newFlat = standoff end
        if newFlat >= flatMag - 0.02 then return nil end
        local ballVel = ball.AssemblyLinearVelocity
        local awaySpeed = ballVel.X * flatX + ballVel.Z * flatZ
        if awaySpeed > 3 then newFlat = math.min(flatMag, newFlat + awaySpeed * 0.015) end
        local targetX = ballPos.X - flatX * newFlat
        local targetZ = ballPos.Z - flatZ * newFlat
        local targetY = realPos.Y
        if part.Name == "Head" then targetY = math.min(realPos.Y, ballPos.Y) end
        return Vector3.new(targetX, targetY, targetZ)
    end
    local function rainbowFlickOverride(part, realPos)
        local rf = getgenv().RainbowFlickConfig
        if not rf.enabled then return nil end
        local ball = getBallDirect()
        if not ball then return nil end
        local ok, ballPos = pcall(function() return ball.Position end)
        if not ok or not ballPos then return nil end
        local dx = ballPos.X - realPos.X
        local dy = ballPos.Y - realPos.Y
        local dz = ballPos.Z - realPos.Z
        local magnitude = math.sqrt(dx*dx + dy*dy + dz*dz)
        local maxReachThreshold = rf.reachScale * 1.25
        if magnitude > maxReachThreshold or magnitude <= 0.1 then return nil end
        return Vector3.new(ballPos.X, ballPos.Y - 3, ballPos.Z)
    end
    local function groundShotsOverride(part, realPos)
        if not getgenv().JuvsReachConfig.Enabled then return nil end
        local ball = getBallDirect()
        if not ball then return nil end
        local ballPos = ball.Position
        local dx = ballPos.X - realPos.X
        local dy = ballPos.Y - realPos.Y
        local dz = ballPos.Z - realPos.Z
        local magnitude = math.sqrt(dx*dx + dy*dy + dz*dz)
        if magnitude > getgenv().JuvsReachConfig.Range or magnitude <= 0.6 then return nil end
        local flatMag = math.sqrt(dx*dx + dz*dz)
        if flatMag <= 0.6 then return nil end
        local flatX, flatZ = dx/flatMag, dz/flatMag
        local standoff = 0.55
        local newFlat = flatMag
        if flatMag > standoff then newFlat = flatMag - (flatMag - standoff) * 0.45 end
        local targetX = ballPos.X - flatX * newFlat
        local targetZ = ballPos.Z - flatZ * newFlat
        return Vector3.new(targetX, realPos.Y, targetZ)
    end
    local function sneakyV2Override(part, realPos)
        if not sneakyV2.enabled then return nil end
        local charNode = player.Character
        if not charNode then return nil end
        local ball = getBallDirect()
        if not ball then return nil end
        local ballPos = ball.Position
        local dx = ballPos.X - realPos.X
        local dy = ballPos.Y - realPos.Y
        local dz = ballPos.Z - realPos.Z
        local magnitude = math.sqrt(dx*dx + dy*dy + dz*dz)
        if magnitude > sneakyV2.reach then return nil end
        local rootPart = charNode:FindFirstChild("HumanoidRootPart")
        local hum = charNode:FindFirstChildOfClass("Humanoid")
        if not (rootPart and hum) then return nil end
        local rawMove = hum.MoveDirection
        local moveDirection = Vector3.new(rawMove.X, 0, rawMove.Z)
        local moveLen = moveDirection.Magnitude
        local isMoving = moveLen > 0.05
        local lookVector = rootPart.CFrame.LookVector
        local lookDirX, lookDirZ = lookVector.X, lookVector.Z
        local lookLen = math.sqrt(lookDirX*lookDirX + lookDirZ*lookDirZ)
        if lookLen > 0 then lookDirX, lookDirZ = lookDirX / lookLen, lookDirZ / lookLen
        else lookDirX, lookDirZ = 0, 1 end
        local alignment = isMoving and ((moveDirection.X / moveLen) * lookDirX + (moveDirection.Z / moveLen) * lookDirZ) or 0
        local speedFactor = isMoving and math.clamp(moveLen, 1.2, 2.5) or 1
        local dynamicModifier = 1.1 + (alignment * 0.45) * speedFactor
        local bx = lookDirX * (0.45 * dynamicModifier)
        local bz = lookDirZ * (0.45 * dynamicModifier)
        return Vector3.new(ballPos.X - bx, realPos.Y, ballPos.Z - bz)
    end
    local function juggleOverride(part, realPos)
        if not getgenv().AutoJuggleV1.enabled then return nil end
        local charNode = player.Character
        if not charNode then return nil end
        local ball = getBallDirect()
        if not ball then return nil end
        local ballPos = ball.Position
        local dx = ballPos.X - realPos.X
        local dy = ballPos.Y - realPos.Y
        local dz = ballPos.Z - realPos.Z
        local mag = math.sqrt(dx*dx + dy*dy + dz*dz)
        if mag > getgenv().AutoJuggleV1.reach or mag <= 0.01 then return nil end
        local rootPart = charNode:FindFirstChild("HumanoidRootPart")
        local hum = charNode:FindFirstChildOfClass("Humanoid")
        if not (rootPart and hum) then return nil end
        local rawMove = hum.MoveDirection
        local moveDirection = Vector3.new(rawMove.X, 0, rawMove.Z)
        local moveLen = moveDirection.Magnitude
        local isMoving = moveLen > 0.05
        local lookVector = rootPart.CFrame.LookVector
        local lookDirX, lookDirZ = lookVector.X, lookVector.Z
        local lookLen = math.sqrt(lookDirX*lookDirX + lookDirZ*lookDirZ)
        if lookLen > 0 then lookDirX, lookDirZ = lookDirX / lookLen, lookDirZ / lookLen
        else lookDirX, lookDirZ = 0, 1 end
        local alignment = isMoving and ((moveDirection.X / moveLen) * lookDirX + (moveDirection.Z / moveLen) * lookDirZ) or 0
        local speedFactor = isMoving and math.clamp(moveLen, 1.2, 2.5) or 1
        local dynamicModifier = 1.1 + (alignment * 0.45) * speedFactor
        return Vector3.new(
            ballPos.X - (dx/math.max(mag,0.01))*(0.18*dynamicModifier),
            realPos.Y,
            ballPos.Z - (dz/math.max(mag,0.01))*(0.18*dynamicModifier)
        )
    end
    local function installHook()
        if hooked then return end
        local success = pcall(function()
            oldIndex = hookmetamethod(game, "__index", function(self, key)
                if key ~= "Position" and key ~= "WalkSpeed" then return oldIndex(self, key) end
                if key == "WalkSpeed" then
                    if LOB_STATE.active then
                        local ok, isHum = pcall(function() return player.Character and self == player.Character:FindFirstChildOfClass("Humanoid") end)
                        if ok and isHum then return getgenv().LobShotKickWalkSpeed or 23 end
                    end
                    if STATE.reachActive then
                        local ok, isHum = pcall(function() return player.Character and self == player.Character:FindFirstChildOfClass("Humanoid") end)
                        if ok and isHum then return getgenv().SneakyKickWalkSpeed or 23 end
                    end
                end
                if key == "Position" then
                    if shouldSpoofPulse(self) then
                        local realPos = oldIndex(self, "Position")
                        local res
                        res = LobShotComputeSpoof(realPos)
                        if res ~= realPos then return res end
                        res = SneakyComputeSpoof(realPos)
                        if res ~= realPos then return res end
                        res = sneakyV2Override(self, realPos)
                        if res then return res end
                        res = reachPositionOverride(self, realPos)
                        if res then return res end
                        res = rainbowFlickOverride(self, realPos)
                        if res then return res end
                        res = groundShotsOverride(self, realPos)
                        if res then return res end
                        res = juggleOverride(self, realPos)
                        if res then return res end
                    end
                end
                return oldIndex(self, key)
            end)
        end)
        if success then hooked = true end
    end
    installHook()
end
