local npc = 50018

-- cache en memoria: codigosPorTexto["ABC123"] = { ...campos... }
local codigosPorTexto = {}

local text = "¡Hola! Soy Grunty, el canjeador de códigos. Si tienes un código especial, puedo ayudarte a canjearlo por recompensas increíbles. ¿Quieres canjear un código ahora?"

-- Utilidad: escape de comillas simples para SQL simple
local function sql_escape(str)
    return (tostring(str):gsub("'", "''"))
end

-- Carga todos los codigos con stack > 0 a memoria
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
                id        = q:GetUInt32(0),
                codigo    = q:GetString(1),
                itemId_1  = q:IsNull(2) and nil or q:GetUInt32(2),
                amount_1  = q:IsNull(3) and nil or q:GetUInt32(3),
                itemId_2  = q:IsNull(4) and nil or q:GetUInt32(4),
                amount_2  = q:IsNull(5) and nil or q:GetUInt32(5),
                itemId_3  = q:IsNull(6) and nil or q:GetUInt32(6),
                amount_3  = q:IsNull(7) and nil or q:GetUInt32(7),
                money     = q:IsNull(8) and 0   or q:GetInt32(8),
                stack     = q:GetUInt32(9),
            }
            codigosPorTexto[string.lower(row.codigo)] = row
        until not q:NextRow()
    end
end

-- Verifica si el jugador ya canjeó este código
local function jugadorYaCanjeo(codigo_id, jugador_id_low)
    local q = CharDBQuery(string.format(
        "SELECT 1 FROM canjes WHERE codigo_id = %u AND jugador_id = %u LIMIT 1",
        codigo_id, jugador_id_low
    ))
    return q ~= nil
end

-- Inserta registro de canje
local function registrarCanje(codigo_id, jugador_id_low)
    WorldDBExecute(string.format(
        "INSERT INTO canjes (codigo_id, jugador_id) VALUES (%u, %u)",
        codigo_id, jugador_id_low
    ))
end

-- Decrementa el stack (si sigue disponible). Devuelve true si lo logró.
local function decrementarStack(codigo_id)
    -- Asegura que no baje de 0
    local res = WorldDBExecute(string.format(
        "UPDATE codigos SET stack = stack - 1 WHERE id = %u AND stack > 0",
        codigo_id
    ))
    return res == true
end

-- Entrega recompensas; devuelve true/false y mensaje de error si falla
local function darRecompensas(player, entry)
    local entregados = {}

    -- helper para dar item y registrar para rollback si falla algo después
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

    -- Dar items
    local ok, err = darItem(entry.itemId_1, entry.amount_1); if not ok then goto fail end
    ok, err = darItem(entry.itemId_2, entry.amount_2);       if not ok then goto fail end
    ok, err = darItem(entry.itemId_3, entry.amount_3);       if not ok then goto fail end

    -- Dar dinero (cobre)
    local money = tonumber(entry.money) or 0
    if money ~= 0 then
        player:ModifyMoney(money)
    end

    return true

::fail::
    -- rollback de items si algo falló
    for _, it in ipairs(entregados) do
        player:RemoveItem(it.itemId, it.amount)
    end
    return false, err or "No se pudieron entregar las recompensas."
end

-- Refresca de BD un código puntual (por si otro jugador lo canjeó y cambió el stack)
local function refrescarCodigoDesdeBD(codigoTextoLower)
    local q = CharDBQuery(string.format([[
        SELECT id, codigo,
               itemId_1, amount_1,
               itemId_2, amount_2,
               itemId_3, amount_3,
               money, stack
        FROM codigos
        WHERE LOWER(codigo) = '%s'
        LIMIT 1
    ]], sql_escape(codigoTextoLower)))

    if q then
        local row = {
            id        = q:GetUInt32(0),
            codigo    = q:GetString(1),
            itemId_1  = q:IsNull(2) and nil or q:GetUInt32(2),
            amount_1  = q:IsNull(3) and nil or q:GetUInt32(3),
            itemId_2  = q:IsNull(4) and nil or q:GetUInt32(4),
            amount_2  = q:IsNull(5) and nil or q:GetUInt32(5),
            itemId_3  = q:IsNull(6) and nil or q:GetUInt32(6),
            amount_3  = q:IsNull(7) and nil or q:GetUInt32(7),
            money     = q:IsNull(8) and 0   or q:GetInt32(8),
            stack     = q:GetUInt32(9),
        }
        codigosPorTexto[codigoTextoLower] = row
        return row
    else
        codigosPorTexto[codigoTextoLower] = nil
        return nil
    end
end

-- =========================
-- GOSSIP
-- =========================
local function OnGossipHello(event, player, object)
    -- Cargamos/recargamos por si hubo cambios
    cargarCodigos()

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

        -- Busca en cache; si no está, intenta refrescarlo de BD
        local entry = codigosPorTexto[codigoLower] or refrescarCodigoDesdeBD(codigoLower)
        if not entry then
            player:SendNotification("Código inválido o agotado.")
            player:GossipComplete()
            return
        end

        -- Refrescar por si el stack cambió
        entry = refrescarCodigoDesdeBD(codigoLower) or entry

        if entry.stack == 0 then
            player:SendNotification("Este código ya fue agotado.")
            player:GossipComplete()
            return
        end

        local guidLow = player:GetGUIDLow()

        -- ¿ya canjeó este jugador este código?
        if jugadorYaCanjeo(entry.id, guidLow) then
            player:SendNotification("Ya has canjeado este código anteriormente.")
            player:GossipComplete()
            return
        end

        -- Intentar decrementar el stack en BD primero (evita carreras)
        if not decrementarStack(entry.id) then
            player:SendNotification("No fue posible canjear: el código ya no tiene usos disponibles.")
            -- refrescar cache
            refrescarCodigoDesdeBD(codigoLower)
            player:GossipComplete()
            return
        end

        -- Entregar recompensas
        local ok, err = darRecompensas(player, entry)
        if not ok then
            -- Si las recompensas fallan, reponemos el stack para no perder un uso
            WorldDBExecute(string.format(
                "UPDATE codigos SET stack = stack + 1 WHERE id = %u",
                entry.id
            ))
            player:SendNotification(err or "Error al entregar las recompensas.")
            player:GossipComplete()
            return
        end

        -- Registrar canje
        registrarCanje(entry.id, guidLow)

        -- Actualizar cache local (disminuir stack)
        entry.stack = (entry.stack > 0) and (entry.stack - 1) or 0
        codigosPorTexto[codigoLower] = entry

        player:SendNotification("¡Código canjeado con éxito! Revisa tu inventario.")
    end

    player:GossipComplete()
end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
