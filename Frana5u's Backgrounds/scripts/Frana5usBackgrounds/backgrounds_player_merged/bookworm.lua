local I = require("openmw.interfaces")
local self = require("openmw.self")
local storage = require("openmw.storage")

local traitType = require("scripts.Frana5usBackgrounds.utils.traitTypes").background

local buffType = I.ReadingIsGood
    and "> You get 1.5x larger skill gain multiplier from reading skill books"
    or "> You get double skills from skill books"

I.CharacterTraits.addTrait {
    id = "bookworm",
    type = traitType,
    name = "Bookworm",
    description = (
        "You have spent your life inside with your nose in a book. This made you physically weak, but lets you learn better "..
        "from books.\n" ..
        "\n" ..
        "-10 Strength and Endurance\n" ..
        buffType
    ),
    doOnce = function()
        -- local selfSkills = self.type.stats.skills
        local selfAttrs = self.type.stats.attributes
        -- local selfSpells = self.type.spells(self)

        selfAttrs.strength(self).base = selfAttrs.strength(self).base - 10
        selfAttrs.endurance(self).base = selfAttrs.endurance(self).base - 10
    end,
    onLoad = function()
        if I.ReadingIsGood then
            local settings = storage.playerSection("SettingsReadingIsGood")
            local bookBoost = settings:get("BOOK_BOOST")
            I.ReadingIsGood.modExpMult("skillId", bookBoost / 2)
        else

        end
    end
}
