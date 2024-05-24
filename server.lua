local QBCore = nil
local ESX = nil
local activePrizes = {}

if Config.framework == "qbcore" then
    QBCore = exports["qb-core"]:GetCoreObject()

    QBCore.Functions.CreateUseableItem("fx_scratchcard", function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.RemoveItem(item.name, 1, item.slot)
        
        local prizes = {}
        for i = 1, 6 do
            if math.random() < Config.tryAgainPercentage then
                table.insert(prizes, "")
            else
                table.insert(prizes, math.floor(math.random(Config.minPrice, Config.maxPrice)))
            end
        end
        
        activePrizes[src] = { prizes = prizes, claimed = {false, false, false, false, false, false} }
        
        TriggerClientEvent("fx_scratchcards:client:Open", src, prizes)
    end)
else
    ESX = exports["es_extended"]:getSharedObject()

    ESX.RegisterUsableItem('fx_scratchcard', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('fx_scratchcard', 1)
        
        local prizes = {}
        for i = 1, 6 do
            if math.random() < Config.tryAgainPercentage then
                table.insert(prizes, "")
            else
                table.insert(prizes, math.floor(math.random(Config.minPrice, Config.maxPrice)))
            end
        end
        
        activePrizes[source] = { prizes = prizes, claimed = {false, false, false, false, false, false} }
        
        TriggerClientEvent("fx_scratchcards:client:Open", source, prizes)
    end)
end

RegisterServerEvent('fx_scratchcard:server:AddMoney')
AddEventHandler('fx_scratchcard:server:AddMoney', function(slotIndex)
    local src = source
    local prizeData = activePrizes[src]
    if prizeData and prizeData.claimed[slotIndex + 1] == false then
        local prize = prizeData.prizes[slotIndex + 1]
        if prize ~= "" and prize >= Config.minPrice and prize <= Config.maxPrice then
            if Config.framework == "qbcore" then
                local Player = QBCore.Functions.GetPlayer(src)
                if Player then
                    Player.Functions.AddMoney("cash", prize)
                end
            else
                local xPlayer = ESX.GetPlayerFromId(src)
                if xPlayer then
                    xPlayer.addAccountMoney('money', prize)
                end
            end
            prizeData.claimed[slotIndex + 1] = true
        end
    end
end)
