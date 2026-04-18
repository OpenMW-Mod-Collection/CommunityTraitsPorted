local I = require("openmw.interfaces")
local self = require("openmw.self")

local traitType = require("scripts.OblivionBackgrounds.utils.traitTypes").background

I.CharacterTraits.addTrait {
    id = "meridian",
    type = traitType,
    name = "Child of Light",
    description = (
        "Much of your life was spent in Meridia's Colored Rooms. " ..
        "Even now you can command the pure light of your home plane, " ..
        "and you can purify the tainted for a time, but you cannot tolerate necromancy, " ..
        "and the brilliant will of the Lady of Light has diminished your own.\n" ..
        "\n" ..
        "-20 Willpower\n" ..
        "> You start with a free Light and Turn Undead spell\n" ..
        "> You start with a powerful Command Humanoid power\n" ..
        "> You cannot summon undead creatures"
    ),
    doOnce = function()
        -- local selfSkills = self.type.stats.skills
        local selfAttrs = self.type.stats.attributes
        local selfSpells = self.type.spells(self)

        selfAttrs.willpower(self).base = selfAttrs.willpower(self).base - 20

        selfSpells:add("lack_gg_ColoredLights")
        selfSpells:add("lack_gg_GlisterWitch")
    end,
    onLoad = function()
        -- TODO
    end
}
