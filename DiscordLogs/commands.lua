local function OnCommand(event, player, command)
    local realmId = GetRealmID()
    if realmId == 1 then
        local accountName = player:GetAccountName()
        local json = [[
        {
          "embeds": [
            {
              "title": "📢 Comando detectado",
              "description": "La cuenta GM **]] .. accountName .. [[** ejecutó el comando: **]] .. command .. [[**.",
              "color": 16711680
            }
          ]
        }
        ]]
        
        HttpRequest(
            "POST",
            "https://discord.com/api/webhooks/1400275132370653286/VUKbGq7tQ9WMGfb43OAZGTRQaye18marw7Lows9vmns9rA_2SFmFGjfIU8JWXbYsKLG9",
            json,
            "application/json",
            function(status, body, headers)
            end
        )
    end
end
RegisterPlayerEvent(42, OnCommand)