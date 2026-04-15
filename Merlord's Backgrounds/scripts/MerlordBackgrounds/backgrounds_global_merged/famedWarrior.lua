---@diagnostic disable: missing-fields, discard-returns
local world = require("openmw.world")
local types = require("openmw.types")

local swordId = "mer_bg_famedSword"

local function grantRep()
    local script = world.mwscript.getGlobalScript("mer_bg_addrep")
    if not script then return end
    script.variables.modRep = 1
end

local function generateFamedSword(data)
    local record = types.Weapon.createRecordDraft {
        template = types.Weapon.records[swordId],
        name = data.swordName
    }
    local sword = world.createObject(record.id)
    sword:moveInto(data.player)
    data.player:sendEvent("CharacterTraits_swordRecieved", sword)

---@diagnostic disable-next-line: undefined-field
    data.player:sendEvent("ShowMessage", { message = "Your sword has been named " .. sword.name .. "." })
end

local function upgradeSword(data)
    local player = data.player

    local oldSword = player.type.inventory(player):find(swordId)
    if not oldSword then return end

    local swordLevel = data.swordLevel
    local swordInitRecord = types.Weapon.records[swordId]
    -- TODO upgrade enchant
    -- TODO upgrade sword
    local record = types.Weapon.createRecordDraft {
        template = swordInitRecord,
    }
    local newSword = world.createObject(record.id)
    
    oldSword:remove()
    newSword:moveInto(player)

---@diagnostic disable-next-line: undefined-field
    player:sendEvent("ShowMessage", { message = newSword.name .. " has grown more powerful." })
end

return {
    eventHandlers = {
        CharacterTraits_grantRep = grantRep,
        CharacterTraits_generateFamedSword = generateFamedSword,
        CharacterTraits_upgradeSword = upgradeSword,
    }
}
