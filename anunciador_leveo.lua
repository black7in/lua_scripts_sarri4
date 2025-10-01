local messages = {
    [LEVEL_TYPE_HARDCORE] = {
        "|cffff0000[Reto Hardcore]|r: |cff00ff00[Jugador]|r ha alcanzado el nivel [X] en el Reto Hardcore… ¡a un paso de la muerte!",
        "|cffff0000[Reto Hardcore]|r: El valiente |cff00ff00[Jugador]|r sigue con vida en el Reto Hardcore, nivel [X].",
        "|cffff0000[Reto Hardcore]|r: |cff00ff00[Jugador]|r desafía al destino y alcanza el nivel [X] en el Reto Hardcore."
    },
    [LEVEL_TYPE_ARTESANO] = {
        "|cffff0000[Reto Artesano]|r: |cff00ff00[Jugador]|r ha forjado su camino al nivel [X] en el Reto Artesano.",
        "|cffff0000[Reto Artesano]|r: Con martillo y aguja, |cff00ff00[Jugador]|r alcanza el nivel [X] en el Reto Artesano.",
        "|cffff0000[Reto Artesano]|r: |cff00ff00[Jugador]|r demuestra que las manos crean poder: nivel [X] en el Reto Artesano."
    },
    [LEVEL_TYPE_MURLOCFOBICO] = {
        "|cffff0000[Reto Murlocfóbico]|r: |cff00ff00[Jugador]|r ha exterminado Murlocs hasta llegar al nivel [X] en el Reto Murlocfóbico.",
        "|cffff0000[Reto Murlocfóbico]|r: El terror de los Murlocs, |cff00ff00[Jugador]|r, alcanza el nivel [X].",
        "|cffff0000[Reto Murlocfóbico]|r: |cff00ff00[Jugador]|r continúa la masacre Murloc: nivel [X] en el Reto Murlocfóbico."
    },
    [LEVEL_TYPE_MAESTRO] = {
        "|cffff0000[Reto Maestro de Oficios]|r: |cff00ff00[Jugador]|r sube al nivel [X] solo con sus profesiones en el Reto Maestro de Oficios.",
        "|cffff0000[Reto Maestro de Oficios]|r: Entre fogones y yunques, |cff00ff00[Jugador]|r alcanza el nivel [X].",
        "|cffff0000[Reto Maestro de Oficios]|r: |cff00ff00[Jugador]|r demuestra maestría y llega al nivel [X] en el Reto Maestro de Oficios."
    }
}

local function OnLevelChange(event, player, oldLevel)
    if player:IsGM() then
        return -- No aplicar mensaje a GMs
    end

    local levelUpType = player:GetLevelUpType()
    if levelUpType == LEVEL_TYPE_NORMAL then
        return -- No aplicar mensaje si es un nivel normal
    end

    local level = player:GetLevel()
    local name = player:GetName()

    -- Niveles en los que se anunciará
    if level % 10 ~= 0 then return end

    local pool = messages[levelUpType]
    if pool then
        local msg = pool[math.random(#pool)]
        msg = msg:gsub("%[Jugador%]", name)
        msg = msg:gsub("%[X%]", tostring(level))
        SendWorldMessage(msg)
    end
end

RegisterPlayerEvent(13, OnLevelChange)
