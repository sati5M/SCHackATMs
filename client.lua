QBCore = exports['qb-core']:GetCoreObject()
local atmProps = {"prop_atm_01","prop_atm_02","prop_atm_03","prop_fleeca_atm"}
exports['qb-target']:AddTargetModel(atmProps, {options = { { icon = 'fas fa-example', label = 'Rob ATM', item = "laptop",
    action = function(entity)
        StartRobbery(entity)
    end,}},distance = 2.5,})
AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
        exports['qb-target']:RemoveTargetModel(atmProps, 'Rob ATM')
   end
end)
function StartRobbery(entity)
    local ped = PlayerPedId()
    local objectCoords = GetEntityCoords(entity)
    QBCore.Functions.TriggerCallback('SCHackATMS:ATMCheck', function(canRob)
        if canRob then
            exports['ps-ui']:Scrambler(function(success)
                if success then
                    QBCore.Functions.Progressbar('Hacking ATM', 'Hacking ATMs', 5000, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {animDict = 'anim@gangops@facility@servers@',anim = 'hotwire',flags = 0}, {}, {}, 
                    function()
                        ClearPedTasksImmediately(ped)
                        TriggerServerEvent("SCHackATMs:HackComplete", objectCoords)
                    end, function() 
                        TriggerServerEvent("SCHackATMS:CancelHack", objectCoords)
                    end)
                else
                    TriggerServerEvent("SCHackATMS:CancelHack", objectCoords, true)
                end
            end, "numeric", 30, 0)
        end
    end, objectCoords)
end
