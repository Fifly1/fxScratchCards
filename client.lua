RegisterNetEvent('fx_scratchcards:client:Open')
AddEventHandler('fx_scratchcards:client:Open', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openScratchCard",
        minPrice = Config.minPrice,
        maxPrice = Config.maxPrice,
        tryAgainPercentage = Config.tryAgainPercentage
    })
end)

RegisterNUICallback('exit', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('giveMoney', function(data)
    local price = tonumber(data.price)
    TriggerServerEvent('fx_scratchcard:server:AddMoney', price)
end)