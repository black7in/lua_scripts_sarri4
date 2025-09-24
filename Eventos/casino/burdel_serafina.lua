local npcSerafina = 60034

local florecitas = {
    60035,
    60036,
    60037,
}

local gossipTextSerafina = "¡Hola, guapo! ¿Quieres ver a mis florecitas? Solo cuesta 10 fichas.\n\nSi te gusta una de mis chicas podrás llevartela al privado por 10 fichas extra."

local function OnGossipHelloSerafina(event, player, object)
    player:GossipMenuAddItem(0, "Quiero ver a tus florecitas!", 0, 1, false, "Ver a las florecitas cuesta 10 fichas. ¿Quieres continuar?")
    player:GossipMenuAddItem(0, "Salir", 0, 3)
    player:SendGossipText(gossipTextSerafina, npcSerafina)
    player:GossipSendMenu(npcSerafina, object)
end

RegisterCreatureGossipEvent(npcSerafina, 1, OnGossipHelloSerafina)

local function OnGossipSelectSerafina(event, player, object, sender, intid, code, menu_id)
end

RegisterCreatureGossipEvent(npcSerafina, 2, OnGossipSelectSerafina)