local npc = 50020

local texto = "Saludos, aventurero. ¿Quieres participar en el reto semanal de Nurpy?\nPara participar, solo necesitas cumplir con algunos objetivos:\n1. Acumular 20 horas de juego.\n2. Superar el nivel 50.\n3. Recolecta 10 objetos perdidos de Nurpy.\n\nSi completas estos objetivos, recibirás una recompensa especial: Huevo de Lurky\nEste mascota cumple la funsión de abrir tu banco personal.\n\n¿Estás listo para el desafío?"

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Quiero participar en el reto semanal de Nurpy.", 0, 1)
    player:SendGossipText(texto, npc*10)
    player:GossipSendMenu(npc*10, creature)
end

local function OnGossipSelect(event, player, creature, sender, intid, code)
    if intid == 1 then
        if player:HasItem(122457) then -- Comprobar si el jugador tiene el objeto requerido
            player:RemoveItem(122457, 1) -- Quitar el objeto del inventario del jugador
            player:AddItem(140632, 1) -- Dar el objeto de participación en el reto semanal
            player:SendBroadcastMessage("Has sido inscrito en el reto semanal de Nurpy. ¡Buena suerte!")
        else
            player:SendBroadcastMessage("No tienes el objeto requerido para participar en el reto semanal de Nurpy.")
        end
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)