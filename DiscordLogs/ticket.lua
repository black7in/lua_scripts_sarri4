local function OnCreateTicket(event, player, ticket)
    local realmId = GetRealmID()
    if realmId == 2 then
        local playerName = ticket:GetPlayerName()
        local accountName = player:GetAccountName()
        local ticketId = ticket:GetId()
        local ticketMessage = ticket:GetMessage()

        local json = [[
        {
          "embeds": [
            {
              "title": "🎫 Ticket creado",
              "description": "@everyone El jugador **]] .. playerName .. [[** (cuenta: **]] .. accountName .. [[**) ha creado un ticket.\n\n**ID del Ticket:** ]] .. ticketId .. [[\n**Mensaje:** ]] .. ticketMessage .. [[",
              "color": 3066993
            }
          ]
        }
        ]]

        HttpRequest(
            "POST",
            "https://discord.com/api/webhooks/1415489407678677127/QRdWXhi1stsDVFKbLm1ZBwUEzUU08t5x9_66_jCB_d5kR2YeFElCA0GlGHvYcWwAVlPa",
            json,
            "application/json",
            function(status, body, headers)
            end
        )
    end
end

--RegisterTicketEvent( 1, OnCreateTicket )