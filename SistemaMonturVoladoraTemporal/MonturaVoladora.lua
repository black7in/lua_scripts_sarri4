local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem( 0, "Quiero poder volar!!!", 0, 1 )
    player:GossipMenuAddItem( 0, "No quiero anda, adios!", 0, 2 )
    player:GossipSendMenu( 1, object )
end RegisterCreatureGossipEvent( npc, 1, OnGossipHello )

local function PlayerDismount(eventid, delay, repeats, player)
    player:Dismount()
end

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if intid == 2 then
        player:GossipComplete()
    else
        player:Dismount()
        player:RemoveEvents()
        object:AddAura(intid, player)
        player:RegisterEvent( PlayerDismount, 60000 )
        OnGossipHello(event, player, object)
    end
end RegisterCreatureGossipEvent( npc, 2, OnGossipSelect )

local function CheckMount(event, player)

end RegisterPlayerEvent( 3, CheckMount )