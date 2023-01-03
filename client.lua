QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent("SCHackATMS:StartHack", function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local object = GetClosestObjectOfType(pedCoords, 5.0, `prop_fleeca_atm`, false)
    if DoesEntityExist(object) then
        local objectCoords = GetEntityCoords(object)
        QBCore.Functions.TriggerCallback('SCHackATMS:ATMCheck', function(canRob)
            if canRob then
                exports['ps-ui']:Scrambler(function(success)
                    if success then
                        QBCore.Functions.Progressbar('Hacking ATM', 'Hacking ATMs', 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = 'anim@gangops@facility@servers@',
                            anim = 'hotwire',
                            flags = 0
                        }, {}, {}, function()
                            ClearPedTasksImmediately(ped)
                            TriggerServerEvent("SCHackATMs:HackComplete", objectCoords)
                        end, function() 
                            TriggerServerEvent("SCHackATMS:CancelHack", objectCoords)
                        end)
                    end
                end, "numeric", 30, 0)
            end
        end, objectCoords)
    end
end)
function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end