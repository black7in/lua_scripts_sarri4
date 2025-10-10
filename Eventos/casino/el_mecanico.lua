-- Mayor o Menor (simple) para Eluna Engine
-- Flujo:
--  * El jugador ingresa cuántas fichas arriesga (valida inventario).
--  * Se genera un número inicial 2..8.
--  * Elige "Mayor" o "Menor". Se tira 1..9.
--     - Si acierta -> gana recompensa y sigue jugando.
--     - Si sale igual -> pierde.
--     - Si falla -> pierde.
--  * Al perder, se cobran las fichas apostadas y termina la sesión.

local npc         = 60040
local fichas      = 49224    -- Item de fichas a arriesgar
local recompensa  = 29837    -- Item de recompensa por victoria
local REWARD_PER_WIN = 1     -- Cantidad de recompensas por cada acierto

local texto = "Mayor o Menor (simple)\n" ..
              "- Se genera un número inicial (2–8)\n" ..
              "- Elige Mayor o Menor contra un nuevo número (1–9)\n" ..
              "- Acierto: ganas recompensa y sigues\n" ..
              "- Igual o fallo: pierdes y se cobran tus fichas"

-- Estado por jugador: [guidLow] = { bet, current, active }
local state = {}

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
    player:SendBroadcastMessage("|cff88ff00[Mayor o Menor]|r " .. msg)
end

local function clearState(player)
    state[guid(player)] = nil
end

local function randomStart()
    -- 2..8 para que ambas opciones (Mayor/Menor) tengan sentido
    return math.random(2, 8)
end

local function randomNext()
    -- Nuevo número 1..9
    return math.random(1, 9)
end

local function startSession(player, bet)
    state[guid(player)] = { bet = bet, current = randomStart(), active = true }
end

-- ---------- Menús ----------
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
    player:GossipMenuAddItem(0, "Número actual: |cffffff00"..num.."|r", 0, 99)
    player:GossipMenuAddItem(0, "Elegir: Mayor", 0, 20) -- adivina mayor
    player:GossipMenuAddItem(0, "Elegir: Menor", 0, 21) -- adivina menor
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

-- ---------- Gossip ----------
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

    -- Resolución de jugada: Mayor (20) o Menor (21)
    if intid == 20 or intid == 21 then
        local st = state[guid(player)]
        if not (st and st.active and st.bet and st.bet > 0 and st.current) then
            sendInfo(player, "No hay sesión activa. Inicia un juego primero.")
            ShowMain(player, creature)
            return
        end

        local choice = (intid == 20) and "Mayor" or "Menor"
        local prev = st.current
        local nxt  = randomNext()

        sendInfo(player, ("Elegiste |cffffff00%s|r. Nuevo número: |cffffff00%d|r (anterior: %d)"):format(choice, nxt, prev))

        -- Igual = pierde
        if nxt == prev then
            takeChips(player, st.bet)
            sendInfo(player, ("|cffff0000IGUAL -> PIERDES|r. Se cobraron |cffffff00%d|r fichas."):format(st.bet))
            EndSession(player, creature)
            return
        end

        local correct = false
        if intid == 20 then -- Mayor
            correct = (nxt > prev)
        else                -- Menor
            correct = (nxt < prev)
        end

        if correct then
            giveReward(player, REWARD_PER_WIN)
            sendInfo(player, ("¡Acierto! |cff00ff00GANAS|r. Recompensa +%d. Puedes seguir..."):format(REWARD_PER_WIN))
            st.current = nxt
            ShowChoice(player, creature)
            return
        else
            takeChips(player, st.bet)
            sendInfo(player, ("|cffff0000Fallo -> PIERDES|r. Se cobraron |cffffff00%d|r fichas."):format(st.bet))
            EndSession(player, creature)
            return
        end
    end
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
