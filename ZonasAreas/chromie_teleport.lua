local npc = 50015

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Quiero ir de casería de Murlocs", 0, 1)
    player:GossipMenuAddItem(0, "Salir", 0, 2)
    player:GossipSendMenu(90000, object)
end
RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if intid == 2 then end

    player:GossipComplete()
end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
