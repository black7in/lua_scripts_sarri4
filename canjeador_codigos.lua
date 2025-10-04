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

local text = "¡Hola! Soy Grunty, el canjeador de códigos. Si tienes un código especial, puedo ayudarte a canjearlo por recompensas increíbles. ¿Quieres canjear un código ahora?"


-- Caché en memoria
local codigosCache = {}

-- Función para escapar strings simples (por seguridad)
local function sql_escape(str)
    return (tostring(str):gsub("'", "''"))
end

-- Función para cargar todos los códigos en cache
local function CargarCodigos()
    codigosCache = {}

    local query = CharDBQuery([[
        SELECT id, codigo,
               itemId_1, amount_1,
               itemId_2, amount_2,
               itemId_3, amount_3,
               money, stack
        FROM codigos
    ]])

    if query then
        repeat
            local row = {
                id       = query:GetUInt32(0),
                codigo   = query:GetString(1),
                itemId_1 = query:IsNull(2) and nil or query:GetUInt32(2),
                amount_1 = query:IsNull(3) and nil or query:GetUInt32(3),
                itemId_2 = query:IsNull(4) and nil or query:GetUInt32(4),
                amount_2 = query:IsNull(5) and nil or query:GetUInt32(5),
                itemId_3 = query:IsNull(6) and nil or query:GetUInt32(6),
                amount_3 = query:IsNull(7) and nil or query:GetUInt32(7),
                money    = query:IsNull(8) and 0 or query:GetInt32(8),
                stack    = query:GetUInt32(9)
            }
            codigosCache[string.lower(row.codigo)] = row
        until not query:NextRow()
    end

    print("[Canjeador] Códigos cargados en caché: " .. tostring(#codigosCache))
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
CargarCodigos()
