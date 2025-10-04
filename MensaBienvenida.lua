local config = require("config")

local function enviarMensaje(eventid, delay, repeats, player)
    local msg = "|cff33FF00Bienvenido a |r|cff00CCFF" .. config.serverName .. "|r\n\n" ..
            "|cffffff00" .. player:GetName() .. "|r, ¡prepárate para tu aventura en Azeroth!\n\n" ..
            "|cffFF6600Recuerda:|r si necesitas ayuda, contacta a un |cffFF0000Game Master|r o visita nuestro sitio web.\n\n" ..
            "|cff00FF00Únete al canal global:|r |cffffff00/join global|r\n" ..
            "|cff00CCFFTambién puedes entrar a nuestro Discord para más información y comunidad:|r |cffffff00[link de Discord]|r\n\n" ..
            "|cffFF33CC¡Diviértete, haz amigos y buena suerte en tus batallas!|r\n"

    player:GossipClearMenu()
    player:GossipMenuAddItem(1, "", 0, 1, false, msg)
    player:GossipSendMenu(1, player, 0)
end

local function OnFirstLogin(event, player)
    player:RegisterEvent(enviarMensaje, 3000)
end


-- RegisterPlayerEvent(30, OnFirstLogin)
RegisterPlayerEvent(3, OnFirstLogin)