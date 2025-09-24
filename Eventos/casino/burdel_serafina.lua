local npcSerafina = 60034

local florecitas = {
    60035,
    60036,
    60037,
}

local textoSerafina = {
    "Sígueme, guapo. Te voy a presentar a mis chicas.",
    "La primera es Margarita. Es muy dulce y cariñosa.",
    "Esta es Violeta. Le encanta que la mimen.",
    "Y por último, Jazmin. Es un poco traviesa, pero muy divertida.",
    "Si te gusta alguna, puedes llevartela al privado por 10 fichas extra. Solo tienes que hablar con ella.",
}

local estado = "INICIAL"
local timer = 0

local gossipTextSerafina = "¡Hola, guapo! ¿Quieres ver a mis florecitas? Solo cuesta 10 fichas la presentación.\n\nSi te gusta una de mis chicas podrás llevartela al privado por 10 fichas extra."

local function OnGossipHelloSerafina(event, player, object)
    player:GossipMenuAddItem(0, "Quiero ver a tus florecitas!", 0, 1, false, "Ver a las florecitas cuesta 10 fichas. ¿Quieres continuar?")
    player:GossipMenuAddItem(0, "Salir", 0, 3)
    player:SendGossipText(gossipTextSerafina, npcSerafina)
    player:GossipSendMenu(npcSerafina, object)
end

RegisterCreatureGossipEvent(npcSerafina, 1, OnGossipHelloSerafina)


local function MovePos2(eventid, delay, repeats, worldobject)
    worldobject:MoveTo( 1, -1642.25, -4380.09, 9.497 )
    estado = "ENPOSICION"
end

local function OnGossipSelectSerafina(event, player, object, sender, intid, code, menu_id)
    if intid == 1 then
        estado = "CAMINANDOPOSICION"
        object:SetWalk( true )
        object:MoveTo( 1, -1643.47, -4381.58, 9.49 )
        object:RegisterEvent(MovePos2, 10000, 1)
        object:SendUnitSay(textoSerafina[1], 0)
        object:RemoveFlag( 82, 1 )
    elseif intid == 2 then
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(npcSerafina, 2, OnGossipSelectSerafina)

local index = 2  -- empieza desde textoSerafina[2]

local function AIUpdate(event, creature, diff)
    if timer > 0 then
        timer = timer - diff
        return
    end

    if textoSerafina[index] then
        creature:SendUnitSay(textoSerafina[index], 0)
        index = index + 1
        timer = 5000 -- espera entre cada texto
    else
        estado = "FINISH"
    end
end

RegisterCreatureEvent(npcSerafina, 7, AIUpdate)