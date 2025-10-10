local npc = 50020

local texto = "Saludos, aventurero. ¿Quieres participar en el reto semanal de Nurpy?\nPara ganar, solo necesitas cumplir con algunos objetivos:\n1. Acumular 20 horas de juego.\n2. Superar el nivel 50.\n3. Recolecta 10 objetos perdidos de Nurpy.\n\nSi completas estos objetivos, recibirás una recompensa especial:\n1. |TINTERFACE/ICONS/inv_egg_03:15:15:0:0|t Huevo de Lurky\n2. |TINTERFACE/ICONS/spell_holy_summonchampion:15:15:0:0|t Emblemas de Triunfo x50.\n\n¿Estás listo para el desafío?"

texto = texto .. "\n\nImportante: El reto comienza desde el viernes a las 6:00 am  hasta el lunes a las 6:00 am. Asegúrate de completar los objetivos y recoger tu recompensa dentro de estas fechas."

local progreso = "Tu progreso actual es:\n- Horas jugadas: {}\n- Nivel alcanzado: {}\n- Objetos recolectados: {}\n\n¡Sigue así, estás en el camino correcto!"

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Ver mi progreso.", 0, 1)
    player:GossipMenuAddItem(0, "Salir.", 0, 5)
    player:SendGossipText(texto, npc*10)
    player:GossipSendMenu(npc*10, creature)
end

local function OnGossipSelect(event, player, creature, sender, intid, code)
    if intid == 1 then
        player:GossipMenuAddItem(0, "Reclamar recompensa.", 0, 2)
        player:GossipMenuAddItem(0, "Atrás.", 0, 3)

        local horas_jugadas = "0h20m59s"
        local nivel = player:GetLevel()
        local objetos_recolectados = 0

        player:SendGossipText(formatString(progreso, horas_jugadas, nivel, objetos_recolectados), npc*10)
        player:GossipSendMenu(npc*10, creature)
    elseif intid == 2 then

    end
    player:GossipComplete()
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)