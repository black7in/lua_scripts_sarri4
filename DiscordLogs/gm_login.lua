local function OnLogin(event, player)
    if player:GetGMRank() >= 1 then
        local content = player:GetName() .. " se ha conectado al servidor."
        local json = '{"content": "' .. content .. '"}'
        
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