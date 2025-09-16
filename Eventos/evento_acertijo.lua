local npc = 60032

-- Este npc es un npc para jugar juegos como por ejemplo Trivia
local text =
    "¡Hola! Soy Riddler el Acertijo. Tienes que responder a mis preguntas para ganar premios. ¿Quieres intentarlo?\n\nEl costo es de 10 monedas de oro por intento. Puedes ganar 2 monedas de oro por pregunta si respondes correctamente."

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()

    player:GossipMenuAddItem(0, "Iniciar Juego", 0, 1, false, "¿Quieres intentarlo? debes depositar monedas de oro.", 100000)

    player:GossipMenuAddItem(0, "Salir", 0, 2)

    player:SendGossipText(text, npc)
    player:GossipSendMenu(npc, object)
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id) player:GossipComplete() end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
