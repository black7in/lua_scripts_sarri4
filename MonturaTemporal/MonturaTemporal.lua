local npc = 90000

local foods = {
    117, 159, 414, 422, 1205, 1645, 1707, 1708, 3927, 8766, 8932, 13931, 23160,
    27854, 27860, 28399, 29394, 33443, 33444, 33445, 35947
}

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Alimentar", 0, 1)
    player:GossipMenuAddItem(0, "Salir", 0, 2)
    player:GossipSendMenu(90000, object)
end
RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function PlayerDismount(eventid, delay, repeats, player) player:Dismount() end

local function hasFoods(player)
    for _, food in ipairs(foods) do
        if player:HasItem(food) then
            return food
        end
    end

    return 0 
end

local function OnGossipSelect(event, player, object, sender, intid, code,
                              menu_id)
    if intid == 2 then
        player:GossipComplete()
    else
        local food = hasFoods(player)
        if food == 0 then
            object:SendUnitSay("¡No tienes comida para alimentarme!", 0)
            player:GossipComplete()

            --print(object:GetGUIDLow())
            return
        end

        object:SendUnitSay("¡Gracias por la comida!", 0)
        player:RemoveItem(food, 1)
        player:Dismount()
        player:RemoveEvents()
        -- object:AddAura(intid, player)
        player:Mount(1149)
        player:RegisterEvent(PlayerDismount, 60000)
    end

    player:GossipComplete()
end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)

local function CheckMount(event, player) end
RegisterPlayerEvent(3, CheckMount)
