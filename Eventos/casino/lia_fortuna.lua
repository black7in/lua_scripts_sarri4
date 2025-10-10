local npc = 60039

local function OnGossipHello(event, player, creature)

    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Quiero participar en el reto semanal.", 0, 1)
end


local function OnGossipSelect(event, player, creature, sender, intid, code)

end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)