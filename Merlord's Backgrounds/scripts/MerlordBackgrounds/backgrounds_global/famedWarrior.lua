local world = require("openmw.world")

local function grantRep()
    local script = world.mwscript.getGlobalScript("mer_bg_addrep")
    if not script then return end
    script.variables.modRep = 1
end

return {
    eventHandlers = {
        CharacterTraits_grantRep = grantRep,
    }
}
