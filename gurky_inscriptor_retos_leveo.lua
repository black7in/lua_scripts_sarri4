local npc = 50016

local text = "¡Hola! Soy Gurky, el de los retos de leveo.\n¿Quieres elegir un reto de leveo? ¡Será divertido!\n¡Vamos a ver qué tan rápido puedes subir de nivel!"

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Alimentar", 0, 1)
    player:GossipMenuAddItem(0, "Salir", 0, 2)
    player:SendGossipText(text, npc)
    player:GossipSendMenu(npc, object)
end
RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)

end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
