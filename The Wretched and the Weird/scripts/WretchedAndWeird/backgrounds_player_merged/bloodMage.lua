local I = require("openmw.interfaces")
local self = require("openmw.self")
local core = require("openmw.core")

local traitType = require("scripts.WretchedAndWeird.utils.traitTypes").background

I.CharacterTraits.addTrait {
    id = "bloodMage",
    type = traitType,
    name = "Blood Mage",
    description = (
        "You are a diabolical Blood Mage. You've studied techniques to directly harm the life force of your victims " ..
        "rather than using elemental magic. " ..
        "Years of self-experimentation with your own blood has left you with some vulnerabilities, however.\n" ..
        "\n" ..
        "+20% Weakness to Magicka\n" ..
        "> Spells using only damage health effects recoup half their magicka cost when cast"
    ),
    doOnce = function()
        -- local selfSkills = self.type.stats.skills
        -- local selfAttrs = self.type.stats.attributes
        local selfSpells = self.type.spells(self)

        selfSpells:add("lack_ww_BloodMageWeaknesses")
        selfSpells:add("lack_ww_BloodBolt")
    end,
    onLoad = function()
        local selfMagicka = self.type.stats.dynamic.magicka(self)
        local stopKeys = {
            ["self stop"] = true,
            ["touch stop"] = true,
            ["target stop"] = true,
        }

        I.AnimationController.addTextKeyHandler('spellcast', function(groupname, key)
            if not stopKeys[key] then return end

            local selectedSpell = self.type.getSelectedSpell(self)
            if not selectedSpell or selectedSpell ~= core.magic.SPELL_TYPE.Spell then return end

            for _, effect in ipairs(selectedSpell.effects) do
                if effect.id ~= core.magic.EFFECT_TYPE.DamageHealth then
                    return
                end
            end

            selfMagicka.current = math.min(
                selfMagicka.base + selfMagicka.modifier,
                selfMagicka.current + selectedSpell.cost / 2
            )
        end)
    end
}
