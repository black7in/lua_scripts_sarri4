local npc = 50016

local text = "¡Saludos, aventurero! Soy Gurky, el maestro de los retos de leveo. Tengo desafíos únicos para poner a prueba tu valor, tu ingenio… y tu paciencia.\nPero cuidado: solo puedes elegir un reto, y una vez que lo aceptes, no hay marcha atrás. Tu camino quedará sellado hasta el final.\n\nAsí que elige sabiamente… y que la marea esté de tu lado.\n\n|cffff0000IMPORTANTE!!|r: Si no aceptas ningún reto tu progreso en el leveo es normal sin ningun tipo de restricciones con rates x6."

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    if player:GetLevelUpType() == LEVEL_TYPE_NORMAL then
        player:GossipMenuAddItem(0, "|TINTERFACE/ICONS/INV_Chest_Leather_09:28:28:-15:0|t Reto Artesano", 0, 2)
        player:GossipMenuAddItem(0, "|TINTERFACE/ICONS/Ability_Creature_Cursed_02:28:28:-15:0|t Reto Hardcore", 0, 1)
        player:GossipMenuAddItem(0, "|TINTERFACE/ICONS/inv_misc_head_murloc_01:28:28:-15:0|t Reto Murlocfóbico", 0, 3)
        player:GossipMenuAddItem(0, "|TINTERFACE/ICONS/Trade_BlackSmithing:28:28:-15:0|t Reto Maestro de Oficios", 0, 4)
    end

    if player:GetLevelUpType() == LEVEL_TYPE_MURLOCFOBICO then
        player:GossipMenuAddItem(0, "|TINTERFACE/ICONS/inv_misc_head_murloc_01:28:28:-15:0|t Zona de Murlocfóbicos", 0, 12, false, "Seguro que quieres ir a la zona de Murlocfóbicos? Aquí solo podrás subir de nivel matando Murlocs. ¡Buena suerte!")
    end
    player:GossipMenuAddItem(0, "Salir", 0, 10)
    player:SendGossipText(text, npc)
    player:GossipSendMenu(npc, object)
end
RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    player:GossipClearMenu()
    local playerName = player:GetName()
    if intid == 1 then
        --player:SendBroadcastMessage("¡Has elegido el Reto Hardcore! Prepárate para una experiencia desafiante.")
        local mensaje = "En este desafío, cada combate es una apuesta con tu vida. Si mueres, tu aventura termina para siempre. Solo los más cautelosos, estratégicos y valientes llegarán al final. ¿Tienes lo necesario para sobrevivir?"
        mensaje = mensaje .. "\n\nSi quieres mas información sobre este reto como reglas y premios, vista el canal de Discord o nuestro sitio web."
        player:GossipMenuAddItem(0, "Aceptar reto", intid, 11, false, "Estás seguro de que quieres aceptar el Reto Hardcore?.")
        player:GossipMenuAddItem(0, "Atras", 0, 20)
        player:SendGossipText(mensaje, npc)
        player:GossipSendMenu(npc, object)
    elseif intid == 2 then
        --player:SendBroadcastMessage("¡Has elegido el Reto Artesano! ¡A mejorar tus habilidades!")
        local mensaje = "Aquí no hay botines fáciles ni regalos de monstruos caídos. Todo lo que uses deberá haber sido creado por ti mismo, usando tus profesiones. Forja tu propia armadura, fabrica tus armas y demuestra que un verdadero héroe se construye… pieza a pieza."
        mensaje = mensaje .. "\n\nSi quieres mas información sobre este reto como reglas y premios, vista el canal de Discord o nuestro sitio web."
        player:GossipMenuAddItem(0, "Aceptar reto", intid, 11, false, "Estás seguro de que quieres aceptar el Reto Artesano?.")
        player:GossipMenuAddItem(0, "Atras", 0, 20)
        player:SendGossipText(mensaje, npc)
        player:GossipSendMenu(npc, object)
    elseif intid == 3 then
        --player:SendBroadcastMessage("¡Has elegido el Reto Murlocfóbico! ¡A cazar Murlocs se ha dicho!")
        local mensaje = "Solo podrás subir de nivel matando Murlocs. No hay lobos, no hay orcos, no hay dragones: tu destino está ligado a esas criaturas parlantes de la costa. Conviértete en la pesadilla de todo Murloc que ose cruzarse en tu camino."
        mensaje = mensaje .. "\n\nSi quieres mas información sobre este reto como reglas y premios, vista el canal de Discord o nuestro sitio web."
        player:GossipMenuAddItem(0, "Aceptar reto", intid, 11, false, "Estás seguro de que quieres aceptar el Reto Murlocfóbico?.")
        player:GossipMenuAddItem(0, "Atras", 0, 20)
        player:SendGossipText(mensaje, npc)
        player:GossipSendMenu(npc, object)
    elseif intid == 4 then
        --player:SendBroadcastMessage("¡Has elegido el Reto Maestro de Oficios! ¡A dominar las profesiones!")
        local mensaje = "Nada de espadas ni de arcos: tu poder proviene de tus profesiones. Sube de nivel únicamente fabricando, recolectando y perfeccionando tus habilidades artesanales. Un reto para mentes pacientes y manos maestras."
        mensaje = mensaje .. "\n\nSi quieres mas información sobre este reto como reglas y premios, vista el canal de Discord o nuestro sitio web."
        player:GossipMenuAddItem(0, "Aceptar reto", intid, 11, false, "Estás seguro de que quieres aceptar el Reto Maestro de Oficios?.")
        player:GossipMenuAddItem(0, "Atras", 0, 20)
        player:SendGossipText(mensaje, npc)
        player:GossipSendMenu(npc, object)
    elseif intid == 10 then
        object:SendUnitSay("¡Hasta luego! ¡Buena suerte con tus retos!", 0)
        player:GossipComplete()
    elseif intid == 20 then
        OnGossipHello(event, player, object)
    elseif intid == 11 then
        if player:GetLevel() > 1 then
            player:SendNotification("¡Ya has comenzado tu aventura! No eres nivel 1.")
            player:GossipComplete()
            return
        end

        if player:GetLevelUpType() ~= LEVEL_TYPE_NORMAL then
            player:SendNotification("¡Ya has aceptado un reto! No puedes cambiarlo.")
            player:GossipComplete()
            return
        end

        if sender == 1 then
            -- Reto Hardcore
            player:SetLevelUpType(LEVEL_TYPE_HARDCORE)
            player:SendBroadcastMessage("¡Has aceptado el Reto Hardcore! Tu aventura será más desafiante.")
            --player:AddQuest( 60000 )
            -- Anunciar al mundo
            local mensaje = "|cffff0000[RETO HARDCORE]|r El jugador |cff00ff00" .. player:GetName() .. "|r ha aceptado el Reto Hardcore. ¡Que la suerte esté de su lado!"
            SendWorldMessage(mensaje)

            local json = [[
                {
                  "embeds": [
                    {
                      "title": "📢 Reto Hardcore",
                      "description": "El jugador **]] .. playerName .. [[** ha aceptado el Reto Hardcore. ¡Mucha suerte! ☠️",
                      "color": 16711680
                    }
                  ]
                }
            ]]

            HttpRequest(
                "POST",
                "https://discord.com/api/webhooks/1422991114763505745/1QpTnuBum1Ae3KdUEx0uw2wChSBMSnfUcKDes3K43Pc0O5NNSv7PjVUV9ulwwzk1IbTW",
                json,
                "application/json",
                function(status, body, headers)
                    -- print("Webhook enviado. Estado: " .. status)
                    -- if body then
                        -- print("Respuesta: " .. body)
                    -- end
                end
            )
        elseif sender == 2 then
            -- Reto Artesano
            player:SetLevelUpType(LEVEL_TYPE_ARTESANO)
            player:SendBroadcastMessage("¡Has aceptado el Reto Artesano! Tu habilidad en las profesiones será tu mayor aliado.")
            --player:AddQuest( 60002 )

            -- Anunciar al mundo
            local mensaje = "|cffff0000[RETO ARTESANO]|r El jugador |cff00ff00" .. player:GetName() .. "|r ha aceptado el Reto Artesano. ¡A crear se ha dicho!"
            SendWorldMessage(mensaje)
        elseif sender == 3 then
            -- Reto Murlocfóbico
            player:SetLevelUpType(LEVEL_TYPE_MURLOCFOBICO)
            player:SendBroadcastMessage("¡Has aceptado el Reto Murlocfóbico! Tu destino está ligado a los Murlocs.")
            --player:AddQuest( 60003 )

            -- anunciar al mundo
            local mensaje = "|cffff0000[RETO MURLOCFÓBICO]|r El jugador |cff00ff00" .. player:GetName() .. "|r ha aceptado el Reto Murlocfóbico. ¡A cazar Murlocs se ha dicho!"
            SendWorldMessage(mensaje)
        elseif sender == 4 then
            -- Reto Maestro de Oficios
            player:SetLevelUpType(LEVEL_TYPE_MAESTRO)
            player:SendBroadcastMessage("¡Has aceptado el Reto Maestro de Oficios! Tu poder proviene de tus profesiones.")
            --player:AddQuest( 60004 )

            -- anunciar al mundo
            local mensaje = "|cffff0000[RETO MAESTRO DE OFICIOS]|r El jugador |cff00ff00" .. player:GetName() .. "|r ha aceptado el Reto Maestro de Oficios. ¡A dominar las profesiones!"
            SendWorldMessage(mensaje)

            local json = [[
                {
                  "embeds": [
                    {
                      "title": "📢 Reto Maestro de Oficios",
                      "description": "El jugador **]] .. playerName .. [[** ha aceptado el Reto Maestro de Oficios. ¡Mucha suerte!",
                      "color": 16711680
                    }
                  ]
                }
            ]]

            HttpRequest(
                "POST",
                "https://discord.com/api/webhooks/1422991114763505745/1QpTnuBum1Ae3KdUEx0uw2wChSBMSnfUcKDes3K43Pc0O5NNSv7PjVUV9ulwwzk1IbTW",
                json,
                "application/json",
                function(status, body, headers)
                    -- print("Webhook enviado. Estado: " .. status)
                    -- if body then
                        -- print("Respuesta: " .. body)
                    -- end
                end
            )
        end

        object:SendUnitSay("¡Excelente elección! Que la marea esté de tu lado.", 0)
        player:GossipComplete()
    elseif intid == 12 then
        player:Teleport(1, 4617.81, -3851.19, 944.648, 1.09499)
        player:SendBroadcastMessage("¡Bienvenido a la zona de Murlocfóbicos! Aquí podrás subir de nivel matando Murlocs. ¡Buena suerte!")
        player:GossipComplete()
    end
    --player:GossipComplete()
end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)


local function OnCanQuestAccept(event, player, quest)
    if quest == 60000 then
        if player:GetLevelUpType() ~= LEVEL_TYPE_HARDCORE then
            player:SendNotification("¡No puedes aceptar esta misión! Solo disponible para el Reto Hardcore.")
            return false
        end
    elseif quest == 60002 then
        if player:GetLevelUpType() ~= LEVEL_TYPE_ARTESANO then
            player:SendNotification("¡No puedes aceptar esta misión! Solo disponible para el Reto Artesano.")
            return false
        end
    elseif quest == 60003 then
        if player:GetLevelUpType() ~= LEVEL_TYPE_MURLOCFOBICO then
            player:SendNotification("¡No puedes aceptar esta misión! Solo disponible para el Reto Murlocfóbico.")
            return false
        end
    elseif quest == 60004 then
        if player:GetLevelUpType() ~= LEVEL_TYPE_MAESTRO then
            player:SendNotification("¡No puedes aceptar esta misión! Solo disponible para el Reto Maestro de Oficios.")
            return false
        end
    end

    return true
end

RegisterPlayerEvent(64, OnCanQuestAccept)

local function OnQuestAdd(event, player, quest)
    if quest >= 60000 and quest <= 60004 then
        --print("Quest ID: " .. quest .. " added for player: " .. player:GetName())
        local level = player:GetLevel()
        player:SendQuestUpdateAddCreature(quest, 0, level)
    end
end 

RegisterPlayerEvent(65, OnQuestAdd)

local function OnLevelChange(event, player, oldLevel)
    if player:HasQuest(60000) then
        local level = player:GetLevel()
        local cantidad = level - oldLevel
        -- Aqu hay que arreglar que tamien se pueda enviar valores negativos y no solo de uint
        player:SendQuestUpdateAddCreature(60000, 0, cantidad)
    end

    if player:HasQuest(60001) then
        local level = player:GetLevel()
        local cantidad = level - oldLevel
        -- Aqu hay que arreglar que tamien se pueda enviar valores negativos y no solo de uint
        player:SendQuestUpdateAddCreature(60001, 0, cantidad)
    end

    if player:HasQuest(60002) then
        local level = player:GetLevel()
        local cantidad = level - oldLevel
        -- Aqu hay que arreglar que tamien se pueda enviar valores negativos y no solo de uint
        player:SendQuestUpdateAddCreature(60002, 0, cantidad)
    end

    if player:HasQuest(60003) then
        local level = player:GetLevel()
        local cantidad = level - oldLevel
        -- Aqu hay que arreglar que tamien se pueda enviar valores negativos y no solo de uint
        player:SendQuestUpdateAddCreature(60003, 0, cantidad)
    end

    if player:HasQuest(60004) then
        local level = player:GetLevel()
        local cantidad = level - oldLevel
        -- Aqu hay que arreglar que tamien se pueda enviar valores negativos y no solo de uint
        player:SendQuestUpdateAddCreature(60004, 0, cantidad)
    end

end

RegisterPlayerEvent(13, OnLevelChange)



local function OnKillPlayer(event, killer, killed)
    if killed:ToPlayer() then
        if killed:GetLevelUpType() == LEVEL_TYPE_HARDCORE then
            local message = "|cffff0000[RETO HARDCORE]|r El jugador |cff00ff00" .. killed:GetName() .. "|r ha muerto en nivel ".. killed:GetLevel() ..". Lamentablemente su aventura termina aquí."
            SendWorldMessage(message)

            local json = [[
                {
                  "embeds": [
                    {
                      "title": "📢 Reto Hardcore",
                      "description": "El jugador **]] .. killed:GetName() .. [[** ha muerto en nivel **]] .. killed:GetLevel() .. [[**.. ¡Lamentablemente su aventura termina aquí.",
                      "color": 16711680
                    }
                  ]
                }
            ]]

            HttpRequest(
                "POST",
                "https://discord.com/api/webhooks/1422991114763505745/1QpTnuBum1Ae3KdUEx0uw2wChSBMSnfUcKDes3K43Pc0O5NNSv7PjVUV9ulwwzk1IbTW",
                json,
                "application/json",
                function(status, body, headers)
                    -- print("Webhook enviado. Estado: " .. status)
                    -- if body then
                        -- print("Respuesta: " .. body)
                    -- end
                end
            )
        end
    end

end

RegisterPlayerEvent(6, OnKillPlayer)
RegisterPlayerEvent(8, OnKillPlayer)

