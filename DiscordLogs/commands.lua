local function OnCommand(event, player, command)
    local realmId = GetRealmID()
    if realmId == 2 then
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
            "https://discord.com/api/webhooks/1415489313180749917/rzpJFTbJ5Bur_Ny5hvU-B1n9tb67llHwx2o33yvw4uHY9s39HaN5ZEMkRuvxMXMJX-n0",
            json,
            "application/json",
            function(status, body, headers)
            end
        )
    end
end
RegisterPlayerEvent(42, OnCommand)