local npc = 90000

local foods = {
    19063, 28036, 29293, 36831, 42437,
}

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Alimentar", 0, 1)
    player:GossipMenuAddItem(0, "Salir", 0, 2)
    player:GossipSendMenu(90000, object)
end
RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function PlayerDismount(eventid, delay, repeats, player) 
    player:Dismount() 
end

local function hasFoods(player)
    for _, food in ipairs(foods) do
        if player:HasItem(food) then
            local item = player:GetItemByEntry(food)
            local playerLevel = player:GetLevel()

            if food == 19063 and playerLevel <= 15 then
                return food
            elseif food == 28036 and playerLevel > 15 and playerLevel <= 30 then
                return food
            elseif food == 29293 and playerLevel > 30 and playerLevel <= 45 then
                return food
            elseif food == 36831 and playerLevel > 45 and playerLevel <= 60 then
                return food
            elseif food == 42737 and playerLevel > 60 then
                return food
            end
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
            object:SendUnitSay("¡No seas tacaño! y comprame comida de tu nivel o superior", 0)
            player:GossipComplete()

            --print(object:GetGUIDLow())
            return
        end

        object:SendUnitSay("¡Gracias por la comida!", 0)
        player:RemoveItem(food, 1)
        player:Dismount()
        player:RemoveEvents()
        -- object:AddAura(intid, player)
        player:AddAura(31700, player)
        player:Mount(24869)
        player:RegisterEvent(PlayerDismount, 50000)
    end

    player:GossipComplete()
end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)

local function CheckMount(event, player) 
    if player:HasAura(31700) then
        player:RemoveAura(31700)
        player:Dismount()
    end

end
RegisterPlayerEvent(3, CheckMount)
