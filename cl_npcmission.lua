ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    if not HasModelLoaded('a_m_y_soucent_02') then
       RequestModel('a_m_y_soucent_02')
       while not HasModelLoaded('a_m_y_soucent_02') do
          Citizen.Wait(5)
       end
    end

npc = CreatePed(4, 'a_m_y_soucent_02', -40.7923, -1674.7013, 28.4704, 132.8449, false, true)
FreezeEntityPosition(npc, true)
SetEntityInvincible(npc, true)
SetBlockingOfNonTemporaryEvents(npc, true)

local VenditaNpc = false
local options = {
    
    {
        name = 'ox:miky',
        event = 'Wql:acquista',
        icon = 'fa-solid fa-road',
        label = '💸 Acquista Grimaldello',
        canInteract = function(entity)
            return not IsEntityDead(entity)
        end
    },
    {
        name = 'ox:furtocasa',
        onSelect = function()
        Wqual() end,
        icon = 'fa-solid fa-road',
        label = '🏠 Civico Casa',
        canInteract = function(entity)
            return not IsEntityDead(entity)
        end
    }
}

local optionNames = { 'ox:miky'}
exports.ox_target:addLocalEntity(npc,options)


end)

local VenditaNpc = nil

RegisterNetEvent('Wql:acquista')
AddEventHandler('Wql:acquista', function(value)
    VenditaNpc = value
end)

RegisterNetEvent('Wql:acquista') 
AddEventHandler('Wql:acquista', function()
    local Ped = PlayerPedId()
    local input = lib.inputDialog('Parla con Miky', {
        {type = 'select', label = 'Vendita di grimaldelli', options = {
            {label = "Grimaldello", value = "grimaldello"}
        }},
    })
    
    if input and #input > 0 then
        TriggerServerEvent('Wql:acquista', input[1])
    end
end)

Wqual = function()
    lavoro = true
    ESX.Game.SpawnVehicle('burrito3', vector3(-46.6498, -1678.5007, 29.3876), 85.29, function(v)
        SetPedIntoVehicle(PlayerPedId(), v, -1)
    end)
    ESX.ShowNotification('Raggiungi la casa da rapinare!')
    waypoint5 = SetNewWaypoint(-149.9468, 123.9495, 70.2254)
    Wql = AddBlipForCoord(-149.9468, 123.9495, 70.2254)
    SetBlipSprite (Wql, 40)
    SetBlipDisplay(Wql, 6)
    SetBlipScale  (Wql, 0.8)
    SetBlipColour (Wql, 2)
    SetBlipAsShortRange(Wql, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Casa da rapinare")
    EndTextCommandSetBlipName(Wql)
    
end 


local casaPopolareEntrata = {
    coords = Wql.EntrataCasa,
    size = vec3(2, 2, 2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'casepopolari',
            icon = 'fa-solid fa-home',
            label = Wql.Traduzione["entra"],
            onSelect = function(data)
                -- Controlla se il giocatore ha la chiave per entrare nella casa popolare
                if HasKey("grimaldello") then -- Item 
                    DoScreenFadeOut(800)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(0)
                    end
                    TriggerServerEvent('entraincasa')
                    SetEntityCoords(PlayerPedId(), Wql.TeleportEntrata)
                    DoScreenFadeIn(800)
                else
                    -- Mostra un messaggio di errore se il giocatore non ha la chiave
					lib.notify({
						title = 'Casa Popolare',
						description = 'Non hai la chiave per entrare in casa!',
						type = 'error'
					})
                    
                end
            end,
        },
    },
}


-- Definisci la zona di uscita dalla casa popolare
local casaPopolareUscita = {
    coords = Wql.UscitaCasa,
    size = vec3(2, 2, 2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'casepopolariuscita',
            icon = 'fa-solid fa-home',
            label = Wql.Traduzione["esci"],
            onSelect = function(data)
                -- Controlla se il giocatore ha la chiave per entrare nella casa popolare
                if HasKey("grimaldello") then -- Item 
                    DoScreenFadeOut(800)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(0)
                    end
                    TriggerServerEvent('escidallacasa')
                    SetEntityCoords(PlayerPedId(), Wql.TeleportUscita)
                    DoScreenFadeIn(800)
                else
                    -- Mostra un messaggio di errore se il giocatore non ha la chiave
					lib.notify({
						title = 'Casa Popolare',
						description = 'Non hai la chiave per uscire di casa!',
						type = 'error'
					})
                    
                end
            end,
        },
    },
}

-- Aggiungi le zone al sistema di trigger della mappa
Citizen.CreateThread(function()
    exports.ox_target:addBoxZone(casaPopolareEntrata)
    exports.ox_target:addBoxZone(casaPopolareUscita)
end)

function HasKey(keyName)
    local player = GetPlayerPed(-1)
    local inventory = ESX.GetPlayerData().inventory
    for i = 1, #inventory do
        local item = inventory[i]
        if item and item.name == keyName then
            return true
        end
    end
    return false
end

exports.ox_target:addBoxZone({
	coords = Wql.FrigoPopolare,
	size = vec3(2, 2, 2),
	rotation = 45,
	debug = drawZones,
	options = {
		{
			name = 'casepopolari',
			icon = 'fa-solid fa-home',
			label = Wql.Traduzione["frigobar"],
			onSelect = function(data)
				-- Frigo Bar delle case popolari
			exports.ox_inventory:openInventory('shop', { type = 'RapinaCasa', id = 1})
			
			end,
		}
	}
})
