RegisterNetEvent('fx_scratchcards:client:Open')
AddEventHandler('fx_scratchcards:client:Open', function(token)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openScratchCard",
        minPrice = Config.minPrice,
        maxPrice = Config.maxPrice,
        tryAgainPercentage = Config.tryAgainPercentage,
        token = token
    })
end)

RegisterNUICallback('exit', function()
    SetNuiFocus(false, false)
    TriggerServerEvent('fx_scratchcard:server:Closed', source)
end)

RegisterNUICallback('giveMoney', function(data)
    local price = tonumber(data.price)
    local token = data.token
    TriggerServerEvent('fx_scratchcard:server:AddMoney', token, price)
end)
