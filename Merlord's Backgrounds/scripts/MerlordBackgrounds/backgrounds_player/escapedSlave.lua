---@diagnostic disable: assign-type-mismatch
local I = require("openmw.interfaces")
local self = require("openmw.self")
local core = require("openmw.core")
local time = require("openmw_aux.time")
local async = require("openmw.async")

local traitType = require("scripts.MerlordBackgrounds.utils.traitTypes").background
local raycast = require("scripts.MerlordBackgrounds.utils.raycast")

local period = time.minute
local slaversKilled = 0
local timerStarted = false
local minDelay = 1 * time.hour
local maxDelay = 7 * time.day -- why such a long delay? so it would be sudden, ofc
local spawnDistance = 300
local stopTimer

local slavers = {
    "mer_bg_headhunter_01",
    "mer_bg_headhunter_02",
    "mer_bg_headhunter_03",
    "mer_bg_headhunter_04",
    "mer_bg_headhunter_05",
    "mer_bg_slavemaster",
}

local spawnSlaver = async:registerTimerCallback(
    "spawnSlaver",
    function()
        core.sendGlobalEvent(
            "CharacterTraits_safeSpawn",
            {
                player = self,
                actor = slavers[slaversKilled + 1],
                script = "scripts/MerlordBackgrounds/backgrounds_custom/escapedSlave.lua",
                pos = raycast.findSafeSpawnPos(self, spawnDistance)
            }
        )
        timerStarted = true
    end
)

local function checkLevel()
    if slaversKilled > #slavers then
        stopTimer()
        return
    end

    local readyForSlaver = self.type.stats.level(self).current > slaversKilled
    if not readyForSlaver or timerStarted then return end

    async:newGameTimer(
        math.random(minDelay, maxDelay),
        spawnSlaver
    )
    timerStarted = true
end

I.CharacterTraits.addTrait {
    id = "escapedSlave",
    type = traitType,
    name = "Escaped Slave",
    description = (
        "You are the property of a wealthy slaver, but you managed to escape... at least for now. " ..
        "Your former owner does not tolerate such disobedience, and has sent a team of headhunters to " ..
        "track you down and kill you, lest the other slaves get any flase hope about ever being free.\n" ..
        "\n" ..
        "Requirements: Khajiit or Argonian only."
    ),
    checkDisabled = function()
        ---@diagnostic disable-next-line: undefined-field
        local race = self.type.records[self.recordId].race
        return race ~= "argonian" and race ~= "khajiit"
    end,
    doOnce = function()
        core.sendGlobalEvent(
            "CharacterTraits_addItems",
            {
                {
                    player = self,
                    itemId = "slave_bracer_left",
                    count = 1,
                    autoEquip = true,
                },
                {
                    player = self,
                    itemId = "slave_bracer_right",
                    count = 1,
                    autoEquip = true,
                },
            }
        )
    end,
    onLoad = function()
        stopTimer = time.runRepeatedly(checkLevel, period)
    end,
}

local function slaverDied()
    slaversKilled = slaversKilled + 1
end

local function onSave()
    return {
        dremorasKilled = slaversKilled,
        timerStarted = timerStarted,
    }
end

local function onLoad(data)
    if not data then return end
    slaversKilled = data.dremorasKilled or slaversKilled
    timerStarted = data.dremoraTimerStarted or timerStarted
end

return {
    engineHandlers = {
        onSave = onSave,
        onLoad = onLoad
    },
    eventHandlers = {
        CharacterTraits_slaverDied = slaverDied,
    }
}
