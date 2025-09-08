-- loader.lua

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local PLACE_ID = game.PlaceId
local HUB_URL = "https://raw.githubusercontent.com/fioso-cat/Fioso-Hub/main/assests/" .. PLACE_ID .. ".lua"

local function safeHttpGet(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result and not result:match("^404") then
        return result
    end
    return nil
end

local content = safeHttpGet(HUB_URL)

if content then
    local func = loadstring(content)
    if func then
        func()
    end
else
    local name = "Unknown Game"
    pcall(function()
        name = MarketplaceService:GetProductInfo(PLACE_ID).Name
    end)
    Players.LocalPlayer:Kick("This game [" .. name .. "] not supported, thank you!")
end
