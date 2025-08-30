local function OnLogin(event, player)
    if player:GetGMRank() >= 1 then
        local playerName = player:GetName()
        local accountName = player:GetAccountName()
        
        local embed = [[
        {
          "embeds": [
            {
              "title": "📢 Conexión detectada",
              "description": "La cuenta GM **]] .. accountName .. [[** se ha conectado con el jugador **]] .. playerName .. [[**.",
              "color": 16711680
            }
          ]
        }
        ]]
        
        HttpRequest("POST",
            "https://discord.com/api/webhooks/1400275132370653286/VUKbGq7tQ9WMGfb43OAZGTRQaye18marw7Lows9vmns9rA_2SFmFGjfIU8JWXbYsKLG9",
            json,
            "application/json",
            function(status, body, headers)
                print("Webhook enviado. Estado: " .. status)
            end
        )
    end
end

RegisterPlayerEvent(3, OnLogin)