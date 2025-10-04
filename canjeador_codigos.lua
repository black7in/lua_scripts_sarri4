local npc = 50018
-- =========================
-- CACHÉS EN MEMORIA
-- =========================
-- codigosPorTexto["abc123"] = { id=..., codigo="ABC123", itemId_1=..., amount_1=..., money=..., stack=... }
local codigosPorTexto = {}
-- canjesPorCodigo[codigo_id] = { [jugador_guid_low] = true, ... }
local canjesPorCodigo = {}
-- locks por código para evitar carreras simultáneas
local codeLocks = {}

local text =
    "¡Hola! Soy Grunty, el canjeador de códigos. Si tienes un código especial, puedo ayudarte a canjearlo por recompensas increíbles. ¿Quieres canjear un código ahora?"

-- Caché en memoria
local CodesCache = {}

-- Función para cargar todos los códigos en cache
-- =========================
-- CACHE GLOBAL
-- =========================
local DBQuery = CharDBQuery -- cambia si usas WorldDB o AuthDB

-- =========================
-- FUNCIÓN PARA CARGAR CÓDIGOS
-- =========================
local function LoadCodesCache()
    CodesCache = {}
    local loaded = 0

    local results = DBQuery("SELECT id, codigo, itemId_1, amount_1, itemId_2, amount_2, itemId_3, amount_3, money, stack FROM codigos;")

    if results then
        repeat
            local id = results:GetUInt32(0)

            CodesCache[id] = {
                id = id,
                codigo = results:GetString(1),

                itemId_1 = results:IsNull(2) and nil or results:GetUInt32(2),
                amount_1 = results:IsNull(3) and nil or results:GetUInt32(3),

                itemId_2 = results:IsNull(4) and nil or results:GetUInt32(4),
                amount_2 = results:IsNull(5) and nil or results:GetUInt32(5),

                itemId_3 = results:IsNull(6) and nil or results:GetUInt32(6),
                amount_3 = results:IsNull(7) and nil or results:GetUInt32(7),

                money = results:IsNull(8) and 0 or results:GetInt32(8),
                stack = results:IsNull(9) and 0 or results:GetUInt32(9)
            }

            loaded = loaded + 1
        until not results:NextRow()

        print(string.format("[Canjeador] Códigos cargados en caché: %d", loaded))
    else
        print("[Canjeador] No hay códigos en la base de datos.")
    end
end

-- =========================
-- VERIFICAR CÓDIGO EN CACHE
-- =========================
local function IsCodeValid(code)
    if not code or code == "" then return false, nil end

    -- Normalizamos a minúsculas
    local codeLower = string.lower(code)

    -- Buscar en cache por coincidencia exacta en codigo
    for _, entry in pairs(CodesCache) do
        if string.lower(entry.codigo) == codeLower then
            -- Debe tener stack > 0 para ser válido
            if entry.stack and entry.stack > 0 then
                return true, entry
            else
                return false, nil
            end
        end
    end

    -- No encontrado
    return false, nil
end

-- =========================
-- VERIFICAR STACK DISPONIBLE
-- =========================
local function HasStackAvailable(entry)
    if not entry then return false end

    if entry.stack and entry.stack > 0 then return true end

    return false
end

-- =========================
-- VERIFICAR SI JUGADOR YA CANJEÓ EL CÓDIGO
-- =========================
local function HasPlayerRedeemedCode(playerId, codigoId)
    -- playerId = GUID low del jugador (player:GetGUIDLow())
    -- codigoId = id del código en la tabla codigos

    local sql = string.format("SELECT 1 FROM canjes WHERE codigo_id = %u AND jugador_id = %u LIMIT 1;", codigoId, playerId)

    local result = CharDBQuery(sql) -- o WorldDBQuery si tus tablas están en WorldDB

    if result then
        return true -- el jugador ya canjeó este código
    end

    return false
end

-- =========================
-- GOSSIP
-- =========================
local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    -- Opción para canjear
    player:GossipMenuAddItem(0, "Canjear código", 0, 1, true, "Ingresa el código que quieres canjear")
    -- Opción para salir
    player:GossipMenuAddItem(0, "No quiero nada", 0, 2)
    player:GossipSendMenu(1, object)
end
RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function trim(s)
    if not s then return "" end
    return (tostring(s):gsub("^%s*(.-)%s*$", "%1"))
end

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    -- Solo procesamos cuando el jugador elige la opción de canjear (intid == 1)
    if intid ~= 1 then
        player:GossipComplete()
        return
    end

    -- 1) Leer y normalizar la entrada
    local input = trim(code)
    if input == "" then
        player:SendNotification("Código vacío.")
        player:GossipComplete()
        return
    end

    -- 2) Verificar si el código es válido (SOLO CACHE)
    local ok, entry = IsCodeValid(input) -- devuelve true/false, entry
    if not ok or not entry then
        player:SendNotification("Código inválido o no existe.")
        player:GossipComplete()
        return
    end

    -- 3) Verificar stack disponible (SOLO CACHE)
    if not HasStackAvailable(entry) then
        player:SendNotification("Este código ya no tiene usos disponibles.")
        player:GossipComplete()
        return
    end

    -- 4) Verificar en BD si el jugador ya canjeó este código
    local guidLow = player:GetGUIDLow()
    local yaCanjeo = HasPlayerRedeemedCode(guidLow, entry.id) -- consulta BD
    if yaCanjeo then
        player:SendNotification("Ya has canjeado este código anteriormente.")
        player:GossipComplete()
        return
    end

    -- Dar ítems (ignoras si hay espacio o no)
    if entry.itemId_1 and entry.amount_1 and entry.amount_1 > 0 then player:AddItem(entry.itemId_1, entry.amount_1) end
    if entry.itemId_2 and entry.amount_2 and entry.amount_2 > 0 then player:AddItem(entry.itemId_2, entry.amount_2) end
    if entry.itemId_3 and entry.amount_3 and entry.amount_3 > 0 then player:AddItem(entry.itemId_3, entry.amount_3) end

    -- Dar dinero
    if entry.money and entry.money > 0 then
        player:ModifyMoney(entry.money) -- se asume en cobre
    end

    -- Restar stack en cache
    entry.stack = entry.stack - 1

    -- Restar stack en BD
    CharDBExecute(string.format("UPDATE codigos SET stack = stack - 1 WHERE id = %u", entry.id))

    -- Registrar canje en BD
    CharDBExecute(string.format("INSERT INTO canjes (codigo_id, jugador_id) VALUES (%u, %u)", entry.id, guidLow))

    -- Mensaje final
    player:SendNotification("¡Código canjeado con éxito! Revisa tu inventario.")
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
            LoadCodesCache()
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
LoadCodesCache()
