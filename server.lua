local QBCore = nil
local ESX = nil
local activeTokens = {}

if Config.framework == "qbcore" then
    QBCore = exports["qb-core"]:GetCoreObject()

    QBCore.Functions.CreateUseableItem("fx_scratchcard", function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.RemoveItem(item.name, 1, item.slot)
        local token = math.random(100000, 999999)
        activeTokens[src] = token
        TriggerClientEvent("fx_scratchcards:client:Open", src, token)
    end)
else
    ESX = exports["es_extended"]:getSharedObject()

    ESX.RegisterUsableItem('fx_scratchcard', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('fx_scratchcard', 1)
        local token = math.random(100000, 999999)
        activeTokens[source] = token
        TriggerClientEvent("fx_scratchcards:client:Open", source, token)
    end)
end

RegisterServerEvent('fx_scratchcard:server:AddMoney')
AddEventHandler('fx_scratchcard:server:AddMoney', function(token, price)
    local src = source
    if activeTokens[src] and activeTokens[src] == token then
        if Config.framework == "qbcore" then
            local Player = QBCore.Functions.GetPlayer(src)
            if Player and price >= Config.minPrice and price <= Config.maxPrice then
                Player.Functions.AddMoney("cash", price)
            end
        else
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer and price >= Config.minPrice and price <= Config.maxPrice then
                xPlayer.addAccountMoney('money', price)
            end
        end
    end
end)

RegisterServerEvent('fx_scratchcard:server:Closed')
AddEventHandler('fx_scratchcard:server:Closed', function()
    local src = source
    activeTokens[src] = nil
end)


