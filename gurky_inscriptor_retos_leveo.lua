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

end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
