---@diagnostic disable: assign-type-mismatch
local self = require("openmw.self")
local core = require("openmw.core")

local player
local script

local function onInit(scriptData)
    player = scriptData.player
    script = scriptData.script
end

local function onDeath()
    player:sendEvent("CharacterTraits_slaverDied")
    core.sendGlobalEvent(
        "CharacterTraits_onScriptedActorDeath",
        {
            script = script,
            actor = self,
            clearInventory = false,
        }
    )
end

return {
    engineHandlers = {
        onInit = onInit,
    },
    eventHandlers = {
        Died = onDeath,
    }
}
