local I = require("openmw.interfaces")
local self = require("openmw.self")
local core = require("openmw.core")

local traitType = require("scripts.MerlordBackgrounds.utils.traitTypes").background

I.CharacterTraits.addTrait {
    id = "greenPact",
    type = traitType,
    name = "Green Pact",
    description = (
        "As a Bosmer, you have sworn an oath, known as the Green Pact, to the forest deity Y'ffre. " ..
        "One of the conditions of this pact states that you may only consume meat-based products." ..
        "\n" ..
        "\nRequirements: Wood Elves only."
    ),
    checkDisabled = function()
        ---@diagnostic disable-next-line: undefined-field
        return self.type.records[self.recordId].race ~= "wood elf"
    end,
    onLoad = function()
        core.sendGlobalEvent("MerlordsTraits_registerGreenPact", self.id)
    end,
}
