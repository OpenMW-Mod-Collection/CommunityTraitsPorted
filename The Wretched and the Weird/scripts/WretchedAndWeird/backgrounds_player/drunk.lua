local I = require("openmw.interfaces")
local self = require("openmw.self")
local time = require("openmw_aux.time")
local types = require("openmw.types")
local core = require("openmw.core")
local storage = require("openmw.storage")

local traitType = require("scripts.WretchedAndWeird.utils.traitTypes").background
local settings = storage.playerSection("SettingsWretchedAndWeird_drunk")

local period = 5
local bgPicked = false
local lastDrinkTimeIngame = core.getGameTime()
local stopTimer
local recovered = false
local debuffed = false

local function checkSoberity()
    if lastDrinkTimeIngame + settings:get("drunkTime") * time.hour >= core.getGameTime() or recovered then return end

    if lastDrinkTimeIngame + settings:get("recoveryTime") * time.day < core.getRealTime() then
        if debuffed then
            local agility = self.type.stats.attributes.agility(self)
            agility.base = agility.base + 30
            local faituge = self.type.stats.dynamic.fatigue(self)
            faituge.base = faituge.base + 10
            debuffed = false
        end

        recovered = true
        stopTimer()
        I.UI.showInteractiveMessage(
            "It feels like ages since you've had a drink, " ..
            "but strangely, you don't feel compelled to find one.\n\n" ..
            "You will no longer experience alcohol withdrawal."
        )
        return
    end

    if not debuffed then
        local agility = self.type.stats.attributes.agility(self)
        agility.base = agility.base - 30
        local faituge = self.type.stats.dynamic.fatigue(self)
        faituge.base = faituge.base - 10

        debuffed = true
        self:sendEvent("ShowMessage", { message = "You could use a drink..." })
    end
end

I.CharacterTraits.addTrait {
    id = "drunk",
    type = traitType,
    name = "Drunkard",
    description = (
        "For as long as you can remember (which admittedly isn't very long), you've needed a drink to get through the working day. " ..
        "You've got a strong stomach, but on days where you can't get a drink your hands shake and you feel awful. " ..
        "You could probably kick the habit if you endured the withdrawal long enough, but it would be tough.\n" ..
        "\n" ..
        "+15 Endurance\n" ..
        "-50 Fatigue while you're not drunk\n" ..
        "-30 Agility while you're not drunk\n" ..
        "> Not drinking for a long time might make you recover from your addiction"
    ),
    doOnce = function()
        local endurance = self.type.stats.attributes.endurance(self)
        endurance.base = endurance.base + 15
    end,
    onLoad = function()
        bgPicked = true
        if not recovered then
            stopTimer = time.runRepeatedly(checkSoberity, period)
        end
    end
}

local function onConsume(item)
    if not bgPicked or item.type ~= types.Potion or recovered then return end

    if I.SunsDusk then
        local _, typ = I.SunsDusk.isConsumable(item)
        if typ and typ == "cooked" then
            return
        end
    end

    lastDrinkTimeIngame = core.getGameTime()

    if debuffed then
        local agility = self.type.stats.attributes.agility(self)
        agility.base = agility.base + 30
        local faituge = self.type.stats.dynamic.fatigue(self)
        faituge.base = faituge.base + 10

        self:sendEvent("ShowMessage", { message = "Finally, a drink!" })
        debuffed = false
    end
end

local function onLoad(data)
    if not data then return end
    lastDrinkTimeIngame = data.lastDrinkTimeIngame or lastDrinkTimeIngame
    recovered = data.recovered or recovered
    debuffed = data.debuffed or debuffed
end

local function onSave()
    return {
        lastDrinkTimeIngame = lastDrinkTimeIngame,
        recovered = recovered,
        debuffed = debuffed,
    }
end

return {
    engineHandlers = {
        onLoad = onLoad,
        onSave = onSave,
        onConsume = onConsume,
    }
}
