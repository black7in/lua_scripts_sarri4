local messages = {
    [LEVEL_TYPE_HARDCORE] = {
        "Reto Hardcore: [Jugador] ha alcanzado el nivel [X] en el Reto Hardcore… ¡a un paso de la muerte!",
        "Reto Hardcore: El valiente [Jugador] sigue con vida en el Reto Hardcore, nivel [X].",
        "Reto Hardcore: [Jugador] desafía al destino y alcanza el nivel [X] en el Reto Hardcore."
    },
    [LEVEL_TYPE_ARTESANO] = {
        "Reto Artesano: [Jugador] ha forjado su camino al nivel [X] en el Reto Artesano.",
        "Reto Artesano: Con martillo y aguja, [Jugador] alcanza el nivel [X] en el Reto Artesano.",
        "Reto Artesano: [Jugador] demuestra que las manos crean poder: nivel [X] en el Reto Artesano."
    },
    [LEVEL_TYPE_MURLOCFOBICO] = {
        "Reto Murlocfóbico: [Jugador] ha exterminado Murlocs hasta llegar al nivel [X] en el Reto Murlocfóbico.",
        "Reto Murlocfóbico: El terror de los Murlocs, [Jugador], alcanza el nivel [X].",
        "Reto Murlocfóbico: [Jugador] continúa la masacre Murloc: nivel [X] en el Reto Murlocfóbico."
    },
    [LEVEL_TYPE_MAESTRO_OFICIOS] = {
        "Reto Maestro de Oficios: [Jugador] sube al nivel [X] solo con sus profesiones en el Reto Maestro de Oficios.",
        "Reto Maestro de Oficios: Entre fogones y yunques, [Jugador] alcanza el nivel [X].",
        "Reto Maestro de Oficios: [Jugador] demuestra maestría y llega al nivel [X] en el Reto Maestro de Oficios."
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
