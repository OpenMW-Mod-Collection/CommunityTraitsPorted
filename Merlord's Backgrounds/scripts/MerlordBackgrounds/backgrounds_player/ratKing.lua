local I = require("openmw.interfaces")
local self = require("openmw.self")
local core = require("openmw.core")
local types = require("openmw.types")
local time = require("openmw_aux.time")
local storage = require("openmw.storage")

local traitType = require("scripts.MerlordBackgrounds.utils.traitTypes").background
local raycast = require("scripts.MerlordBackgrounds.utils.raycast")
local rats = require("scripts.MerlordBackgrounds.utils.rats")
local settings = storage.globalSection("SettingsMerlordBackgrounds_ratKing")

local spawnDistance = 300
local bgPicked = false
local lastRatSpawn = 0

I.CharacterTraits.addTrait {
    id = "ratKing",
    type = traitType,
    name = "Rat King",
    description = (
        "Discarded in the sewers as an infant, you were raised by rats. " ..
        "You now have an affinity for the furry beasts, and any you encounter will follow " ..
        "you wherever you go no matter what. " ..
        "Unfortunately, your time spent in close proximity with your rodent friends has given you a " ..
        "potent odor.\n" ..
        "\n" ..
        "-20 Personality\n" ..
        "> Rats start follow you wherever you go.\n" ..
        "> In wilderness occasionaly a few rats will join you in fight."
    ),
    doOnce = function()
        local personality = self.type.stats.attributes.personality(self)
        personality.base = personality.base - 20
    end,
    onLoad = function()
        bgPicked = true
    end
}

local function localEnemyTargetChanged(data)
    if not bgPicked then return end

    if rats.isRat(data.actor) then
        for _, target in ipairs(data.targets) do
            if target.type == self.type then
                data.actor:sendEvent("RemoveAIPackages", "Combat")
                data.actor:sendEvent("StartAIPackage", { type = "Follow", target = self })
                break
            end
        end
    else
        local offCooldown = core.getSimulationTime() - lastRatSpawn >= settings:get("spawnCooldown") * time.hour
        local randomProc = math.random() < settings:get("spawnChance") / 100
        local inWild = self.cell
            and not self.cell:hasTag("NoSleep")
            and (self.cell.isExterior or self.cell.isQuasiExterior)
        if offCooldown and randomProc and inWild then
            lastRatSpawn = core.getSimulationTime()
            local spawnData = {
                player = self,
                actor = "Rat",
                pos = raycast.findSafeSpawnPos(self, spawnDistance)
            }
            local count = math.random(
                settings:get("minSpawn"),
                settings:get("maxSpawn")
            )
            for _ = 1, count do
                core.sendGlobalEvent("MerlordsTraits_safeSpawn", spawnData)
            end
        end
    end
end

local function onSave()
    return {
        lastRatSpawn = lastRatSpawn
    }
end

local function onLoad(data)
    if not data then return end
    lastRatSpawn = data.lastRatSpawn or lastRatSpawn
end

return {
    engineHandlers = {
        onSave = onSave,
        onLoad = onLoad,
    },
    eventHandlers = {
        OMWMusicCombatTargetsChanged = localEnemyTargetChanged,
    }
}
