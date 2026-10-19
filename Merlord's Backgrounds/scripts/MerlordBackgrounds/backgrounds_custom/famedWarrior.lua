local player

local function onInit(scriptData)
    player = scriptData.player
end

local function onDeath()
    player:sendEvent("MerlordsTraits_rivalDied")
end

return {
    engineHandlers = {
        onInit = onInit,
        onSave = function()
            return {
                player = player,
            }
        end,
        onLoad = function(data)
            data = data or {}
            player = data.player
        end,
    },
    eventHandlers = {
        Died = onDeath,
    }
}
