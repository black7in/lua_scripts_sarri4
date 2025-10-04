local npc = 50018

-- =========================
-- CONFIG DB (cambia esto SI tus tablas están en WorldDB)
-- =========================
local USE_CHAR_DB = true  -- true = usar CharDB; false = usar WorldDB
local function DB_Query(sql)
    if USE_CHAR_DB then return CharDBQuery(sql) else return WorldDBQuery(sql) end
end
local function DB_Execute(sql)
    if USE_CHAR_DB then return CharDBExecute(sql) else return WorldDBExecute(sql) end
end

-- =========================
-- CACHÉS EN MEMORIA
-- =========================
-- codigosPorTexto["abc123"] = { id=..., codigo="ABC123", itemId_1=..., amount_1=..., money=..., stack=... }
local codigosPorTexto = {}
-- canjesPorCodigo[codigo_id] = { [jugador_guid_low] = true, ... }
local canjesPorCodigo = {}
-- locks por código para evitar carreras simultáneas
local codeLocks = {}

local text = "¡Hola! Soy Grunty, el canjeador de códigos. Si tienes un código especial, puedo ayudarte a canjearlo por recompensas increíbles. ¿Quieres canjear un código ahora?"

local function sql_escape(str) return (tostring(str):gsub("'", "''")) end

-- =========================
-- CARGA INICIAL A MEMORIA
-- =========================
local function cargarCodigos()
    codigosPorTexto = {}
    local q = DB_Query([[
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
    local q = DB_Query("SELECT codigo_id, jugador_id FROM canjes")
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
-- HELPERS DE CACHÉ / LOCK
-- =========================
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

local function acquireLock(codeKey)
    if codeLocks[codeKey] then return false end
    codeLocks[codeKey] = true
    return true
end
local function releaseLock(codeKey)
    codeLocks[codeKey] = nil
end

-- =========================
-- ESCRITURAS EN BD (SOLO CUANDO HAY CAMBIOS)
-- =========================
local function decrementarStack_DB(codigo_id)
    -- Nota: Eluna no da "rows affected"; el lock en memoria evita carreras en este script.
    return DB_Execute(string.format(
        "UPDATE codigos SET stack = stack - 1 WHERE id = %u AND stack > 0",
        codigo_id
    ))
end

local function reponerStack_DB(codigo_id)
    return DB_Execute(string.format(
        "UPDATE codigos SET stack = stack + 1 WHERE id = %u",
        codigo_id
    ))
end

local function registrarCanje_DB(codigo_id, jugador_id_low)
    return DB_Execute(string.format(
        "INSERT INTO canjes (codigo_id, jugador_id) VALUES (%u, %u)",
        codigo_id, jugador_id_low
    ))
end

-- =========================
-- ENTREGA DE RECOMPENSAS
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
    if not ok then return false, err, entregados end

    -- Item 2
    ok, err = darItem(entry.itemId_2, entry.amount_2)
    if not ok then return false, err, entregados end

    -- Item 3
    ok, err = darItem(entry.itemId_3, entry.amount_3)
    if not ok then return false, err, entregados end

    -- Dinero (en cobre)
    local money = tonumber(entry.money) or 0
    if money ~= 0 then player:ModifyMoney(money) end

    return true, nil, entregados, money
end

local function revertirRecompensas(player, entregados, money)
    if entregados then
        for _, it in ipairs(entregados) do
            if it.itemId and it.amount and it.amount > 0 then
                player:RemoveItem(it.itemId, it.amount)
            end
        end
    end
    if money and money ~= 0 then
        player:ModifyMoney(-money)
    end
end

-- =========================
-- GOSSIP
-- =========================
local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Canjear código", 0, 1, true, "Ingresa el código que quieres canjear")
    player:GossipMenuAddItem(0, "No quiero nada", 0, 2)
    player:SendGossipText(text, npc) -- si usas textoID, cambia a un número
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

        if jugadorYaCanjeo_cache(entry.id, guidLow) then
            player:SendNotification("Ya has canjeado este código anteriormente.")
            player:GossipComplete()
            return
        end

        -- ===== Lock por código para evitar carreras =====
        if not acquireLock(codigoLower) then
            player:SendNotification("El código se está procesando, intenta de nuevo en un instante.")
            player:GossipComplete()
            return
        end

        -- 1) Decrementar BD PRIMERO (si no hay stack, no se entregan items)
        if not decrementarStack_DB(entry.id) then
            releaseLock(codigoLower)
            player:SendNotification("No fue posible canjear: error al actualizar la BD.")
            player:GossipComplete()
            return
        end

        -- 2) Entregar recompensas
        local ok, err, entregados, dineroEntregado = darRecompensas(player, entry)
        if not ok then
            -- Reponer en BD y revertir items/dinero
            reponerStack_DB(entry.id)
            revertirRecompensas(player, entregados, dineroEntregado)
            releaseLock(codigoLower)
            player:SendNotification(err or "Error al entregar las recompensas.")
            player:GossipComplete()
            return
        end

        -- 3) Registrar canje en BD
        if not registrarCanje_DB(entry.id, guidLow) then
            -- Revertimos todo si no se pudo registrar
            reponerStack_DB(entry.id)
            revertirRecompensas(player, entregados, dineroEntregado)
            releaseLock(codigoLower)
            player:SendNotification("Ocurrió un problema al registrar el canje. Intenta de nuevo.")
            player:GossipComplete()
            return
        end

        -- 4) Actualizar caché y liberar lock
        entry.stack = (entry.stack or 1) - 1
        if entry.stack < 0 then entry.stack = 0 end
        codigosPorTexto[codigoLower] = entry
        marcarCanjeEnCache(entry.id, guidLow)

        releaseLock(codigoLower)
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
            cargarCodigos()
            cargarCanjes()
            player:SendBroadcastMessage("|cff00ff00[Códigos]|r Caché recargada.")
            return false
        end
    end
    return true
end
RegisterPlayerEvent(42, OnCommand)

-- =========================
-- CARGA INICIAL
-- =========================
recargarTodo()
