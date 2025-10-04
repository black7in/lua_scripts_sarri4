local npc = 50018

-- =========================
-- CACHÉS EN MEMORIA
-- =========================
-- codigosPorTexto["abc123"] = { id=..., codigo="ABC123", itemId_1=..., amount_1=..., money=..., stack=... }
local codigosPorTexto = {}
-- canjesPorCodigo[codigo_id] = { [jugador_guid_low] = true, ... }
local canjesPorCodigo = {}

local text = "¡Hola! Soy Grunty, el canjeador de códigos. Si tienes un código especial, puedo ayudarte a canjearlo por recompensas increíbles. ¿Quieres canjear un código ahora?"

-- Utilidad: escape de comillas simples para SQL
local function sql_escape(str) return (tostring(str):gsub("'", "''")) end

-- =========================
-- CARGA INICIAL A MEMORIA
-- =========================
local function cargarCodigos()
    codigosPorTexto = {}
    local q = CharDBQuery([[
        SELECT id, codigo,
               itemId_1, amount_1,
               itemId_2, amount_2,
               itemId_3, amount_3,
               money, stack
        FROM codigos
        WHERE stack > 0
    ]])
    if q then
        repeat
            local row = {
                id       = q:GetUInt32(0),
                codigo   = q:GetString(1),
                itemId_1 = q:IsNull(2) and nil or q:GetUInt32(2),
                amount_1 = q:IsNull(3) and nil or q:GetUInt32(3),
                itemId_2 = q:IsNull(4) and nil or q:GetUInt32(4),
                amount_2 = q:IsNull(5) and nil or q:GetUInt32(5),
                itemId_3 = q:IsNull(6) and nil or q:GetUInt32(6),
                amount_3 = q:IsNull(7) and nil or q:GetUInt32(7),
                money    = q:IsNull(8) and 0   or q:GetInt32(8),
                stack    = q:GetUInt32(9)
            }
            codigosPorTexto[string.lower(row.codigo)] = row
        until not q:NextRow()
    end
end

local function cargarCanjes()
    canjesPorCodigo = {}
    local q = CharDBQuery("SELECT codigo_id, jugador_id FROM canjes")
    if q then
        repeat
            local codigo_id = q:GetUInt32(0)
            local jugador   = q:GetUInt32(1)
            if not canjesPorCodigo[codigo_id] then
                canjesPorCodigo[codigo_id] = {}
            end
            canjesPorCodigo[codigo_id][jugador] = true
        until not q:NextRow()
    end
end

local function recargarTodo()
    cargarCodigos()
    cargarCanjes()
end

-- =========================
-- HELPERS EN CACHÉ
-- =========================
local function obtenerEntradaPorTexto(codeText)
    if not codeText then return nil end
    return codigosPorTexto[string.lower(codeText)]
end

local function jugadorYaCanjeo_cache(codigo_id, jugador_id_low)
    local t = canjesPorCodigo[codigo_id]
    return t and t[jugador_id_low] == true or false
end

local function marcarCanjeEnCache(codigo_id, jugador_id_low)
    if not canjesPorCodigo[codigo_id] then
        canjesPorCodigo[codigo_id] = {}
    end
    canjesPorCodigo[codigo_id][jugador_id_low] = true
end

-- =========================
-- ESCRITURAS EN BD (SOLO CUANDO HAY CAMBIOS)
-- =========================
local function registrarCanje_DB(codigo_id, jugador_id_low)
    return CharDBExecute(string.format(
        "INSERT INTO canjes (codigo_id, jugador_id) VALUES (%u, %u)",
        codigo_id, jugador_id_low
    ))
end

local function decrementarStack_DB(codigo_id)
    -- Guardia en BD para evitar carreras
    return CharDBExecute(string.format(
        "UPDATE codigos SET stack = stack - 1 WHERE id = %u AND stack > 0",
        codigo_id
    ))
end

local function reponerStack_DB(codigo_id)
    return CharDBExecute(string.format(
        "UPDATE codigos SET stack = stack + 1 WHERE id = %u",
        codigo_id
    ))
end

-- =========================
-- ENTREGA DE RECOMPENSAS (NO TOCA BD)
-- =========================
local function darRecompensas(player, entry)
    local entregados = {}

    local function darItem(itemId, amount)
        if not itemId or not amount or amount <= 0 then return true end
        local ok = player:AddItem(itemId, amount)
        if ok then
            table.insert(entregados, { itemId = itemId, amount = amount })
            return true
        else
            return false, string.format("No tienes espacio para el objeto %u x%d.", itemId, amount)
        end
    end

    -- Item 1
    local ok, err = darItem(entry.itemId_1, entry.amount_1)
    if not ok then return false, err end

    -- Item 2
    ok, err = darItem(entry.itemId_2, entry.amount_2)
    if not ok then
        for _, it in ipairs(entregados) do player:RemoveItem(it.itemId, it.amount) end
        return false, err
    end

    -- Item 3
    ok, err = darItem(entry.itemId_3, entry.amount_3)
    if not ok then
        for _, it in ipairs(entregados) do player:RemoveItem(it.itemId, it.amount) end
        return false, err
    end

    -- Dinero (en cobre)
    local money = tonumber(entry.money) or 0
    if money ~= 0 then player:ModifyMoney(money) end

    return true
end

-- =========================
-- GOSSIP
-- =========================
local function OnGossipHello(event, player, object)
    -- TODO: si quieres, puedes quitar por completo las recargas aquí para 0 hits a BD.
    -- Ahora no recarga nada: todo va por caché ya cargada al inicio o con .reloadcodigos
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Canjear código", 0, 1, true, "Ingresa el código que quieres canjear")
    player:GossipMenuAddItem(0, "No quiero nada", 0, 2)
    player:SendGossipText(text, npc)
    player:GossipSendMenu(npc, object)
end
RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if intid == 1 then
        local input = tostring(code or "")
        local codigoLower = string.lower(input:gsub("^%s*(.-)%s*$", "%1"))
        if codigoLower == "" then
            player:SendNotification("Código vacío.")
            player:GossipComplete()
            return
        end

        -- 1) Buscar SOLO en caché
        local entry = codigosPorTexto[codigoLower]
        if not entry then
            player:SendNotification("Código inválido o agotado.")
            player:GossipComplete()
            return
        end

        if not entry.stack or entry.stack == 0 then
            player:SendNotification("Este código ya fue agotado.")
            player:GossipComplete()
            return
        end

        local guidLow = player:GetGUIDLow()

        -- 2) Verificar canje previo usando SOLO caché
        if jugadorYaCanjeo_cache(entry.id, guidLow) then
            player:SendNotification("Ya has canjeado este código anteriormente.")
            player:GossipComplete()
            return
        end

        -- 3) Dar recompensas (no toca BD)
        local ok, err = darRecompensas(player, entry)
        if not ok then
            player:SendNotification(err or "Error al entregar las recompensas.")
            player:GossipComplete()
            return
        end

        -- 4) Persistir cambios en BD: decrementar stack + registrar canje
        --    (si fallara decrementar stack en BD por carrera, revertimos entrega)
        if not decrementarStack_DB(entry.id) then
            -- revertir entrega
            if entry.itemId_1 and entry.amount_1 and entry.amount_1 > 0 then player:RemoveItem(entry.itemId_1, entry.amount_1) end
            if entry.itemId_2 and entry.amount_2 and entry.amount_2 > 0 then player:RemoveItem(entry.itemId_2, entry.amount_2) end
            if entry.itemId_3 and entry.amount_3 and entry.amount_3 > 0 then player:RemoveItem(entry.itemId_3, entry.amount_3) end
            local money = tonumber(entry.money) or 0
            if money ~= 0 then player:ModifyMoney(-money) end

            player:SendNotification("No fue posible canjear: el código ya no tiene usos disponibles.")
            player:GossipComplete()
            return
        end

        if not registrarCanje_DB(entry.id, guidLow) then
            -- si falló registrar canje en BD, reponemos stack y revertimos entrega
            reponerStack_DB(entry.id)

            if entry.itemId_1 and entry.amount_1 and entry.amount_1 > 0 then player:RemoveItem(entry.itemId_1, entry.amount_1) end
            if entry.itemId_2 and entry.amount_2 and entry.amount_2 > 0 then player:RemoveItem(entry.itemId_2, entry.amount_2) end
            if entry.itemId_3 and entry.amount_3 and entry.amount_3 > 0 then player:RemoveItem(entry.itemId_3, entry.amount_3) end
            local money = tonumber(entry.money) or 0
            if money ~= 0 then player:ModifyMoney(-money) end

            player:SendNotification("Ocurrió un problema al registrar el canje. Intenta de nuevo.")
            player:GossipComplete()
            return
        end

        -- 5) Actualizar CACHÉ: bajar stack y marcar canje del jugador
        entry.stack = (entry.stack or 1) - 1
        if entry.stack < 0 then entry.stack = 0 end
        codigosPorTexto[codigoLower] = entry
        marcarCanjeEnCache(entry.id, guidLow)

        player:SendNotification("¡Código canjeado con éxito! Revisa tu inventario.")
    end

    player:GossipComplete()
end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)

-- =========================
-- COMANDO GM PARA RECARGAR CACHÉ
-- =========================
-- Uso: .reloadcodigos
local function OnCommand(event, player, command)
    if command == "reloadcodigos" or command == ".reloadcodigos" then
        if player and player:IsGM() then
            recargarTodo()
            player:SendBroadcastMessage("|cff00ff00[Códigos]|r Caché recargada.")
            return false -- consumimos el comando
        end
    end
    return true
end
RegisterPlayerEvent(42, OnCommand)

-- =========================
-- CARGA INICIAL AL ARRANCAR EL SCRIPT
-- =========================
recargarTodo()
