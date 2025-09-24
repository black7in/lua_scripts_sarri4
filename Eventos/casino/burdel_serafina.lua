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
end

local function CambiraEstado(eventid, delay, repeats, worldobject)
    estado = "ENPOSICION"
end

local function OnGossipSelectSerafina(event, player, object, sender, intid, code, menu_id)
    if intid == 1 then
        estado = "CAMINANDOPOSICION"
        object:SetWalk( true )
        object:MoveTo( 1, -1643.47, -4381.58, 9.49 )
        object:RegisterEvent(MovePos2, 12000, 1)
        object:RegisterEvent(CambiraEstado, 17000, 1)
        object:SendUnitSay(textoSerafina[1], 0)
        object:RemoveFlag( 82, 1 )
    elseif intid == 2 then
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(npcSerafina, 2, OnGossipSelectSerafina)

local function AIUpdate(event, creature, diff)
    if estado == "ENPOSICION" and timer <= 0 then
        creature:SendUnitSay(textoSerafina[2], 0)
        estado = "TEXTO2"
        timer = 5000
    elseif estado == "TEXTO2" and timer <= 0 then
        creature:SendUnitSay(textoSerafina[3], 0)
        estado = "TEXTO3"
        timer = 5000
    elseif estado == "TEXTO3" and timer <= 0 then
        creature:SendUnitSay(textoSerafina[4], 0)
        estado = "TEXTO4"
        timer = 5000
    elseif estado == "TEXTO4" and timer <= 0 then
        creature:SendUnitSay(textoSerafina[5], 0)
        estado = "FINISH"
    end

    -- resta el diff al timer si es mayor a 0
    if timer > 0 then
        timer = timer - diff
    end
end

RegisterCreatureEvent(npcSerafina, 7, AIUpdate)