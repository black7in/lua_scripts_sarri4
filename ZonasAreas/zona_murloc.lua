local AreaId = 616 -- ID de la zona Murloc (Hyjal)

local CMSG_REPOP_REQUEST = 0x15A

local function OnReceiveRepopRequest(event, packet, player)
    if player:GetAreaId() == AreaId then
        player:SendNotification("¡Has muerto en la Zona Murloc! Espera que una ValkYria te retorne a la vida.")
        return false
    end
end


-- RegisterPacketEvent( CMSG_REPOP_REQUEST, 5, OnReceiveRepopRequest )
--66
local function OnTeleportGraveYard(event, player, mapId, x, y, z)
    print("OnTeleportGraveYard called for player: " .. player:GetName())
    print("Player Map ID: " .. mapId)
    print("Player Coordinates: (" .. x .. ", " .. y .. ", " .. z .. ")")
    if player:GetAreaId() == AreaId then
        -- Teletransportar al jugador a la zona Murloc
        player:SendNotification("Has sido teletransportado a la Zona Murloc.")
    else
        player:SendNotification("No estás en la Zona Murloc.")
    end

end

RegisterPlayerEvent(66, OnTeleportGraveYard)