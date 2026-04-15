---@diagnostic disable: assign-type-mismatch
local I = require("openmw.interfaces")
local self = require("openmw.self")
local core = require("openmw.core")
local time = require("openmw_aux.time")
local async = require("openmw.async")

local traitType = require("scripts.MerlordBackgrounds.utils.traitTypes").background
local raycast = require("scripts.MerlordBackgrounds.utils.raycast")

local period = time.minute
local rivalsSpawned = 0
local timerStarted = false
local minDelay = 1 * time.hour
local maxDelay = 7 * time.day -- why such a long delay? so it would be sudden, ofc
local spawnDistance = 300
local stopTimer
local bgPicked = false
local swordSpawned = false

local rivals = {
    "mer_bg_rival_01",
    "mer_bg_rival_02",
    "mer_bg_rival_03",
    "mer_bg_rival_04",
    "mer_bg_rival_05",
    "mer_bg_rival_06",
    "mer_bg_rival_07",
    "mer_bg_rival_08",
    "mer_bg_rival_09",
    "mer_bg_rival_10",
}

local spawnRival = async:registerTimerCallback(
    "spawnRival",
    function()
        core.sendGlobalEvent(
            "CharacterTraits_safeSpawn",
            {
                player = self,
                actor = rivals[rivalsSpawned + 1],
                script = "scripts/MerlordBackgrounds/backgrounds_custom/famedWarrior.lua",
                pos = raycast.findSafeSpawnPos(self, spawnDistance)
            }
        )
        timerStarted = false
        rivalsSpawned = rivalsSpawned + 1
    end
)

local function checkLevel()
    if rivalsSpawned > #rivals then
        stopTimer()
        return
    end

    local readyForRival = self.type.stats.level(self).current > rivalsSpawned
    if not readyForRival or timerStarted then return end

    async:newGameTimer(
        math.random(minDelay, maxDelay),
        spawnRival
    )
    timerStarted = true
end

I.CharacterTraits.addTrait {
    id = "famedWarrior",
    type = traitType,
    name = "Famed Warrior",
    description = (
        "Back in your homeland, you had a reputation as a mighty warrior. " ..
        "Renown comes with a price, however. There are many would-be heroes who would stake their claim " ..
        "as the warrior who finally defeated you in battle. As such, you will likely encounter these rivals in " ..
        "your travels.\n" ..
        "\n"..
        "+10 Long Blade\n"..
        "+10 Reputation\n"..
        "> You start with your infamous sword.\n" ..
        "> For each rival you defeat, your blade will grow in power."
    ),
    doOnce = function()
        core.sendGlobalEvent("CharacterTraits_grantRep", 10)
        -- not adding it until .51 fully gets released
        -- local rep = self.type.stats.reputation(self)
        -- rep.current = rep.current + 10

        local longBlade = self.type.stats.skills.longblade(self)
        longBlade.base = longBlade.base + 10
    end,
    onLoad = function()
        core.sendGlobalEvent("CharacterTraits_grantRep", 10)
        bgPicked = true
        stopTimer = time.runRepeatedly(checkLevel, period)
    end,
}

local function tryNamingSword()
    if not bgPicked or swordSpawned then return end

    -- upen UI for naming the sword
    -- it fires a global event to create the sword
    -- the rest will get figured later

    swordSpawned = true
end

local function onSave()
    return {
        slaversSpawned = rivalsSpawned,
        timerStarted = timerStarted,
        swordSpawned = swordSpawned
    }
end

local function onLoad(data)
    if not data then return end
    rivalsSpawned = data.slaversSpawned or rivalsSpawned
    timerStarted = data.timerStarted or timerStarted
    swordSpawned = data.swordSpawned or swordSpawned
end

return {
    engineHandlers = {
        onSave = onSave,
        onLoad = onLoad
    },
    eventHandlers = {
        CharacterTraits_allTraitsPicked = tryNamingSword,
    }
}
