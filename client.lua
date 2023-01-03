QBCore = exports['qb-core']:GetCoreObject()
local atmProps = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_fleeca_atm"
}


exports['qb-target']:AddTargetModel(atmProps, { -- This defines the models, can be a string or a table
options = { -- This is your options table, in this table all the options will be specified for the target to accept
    { -- This is the first table with options, you can make as many options inside the options table as you want
    num = 1, -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
    icon = 'fas fa-example', -- This is the icon that will display next to this trigger option
    label = 'Rob ATM', -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string

    action = function(entity) -- This is the action it has to perform, this REPLACES the event and this is OPTIONAL
        StartRobbery(entity)
    end,
    }
},
distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
})

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
