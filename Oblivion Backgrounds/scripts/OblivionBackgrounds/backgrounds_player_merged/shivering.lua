local I = require("openmw.interfaces")
local self = require("openmw.self")
local core = require("openmw.core")
local time = require("openmw_aux.time")

local traitType = require("scripts.OblivionBackgrounds.utils.traitTypes").background

I.CharacterTraits.addTrait {
    id = "shivering",
    type = traitType,
    name = "Shivering Islander",
    description = (
        "You were born in the Madgod's Realm. You can still hear Sheogorath's voice at certain times, " ..
        "and other people have a hard time understanding your disordered thoughts. " ..
        "You can share your madness with others, " ..
        "and the constant hallucinations have made you relatively apt at discerning reality from the Madgod's visions.\n" ..
        "\n" ..
        "+10 Willpower\n" ..
        "-10 Speechcraft\n" ..
        "+15 pt Sound on nights of the full moon\n" ..
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
        local SPELL_ID = "lack_gg_SheoWhispers"
        local selfSpells = self.type.spells(self)

        local MOONS = {
            masser  = { cycleDays = 24, fullPhase = 0 },
            secunda = { cycleDays = 32, fullPhase = 0 },
        }
        local NIGHT_START = 20
        local NIGHT_END = 6
        local period = 1

        local function isNight(hour)
            return hour >= NIGHT_START or hour < NIGHT_END
        end

        local function isMoonFull(moon, gameTime)
            local day = math.floor((gameTime - NIGHT_END * time.hour) / time.day)
            local phase = math.floor((day % moon.cycleDays) / (moon.cycleDays / 8))
            return phase == moon.fullPhase
        end

        local function isAnyMoonFull(gameTime)
            for _, moon in pairs(MOONS) do
                if isMoonFull(moon, gameTime) then
                    return true
                end
            end
            return false
        end

        local function update()
            local gameTime = core.getGameTime()
            local hour = (gameTime / time.hour) % 24
            local active = isNight(hour) and isAnyMoonFull(gameTime)
            local hasSpell = selfSpells[SPELL_ID] ~= nil

            if active and not hasSpell then
                selfSpells:add(SPELL_ID)
                self:sendEvent("ShowMessage", { message = "You begin to hear voices..." })
            elseif not active and hasSpell then
                selfSpells:remove(SPELL_ID)
                self:sendEvent("ShowMessage", { message = "The shadowed moons quiet the voices..." })
            end
        end

        update()
        time.runRepeatedly(update, period)
    end
}
