local function OnLogin(event, player)
    if player:GetGMRank() >= 1 then
        local content = player:GetName() .. " se ha conectado al servidor."
        local json = '{"content": "' .. content .. '"}'
        
        HttpRequest("POST",
            "https://discord.com/api/webhooks/1400264964412801238/RdBNg8fXgkcTH5gY6YQGJvMJTbVE6-toZjuWzTFwS6R9xCvxUyQRAn0tvsBxrDuszbp",
            json,
            "application/json",
            function(status, body, headers)
                print("Webhook enviado. Estado: " .. status)
            end
        )
    end
end

RegisterPlayerEvent(3, OnLogin)