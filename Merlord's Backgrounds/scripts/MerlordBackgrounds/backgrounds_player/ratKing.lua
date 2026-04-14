local I = require("openmw.interfaces")
local self = require("openmw.self")

local traitType = require("scripts.MerlordBackgrounds.utils.traitTypes").background

I.CharacterTraits.addTrait {
    id = "ratKing",
    type = traitType,
    name = "Rat King",
    description = (
        "Discarded in the sewers as an infant, you were raised by rats. " ..
        "You now have an affinity for the furry beasts, and any you encounter will follow " ..
        "you wherever you go. Additionally, when fighting in the " ..
        "wilderness, a horde of rats may be summoned to aid you in battle. " ..
        "Your time spent in close proximity with your rodent friends has given you a " ..
        "potent odor\n" ..
        "\n" ..
        "> Rats become friendly. Talking to them will make them follow you.\n" ..
        "> Power to summon horde of rats.\n" ..
        "-20 Personality"
    ),
    doOnce = function()
        -- local armorer = self.type.stats.skills.armorer(self)
        -- armorer.base = armorer.base + 15

        -- local strength = self.type.stats.attributes.strength(self)
        -- strength.base = strength.base + 5

        -- local agility = self.type.stats.attributes.agility(self)
        -- agility.base = agility.base - 10
    end,
}