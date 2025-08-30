local emblemas = {
    47241,
    49426
}

local function OnLootItem(event, player, item, count)
    local itemId = item:GetEntry()
    local tabardo = Player:GetItemByPos( 255, 18 )

    if tabardo then
        if tabard:GetEntry() ~= 23388 then
            return
        end

        if emblemas[itemId] then
            local newItemId = emblemas[itemId]
            player:AddItem(newItemId, count)
        end
    end
end

-- RegisterPlayerEvent(32, OnLootItem)


local function OnQuestRewardItem(event, player, item, count)
    local itemId = item:GetEntry()
    local tabardo = Player:GetItemByPos( 255, 18 )

    if tabardo then
        if tabard:GetEntry() ~= 23388 then
            return
        end

        if emblemas[itemId] then
            local newItemId = emblemas[itemId]
            player:AddItem(newItemId, count)
        end
    end
end

-- RegisterPlayerEvent(51, OnQuestRewardItem)

local function OnStoreNewItem(event, player, item, count)
    local itemId = item:GetEntry()
    local tabardo = Player:GetItemByPos( 255, 18 )

    if tabardo then
        if tabard:GetEntry() ~= 23388 then
            return
        end

        if emblemas[itemId] then
            local newItemId = emblemas[itemId]
            player:AddItem(newItemId, count)
        end
    end
end

-- Aqui se puede generar un bucle bien gacho, pq dare add y otra vez y otra vez jejeje lo unic que veo es modificar esa mrd
-- RegisterPacketEvent(53, OnStoreNewItem)