-- Craps (Pass Line) para Eluna Engine
-- Config
local npc         = 60038
local fichas      = 49224  -- item de fichas a arriesgar
local recompensa  = 29837  -- item de recompensa por victoria
local REWARD_PER_WIN = 1   -- cuántas recompensas dar por cada victoria

-- Texto inicial (puedes personalizarlo)
local texto = "Craps (Pass Line)\nReglas:\n- Come-out: 7/11 ganas | 2/3/12 pierdes | 4,5,6,8,9,10 = Point\n- Con Point: repite el Point = ganas | sale 7 = pierdes\n- Ganas → recibes recompensa; Pierdes → se cobran tus fichas arriesgadas."

-- Estado por jugador
local state = {}  -- [guidLow] = { bet = number, phase = "comeout"|"point", point = number, active = bool }

-- Utilidades
math.randomseed(os.time())

local function guid(p) return p:GetGUIDLow() end

local function clearState(player)
    state[guid(player)] = nil
end

local function startSession(player, bet)
    state[guid(player)] = { bet = bet, phase = "comeout", point = 0, active = true }
end

local function hasChips(player, amount)
    return player:GetItemCount(fichas) >= amount
end

local function takeChips(player, amount)
    player:RemoveItem(fichas, amount)
end

local function giveReward(player, amount)
    player:AddItem(recompensa, amount)
end

local function roll2d6()
    local d1 = math.random(1,6)
    local d2 = math.random(1,6)
    return d1, d2, d1 + d2
end

local function sendInfo(player, msg)
    player:SendBroadcastMessage("|cff00ff88[Craps]|r "..msg)
end

-- Gossip helpers
local function ShowPlayMenu(player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Quiero Jugar.", 0, 1, true, "Ingresa cuántas fichas quieres apostar (número entero).")
    player:GossipMenuAddItem(0, "Salir.", 0, 5)
    player:SendGossipText(texto, npc*10)  -- si usas textoID, ajusta a tu DB; si no, puedes quitar esta línea
    player:GossipSendMenu(npc*10, creature)
end

local function ShowComeOutPrompt(player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "🎲 Tirar (Come-out)", 0, 10) -- intid 10 = tirar en come-out
    player:GossipSendMenu(npc*10, creature)
end

local function ShowPointPrompt(player, creature, point)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "🎲 Tirar (Point = "..point..")", 0, 11) -- intid 11 = tirar con point
    player:GossipSendMenu(npc*10, creature)
end

local function EndSession(player, creature)
    clearState(player)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Jugar de nuevo.", 0, 1, true, "Ingresa cuántas fichas quieres apostar (número entero).")
    player:GossipMenuAddItem(0, "Salir.", 0, 5)
    player:GossipSendMenu(npc*10, creature)
end

-- Lógica de una tirada en come-out: retorna "win"/"lose"/"point", y el point si aplica
local function DoComeOutRoll(player)
    local d1, d2, sum = roll2d6()
    sendInfo(player, ("Come-out: [%d] + [%d] = |cff00ffff%d|r"):format(d1, d2, sum))

    if sum == 7 or sum == 11 then
        return "win", 0
    elseif sum == 2 or sum == 3 or sum == 12 then
        return "lose", 0
    else
        return "point", sum
    end
end

-- Lógica de una tirada con point activo: retorna "win"/"lose"/"again"
local function DoPointRoll(player, point)
    local d1, d2, sum = roll2d6()
    sendInfo(player, ("Point %d: [%d] + [%d] = |cff00ffff%d|r"):format(point, d1, d2, sum))

    if sum == point then
        return "win"
    elseif sum == 7 then
        return "lose"
    else
        return "again"
    end
end

-- Gossip: entrada
local function OnGossipHello(event, player, creature)
    ShowPlayMenu(player, creature)
end

-- Gossip: selección
local function OnGossipSelect(event, player, creature, sender, intid, code)
    if intid == 5 then
        player:GossipComplete()
        return
    end

    -- Iniciar juego: pedir apuesta con "code"
    if intid == 1 then
        local raw = tostring(code or "")
        local bet = tonumber(raw)
        if not bet or bet < 1 then
            sendInfo(player, "Cantidad inválida. Debe ser un número entero ≥ 1.")
            ShowPlayMenu(player, creature)
            return
        end
        if not hasChips(player, bet) then
            sendInfo(player, "No tienes suficientes fichas. Revisa tu inventario.")
            ShowPlayMenu(player, creature)
            return
        end

        -- Comienza la sesión
        startSession(player, bet)
        sendInfo(player, ("Has arriesgado |cffffff00%d|r fichas. ¡Vamos a tirar!"):format(bet))
        ShowComeOutPrompt(player, creature)
        return
    end

    -- Tirada en come-out
    if intid == 10 then
        local st = state[guid(player)]
        if not (st and st.active) then
            sendInfo(player, "No hay sesión activa. Inicia un juego primero.")
            ShowPlayMenu(player, creature)
            return
        end

        local result, point = DoComeOutRoll(player)
        if result == "win" then
            giveReward(player, REWARD_PER_WIN)
            sendInfo(player, ("¡Natural! |cff00ff00GANAS|r. Recompensa +%d"):format(REWARD_PER_WIN))
            -- Sigues jugando hasta perder (reinicia a come-out)
            st.phase = "comeout"
            st.point = 0
            ShowComeOutPrompt(player, creature)
            return
        elseif result == "lose" then
            takeChips(player, st.bet)
            sendInfo(player, ("|cffff0000PIERDES|r. Se cobraron |cffffff00%d|r fichas."):format(st.bet))
            EndSession(player, creature)
            return
        else
            -- Se establece Point
            st.phase = "point"
            st.point = point
            sendInfo(player, ("Se establece el |cffffff00POINT = %d|r."):format(point))
            ShowPointPrompt(player, creature, point)
            return
        end
    end

    -- Tirada con Point activo
    if intid == 11 then
        local st = state[guid(player)]
        if not (st and st.active and st.phase == "point" and st.point and st.point > 0) then
            sendInfo(player, "No hay Point activo. Volviendo al inicio.")
            ShowPlayMenu(player, creature)
            return
        end

        local outcome = DoPointRoll(player, st.point)
        if outcome == "win" then
            giveReward(player, REWARD_PER_WIN)
            sendInfo(player, ("¡Has repetido el Point! |cff00ff00GANAS|r. Recompensa +%d"):format(REWARD_PER_WIN))
            -- Sigues jugando hasta perder (nuevo come-out)
            st.phase = "comeout"
            st.point = 0
            ShowComeOutPrompt(player, creature)
            return
        elseif outcome == "lose" then
            takeChips(player, st.bet)
            sendInfo(player, ("|cffff0000Siete fuera... PIERDES|r. Se cobraron |cffffff00%d|r fichas."):format(st.bet))
            EndSession(player, creature)
            return
        else
            -- Sigue tirando con el mismo Point
            ShowPointPrompt(player, creature, st.point)
            return
        end
    end
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
