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
function F.CodesLoadCache()
    CodesByText = {}
    CodesById   = {}

    local results = DBQuery([[
        SELECT
            id,            -- 0
            codigo,        -- 1
            itemId_1,      -- 2
            amount_1,      -- 3
            itemId_2,      -- 4
            amount_2,      -- 5
            itemId_3,      -- 6
            amount_3,      -- 7
            money,         -- 8
            stack          -- 9
        FROM codigos;
    ]])

    if results then
        local loaded = 0
        repeat
            local id      = results:GetUInt32(0)
            local codigo  = results:GetString(1)
            local codeKey = string.lower(codigo)

            local entry = {
                id       = id,
                codigo   = codigo,

                itemId_1 = results:IsNull(2) and nil or results:GetUInt32(2),
                amount_1 = results:IsNull(3) and nil or results:GetUInt32(3),

                itemId_2 = results:IsNull(4) and nil or results:GetUInt32(4),
                amount_2 = results:IsNull(5) and nil or results:GetUInt32(5),

                itemId_3 = results:IsNull(6) and nil or results:GetUInt32(6),
                amount_3 = results:IsNull(7) and nil or results:GetUInt32(7),

                money    = results:IsNull(8) and 0   or results:GetInt32(8),
                stack    = results:IsNull(9) and 0   or results:GetUInt32(9)
            }

            CodesByText[codeKey] = entry
            CodesById[id]        = entry
            loaded = loaded + 1
        until not results:NextRow()

        print(string.format("[Canjeador] Códigos cargados en caché: %d", loaded))
    else
        print("[Canjeador] No se encontraron códigos para cargar en caché.")
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
