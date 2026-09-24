local I = require("openmw.interfaces")
local self = require("openmw.self")
local time = require("openmw_aux.time")
local core = require("openmw.core")

local traitType = require("scripts.WretchedAndWeird.utils.traitTypes").background
local rewardWindow = require("scripts.WretchedAndWeird.ui.wretch")

local period = time.second

local firstLoad = false
local bgPicked = false
local rewardGiven = false
local stopLevelCheck

local function setInitSkills()
    local aamNotInstalled = not core.contentFiles.has("AbilitiesAreModifiers.omwscripts")
    local selfEffects = self.type.activeEffects(self)

    for name, handler in pairs(self.type.stats.skills) do
        local skill = handler(self)
        skill.base = math.min(skill.base, 15)

        if aamNotInstalled then
            local effect = selfEffects:getEffect(core.magic.EFFECT_TYPE.FortifySkill, name)
            skill.base = skill.base + effect.magnitude
        end
    end

    for name, handler in pairs(self.type.stats.attributes) do
        local attr = handler(self)
        attr.base = math.min(attr.base, 10)

        if aamNotInstalled then
            local effect = selfEffects:getEffect(core.magic.EFFECT_TYPE.FortifyAttribute, name)
            attr.base = attr.base + effect.magnitude
        end
    end
end

local function uiModeChanged(data)
    if not (bgPicked and data.newMode == "Training") then return end
    I.UI.setMode(data.oldMode, data.arg)
end

local function checkLevel()
    if self.type.stats.level(self).current < 20 then
        return
    end

    if rewardGiven then
        stopLevelCheck()
        return
    end

    rewardGiven = true
    rewardWindow.show()
    ---@diagnostic disable-next-line: missing-fields
    I.UI.setMode('Interface', { windows = {} })
    core.sendGlobalEvent('Pause', 'ui')
    stopLevelCheck()
end

I.CharacterTraits.addTrait {
    id = "wretch",
    type = traitType,
    name = "Wretch",
    description = (
        "Worthless. That is what you've been called all your life. " ..
        "You are weak, stupid, and unpleasant to look upon. " ..
        "You have never been trained in any useful profession, " ..
        "and lack the capacity to learn from others. " ..
        "You have no belongings, you do not have a single coin to your name, and you've been dumped into Morrowind " ..
        "without a stitch of clothing. " ..
        "It will take monumental effort to overcome these challenges, but if you do, you may blossom into something truly great.\n" ..
        "\n" ..
        "> All your attributes are set to 10\n" ..
        "> All your skills are set to 15 or lower\n" ..
        "> Training from NPCs is permanently disabled\n" ..
        "> Your inventory is completely emptied\n" ..
        "> You unlock special abilities if you survive to level 20"
    ),
    doOnce = function()
        firstLoad = true
    end,
    onLoad = function()
        bgPicked = true
        if not rewardGiven then
            stopLevelCheck = time.runRepeatedly(checkLevel, period)
        end
    end
}

local function onLoad(data)
    if not data then return end
    rewardGiven = data.rewardGiven or rewardGiven
end

local function onSave()
    return {
        rewardGiven = rewardGiven
    }
end

return {
    engineHandlers = {
        onLoad = onLoad,
        onSave = onSave,
    },
    eventHandlers = {
        UiModeChanged = uiModeChanged,
        CharacterTraits_allTraitsPicked = function()
            if firstLoad then
                setInitSkills()
                core.sendGlobalEvent("WretchedAndWeird_clrearInventory", self)
            end
        end,
    }
}
