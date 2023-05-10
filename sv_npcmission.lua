ESX = exports["es_extended"]:getSharedObject()


RegisterServerEvent('Wql:acquista')
AddEventHandler('Wql:acquista', function(value)
    local xPlayer = ESX.GetPlayerFromId(source)
    local prezzoGrimaldello = 2250 -- Prezzo grimaldello

    if value == 'grimaldello' then
        if xPlayer.getMoney() >= prezzoGrimaldello then
            xPlayer.removeMoney(prezzoGrimaldello)
            xPlayer.addInventoryItem('grimaldello', 1)
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {type = 'success', description = 'Hai comprato un grimaldello per ' .. prezzoGrimaldello .. '$'})
        else
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {type = 'error', description = 'Non hai abbastanza soldi!'})
        end
    end
end)

