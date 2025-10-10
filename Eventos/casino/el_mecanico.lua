-- Mayor / Menor / Igual para Eluna
-- Reglas:
-- - Se muestra número inicial 2..8
-- - El jugador elige MAYOR, MENOR o IGUAL contra un nuevo número 1..9
-- - Pago:
--     * IGUAL acertado -> paga = apuesta completa
--     * MAYOR/MENOR acertado -> paga = mitad de la apuesta redondeada hacia arriba
-- - Si falla, se cobran las fichas apostadas y termina la sesión

local npc         = 60040
local fichas      = 49224   -- item de fichas
local recompensa  = 29837   -- item de recompensa

local texto = "Mayor / Menor / Igual\n" ..
              "- Número inicial (2–8)\n" ..
              "- Elige MAYOR, MENOR o IGUAL contra un nuevo número (1–9)\n" ..
              "- IGUAL acierta: premio = apuesta\n" ..
              "- MAYOR/MENOR acierta: premio = mitad de la apuesta (redondeo arriba)\n" ..
              "- Fallo: pierdes y se cobran tus fichas"

-- Estado por jugador
-- [guidLow] = { bet = number, current = number, active = bool }
local state = {}

math.randomseed(os.time())

local function guid(p) return p:GetGUIDLow() end

local function hasChips(player, amount)
    return player:GetItemCount(fichas) >= amount
end

local function takeChips(player, amount)
    if amount > 0 then player:RemoveItem(fichas, amount) end
end

local function giveReward(player, amount)
    if amount > 0 then player:AddItem(recompensa, amount) end
end

local function sendInfo(player, msg)
    player:SendBroadcastMessage("|cff88ff00[Mayor/Menor/Igual]|r " .. msg)
end

local function clearState(player)
    state[guid(player)] = nil
end

local function randomStart()  return math.random(2, 8) end   -- 2..8
local function randomNext()   return math.random(1, 9) end   -- 1..9

local function startSession(player, bet)
    state[guid(player)] = { bet = bet, current = randomStart(), active = true }
end

-- Pago mitad redondeando hacia arriba: 5 -> 3, 10 -> 5, 1 -> 1
local function halfRoundUp(n)
    return math.floor((n + 1) / 2)
end

-- --------- Menús ----------
local function ShowMain(player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Quiero jugar.", 0, 1, true, "¿Cuántas fichas quieres arriesgar?\n(ingresa un número entero ≥ 1)")
    player:GossipMenuAddItem(0, "Salir.", 0, 5)
    player:SendGossipText(texto, npc*10)
    player:GossipSendMenu(npc*10, creature)
end

local function ShowChoice(player, creature)
    local st = state[guid(player)]
    local num = st and st.current or "?"
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Número actual: |cffffff00"..num.."|r  (Apuesta: |cffffff00"..(st and st.bet or "?").."|r)", 0, 99)
    player:GossipMenuAddItem(0, "Elegir: MAYOR", 0, 20)
    player:GossipMenuAddItem(0, "Elegir: MENOR", 0, 21)
    player:GossipMenuAddItem(0, "Elegir: IGUAL", 0, 22)
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

-- --------- Gossip ----------
local function OnGossipHello(event, player, creature)
    ShowMain(player, creature)
end

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
        local st = state[guid(player)]
        sendInfo(player, ("Has arriesgado |cffffff00%d|r fichas. Número inicial: |cffffff00%d|r"):format(bet, st.current))
        ShowChoice(player, creature)
        return
    end

    -- Mostrar número actual (informativo)
    if intid == 99 then
        ShowChoice(player, creature)
        return
    end

    -- Resolución: MAYOR (20), MENOR (21), IGUAL (22)
    if intid == 20 or intid == 21 or intid == 22 then
        local st = state[guid(player)]
        if not (st and st.active and st.bet and st.bet > 0 and st.current) then
            sendInfo(player, "No hay sesión activa. Inicia un juego primero.")
            ShowMain(player, creature)
            return
        end

        local decision = (intid == 20 and "MAYOR") or (intid == 21 and "MENOR") or "IGUAL"
        local prev = st.current
        local nxt  = randomNext()

        sendInfo(player, ("Elegiste |cffffff00%s|r. Nuevo número: |cffffff00%d|r (anterior: %d)"):format(decision, nxt, prev))

        local won = false
        local payout = 0

        if decision == "IGUAL" then
            if nxt == prev then
                won = true
                payout = st.bet                      -- IGUAL: paga apuesta completa
            end
        elseif decision == "MAYOR" then
            if nxt > prev then
                won = true
                payout = halfRoundUp(st.bet)        -- MAYOR: paga mitad redondeando arriba
            end
        elseif decision == "MENOR" then
            if nxt < prev then
                won = true
                payout = halfRoundUp(st.bet)        -- MENOR: paga mitad redondeando arriba
            end
        end

        if won then
            giveReward(player, payout)
            sendInfo(player, ("|cff00ff00¡GANAS!|r Premio: |cffffff00%d|r (decisión: %s)"):format(payout, decision))
            -- La sesión continúa hasta que pierda: el nuevo "current" pasa a ser el que salió
            st.current = nxt
            ShowChoice(player, creature)
            return
        else
            takeChips(player, st.bet)
            sendInfo(player, ("|cffff0000PIERDES|r. Se cobraron |cffffff00%d|r fichas. (decisión: %s)"):format(st.bet, decision))
            EndSession(player, creature)
            return
        end
    end
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
