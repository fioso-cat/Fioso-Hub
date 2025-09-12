--// Fioso Hub Core Module
-- Author: fioso-cat

local Fioso = {}

--====================================================
-- Safe fallback helper
--====================================================
local function missing(t, f, fallback)
    if type(f) == t then
        return f
    end
    return fallback
end

-- Safe some else thing
local cloneref = missing("function", cloneref, function(...) return ... end)
local httprequest =  missing("function", request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request))

--====================================================
-- Common Roblox Services
--====================================================
Fioso.Services = setmetatable({}, {
    __index = function(_, k)
        local s = game:GetService(k)
        return cloneref(s)
    end
})

Fioso.Workspace          = Fioso.Services.Workspace
Fioso.Players            = Fioso.Services.Players
Fioso.ReplicatedStorage  = Fioso.Services.ReplicatedStorage
Fioso.HttpService        = Fioso.Services.HttpService
Fioso.TweenService       = Fioso.Services.TweenService
Fioso.TeleportService    = Fioso.Services.TeleportService
Fioso.RunService         = Fioso.Services.RunService
Fioso.StarterGui         = Fioso.Services.StarterGui
Fioso.MarketplaceService = Fioso.Services.MarketplaceService
Fioso.ProximityPromptService = Fioso.Services.ProximityPromptService

--====================================================
-- HttpGet with fallback
--====================================================
Fioso.HttpGet = function(url, method, headers, body)
    local success, result = pcall(function()
        return httprequest({
            Url = url,
            Method = method or "GET",
            Headers = headers,
            Body = body
        }).Body
    end)

    if success then return result end

    local ok2, result2 = pcall(function()
        return game:HttpGet(url, true)
    end)
    if ok2 then return result2 end

    local ok3, result3 = pcall(function()
        return game:HttpGetAsync(url, true)
    end)
    if ok3 then return result3 end

    return nil
end

--====================================================
-- RemoteCall wrapper
--====================================================
Fioso.RemoteCall = function(remote, action, ...)
    if not remote then return end
    if action == "FireServer" then
        remote:FireServer(...)
    elseif action == "InvokeServer" then
        return remote:InvokeServer(...)
    elseif action == "Fire" then
        remote:Fire(...)
    elseif action == "Invoke" then
        return remote:Invoke(...)
    end
end

--====================================================
-- File utilities
--====================================================
Fioso.writefile  = missing("function", writefile, function() end)
Fioso.readfile   = missing("function", readfile, function() return nil end)
Fioso.isfile     = missing("function", isfile, function() return false end)
Fioso.makefolder = missing("function", makefolder, function() end)
Fioso.isfolder   = missing("function", isfolder, function() return false end)

--====================================================
-- Server Info
--====================================================
Fioso.ServerInfo = function()
    local ps = Fioso.Services.MarketplaceService:GetProductInfo(game.PlaceId)
    return {
        PlaceId       = game.PlaceId,
        JobId         = game.JobId,
        PlayersCount  = #Fioso.Players:GetPlayers(),
        PlayersMax    = Fioso.Players.MaxPlayers,
        GameOwner     = ps.Creator.Name,
        CreatorId     = ps.Creator.CreatorTargetId,
        ServerName    = ps.Name
    }
end

--====================================================
-- Client Info (local player only)
--====================================================
Fioso.ClientInfo = function()
    local lp = Fioso.Players.LocalPlayer
    local analytics = Fioso.Services.RbxAnalyticsService
    return {
        Name        = lp.Name,
        UserId      = lp.UserId,
        AccountAge  = lp.AccountAge,
        DisplayName = lp.DisplayName,
        HWID        = analytics:GetClientId()
    }
end

--====================================================
-- Logger helper
--====================================================
Fioso.log = function(title, data)
    print(("==== %s ===="):format(title))
    if type(data) == "table" then
        for k, v in pairs(data) do
            print(k, ":", v)
        end
    else
        print(data)
    end
    print(("="):rep(30))
end

return Fioso
