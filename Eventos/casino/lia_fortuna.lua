-- Cara o Cruz (simple) para Eluna Engine
-- Reglas: 50/50 por tirada. Ganas -> recibes recompensa y puedes seguir. Pierdes -> se cobran fichas y termina.

local npc         = 60039
local fichas      = 49224   -- item de fichas a arriesgar (mismo que el juego anterior)
local recompensa  = 29837   -- item de recompensa por victoria
local REWARD_PER_WIN = 1    -- recompensas que se dan por cada victoria

local texto = "Cara o Cruz (Súper simple)\n- Ingresas cuántas fichas arriesgas.\n- Cada tirada es 50/50.\n- Si ganas: recibes recompensa y puedes seguir.\n- Si pierdes: se cobran tus fichas arriesgadas y termina."

-- Estado por jugador
local state = {} -- [guidLow] = { bet = number, active = bool }

math.randomseed(os.time())

local function guid(p) return p:GetGUIDLow() end

local function hasChips(player, amount)
    return player:GetItemCount(fichas) >= amount
end

local function takeChips(player, amount)
    player:RemoveItem(fichas, amount)
end

local function giveReward(player, amount)
    player:AddItem(recompensa, amount)
end

local function sendInfo(player, msg)
    player:SendBroadcastMessage("|cff00ff88[Cara o Cruz]|r "..msg)
end

local function clearState(player)
    state[guid(player)] = nil
end

local function startSession(player, bet)
    state[guid(player)] = { bet = bet, active = true }
end

-- Menús
local function ShowMain(player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Quiero jugar.", 0, 1, true, "¿Cuántas fichas quieres arriesgar?\n(ingresa un número entero ≥ 1)")
    player:GossipMenuAddItem(0, "Salir.", 0, 5)
    player:SendGossipText(texto, npc*10)
    player:GossipSendMenu(npc*10, creature)
end

local function ShowPlayPrompt(player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Tirar (50/50)", 0, 10) -- ejecutar tirada
    player:GossipMenuAddItem(0, "Terminar ahora", 0, 5)
    player:GossipSendMenu(npc*10, creature)
end

local function EndSession(player, creature)
    clearState(player)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Jugar de nuevo.", 0, 1, true, "¿Cuántas fichas quieres arriesgar?")
    player:GossipMenuAddItem(0, "Salir.", 0, 5)
    player:GossipSendMenu(npc*10, creature)
end

-- Gossip Hello
local function OnGossipHello(event, player, creature)
    ShowMain(player, creature)
end

-- Gossip Select
local function OnGossipSelect(event, player, creature, sender, intid, code)
    -- Salir
    if intid == 5 then
        player:GossipComplete()
        return
    end

    -- Iniciar: pedir apuesta
    if intid == 1 then
        local bet = tonumber(tostring(code or ""))
        if not bet or bet < 1 then
            sendInfo(player, "Cantidad inválida. Debe ser un número entero ≥ 1.")
            ShowMain(player, creature)
            return
        end
        if not hasChips(player, bet) then
            sendInfo(player, "No tienes suficientes fichas.")
            ShowMain(player, creature)
            return
        end

        startSession(player, bet)
        sendInfo(player, ("Has arriesgado |cffffff00%d|r fichas. ¡Suerte!"):format(bet))
        ShowPlayPrompt(player, creature)
        return
    end

    -- Tirada 50/50
    if intid == 10 then
        local st = state[guid(player)]
        if not (st and st.active and st.bet and st.bet > 0) then
            sendInfo(player, "No hay sesión activa. Inicia un juego primero.")
            ShowMain(player, creature)
            return
        end

        -- 1 = gana, 2 = pierde (puro 50/50)
        local roll = math.random(1, 2)
        if roll == 1 then
            giveReward(player, REWARD_PER_WIN)
            sendInfo(player, ("¡Ganaste! Recompensa +%d. Puedes seguir tirando…"):format(REWARD_PER_WIN))
            -- sigue la sesión sin tocar las fichas arriesgadas
            ShowPlayPrompt(player, creature)
            return
        else
            takeChips(player, st.bet)
            sendInfo(player, ("Perdiste. Se cobraron |cffffff00%d|r fichas. Fin de la sesión."):format(st.bet))
            EndSession(player, creature)
            return
        end
    end
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
