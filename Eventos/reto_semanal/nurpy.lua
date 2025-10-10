local npc = 50020

local texto = "Saludos, aventurero. ¿Quieres participar en el reto semanal de Nurpy?\nPara ganar, solo necesitas cumplir con algunos objetivos:\n1. Acumular 20 horas de juego.\n2. Superar el nivel 50.\n3. Recolecta 10 objetos perdidos de Nurpy.\n\nSi completas estos objetivos, recibirás una recompensa especial:\n1. |TINTERFACE/ICONS/inv_egg_03:15:15:0:0|t Huevo de Lurky\n2. |TINTERFACE/ICONS/spell_holy_summonchampion:15:15:0:0|t Emblemas de Triunfo x50.\n\n¿Estás listo para el desafío?"

texto = texto .. "\n\nImportante: El reto comienza desde el viernes a las 6:00 am  hasta el lunes a las 6:00 am. Asegúrate de completar los objetivos y recoger tu recompensa dentro de estas fechas."

local progreso = "Tu progreso actual es:\n- Horas jugadas: {}\n- Nivel alcanzado: {}\n- Objetos recolectados: {}\n\n¡Sigue así, estás en el camino correcto!"

local function OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Ver mi progreso.", 0, 1)
    player:GossipMenuAddItem(0, "Salir.", 0, 5)

    if(player:IsGM()) then
        player:GossipMenuAddItem(0, "Iniciar Evento - Solo Admins", 0, 4, true, "Ingresa la clave.")
    end

    player:SendGossipText(texto, npc*10)
    player:GossipSendMenu(npc*10, creature)
end

function obtenerTiempoJugado(player)
    local result = CharDBQuery("SELECT tiempo_total FROM characters_evento_semanal WHERE guid = " .. player:GetGUIDLow() .. ";")
    if result then
        local row = result:GetRow(0)
        return player:GetTotalPlayedTime() - row["tiempo_total"]
    else
        return player:GetTotalPlayedTime()
    end
end

function formatearTiempo(segundos)
    local horas = math.floor(segundos / 3600)
    local minutos = math.floor((segundos % 3600) / 60)
    local segs = segundos % 60

    return string.format("%02d:%02d:%02d", horas, minutos, segs)
end

local function OnGossipSelect(event, player, creature, sender, intid, code)
    if intid == 1 then
        player:GossipMenuAddItem(0, "Reclamar recompensa.", 0, 2)
        player:GossipMenuAddItem(0, "Atrás.", 0, 3)

        local horas_jugadas = formatearTiempo(obtenerTiempoJugado(player))
        local nivel = player:GetLevel()
        local objetos_recolectados = 0

        player:SendGossipText(formatString(progreso, horas_jugadas, nivel, objetos_recolectados), npc*10)
        player:GossipSendMenu(npc*10, creature)
    elseif intid == 2 then


        if player:GetLevel() < 50 then
            player:SendNotification("No has alcanzado el nivel 50 necesario.")
            player:GossipComplete()
            return
        end

        -- verficar si ya reclamó la recompensa
        local result = CharDBQuery("SELECT premio_reclamado FROM characters_evento_semanal WHERE guid = " .. player:GetGUIDLow() .. ";")
        if result then
            local row = result:GetRow(0)
            if row["premio_reclamado"] == 1 then
                player:SendNotification("Ya has reclamado tu recompensa esta semana.")
                player:GossipComplete()
                return
            end
        end

        CharDBExecute("INSERT INTO characters_evento_semanal (guid, tiempo_total, premio_reclamado) VALUES (" .. player:GetGUIDLow() .. ", " .. player:GetTotalPlayedTime() .. ", 1) ON DUPLICATE KEY UPDATE premio_reclamado = 1;")
        player:AddItem(39896, 1) -- Huevo de Lurky
        player:AddItem(40752, 50) -- Emblemas de Triunfo
    elseif intid == 3 then
        OnGossipHello(event, player, creature)
    elseif intid == 4 then
        if code == "warsitobb" then
            CharDBExecute("INSERT INTO characters_evento_semanal (guid, tiempo_total, premio_reclamado) SELECT guid, totaltime, 0 FROM characters;")
            player:SendBroadcastMessage("Evento semanal iniciado por un administrador.")
        else
            player:SendBroadcastMessage("Clave incorrecta.")
        end
    else
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)