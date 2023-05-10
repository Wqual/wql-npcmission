ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    if not HasModelLoaded('csb_chin_goon') then
       RequestModel('csb_chin_goon')
       while not HasModelLoaded('csb_chin_goon') do
          Citizen.Wait(5)
       end
    end

npc = CreatePed(4, 'csb_chin_goon', -429.4413, 1109.6167, 326.6818, 340.9529, false, true)
FreezeEntityPosition(npc, true)
SetEntityInvincible(npc, true)
SetBlockingOfNonTemporaryEvents(npc, true)


CreateThread(function()
   while true do
       Sleep = 1000
           local ped = PlayerPedId()
           local plyCords = GetEntityCoords(ped)
           local coords = vector3(-429.4413, 1109.6167, 326.6818 + 2)
           local dist = #( plyCords - coords)
           if dist < 5 then
               Sleep = 0
               SetFloatingHelpTextWorldPosition(1, coords)
               SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
               BeginTextCommandDisplayHelp("Indicazione1")
               EndTextCommandDisplayHelp(2, false, false, -1)
           end
       Wait(Sleep)
   end
end)

local startveicolo = true

local options = {
    {
        name = 'ox:mandante',
        onSelect = function()
            startveicolo = false
            Wqual() end,
        icon = 'fa-solid fa-person-rifle',
        label = '💀 Uccidi Mandante',
        canInteract = function(entity)
            return not IsEntityDead(entity) and startveicolo
        end
    }
}

local optionNames = { 'ox:mrbosic'}
exports.ox_target:addLocalEntity(npc,options)


end)


Wqual = function()
    lavoro = true
    ESX.Game.SpawnVehicle('burrito3', vector3(-408.9817, 1183.1298, 325.5564), 85.29, function(v)
        SetPedIntoVehicle(PlayerPedId(), v, -1)
    end)
    ESX.ShowNotification('Raggiungi la posizione e uccidi il mandante!')
    waypoint5 = SetNewWaypoint(3334.8523, 5163.3628, 18.3227)
    Wql = AddBlipForCoord(3334.8523, 5163.3628, 18.3227)
    SetBlipSprite (Wql, 156)
    SetBlipDisplay(Wql, 6)
    SetBlipScale  (Wql, 0.9)
    SetBlipColour (Wql, 0)
    SetBlipAsShortRange(Wql, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("[Mandante]")
    EndTextCommandSetBlipName(Wql)
    
end 


Citizen.CreateThread(function()
    if not HasModelLoaded('s_m_y_dealer_01') then
       RequestModel('s_m_y_dealer_01')
       while not HasModelLoaded('s_m_y_dealer_01') do
          Citizen.Wait(5)
       end
    end

npc = CreatePed(4, 's_m_y_dealer_01', 3334.7817, 5161.9512, 17.2999, 286.8217, false, true)
FreezeEntityPosition(npc, true)
SetEntityInvincible(npc, false)
SetBlockingOfNonTemporaryEvents(npc, true)

local perquisizione = true

local options = {
    {
        name = 'ox:option1',
        icon = 'fa-sharp fa-solid fa-hand',
        label = 'Perquisisci Mandante',

        canInteract = function(entity, distance, coords, name, bone)
            return IsEntityDead(entity) and perquisizione
        end,

        onSelect = function(data)
            if lib.progressBar({
                duration = 5000,
                ESX.ShowNotification('Hai ucciso il mandante! Cerca nelle sue tasche...'),
                label = 'Cercando nelle tasche...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
                anim = {
                    dict = 'mini@repair',
                    clip = 'fixing_a_ped'
                }
            }) then
                ESX.ShowNotification('Ora possiedi la valiggetta! Raggiungi gps impostato')
                waypoint5 = SetNewWaypoint(-35.5588, 2871.5527, 59.6102)
                Wql2 = AddBlipForCoord(-35.5588, 2871.5527, 59.6102)
                print("ciao")
                SetBlipSprite (Wql2, 351)
                SetBlipDisplay(Wql2, 6)
                SetBlipScale  (Wql2, 1.3)
                SetBlipColour (Wql2, 56)
                SetBlipAsShortRange(Wql2, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString("[Punto di consegna]")
                EndTextCommandSetBlipName(Wql2)
                
                TriggerServerEvent("SearchMandante")
                perquisizione = false

            end
        end
        
    }
}

exports.ox_target:addLocalEntity(npc, options)

end)

Citizen.CreateThread(function()
    if not HasModelLoaded('ig_claypain') then
       RequestModel('ig_claypain')
       while not HasModelLoaded('ig_claypain') do
          Citizen.Wait(5)
       end
    end

npc = CreatePed(4, 'ig_claypain', -35.5588, 2871.5527, 58.6102, 160.5027, false, true)
FreezeEntityPosition(npc, true)
SetEntityInvincible(npc, true)
SetBlockingOfNonTemporaryEvents(npc, true)

local vendita = {
    {
        name = 'ox:vendita',
        icon = 'fa-solid fa-money-bill',
        label = 'Consegna Valigetta',
        onSelect = function()
            local chechitem = exports.ox_inventory:Search('count', 'valigia')
            if chechitem >= 1 then
                TriggerServerEvent("vendita_missione")
                RemoveBlip(Wql)
                RemoveBlip(Wql2)
            end
        end,
        canInteract = function(entity)
            return not IsEntityDead(entity)
        end
    }
}

exports.ox_target:addLocalEntity(npc,vendita)

end)
