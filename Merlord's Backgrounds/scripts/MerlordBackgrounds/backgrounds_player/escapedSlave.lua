---@diagnostic disable: assign-type-mismatch
local I = require("openmw.interfaces")
local self = require("openmw.self")
local core = require("openmw.core")
local time = require("openmw_aux.time")
local async = require("openmw.async")
local storage = require("openmw.storage")

local traitType = require("scripts.MerlordBackgrounds.utils.traitTypes").background
local raycast = require("scripts.MerlordBackgrounds.utils.raycast")
local raceCheckers = require("scripts.MerlordBackgrounds.utils.raceGroups")

local settings = storage.globalSection("SettingsMerlordBackgrounds_escapedSlave")
local period = time.minute
local spawnDistance = 300
local stopTimer

local slaversSpawned = 0
local timerStarted = false

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
            "MerlordsTraits_safeSpawn",
            {
                player = self,
                actor = slavers[slaversSpawned + 1],
                pos = raycast.findSafeSpawnPos(self, spawnDistance)
            }
        )
        timerStarted = false
        slaversSpawned = slaversSpawned + 1
    end
)

local function checkLevel()
    if slaversSpawned > #slavers then
        stopTimer()
        return
    end

    local readyForSlaver = self.type.stats.level(self).current > slaversSpawned * settings:get("ES_levelsPerEnemy")
    if not readyForSlaver or timerStarted then return end

    async:newGameTimer(
        math.random(settings:get("ES_minDelay"), settings:get("ES_maxDelay")),
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
        return not raceCheckers.isKhajiit(self)
            ---@diagnostic disable-next-line: undefined-field
            and self.type.records[self.recordId].race ~= "argonian"
    end,
    doOnce = function()
        core.sendGlobalEvent(
            "MerlordsTraits_addItems",
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

local function onSave()
    return {
        slaversSpawned = slaversSpawned,
        timerStarted = timerStarted,
    }
end

local function onLoad(data)
    if not data then return end
    slaversSpawned = data.slaversSpawned or slaversSpawned
    timerStarted = data.timerStarted or timerStarted
end

return {
    engineHandlers = {
        onSave = onSave,
        onLoad = onLoad
    },
}
