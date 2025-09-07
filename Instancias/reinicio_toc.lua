local npc = 60501
local cantidadOro = 5000000 -- 500 gold

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Reiniciar Registros de Prueba del Cruzado", 0, 1, false, "Esto borrará tu registro de la instancia. ¿Estás seguro?", cantidadOro)
    player:GossipMenuAddItem(0, "Salir", 0, 2)
    player:SendGossipText("Reinicia tus registros en TOC por oro y no esperes al reinicio semanal, al reiniciar cualquier progreso o registro obtenido en TOC será eliminado. Este reinicio es personal.\n\nUn reinicio afecta a todas las dificultades de la instancia.", npc)
    player:GossipSendMenu(npc, object)
end


local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if intid == 1 then
        local mapId = 649
        player:ModifyMoney( -cantidadOro )
        player:UnbindInstance( mapId )
        player:SendBroadcastMessage("Tu registro de la instancia ha sido reiniciado.")
    end

    player:GossipComplete()
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)