
local areasInicio = {9, 363, 24, 59, 34, 364, 365, 132, 800, 188, 256, 3526, 3560, 3528, 3529, 3559, 2117, 154, 155, 221, 220, 358, 3431, 3458}

local doubleSpeed = 59737

local function OnUpdateArea(event, player, oldArea, newArea)
    if player:IsGM() then
        return -- No aplicar aura a GMs
    end
    -- verificar si el player esta en algun area de inicio
    local isInStartArea = false
    for _, area in ipairs(areasInicio) do
        if newArea == area then
            isInStartArea = true
            break
        end
    end
    -- si el player esta en un area de inicio, aplicar aura de velocidad
    if isInStartArea then
        player:AddAura(doubleSpeed, player) -- aplicar aura de velocidad
        local aura = player:GetAura( doubleSpeed )
        if aura then
            -- 1 hora en milisegundos
            aura:SetDuration(3600000) -- 1 hora en milisegundos
        end
        return
    else
        -- si sale de las areas de inicio, eliminar aura de velocidad
        if player:HasAura(doubleSpeed) then
            player:RemoveAura(doubleSpeed)
        end
    end
end

RegisterPlayerEvent(47, OnUpdateArea)

local function OnLeaveCombat(event, player)
    if player:IsGM() then
        return -- No aplicar aura a GMs
    end
    -- verificar si el player esta en algun area de inicio
    local isInStartArea = false
    for _, area in ipairs(areasInicio) do
        if newArea == area then
            isInStartArea = true
            break
        end
    end

    if isInStartArea then
        player:AddAura(doubleSpeed, player) -- aplicar aura de velocidad
        local aura = player:GetAura( doubleSpeed )
        if aura then
            -- 1 hora en milisegundos
            aura:SetDuration(3600000) -- 1 hora en milisegundos
        end
        return
    end
end

RegisterPlayerEvent(34, OnLeaveCombat) -- Evento 34 es Leave Combat