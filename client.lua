RegisterNetEvent('fx_scratchcards:client:Open')
AddEventHandler('fx_scratchcards:client:Open', function(prizes)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openScratchCard",
        resourceName = GetCurrentResourceName(),
        prizes = prizes
    })
    if not IsPedInAnyVehicle(PlayerPedId()) then
        TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 0, true)
    end
end)


RegisterNUICallback('exit', function()
    SetNuiFocus(false, false)
    if not IsPedInAnyVehicle(PlayerPedId()) then
        ClearPedTasksImmediately(PlayerPedId())
    end
end)

RegisterNUICallback('giveMoney', function(data)
    local slotIndex = tonumber(data.slotIndex)
    TriggerServerEvent('fx_scratchcard:server:AddMoney', slotIndex)
end)
