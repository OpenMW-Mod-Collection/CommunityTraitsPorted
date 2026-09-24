local I = require("openmw.interfaces")

local U = require("scripts.SagesBackgrounds.utils.scriptMerger")
local deps = require("scripts.SagesBackgrounds.utils.dependencies")

deps.checkAll("Sage's Backgrounds", { {
    plugin = "CharacterTraitsFramework.omwscripts",
    interface = I.CharacterTraits,
} })

local folderPath = "scripts/SagesBackgrounds/backgrounds_player_merged/"

return U.mergeAllHandlers(folderPath)
