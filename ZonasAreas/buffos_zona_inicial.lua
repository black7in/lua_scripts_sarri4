
local areasInicio = {9, 363}

local doubleSpeed = 59737

local function OnUpdateArea(event, player, oldArea, newArea)
    -- verificar si el player esta en algun area de inicio
    if newArea == 9 or newArea == 363 then
        player:AddAura(doubleSpeed, player) -- aplicar aura de velocidad
        local aura = player:GetAura( doubleSpeed )
        if aura then
            -- 1 hora en milisegundos
            aura:SetDuration(3600000) -- 1 hora en milisegundos
        end
    else
        -- si sale de las areas de inicio, eliminar aura de velocidad
        if player:HasAura(doubleSpeed) then
            player:RemoveAura(doubleSpeed)
        end
    end
end

RegisterPlayerEvent(47, OnUpdateArea)