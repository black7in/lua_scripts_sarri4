local npcEntry = 90002


local Coordenadas = {
    [0] = {
        {0, -8833.38, 628.628, 94.0066, 1.06535, "Ventormenta"}, -- Ventormenta
        {0, -4918.88, -940.406, 501.564, 5.42347, "Forjaz"}, -- Forjaz
        {1, 9949.56, 2284.21, 1341.4, 1.59587, "Darnassus"}, -- Darnassus
        {530, -3965.7, -11653.6, -138.844, 0.852154, "El Exodar"}, -- Exodar
    }, -- Coordendas para la Alianza,
    [1] = {
        { 1, 1629.85, -4373.64, 31.5573, 3.69762, "Ogrimmar" }, -- Orgrimmar
        { 0, 1584.14, 240.308, -52.1534, 0.041793, "Entrañas" }, -- Entrañas
        { 1, -1277.37, 124.804, 131.287, 5.22274, "Cima del Tueno" }, -- Cima del Trueno
        { 530, 9487.69, -7279.2, 14.2866, 6.16478, "Lunargenta" }, -- Lunargenta
    }, -- Coordendas para la Horda
    [2] = {
        { 571, 5807.98, 588.487, 660.94, 1.66594, "Dalaran" }, -- Dalaran
        { 530, -1838.16, 5301.79, -12.428, 5.9517, "Shattrath" }, -- Shattrath
        { 1, 4617.81, -3851.19, 944.648, 1.09499, "Zona Murlocs" }, -- Zona Murlocs
    }, -- Coordendas para Ambos
}


local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    local teamId = player:GetTeam()
    for i, coords in ipairs(Coordenadas[teamId]) do
        player:GossipMenuAddItem(2, coords[6], 0, i, false, "¿Quieres ir a " .. coords[6] .. "?")
    end

    for i, coords in ipairs(Coordenadas[2]) do
        player:GossipMenuAddItem(2, coords[6], 0, i + 10, false, "¿Quieres ir a " .. coords[6] .. "?")
    end

    player:SendGossipText("Teletransportate gratis cuando quieras, recuerda que no puedes transportarte mientras estas en combate.", 90002) -- Aquí puedes poner el texto que quieras mostrar al jugador
    player:GossipSendMenu(90002, object)
end
RegisterCreatureGossipEvent(npcEntry, 1, OnGossipHello)

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if player:IsInCombat() then
        player:SendNotification("No puedes teletransportarte mientras estás en combate.")
        player:GossipComplete()
        return
    end

    if intid >= 1 and intid <= 10 then
        local coords = Coordenadas[player:GetTeam()][intid]
        if coords then
            player:Teleport(coords[1], coords[2], coords[3], coords[4], coords[5])
        end
    elseif intid >= 11 and intid <= 20 then
        local coords = Coordenadas[2][intid - 10]
        if coords then
            player:Teleport(coords[1], coords[2], coords[3], coords[4], coords[5])
        end
    end

    player:GossipComplete()
    
end
RegisterCreatureGossipEvent(npcEntry, 2, OnGossipSelect)