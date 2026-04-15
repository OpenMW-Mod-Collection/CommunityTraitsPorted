local player

local function onInit(scriptData)
    player = scriptData.player
end

local function onDeath()
    player:sendEvent("CharacterTraits_rivalDied")
end

return {
    engineHandlers = {
        onInit = onInit,
    },
    eventHandlers = {
        Died = onDeath,
    }
}
