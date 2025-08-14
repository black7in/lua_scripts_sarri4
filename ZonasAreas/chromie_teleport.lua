local npc = 50015

local spellTeleport = 62940
local spellVisual = 64446

local positionX = 857.86
local positionY = 253.95
local positionZ = 269.70
local positionO = 4.13
local pistionMap = 37

local text = "¡Hola! Soy Chromie, la guardiana del tiempo. ¿Quieres ir de cacería de Murlocs conmigo? ¡Será divertido! ¡Vamos a cazar algunos Murlocs juntos!"

local estado = 0

local function OnGossipHello(event, player, object)
    if estado == 1 then
        return
    end

    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Quiero ir de cacería de Murlocs", 0, 1, false "Está bien, Chromie. ¡Vamos a cazar Murlocs!")
    player:GossipMenuAddItem(0, "Salir", 0, 2)

    player:SendGossipText(text, npc)
    player:GossipSendMenu(npc, object)
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function CastSpellTeleport(eventid, delay, repeats, object) 
    object:CastSpell( object, spellTeleport, false )
end

local function EstadoO(eventid, delay, repeats, object) 
    estado = 0
    object:RemoveEvents()
end

local function TeleTransportarJugador(eventid, delay, repeats, player) 
    player:CastSpell(player, spellVisual, true)
    player:Teleport( pistionMap, positionX, positionY, positionZ, positionO ) -- Teletransporte a la ubicación deseada
end

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if intid == 1 then
        if estado == 0 then
            estado = 1
            object:SendUnitSay("¡Genial! ¡Vamos a cazar Murlocs juntos!", 0)
            object:RegisterEvent( CastSpellTeleport, 1000 )
            player:RegisterEvent( TeleTransportarJugador, 3000, 1 )
            object:RegisterEvent( EstadoO, 60000, 1 )
        else
            return
        end
    end

    if intid == 2 then
        object:SendUnitSay("¡Hasta luego!", 0)
    end

    player:GossipComplete()
end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)
