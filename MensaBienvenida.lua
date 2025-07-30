

local function enviarMensaje(eventid, delay, repeats, player)
    local msg = "Bienvenido a Murloc Wow\n" .. player:GetName() .. "! Disfruta de tu aventura en Azeroth."
    player:GossipClearMenu()
    player:GossipMenuAddItem(1, "", 0, 1, false, msg)
    player:GossipSendMenu(1, player, 0)
end

local function OnFirstLogin(event, player)
    player:RegisterEvent(enviarMensaje, 3000)
end


-- RegisterPlayerEvent(30, OnFirstLogin)
RegisterPlayerEvent(3, OnFirstLogin)