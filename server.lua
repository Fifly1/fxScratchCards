local QBCore = nil
local ESX = nil
local xPlayer = nil

if Config.framework == "qbcore" then
    QBCore = exports["qb-core"]:GetCoreObject()

    QBCore.Functions.CreateUseableItem("fx_scratchcard", function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.RemoveItem(item.name, 1, item.slot)
        TriggerClientEvent("fx_scratchcards:client:Open", source)
    end)
else
    ESX = exports["es_extended"]:getSharedObject()

    ESX.RegisterUsableItem('fx_scratchcard', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('fx_scratchcard', 1)
        TriggerClientEvent("fx_scratchcards:client:Open", source)
    end)
end

RegisterServerEvent('fx_scratchcard:server:AddMoney')
AddEventHandler('fx_scratchcard:server:AddMoney', function(price)
    local src = source
    if Config.framework == "qbcore" then
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddMoney("cash", price)
    else
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addAccountMoney('bank', price)
    end
end)