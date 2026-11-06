local I = require("openmw.interfaces")
local self = require("openmw.self")
local time = require("openmw_aux.time")
local types = require("openmw.types")
local storage = require("openmw.storage")

local settings = storage.globalSection("SettingsMerlordBackgrounds_fencer")
local traitType = require("scripts.MerlordBackgrounds.utils.traitTypes").background

local function checkFencing()
    local rightHandItem = self.type.getEquipment(self, self.type.EQUIPMENT_SLOT.CarriedRight)
    local isFencing = rightHandItem
        and rightHandItem.type == types.Weapon
        and rightHandItem.type.records[rightHandItem.recordId].type == rightHandItem.type.TYPE.LongBladeOneHand

    local offhandItem = self.type.getEquipment(self, self.type.EQUIPMENT_SLOT.CarriedLeft)
    if offhandItem then
        if settings:get("ignoreLights") then
            isFencing = isFencing and not types.Armor.objectIsInstance(offhandItem)
        else
            isFencing = false
        end
    end

    return isFencing
end

local period = 1
local wasFencing = checkFencing()

local function updateLongBlade(amount)
    local longBlade = self.type.stats.skills.longblade(self)
    local direction = wasFencing and 1 or -1
    longBlade.base = longBlade.base + amount * direction
end

local function checkOffHand()
    if checkFencing() == wasFencing then return end
    wasFencing = not wasFencing
    updateLongBlade(20)
end

I.CharacterTraits.addTrait {
    id = "fencer",
    type = traitType,
    name = "Fencing Master",
    description = (
        "You have dedicated your life to the art of fencing.\n" ..
        "\n" ..
        "+20 Long Blade if your off-hand is free"
    ),
    doOnce = function ()
        if wasFencing then
            updateLongBlade(20)
        end
    end,
    onLoad = function()
        time.runRepeatedly(checkOffHand, period)
    end
}
