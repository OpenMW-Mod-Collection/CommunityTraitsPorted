local I = require("openmw.interfaces")
local self = require("openmw.self")

local traitType = require("scripts.OblivionBackgrounds.utils.traitTypes").background

I.CharacterTraits.addTrait {
    id = "shivering",
    type = traitType,
    name = "Shivering Islander",
    description = (
        "You were born in the Madgod's Realm. You can still hear Sheogorath's voice at certain times (sound effect during full moons), " ..
        "and other people have a hard time understanding your disordered thoughts " ..
        " (-10 Speechcraft). You can share your madness with others (once-per-day Frenzy Power), " ..
        "and the constant hallucinations have made you relatively apt at discerning reality from the Madgod's visions (+10 Willpower)." ..

        "You were formed in the treacherous Spiral Skein, the dominion of Mephala. " ..
        "Swathed in falsehoods, your movements are as hidden as your intentions. " ..
        "Your strikes are venomous and made in anonymity. " ..
        "Webs beget webs, and your seat within the plots of others has scarred you. " ..
        "You persist still, holding onto the knowledge of plots and survival.\n" ..
        "\n" ..
        "+10 Willpower\n" ..
        "-10 Speechcraft\n" ..
        "> You start with a Frenzy power"
    ),
    doOnce = function()
        local selfSkills = self.type.stats.skills
        local selfAttrs = self.type.stats.attributes
        local selfSpells = self.type.spells(self)
        
        selfAttrs.willpower(self).base = selfAttrs.willpower(self).base + 10
        selfSkills.speechcraft(self).base = selfSkills.speechcraft(self).base - 10

        selfSpells:add("lack_gg_InfectiousInsanity")
    end,
    onLoad = function()
        -- TODO sound effect during full moons
    end
}
