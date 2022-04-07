
ESX = nil
AdminPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('tag', function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if AdminPlayers[source] == nil then
            AdminPlayers[source] = {source = source, group = xPlayer.getGroup()}
    else
        AdminPlayers[source] = nil
    end
    TriggerClientEvent('adutyiteg:set_admins',-1,AdminPlayers)
end)

ESX.RegisterServerCallback('adutyiteg:getAdminsPlayers',function(source,cb)
    cb(AdminPlayers)
end)

AddEventHandler('esx:playerDropped', function(source)
    if AdminPlayers[source] ~= nil then
        AdminPlayers[source] = nil
    end
    TriggerClientEvent('adutyiteg:set_admins',-1,AdminPlayers)
end)
