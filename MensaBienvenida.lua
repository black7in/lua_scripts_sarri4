

local function enviarMensaje(eventid, delay, repeats, player)
    local msg = "Bienvenido a |cff33FF00Murloc Wow|r\n" .. player:GetName() .. "! Disfruta de tu aventura en Azeroth.\n" ..
                "Si necesitas ayuda, puedes contactar a un Game Master o visitar nuestro sitio web.\n" ..
                "Recuerda que estamos aquí para ayudarte a disfrutar de la mejor experiencia de juego posible.\n\n" ..
                "¡Diviértete y buena suerte!\n"
    player:GossipClearMenu()
    player:GossipMenuAddItem(1, "", 0, 1, false, msg)
    player:GossipSendMenu(1, player, 0)
end

local function OnFirstLogin(event, player)
    player:RegisterEvent(enviarMensaje, 3000)
end


-- RegisterPlayerEvent(30, OnFirstLogin)
RegisterPlayerEvent(3, OnFirstLogin)