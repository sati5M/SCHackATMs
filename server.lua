QBCore = exports['qb-core']:GetCoreObject()
local hackedATMs, inHack = {}, {}
local itemsToGive = {{["lockpick"] = 3, ["laptop"] = 2}, {["lockpick"] = 1, ["laptop"] = 4},}
RegisterNetEvent("SCHackATMs:HackComplete", function(objCoords)
    local source = source
    if inHack[source] == objCoords then
        local Player = QBCore.Functions.GetPlayer(source)
        local randomItemsToGive = itemsToGive[math.random(#itemsToGive)]
        local moneyToGive = math.random(5000, 10000)
        for k, v in pairs(randomItemsToGive) do
            Player.Functions.AddItem(k, v)
            Player.Functions.AddMoney('cash', moneyToGive)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[k], "add")
        end
        inHack[source] = false
        QBCore.Functions.Notify(source, 'ATM robbed.', 'success', 7500)
    end
end)
RegisterNetEvent("SCHackATMS:CancelHack", function(objCoords, fail)
    local source = source
    if inHack[source] == objCoords then
        inHack[source] = false
        hackedATMs[objCoords] = false
        if not fail then
            QBCore.Functions.Notify(source, 'Hack cancelled.', 'error', 7500)
        else
            QBCore.Functions.Notify(source, 'You failed the hack', 'error', 7500)
        end
    end
end) 
QBCore.Functions.CreateCallback('SCHackATMS:ATMCheck', function(source, cb, coords)
    local Player = QBCore.Functions.GetPlayer(source)
    if not hackedATMs[coords] then
        inHack[source] = coords
        hackedATMs[coords] = true
        Player.Functions.RemoveItem("laptop")
        cb(true)
    else
        QBCore.Functions.Notify(source, 'This ATM has already been robbed!', 'error', 7500)
        cb(false)
    end
end)