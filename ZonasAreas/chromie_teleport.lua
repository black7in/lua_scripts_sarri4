local npc = 50015

local spellTeleport = 62940
local spellVisual = 64446

local positionX = 857.86
local positionY = 253.95
local positionZ = 269.70
local positionO = 4.13
local pistionMap = 37

local positions = {
    [RACE_HUMAN] = {0, -9090.85, -48.61, 85.96, 2.30},
    [RACE_ORC] = {1, -608.0826, -4608.98, 41.422, 3.24},
    [RACE_BLOOD_ELF] = {530, 10047.55, -6365.54, 4.66, 3.384},
    [RACE_DRAENEI] = {530, -4243.47, -13008.87, 0.46, 0.62}, -- ojo al punto decimal
    [RACE_DWARF] = {0, -6013.65, 58.160, 405.12, 1.18},
    [RACE_GNOME] = {0, -6013.65, 58.160, 405.12, 1.18},
    [RACE_NIGTH_ELF] = {1, 10047.31, 576.69, 1320.84, 3.21},
    [RACE_TAUREN] = {1, -2998.72, 181.24, 70.17, 1.95},
    [RACE_TROLL] = {1, -608.0826, -4608.98, 41.422, 3.24},
    [RACE_UNDEAD] = {0, 2159.60, 1249.73, 49.08, 3.95}
}

local text =
    "¡Hola! Soy Chromie, la guardiana del tiempo. ¿Quieres ir de cacería de Murlocs conmigo? ¡Será divertido! ¡Vamos a cazar algunos Murlocs juntos!"

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()

    if player:GetAreaId() == 268 then
        player:GossipMenuAddItem(0, "Quiero salir de esta zona", 0, 3, false,
                                 "¡Claro! Te teletransportaré a un lugar seguro fuera de esta zona.")
    else
        player:GossipMenuAddItem(0, "Quiero ir de cacería de Murlocs", 0, 1,
                                 false,
                                 "Está bien, Chromie. ¡Vamos a cazar Murlocs!")
    end

    player:GossipMenuAddItem(0, "Salir", 0, 2)

    player:SendGossipText(text, npc)
    player:GossipSendMenu(npc, object)
end

RegisterCreatureGossipEvent(npc, 1, OnGossipHello)

local function CastSpellTeleport(eventid, delay, repeats, object)
    object:CastSpell(object, spellTeleport, false)
end

local function EstadoO(eventid, delay, repeats, object) object:RemoveEvents() end

local function TeleTransportarJugador(eventid, delay, repeats, player)
    player:CastSpell(player, spellVisual, true)
    player:Teleport(pistionMap, positionX, positionY, positionZ, positionO) -- Teletransporte a la ubicación deseada
end

local function OnGossipSelect(event, player, object, sender, intid, code,
                              menu_id)
    if intid == 1 then
        object:SendUnitSay("¡Genial! ¡Vamos a cazar Murlocs juntos!", 0)
        object:RegisterEvent(CastSpellTeleport, 1000)
        player:RegisterEvent(TeleTransportarJugador, 3000, 1)
        object:RegisterEvent(EstadoO, 3000, 1)
    end

    if intid == 3 then
        local race = player:GetRace()

        -- teletranportar segun su raza
        player:Teleport(positions[race][1], positions[race][2],
                        positions[race][3], positions[race][4],
                        positions[race][5])

    end

    if intid == 2 then object:SendUnitSay("¡Hasta luego!", 0) end

    player:GossipComplete()
end
RegisterCreatureGossipEvent(npc, 2, OnGossipSelect)


local function OnRepop(event, player)
    if player:GetAreaId() == 268 then
        player::ResurrectPlayer( 100 )
    end
end

RegisterPlayerEvent(35, OnRepop)