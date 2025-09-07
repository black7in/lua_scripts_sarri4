local npc = 60501

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Reiniciar Prueba del Cruzado", 0, 1, false, "Esto borrará tu registro de la instancia. ¿Estás seguro?", 100000)
    player:GossipSendMenu(1, object)
end


local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if intid == 1 then
        local mapId = 1
        player:UnbindInstance( mapId )
        player:SendBroadcastMessage("Tu registro de la instancia ha sido reiniciado.")
    end
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)