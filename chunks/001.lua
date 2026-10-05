
local SAB_LIVE = function() return true end
local _SABCAP = {}
if not LPH_OBFUSCATED then
    local ok, env = pcall(getfenv)
    local _envs = {}
    if ok and type(env) == "table" then _envs[#_envs + 1] = env end
    if getgenv then local gok, g = pcall(getgenv); if gok and type(g) == "table" then _envs[#_envs + 1] = g end end
    if type(_G) == "table" then _envs[#_envs + 1] = _G end
    for _, e in ipairs(_envs) do
        if not e["LPH_ATTRIBUTES"] then e["LPH_ATTRIBUTES"] = function() end end
        if not e["VM"]     then e["VM"]     = function() end end
        if not e["PRESET"] then e["PRESET"] = function() end end
        if not e["ERROR_HANDLING"] then e["ERROR_HANDLING"] = function() end end
        if not e["LPH_ENCSTR"] then e["LPH_ENCSTR"] = function(s) return s end end
        if not e["LPH_ENCNUM"] then e["LPH_ENCNUM"] = function(n) return n end end
    end end
-- FAST OFF-LOAD TP (Meerko method): read the authoritative synchronizer/channel
-- AnimalList (instant + accurate) instead of waiting for workspace models to stream.
-- This is rose's own sync-scan path (SharedState.ScanAllPlots), just enabled by default.
if _G.JAF_NoSynchronizer   == nil then _G.JAF_NoSynchronizer   = false end
if _G.JAF_ScanViaInstances == nil then _G.JAF_ScanViaInstances = true  end
if _G.JAF_WaitBasesBeforeTp == nil then _G.JAF_WaitBasesBeforeTp = false end
_G.JAF_M2 = function(ax, az, bx, bz) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local dx, dz = ax - bx, az - bz
    return math.sqrt(dx * dx + dz * dz)
end
local _P; _P = function(o, ...) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
            for i = 1, select("#", ...), 2 do o[select(i, ...)] = select(i + 1, ...) end return o end
do
    local _clsMemo = {}
    local _isACN; _isACN = (function(cn, inst, cls) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if _G.JAF_ClassMemo == false then return inst:IsA(cls) end
        local m = _clsMemo[cls]
        if not m then m = {}; _clsMemo[cls] = m end
        local v = m[cn]
        if v == nil then v = inst:IsA(cls); m[cn] = v end
        return v
    end)
    _G.JAF_IsACN = _isACN
    _G.JAF_IsA = (function(inst, cls) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if _G.JAF_ClassMemo == false then return inst:IsA(cls) end
        return _isACN(inst.ClassName, inst, cls)
    end) end
_G.JAF_BootReady = false
if _G.JAF_BootYield == false then _G.JAF_BootReady = true end
if _G.JAF_BootYield ~= false then
    task.spawn(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local t0 = os.clock()
        local cap = tonumber(_G.JAF_BootYieldMax) or 20
        if not game:IsLoaded() then game.Loaded:Wait() end
        local RS = game:GetService("ReplicatedStorage")
        local pkgs = RS:WaitForChild("Packages", 10)
        local netF = pkgs and pkgs:WaitForChild("Net", 10)
        if netF then
            local last, stable = -1, 0
            while os.clock() - t0 < cap do
                local n = #netF:GetChildren()
                if n == last and n > 0 then
                    stable = stable + 1
                    if stable >= 2 then break end
                else
                    stable, last = 0, n
                end
                task.wait(0.2)
            end end
        _G.JAF_BootYieldTook = os.clock() - t0
    end)
    _G.JAF_BootReady = true
    end) end
if not game:IsLoaded() then game.Loaded:Wait() end
do
    local _efOn = true
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if type(isfile) == "function" and type(readfile) == "function" and isfile("rosehub.json") then
            local d = game:GetService("HttpService"):JSONDecode(readfile("rosehub.json"))
            if type(d) == "table" and d.FpsOptimizer == false then _efOn = false end
        end end)
    if _efOn then
        local _efPlayers = game:GetService("Players")
        local _efCls = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory",
            "FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory",
            "BackAccessory","WaistAccessory"}
        local function _efStrip(obj, isOther) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
            if _G.JAF_FpsOptimizer == false then return end
            pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                if obj.Name == "Overhead" then return end
                for _, c in ipairs(_efCls) do if obj:IsA(c) then obj:Destroy(); return end end
                if isOther and obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                    local s = obj.Size
                    if s.X > 10 or s.Y > 10 or s.Z > 10 then
                        _P(obj, "Transparency", 1, "Transparency", 1, "CanCollide", false, "CanQuery", false, "CanTouch", false, "CastShadow", false)
                    end end end) end
        local function _efChar(char) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
            if not char then return end
            local _lp = _efPlayers.LocalPlayer
            local isOther = (_lp ~= nil) and (_efPlayers:GetPlayerFromCharacter(char) ~= _lp)
            task.spawn(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                for _, d in ipairs(char:GetDescendants()) do _efStrip(d, isOther) end
            end)
            char.DescendantAdded:Connect(function(d) LPH_ATTRIBUTES(ERROR_HANDLING(false))
task.defer(_efStrip, d, isOther) end)
        end
        local function _efHook(plr) LPH_ATTRIBUTES(ERROR_HANDLING(false))
            if plr.Character then _efChar(plr.Character) end
            plr.CharacterAdded:Connect(_efChar)
        end
        for _, plr in ipairs(_efPlayers:GetPlayers()) do pcall(_efHook, plr) end
        _efPlayers.PlayerAdded:Connect(_efHook)
    end end
_G.SAB_T_GameLoaded = tick()
if not _G.JAF_WaitPackages then
    local _pkgCache
    _G.JAF_WaitPackages = function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if _pkgCache and _pkgCache.Parent then return _pkgCache end
        local RS = game:GetService("ReplicatedStorage")
        local p = RS:FindFirstChild("Packages")
        while not p do p = RS:WaitForChild("Packages", 5) end
        _pkgCache = p
        return p
    end end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _SyncReal = nil
-- use the getgc-based channel reader instead of require()-ing / calling the
-- Synchronizer module (same approach the working Extras/Teleport hubs use).
if _G.JAF_NoSynchronizer == nil then _G.JAF_NoSynchronizer = true end
local _SyncProxy
local function _syncMod() LPH_ATTRIBUTES(ERROR_HANDLING(false))
    if _G.JAF_NoSynchronizer == true then return nil end
    if _SyncReal ~= nil then return _SyncReal end
    local ok, m = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Synchronizer")) end)
    if ok and type(m) == "table" then _SyncReal = m end
    return _SyncReal
end
_G.JAF_SyncMod = _syncMod
_G.JAF_SyncModLoaded = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return _SyncReal ~= nil end
_SyncProxy = setmetatable({}, {
    __index = function(_, k) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        local m = _syncMod(); if not m then return nil end
        local v = m[k]
        if type(v) ~= "function" then return v end
        return function(a, ...) LPH_ATTRIBUTES(ERROR_HANDLING(false))
if rawequal(a, _SyncProxy) then return v(m, ...) end return v(a, ...) end
    end,
    __newindex = function(_, k, v) LPH_ATTRIBUTES(ERROR_HANDLING(false))
local m = _syncMod(); if m then pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
m[k] = v end) end end,
})
local Synchronizer = _SyncProxy
task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
local t0 = os.clock() _syncMod() _G.JAF_SyncModWarmMs = (os.clock() - t0) * 1000 end)
_G.JAF_Mod = (function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
    local cache = {}
    return function(folder, name) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local key = folder .. "." .. name
        local hit = cache[key]
        if hit ~= nil then return hit or nil end
        local ok, mod = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            local RS2 = game:GetService("ReplicatedStorage")
            return require(RS2:WaitForChild(folder, 10):WaitForChild(name, 10))
        end)
        cache[key] = (ok and mod) or false
        return cache[key] or nil
    end end)()
do
    local _RS = game:GetService("ReplicatedStorage")
    local _D  = _RS:WaitForChild("Datas")
    local okA, _A = pcall(require, _D:WaitForChild("Animals"))
    local okG, _G_ = pcall(require, _D:WaitForChild("Game"))
    local okM, _M = pcall(require, _D:WaitForChild("Mutations"))
    local okT, _T = pcall(require, _D:WaitForChild("Traits"))
    _G.JAF_SafeGen = function(index, mutation, traits, _player) LPH_ATTRIBUTES(PRESET(FAST), ERROR_HANDLING(false))
        if _G.JAF_UseGameGen == true then
            local okX, vX = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return require(_RS.Shared.Animals):GetGeneration(index, mutation, traits, nil) end)
            if okX then return vX end
        end
        if not (okA and _A) then return 0 end
        local e = _A[index]
        if not e then return 0 end
        local base = e.Generation
        if not base then local mod = (okG and _G_ and _G_.Game and _G_.Game.AnimalGanerationModifier) or 0 base = (e.Price or 0) * mod end
        local mult, sleepy = 1, false
        local _mu = mutation and okM and _M and _M[mutation]
        if _mu then mult = mult + (_mu.Modifier or 0) end
        if traits and okT and _T then
            for _, t in pairs(traits) do
                local tr = _T[t]
                if tr then if t == "Sleepy" then sleepy = true else mult = mult + (tr.MultiplierModifier or 0) end end
            end end
        local v = base * mult
        if sleepy then v = v * 0.5 end
        return math.round(v)
    end end
_G.Synchronizer = Synchronizer
if _G.JAF_NoSynchronizer == nil then _G.JAF_NoSynchronizer = true end
if _G.JAF_NoCarpetScan   == nil then _G.JAF_NoCarpetScan   = false end
if _G.JAF_NoUpvalues == nil then _G.JAF_NoUpvalues = true end
if _G.JAF_NoFSHook   == nil then _G.JAF_NoFSHook   = true end
_G.JAF_UseGameGen = false
do
    local realT = getfenv(0)
    local BAD = {
        writefile=1, readfile=1, appendfile=1, isfile=1, delfile=1, listfiles=1, makefolder=1,
        isfolder=1, delfolder=1, loadstring=1, hookfunction=1, hookmetamethod=1, newcclosure=1,
        getgenv=1, getrenv=1, getreg=1, getgc=1, getrawmetatable=1, setrawmetatable=1, setreadonly=1,
        getconnections=1, firesignal=1, gethui=1, get_hidden_gui=1, getcustomasset=1, setclipboard=1,
        queue_on_teleport=1, getscriptclosure=1, getscriptbytecode=1, decompile=1, identifyexecutor=1,
        getexecutorname=1, request=1, http_request=1, syn=1, protect_gui=1, checkcaller=1,
        islclosure=1, iscclosure=1, clonefunction=1, getcallingscript=1, getnilinstances=1,
        setthreadidentity=1, getthreadidentity=1, set_thread_identity=1, get_thread_identity=1,
    }
    local cleanT = setmetatable({}, {
        __index    = function(_, k) LPH_ATTRIBUTES(ERROR_HANDLING(false))
if BAD[k] then return nil end return realT[k] end,
        __newindex = function(_, k, v) LPH_ATTRIBUTES(ERROR_HANDLING(false))
realT[k] = v end,
    })
    local function safeCall(f, ...) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if _G.JAF_NoSafeCall == true then return pcall(f, ...) end
        local args = table.pack(...)
        local body = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
setfenv(0, cleanT) return table.pack(pcall(f, table.unpack(args, 1, args.n))) end
        setfenv(body, cleanT)
        local co = coroutine.create(body)
        local ok, packed = coroutine.resume(co)
        if not ok then return false, packed end
        if type(packed) ~= "table" then return false, "safeCall: target yielded" end
        return table.unpack(packed, 1, packed.n)
    end
    _G.JAF_SafeCall = safeCall
    local chanCache = setmetatable({}, {__mode = "k"})
    local function wrapChannel(ch) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if ch == nil or (type(ch) ~= "table" and type(ch) ~= "userdata") then return ch end
        local hit = chanCache[ch]; if hit then return hit end
        local w = setmetatable({}, {
            __index = function(_, k) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local v = ch[k]
                if type(v) ~= "function" then return v end
                return function(_, ...) LPH_ATTRIBUTES(ERROR_HANDLING(false))
local ok, r = safeCall(v, ch, ...) if not ok then return nil end return r end
            end,
            __newindex = function(_, k, v) LPH_ATTRIBUTES(ERROR_HANDLING(false))
ch[k] = v end,
        })
        chanCache[ch] = w
        return w
    end
    _G.JAF_WrapChannel = wrapChannel
    local _chanTable, _chanAt = nil, 0
    local HEAP_MIN = 24
    local heapScanAsync
    local _heapBusy, _heapDone, _missAt = false, false, 0
    local RETRY_COOLDOWN = 3
    local _heapMissAt = 0
    local HEAP_RETRY  = 5
    local GUIDPAT_C = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
    local function _looksLikeRegistry(t) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if type(t) ~= "table" then return false end
        local hits, n = 0, 0
        for k, chan in pairs(t) do
            n = n + 1
            if n > 64 then break end
            if type(k) == "string" and #k == 36 and k:match(GUIDPAT_C) and type(chan) == "table"
               and type(rawget(chan, "CacheTable")) == "table" then
                hits = hits + 1
                if hits >= 3 then return true end
            end end
        return false
    end
    _G.JAF_ChanValid = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return _looksLikeRegistry(_chanTable) end
    local _needCache, _needAt, _haveCache = 0, 0, 0
    local _pulled = {}
    local _pullT0 = tick()      -- ⭐own clock: JAF_HubStart is defined much later in the file
    _G.JAF_Pulled = _pulled
    local function _requestData(name) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        local pk = ReplicatedStorage:FindFirstChild("Packages")
        local sy = pk and pk:FindFirstChild("Synchronizer")
        local rf = sy and sy:FindFirstChild("RequestData")
        if not rf or not rf:IsA("RemoteFunction") then return nil end
        local ok, res = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return rf:InvokeServer(name) end)
        if ok and type(res) == "table" then return res end
        return nil
    end
    _G.JAF_PullPlot = function(name) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        local ct = _requestData(name)
        if ct then
            _pulled[name] = ct
            _G.JAF_PullOk = (tonumber(_G.JAF_PullOk) or 0) + 1
        else
            _G.JAF_PullFail = (tonumber(_G.JAF_PullFail) or 0) + 1
        end
        return ct
    end
    local function _instanceChans() LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if not (getconnections and debug and debug.getupvalues) then return nil end
        local pk = ReplicatedStorage:FindFirstChild("Packages")
        local sy = pk and pk:FindFirstChild("Synchronizer")
        local cf = sy and sy:FindFirstChild("Channel")
        if not cf then return nil end
        local map, n = {}, 0
        for _, re in ipairs(cf:GetChildren()) do
            if re:IsA("RemoteEvent") then
                local okC, conns = pcall(getconnections, re.OnClientEvent)
                if okC and type(conns) == "table" then
                    for _, conn in ipairs(conns) do
                        local okF, f = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return conn.Function end)
                        if okF and type(f) == "function" then
                            local okU, uvs = pcall(debug.getupvalues, f)
                            if okU and type(uvs) == "table" then
                                for _, uv in ipairs(uvs) do
                                    if type(uv) == "table" and type(rawget(uv, "CacheTable")) == "table" then
                                        map[re.Name] = uv
                                        n = n + 1
                                        break
                                    end end end end
                        if map[re.Name] then break end
                    end end end end
        local function _realCount(c) LPH_ATTRIBUTES(ERROR_HANDLING(false))
            if type(c) ~= "table" then return -1 end
            local al = rawget(c, "AnimalList") or rawget(c, "Animals")
            if type(al) ~= "table" then return -1 end
            local n2 = 0
            for _, a in pairs(al) do if type(a) == "table" then n2 = n2 + 1 end end
            return n2
        end
        local _inWindow = (tick() - _pullT0) < (tonumber(_G.JAF_PullTrustWindow) or 15)
        if not _inWindow and next(_pulled) ~= nil then
            local anyLive = false
            for kk in pairs(_pulled) do
                local c2 = map[kk]
                if c2 and _realCount(rawget(c2, "CacheTable")) >= 0 then anyLive = true break end
            end
            if anyLive then
                table.clear(_pulled)
                _G.JAF_PullDropped = (tonumber(_G.JAF_PullDropped) or 0) + 1
            end
        end
        for k, ct in pairs(_pulled) do
            local cur   = map[k]
            local curCT = cur and rawget(cur, "CacheTable")
            if cur == nil then
                map[k] = { CacheTable = ct }
                n = n + 1
            elseif _inWindow and _realCount(ct) > _realCount(curCT) then
                map[k] = { CacheTable = ct }
                _G.JAF_PullPreferred = (tonumber(_G.JAF_PullPreferred) or 0) + 1
            end end
        if n == 0 then return nil end
        _G.JAF_ChanInstCount = n
        if not _G.JAF_ChansFirstAt then _G.JAF_ChansFirstAt = tick() end
        return map
    end
    _G.JAF_InstanceChans = _instanceChans
    if _G.JAF_PullOnJoin ~= false then
        task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            local t0 = os.clock()
            local plotsF = workspace:FindFirstChild("Plots") or workspace:WaitForChild("Plots", 10)
            if not plotsF then return end
            local kids = plotsF:GetChildren()
            local left = #kids
            for _, pl in ipairs(kids) do task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_G.JAF_PullPlot(pl.Name) left = left - 1 end) end
            local t1 = os.clock()
            while left > 0 and (os.clock() - t1) < 8 do task.wait(0.02) end
            _G.JAF_PullMs = (os.clock() - t0) * 1000
            local got = 0 ; for _ in pairs(_pulled) do got = got + 1 end
            local function allSettled() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                for _, ct in pairs(_pulled) do
                    if type(ct) == "table" and rawget(ct, "Owner") ~= nil then
                        local al = rawget(ct, "AnimalList") or rawget(ct, "Animals")
                        local real = 0
                        if type(al) == "table" then
                            for _, a in pairs(al) do if type(a) == "table" then real = real + 1 end end
                        end
                        if real == 0 then return false end   -- owned base, still empty -> ask again
                    end
                end
                return true
            end
            local rounds = math.clamp(tonumber(_G.JAF_PullRetries) or 4, 0, 8)
            for r = 1, rounds do
                if allSettled() then break end
                task.wait(tonumber(_G.JAF_PullRetryGap) or 0.4)
                local n2 = #kids
                for _, pl in ipairs(kids) do task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_G.JAF_PullPlot(pl.Name) ; n2 = n2 - 1 end) end
                local t2 = os.clock()
                while n2 > 0 and (os.clock() - t2) < 5 do task.wait(0.02) end
                _G.JAF_PullRounds = r
                if allSettled() then
                    if _G.JAF_JoinMark then _G.JAF_JoinMark("pullSettled", "round " .. r) end
                    break
                end
            end end) end
    local ANIMAL_KEYS = { "Animals", "AnimalList" }
    local function animalsOf(cacheTable) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if type(cacheTable) ~= "table" then return nil end
        for _, k in ipairs(ANIMAL_KEYS) do local v = rawget(cacheTable, k) if type(v) == "table" then return v end end
        return nil
    end
    _G.JAF_AnimalsOf = animalsOf
    _G.JAF_OwnerName = function(o) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if o == nil then return nil end
        if typeof(o) == "Instance" then return o.Name end
        if type(o) == "table"  then return o.Name end
        if type(o) == "string" then if o == "" or o == "..." then return nil end return o end
        return nil
    end
    _G.JAF_OwnerPlayer = function(o) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if typeof(o) == "Instance" and o:IsA("Player") then return o end
        if type(o) == "table" and o.UserId then return game:GetService("Players"):GetPlayerByUserId(o.UserId) end
        local n = _G.JAF_OwnerName(o)
        return n and game:GetService("Players"):FindFirstChild(n) or nil
    end
    local function _findChans() LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if _G.JAF_ChanInstOff ~= true then
            local _now = tick()
            if (_now - _needAt) > 2 then
                local _pl = workspace:FindFirstChild("Plots")
                _needCache, _needAt = (_pl and #_pl:GetChildren() or 0), _now
            end
            local _need     = _needCache
            local _have     = _haveCache
            local _complete = (_need > 0 and _have >= _need)
            if _complete and _G.JAF_ChanSource == "instances" and _chanTable and next(_chanTable) ~= nil
               and (tick() - _chanAt) < (tonumber(_G.JAF_ChanInstTTL) or 1) then
                return _chanTable
            end
            local m = _instanceChans()
            if m then
                if _chanTable then for k, v in pairs(_chanTable) do if m[k] == nil then m[k] = v end end end
                local mn = 0 ; for _ in pairs(m) do mn = mn + 1 end
                _chanTable, _chanAt = m, tick()
                _haveCache          = mn
                _G.JAF_ChanSource   = "instances"
                _G.JAF_ChanHave, _G.JAF_ChanNeed = mn, _need
                if _need > 0 and mn < _need then
                    _G.JAF_ChanPartial = (tonumber(_G.JAF_ChanPartial) or 0) + 1
                    if heapScanAsync then pcall(heapScanAsync) end
                end
                return m
            end end
        if _chanTable and not _looksLikeRegistry(_chanTable) then
            _chanTable = nil
            _haveCache = 0
            _heapDone  = false
            _G.JAF_ChanEvictions = (tonumber(_G.JAF_ChanEvictions) or 0) + 1
        end
        if _chanTable and next(_chanTable) ~= nil then return _chanTable end
        if _chanTable and (tick() - _chanAt) < 5 then return _chanTable end
        if (tick() - _missAt) < RETRY_COOLDOWN then return _chanTable end
        local best, bestScore = nil, 0
        pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            local BUDGET, seen = 30000, {}
            local function score(t) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local withCache, withAL, n = 0, 0, 0
                for _, v in next, t do
                    n = n + 1; if n > 400 then break end
                    if type(v) == "table" then
                        local c = rawget(v, "CacheTable")
                        if type(c) == "table" then withCache = withCache + 1 if animalsOf(c) then withAL = withAL + 1 end end
                    end end
                return withCache + withAL * 10
            end
            heapScanAsync = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                if not getgc then return end
                if _heapBusy or _heapDone then return end
                if (tick() - _heapMissAt) < HEAP_RETRY then return end
                _heapBusy = true
                task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                    local ok, gc = pcall(getgc, true)
                    if not ok or type(gc) ~= "table" then _heapBusy, _heapMissAt = false, tick() return end
                    local SLICE = math.clamp(tonumber(_G.JAF_HeapSliceMs) or 4, 1, 16) / 1000
                    local _lastYield = os.clock()
                    local GUIDPAT = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
                    local best, bestGuid, bestAnimals, cands, since = nil, 0, -1, 0, 0
                    for i = 1, #gc do
                        local v = gc[i]
                        if type(v) == "table" then
                            pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                                local guidHits, animals, n = 0, 0, 0
                                for k, chan in pairs(v) do
                                    n = n + 1
                                    if n > 64 then return end
                                    if type(k) == "string" and k:match(GUIDPAT) and type(chan) == "table" then
                                        local ct = rawget(chan, "CacheTable")
                                        if type(ct) == "table" then
                                            guidHits = guidHits + 1
                                            local al = rawget(ct, "AnimalList")
                                            if type(al) == "table" then
                                                for _, a in pairs(al) do if type(a) == "table" then animals = animals + 1 end end
                                            end end end end
                                if guidHits >= 3 then
                                    cands = cands + 1
                                    if guidHits > bestGuid or (guidHits == bestGuid and animals > bestAnimals) then
                                        best, bestGuid, bestAnimals = v, guidHits, animals
                                    end end end) end
                        if (os.clock() - _lastYield) >= SLICE then task.wait() _lastYield = os.clock() since = since + 1 end
                    end
                    _G.JAF_HeapYields = since
                    if best then
                        _chanTable, _chanAt = best, tick()
                        do local _hc = 0 for _ in pairs(best) do _hc = _hc + 1 end _haveCache = _hc end
                        _G.JAF_ChanGuids   = bestGuid
                        _G.JAF_ChanCands   = cands
                        _G.JAF_ChanSource  = "heap-validated"
                    end
                    _heapBusy = false
                    if best then
                        _heapDone = true
                    else
                        _heapMissAt = tick()
                        _G.JAF_HeapMisses = (tonumber(_G.JAF_HeapMisses) or 0) + 1
                    end end) end
            _G.JAF_HeapRescan = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_heapDone, _heapBusy, _chanTable = false, false, nil heapScanAsync() end
            _G.JAF_HeapScan = heapScanAsync
            if _G.JAF_HeapWarm ~= false then
                task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
local t0 = os.clock() pcall(heapScanAsync) _G.JAF_HeapWarmMs = (os.clock() - t0) * 1000 end)
            end
            local function scan(v, depth) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                BUDGET = BUDGET - 1
                if BUDGET <= 0 or depth > 7 then return end
                local tv = type(v)
                if tv == "table" then
                    if seen[v] then return end; seen[v] = true
                    local n = 0
                    for _ in next, v do n = n + 1; if n > 600 then return end end
                    local s = score(v)
                    if s > bestScore then best, bestScore = v, s end
                    for _, val in next, v do scan(val, depth + 1) end
                elseif tv == "function" then
                    if seen[v] then return end; seen[v] = true
                    local oku, ups = pcall(debug.getupvalues, v)
                    if oku and type(ups) == "table" then for _, u in next, ups do scan(u, depth + 1) end end
                end end
            for _, fn in next, (_syncMod() or {}) do if type(fn) == "function" then pcall(scan, fn, 0) end end
        end)
        if best and bestScore >= HEAP_MIN then
            _chanTable, _chanAt = best, tick()
            _G.JAF_ChanSource = "upvalues"
        else
            _missAt = tick()
            if not _chanTable then heapScanAsync() end
        end
        _G.JAF_ChanScore = bestScore
        return _chanTable
    end
    _G.JAF_FindChans = _findChans
    local dcCache = setmetatable({}, {__mode = "k"})
    local function directChannel(cd) LPH_ATTRIBUTES(ERROR_HANDLING(false))
        if type(cd) ~= "table" then return cd end
        local hit = dcCache[cd]; if hit then return hit end
        local w = {
            Raw = cd,
            Get = function(_, key) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local ct = rawget(cd, "CacheTable")
                if type(ct) ~= "table" then return nil end
                if key == "AnimalList" or key == "Animals" then return _G.JAF_AnimalsOf(ct) end
                return rawget(ct, key)
            end,
            GetTable = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return rawget(cd, "CacheTable") end,
        }
        dcCache[cd] = w
        return w
    end
    _G.JAF_DirectChannel = directChannel
    if _G.JAF_SnitchPatchOn == true and _G.JAF_NoSnitchPatch ~= true then
        task.spawn(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            local t
            for _ = 1, 120 do
                t = _findChans()
                if type(t) == "table" and (_G.JAF_ChanScore or 0) >= 10 then break end
                t = nil
                task.wait(0.25)
            end
            if type(t) ~= "table" then _G.JAF_SnitchPatched = 0 return end
            pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            _G.JAF_SyncOrig = {
                GetAllChannels      = Synchronizer.GetAllChannels,
                Get                 = Synchronizer.Get,
                GetTableFromChannel = Synchronizer.GetTableFromChannel,
            }
            local function reg() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return _findChans() or t end
            local patched = 0
            local function put(name, fn) LPH_ATTRIBUTES(ERROR_HANDLING(false))
if pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
Synchronizer[name] = fn end) then patched = patched + 1 end end
            put("GetAllChannels", function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return reg() end)
            put("Get", function(_, key) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local r = reg()
                local direct = rawget(r, key)
                if direct ~= nil then return direct end
                return rawget(r, tostring(key))
            end)
            put("GetTableFromChannel", function(_, key) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                local r = reg()
                local ch = rawget(r, key) or rawget(r, tostring(key))
                if type(ch) ~= "table" then return nil end
                return rawget(ch, "CacheTable")
            end)
            _G.JAF_SnitchPatched = patched
            end) end) end
    local _getCache = {}
    _G.JAF_SyncGetCache = _getCache
    local SyncSafe = setmetatable({}, {
        __index = function(_, k) LPH_ATTRIBUTES(ERROR_HANDLING(false))
            if k == "GetAllChannels" then
                return function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
                    local t = _findChans(); if not t then return {} end
                    local out = {}
                    for n, cd in next, t do out[n] = directChannel(cd) end
                    return out
                end end
            if k == "Get" and _G.JAF_SyncPlain ~= true then
                return function(_, name) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                    local t = _findChans(); if not t then return nil end
                    return directChannel(rawget(t, tostring(name)))
                end end
            if k == "Get" and _G.JAF_SyncPlain == true then
                return function(_, name) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                    local key = tostring(name)
                    local hit = _getCache[key]
                    if hit ~= nil then return hit end
                    local ok, ch = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return Synchronizer:Get(name) end)
                    if not ok or ch == nil then return nil end
                    local w = directChannel(ch)
                    _getCache[key] = w
                    return w
                end end
            local v = Synchronizer[k]
            if type(v) ~= "function" then return v end
            return function(_, ...) LPH_ATTRIBUTES(ERROR_HANDLING(false))
                if k == "Get" then local ok, r = safeCall(v, _syncMod(), ...) if not ok then return nil end return wrapChannel(r) end
                local a = table.pack(...)
                local ok, r = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return v(_syncMod(), table.unpack(a, 1, a.n)) end)
                if not ok then return nil end
                return r
            end end, })
    _G.JAF_SyncSafe = SyncSafe
    if _G.JAF_SyncStub == true and debug and debug.getupvalues then
        task.spawn(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
            local function isGuid(s) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                return type(s) == "string" and #s == 36 and s:upper() == s
                   and s:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
            end
            local patched, BUDGET, seen = 0, 40000, {}
            local function scan(v, depth) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
                BUDGET = BUDGET - 1
                if BUDGET <= 0 or depth > 8 then return end
                local tv = type(v)
                if tv == "table" then
                    if seen[v] then return end; seen[v] = true
                    local n = 0
                    for _ in next, v do n = n + 1; if n > 600 then return end end
                    if n <= 12 then
                        local guid, fnKeys = nil, {}
                        for k, val in next, v do
                            if isGuid(val) then guid = val
                            elseif type(val) == "function" then fnKeys[#fnKeys + 1] = k end
                        end
                        if guid and #fnKeys > 0 then
                            for _, fk in ipairs(fnKeys) do
                                local g = guid
                                if pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
v[fk] = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return g end end) then patched = patched + 1 end
                            end end end
                    for _, val in next, v do scan(val, depth + 1) end
                elseif tv == "function" then
                    if seen[v] then return end; seen[v] = true
                    local oku, ups = pcall(debug.getupvalues, v)
                    if oku and type(ups) == "table" then for _, u in next, ups do scan(u, depth + 1) end end
                end end
            for _, fn in next, (_syncMod() or {}) do if type(fn) == "function" then pcall(scan, fn, 0) end end
            _G.JAF_SyncStubbed = patched
        end) end end
_G.JAF_GetSynchronizer = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
if _G.JAF_NoSafeCall == true then return Synchronizer end return _G.JAF_SyncSafe end
do
    local _PS = game:GetService("Players")
    pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_PS.RespawnTime = 0 end)
    pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_PS.CharacterAutoLoads = true end)
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        _PS:GetPropertyChangedSignal("CharacterAutoLoads"):Connect(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            if _PS.CharacterAutoLoads ~= true then pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_PS.CharacterAutoLoads = true end) end
        end) end)
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        _PS:GetPropertyChangedSignal("RespawnTime"):Connect(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
            if _PS.RespawnTime ~= 0 then pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_PS.RespawnTime = 0 end) end
        end) end)
    local function _hookLP(lp) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if not lp then return end
        lp.CharacterAdded:Connect(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false)) pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
_PS.RespawnTime = 0 end) end)
    end
    _hookLP(_PS.LocalPlayer)
    _PS.PlayerAdded:Connect(function(plr) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        if plr == _PS.LocalPlayer then _hookLP(plr) end
    end) end
pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
if setfpscap then setfpscap(_G.JAF_FpsCap or 9999) end end)
local SharedState = {
    ConveyorAnimals = {},
    AllAnimalsCache = nil,
    DisableStealSpeed = nil,
    AdminButtonCache = {},
    StealSpeedToggleFunc = nil,
    BalloonedPlayers = {},
}
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    TweenService = game:GetService("TweenService"),
    HttpService = game:GetService("HttpService"),
    Workspace = game:GetService("Workspace"),
    Lighting = game:GetService("Lighting"),
    VirtualInputManager = (cloneref and cloneref(game:GetService("VirtualInputManager"))) or game:GetService("VirtualInputManager"),
    GuiService = game:GetService("GuiService"),
    TeleportService = game:GetService("TeleportService"),
}
local Players = Services.Players
local RunService = Services.RunService
local UserInputService = Services.UserInputService
local ReplicatedStorage = Services.ReplicatedStorage
local TweenService = Services.TweenService
local HttpService = Services.HttpService
local Workspace = Services.Workspace
local Lighting = Services.Lighting
local VirtualInputManager = Services.VirtualInputManager
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local LocalPlayer = Players.LocalPlayer
if _G.JAF_PingAdapt == nil then _G.JAF_PingAdapt = false end
_G.JAF_Ping = function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if _G.JAF_PingAdapt ~= true then return 0 end
    local p = 0; pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
p = LocalPlayer:GetNetworkPing() or 0 end)
    return p
end
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local HubGui = PlayerGui
pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local h = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui())
    if typeof(h) == "Instance" then HubGui = h end
end)
local hubFind; hubFind = function(name) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if HubGui ~= PlayerGui then local g = HubGui:FindFirstChild(name); if g then return g end end
    return PlayerGui:FindFirstChild(name)
end
local function safeKeyCode(name, fallback) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    if type(name) ~= "string" then return fallback end
    local cleaned = name:gsub("^%s+", ""):gsub("%s+$", "")
    if cleaned == "" or cleaned == "--" or cleaned == "NONE" then return nil end
    local ok, kc = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return Enum.KeyCode[cleaned] end)
    if ok and kc then return kc end
    return fallback
end
local FileName = "rosehub.json"
do
    if type(isfile) == "function" and type(readfile) == "function" and type(writefile) == "function" then
        if not isfile(FileName) then
            for _, old in ipairs({ "rosehub_v1.json", "JustAFanHub_v1.json" }) do
                if isfile(old) then pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
writefile(FileName, readfile(old)) end); break end
            end end end end
local DefaultConfig = {
    Positions = {
        AdminPanel = {X = 0.1859375, Y = 0.5767123526556385},
        -- Hub name plate now owns the bottom centre (JustAFanStatusHUD), so this pill
        -- sits above it instead of on top of it.
        WalkingBestBar = {X = 0.5, Y = 0.86},
    },
    TpSettings = {
        Tool           = "Flying Carpet",
        TpKey          = "T",
        CloneKey       = "V",
        CarpetSpeedKey = "Q",
        InfiniteJump   = false,
        CacheWait      = 0.00,
        WaitFullScan   = true,
        TpSpeedF1      = 130,
        TpSpeedF2      = 130,
        TpSpeedF1Front      = 130, TpSpeedF1Side      = 130,
        TpSpeedF2Front      = 130, TpSpeedF2Side      = 130,
        GrappleSpeedF1Front = 400, GrappleSpeedF1Side = 400,
        GrappleSpeedF2Front = 400, GrappleSpeedF2Side = 400,
        F1SpotMode      = "auto",
        F2SpotMode      = "auto",
        F2StealBelow    = true,
        TpMode          = "tween",
        GrappleFireMode = "firesignal",
        GrappleSpeed    = 400,
        BrainrotSpeed   = 175,
        InstaTpBrainrot = true,
        CloneDelay      = 0.15,
        F1FrontCloneDelay = 0.15,
        WaitStableFps   = false,
        FpsStableThresh = 60,
    },
    HitRecovery    = true,
    RetargetOnSelect      = true,
    SkipStolenTarget      = true,
    AutoTPPriority = true,
    StealSpeed   = 20,
    MenuKey      = "LeftControl",
    AntiRagdollV2 = true,
    PlayerESP    = true,
    StealerESP   = false,
    BaseOwnerESP = false,
    FpsOptimizer = true,
    RemoveAnimations = true,
    OptimizeFloorSmooth = true,
    OptimizeStripMeshTextures = true,
    DarkMode     = false,
    DarkBrightness = 0.4,
    BrainrotESP = true,
    LineToBase = false,
    StealNearest = false,
    ConveyorESP = false,
    PriorityList = {},
    MutationPriorityList = {},
    MutationPriorityEnabled = true,
    PrioritySkipPicker   = false,
    PriorityLastTab      = "brainrot",
    UILocked     = false,
    HideAdminPanel = false,
    HideAutoSteal = false,
    HideWalkingBest = false,
    AutoKickOnSteal = false,
    KickToPrivateOnSteal = false,
    PrivateServerCode = "",
    InvisStealAngle = 233,
    SinkSliderValue = 2.5,
    AutoRecoverLagback = true,
    AutoInvisDuringSteal = false,
    InvisDelayEnabled = false,
    InvisDelayMs = 0,
    InvisToggleKey = "I",
    ClickToAP = false,
    ClickToAPKeybind = "L",
    ProximityAP = false,
    ProximityAPKeybind = "P",
    ProximityRange = 15,
    StealSpeedKey = "C",
    ResetKey = "X",
    AntiBeeDisco = false,
    FOV = 70,
    AutoUnlockOnSteal = false,
    UIScale = 1,
    PanelScales = {},
    MobileMode      = "auto",
    HubButtonMode   = "auto",
    MobileHubButton = true,
    MobileSheet     = true,
    MobileBtnPos    = nil,
    KickKey = "",
    CleanErrorGUIs = false,
    ClickToAPSingleCommand = false,
    RagdollSelfKey = "",
    AutoBuyKey = "",
    DropBrainrotKey = "",
    FloatKey   = "" ,
    FloatSpeed = 40,
    AutoBuyEnabled = false,
    AutoBuyMode = "normal",
    AutoBuyFastRate = 12,
    CarpetAutoBuy = false,
    CarpetMinGen = "",
    CarpetBuySpeed = 70,
    AutoGrief = false,
    KickAfterBuy = false,
    KickAfterBuyToPS = false,
    AutoResetOnBalloon = false,
    AutoStealSpeed = false,
    AutoDestroyTurrets = true,
    HideAdminCooldowns = false,
    CurrentTheme = "galaxy",
    CustomThemeHex = "FFC800",
    HubName = "BEROLA'S HUB",
    HubOwner = "berola hub, (berola_)",
    ThemeImageUrl = "",
    ShowMiniActions = true,
    MiniUIPos = {X = 0.01, Y = 0.35},
    Blacklist = {},
    AntiApAtlasUsers = true,
    AntiApKawaifuUsers = true,
    AntiApBraintopiaUsers = true,
    AntiApFmlyUsers = true,
    AntiApSonUsers = true,
    GriefDetectorEnabled = true,
    AdminRandomCmd = false,
    ShowProxCircle = false,
    AdminAllowedCmds = {},
    AdminCmdOrder = {"ragdoll", "balloon", "rocket", "jail", "inverse", "jumpscare", "morph", "nightvision", "tiny"},
    AdminCmdPinned = {},
    KnownSecrets = {},
    KnownSecretRarities = {},
    NewSecretsBatch = {},
}
local function _deepCopy(t) LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
    local o = {}
    for k, v in pairs(t) do o[k] = (type(v) == "table") and _deepCopy(v) or v end
    return o
end
_G.JAF_ConfigDefaults = _deepCopy(DefaultConfig)
local Config = DefaultConfig
if isfile and isfile(FileName) then
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local ok, decoded = pcall(function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return HttpService:JSONDecode(readfile(FileName)) end)
        if not ok then return end
        for k, v in pairs(DefaultConfig) do if decoded[k] == nil then decoded[k] = v end end
        for _, sub in ipairs({"TpSettings", "Positions"}) do
            if decoded[sub] then for k, v in pairs(DefaultConfig[sub]) do if decoded[sub][k] == nil then decoded[sub][k] = v end end end
        end
        for _, k in ipairs({"Blacklist", "AdminAllowedCmds", "AdminCmdPinned", "KnownSecrets"}) do
            if type(decoded[k]) ~= "table" then decoded[k] = {} end
        end
        if type(decoded.AdminCmdOrder) ~= "table" or #decoded.AdminCmdOrder == 0 then
            local _o = {}
            for _, c in ipairs(DefaultConfig.AdminCmdOrder) do _o[#_o + 1] = c end
            decoded.AdminCmdOrder = _o
        end
        Config = decoded
    end) end
Config.ProximityAP = false
if not Config._CloneDelayMigrated then
    Config._CloneDelayMigrated = true
    if Config.TpSettings and tonumber(Config.TpSettings.CloneHold) then
        Config.TpSettings.CloneDelay = tonumber(Config.TpSettings.CloneHold)
        Config.TpSettings.CloneHold  = nil
    end end
Config.StealRadius = nil
if not Config._F2StealBelowDefaultOn then
    Config._F2StealBelowDefaultOn = true
    if Config.TpSettings then Config.TpSettings.F2StealBelow = true end
end
Config.OptimizeFloorSmooth = true
Config.OptimizeStripMeshTextures = true
if _G.JAF_NoCarpetScan == true then Config.CarpetAutoBuy = false end
if _G.JAF_FastBuyPublic == nil then _G.JAF_FastBuyPublic = true end
_G.JAF_FastBuyAllowed = function() LPH_ATTRIBUTES(ERROR_HANDLING(false))
return true end
if not (isfile and isfile(FileName)) then
    local vpH = 1080
    pcall(function() LPH_ATTRIBUTES(VM(NONE), ERROR_HANDLING(false))
        local cam = Workspace.CurrentCamera
        local h = cam and cam.ViewportSize and cam.ViewportSize.Y
        if not h or h < 200 then local res = GuiService.GetScreenResolution and GuiService:GetScreenResolution() h = res and res.Y end
        if h and h >= 200 then vpH = h end
    end)
    local autoScale = 0.9 * (vpH / 1080)
    Config.UIScale = math.floor(math.clamp(autoScale, 0.9, 1.5) * 20 + 0.5) / 20
end
_G.JAF_FFlagList = {
    {"DFFlagBrowserTrackerIdTelemetryEnabled","False"},{"DFFlagPreloadAsyncSupportTexturePack","True"},{"DFFlagTextureQualityOverrideEnabled","True"},
    {"DFFlagVideoCaptureServiceEnabled","False"},{"DFFlagSampleAndRefreshRakPing","True"},{"DFFlagRakNetUseSlidingWindow4","True"},
    {"DFFlagCoreScriptTelemetry2","False"},{"DFFlagEnableSoundPreloading","True"},{"DFFlagOptimizePartsInPart","True"},
    {"DFFlagDisableDPIScale","True"},{"DFFlagDebugPerfMode","True"},{"DFIntRaknetBandwidthInfluxHundredthsPercentageV2","10000"},
    {"DFIntRakNetClockDriftAdjustmentPerPingMillisecond","100"},{"DFIntPerformanceControlTextureQualityBestUtility","-1"},{"DFIntSignalRHubConnectionHeartbeatTimerRateMs","1000"},
    {"DFIntMaxReceiveToDeserializeLatencyMilliseconds","15"},{"DFIntMegaReplicatorNetworkQualityProcessorUnit","10"},{"DFIntNetworkInDeserializeLimitGameplayMsClient","6"},
    {"DFIntSignalRHubConnectionBaseRetryTimeMs","100"},{"DFIntClientPacketHealthyAllocationPercent","20"},{"DFIntTelemetryProfilerHundredthsPercentage","0"},
    {"DFIntMaxWaitTimeBeforeForcePacketProcessMS","1"},{"DFIntNetworkInProcessLimitGameplayMsClient","6"},{"DFIntAnimationLodFacsVisibilityDenominator","0"},
    {"DFIntRaknetBandwidthPingSendEveryXSeconds","1"},{"DFIntSignalRCoreKeepAlivePingPeriodMs","250"},{"DFIntClientPacketMaxFrameMicroseconds","200"},
    {"DFIntSoundServiceCacheCleanupMaxAgeDays","2"},{"DFIntMaxProcessPacketsStepsPerCyclic","5000"},{"DFIntClientPacketExcessMicroseconds","1000"},
    {"DFIntMaxProcessPacketsStepsAccumulated","0"},{"DFIntWaitOnUpdateNetworkLoopEndedMS","100"},{"DFIntLargePacketQueueSizeCutoffMB","1000"},
    {"DFIntMaxProcessPacketsJobScaling","10000"},{"DFIntRakNetNakResendDelayRttPercent","50"},{"DFIntSignalRCoreServerTimeoutMs","11100"},
    {"DFIntDebugFRMQualityLevelOverride","1"},{"DFIntClientPacketMinMicroseconds","1"},{"DFIntAnimationLodFacsDistanceMin","0"},
    {"DFIntAnimationLodFacsDistanceMax","0"},{"DFIntWaitOnRecvFromLoopEndedMS","100"},{"DFIntRakNetNakResendDelayMsMax","100"},
    {"DFIntCodecMaxOutgoingFrames","10000"},{"DFIntSignalRCoreRpcQueueSize","256"},{"DFIntRakNetMinAckGrowthPercent","0"},
    {"DFIntTaskSchedulerTargetFps","9999"},{"DFIntCodecMaxIncomingPackets","100"},{"DFIntRakNetMtuValue3InBytes","1200"},
    {"DFIntRakNetMtuValue1InBytes","1280"},{"DFIntRakNetMtuValue2InBytes","1240"},{"DFIntRakNetNakResendDelayMs","10"},
    {"DFIntRakNetResendRttMultiple","1"},{"DFIntMemCacheMaxCapacityMB","48"},{"DFIntClientPacketMaxDelayMs","11"},
    {"DFIntTextureQualityOverride","0"},{"DFIntRakNetSelectTimeoutMs","1"},{"DFIntSignalRCoreTimerMs","750"},
    {"DFIntConnectionMTUSize","1260"},{"DFIntMaxFrameBufferSize","4"},{"DFIntRakNetLoopMs","1"},
    {"DFIntDebugRestrictGCDistance","1"},{"FIntTaskSchedulerAsyncTasksMinimumThreadCount","2"},{"FIntRenderMaxShadowAtlasUsageBeforeDownscale","80"},
    {"FIntPerformanceTelemetryQueueProcessLimit","0"},{"FIntRenderShadowMapDepthCacheMemLimit","192"},{"FIntUITextureMaxRenderTextureSize","1024"},
    {"FIntRakNetResendBufferArrayLength","128"},{"FIntTaskSchedulerAutoThreadLimit","6"},{"FIntTerrainOTAMaxTextureSize","1024"},