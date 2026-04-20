local angyCreatures = {

}
local script = ""
local registeredPlayers = {}

local function onActorActive(actor)
    if not angyCreatures[actor.recordId] or not next(registeredPlayers) then return end
    actor:addScript(script)
end

return {
    engineHandlers = {
        onActorActive = onActorActive,
    },
    eventHandlers = {
        Frana5usBackgrounds_registerDenyingGreen = function(player)
            registeredPlayers[player.id] = player
        end
    }
}