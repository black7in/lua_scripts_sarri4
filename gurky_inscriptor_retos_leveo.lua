local npc = 50016

local text = "¡Hola! Soy Gurky, el de los retos de leveo.\n¿Quieres elegir un reto de leveo? ¡Será divertido!\n¡Vamos a ver qué tan rápido puedes subir de nivel!"

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "|TINTERFACE/ICONS/Ability_Creature_Cursed_02:28:28:-15:0|t Reto Hardcore", 0, 1)
    player:GossipMenuAddItem(0, "|TINTERFACE/ICONS/INV_Chest_Leather_09:28:28:-15:0|t Reto Artesano", 0, 2)
    player:GossipMenuAddItem(0, "|TINTERFACE/ICONS/inv_misc_head_murloc_01:28:28:-15:0|t Reto Murlocfóbico", 0, 3)
    player:GossipMenuAddItem(0, "|TINTERFACE/ICONS/Trade_BlackSmithing:28:28:-15:0|t Reto Maestro de Oficios", 0, 4)
    player:GossipMenuAddItem(0, "Salir", 0, 10)
    player:SendGossipText(text, npc)
    player:GossipSendMenu(npc, object)
end
RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    player:GossipClearMenu()
    if intid == 1 then
        --player:SendBroadcastMessage("¡Has elegido el Reto Hardcore! Prepárate para una experiencia desafiante.")
        local mensaje = "En este desafío, cada combate es una apuesta con tu vida. Si mueres, tu aventura termina para siempre. Solo los más cautelosos, estratégicos y valientes llegarán al final. ¿Tienes lo necesario para sobrevivir?"
        player:GossipMenuAddItem(0, "Aceptar reto", 0, 11)
        player:GossipMenuAddItem(0, "Atras", 0, 20)
        player:SendGossipText(mensaje, npc)
        player:GossipSendMenu(npc, object)
    elseif intid == 2 then
        --player:SendBroadcastMessage("¡Has elegido el Reto Artesano! ¡A mejorar tus habilidades!")
        local mensaje = "Aquí no hay botines fáciles ni regalos de monstruos caídos. Todo lo que uses deberá haber sido creado por ti mismo, usando tus profesiones. Forja tu propia armadura, fabrica tus armas y demuestra que un verdadero héroe se construye… pieza a pieza."
        player:GossipMenuAddItem(0, "Aceptar reto", 0, 11)
        player:GossipMenuAddItem(0, "Atras", 0, 20)
        player:SendGossipText(mensaje, npc)
        player:GossipSendMenu(npc, object)
    elseif intid == 3 then
        --player:SendBroadcastMessage("¡Has elegido el Reto Murlocfóbico! ¡A cazar Murlocs se ha dicho!")
        local mensaje = "Solo podrás subir de nivel matando Murlocs. No hay lobos, no hay orcos, no hay dragones: tu destino está ligado a esas criaturas parlantes de la costa. Conviértete en la pesadilla de todo Murloc que ose cruzarse en tu camino."
        player:GossipMenuAddItem(0, "Aceptar reto", 0, 11)
        player:GossipMenuAddItem(0, "Atras", 0, 20)
        player:SendGossipText(mensaje, npc)
        player:GossipSendMenu(npc, object)
    elseif intid == 4 then
        --player:SendBroadcastMessage("¡Has elegido el Reto Maestro de Oficios! ¡A dominar las profesiones!")
        local mensaje = "Nada de espadas ni de arcos: tu poder proviene de tus profesiones. Sube de nivel únicamente fabricando, recolectando y perfeccionando tus habilidades artesanales. Un reto para mentes pacientes y manos maestras."
        player:GossipMenuAddItem(0, "Aceptar reto", 0, 11)
        player:GossipMenuAddItem(0, "Atras", 0, 20)
        player:SendGossipText(mensaje, npc)
        player:GossipSendMenu(npc, object)
    elseif intid == 10 then
        object:SendUnitSay("¡Hasta luego! ¡Buena suerte con tus retos!", 0)
        player:GossipComplete()
    end
    player:GossipComplete()
end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
