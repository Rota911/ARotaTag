
ESX = nil
local currentAdminPlayers = {}
local visibleAdmins = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('adutyiteg:set_admins')
AddEventHandler('adutyiteg:set_admins', function(admins)
    currentAdminPlayers = admins
    for id, admin in pairs(visibleAdmins) do
        if admins[id] == nil then
            visibleAdmins[id] = nil
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    ESX.TriggerServerCallback('adutyiteg:getAdminsPlayers', function(admins)
        currentAdminPlayers = admins
    end)
end)

function draw3DText(pos, text, options)
    options = options or {}
    local scaleOption = options.size or 0.8

    local camCoords = GetGameplayCamCoords()
    local dist = #(vector3(camCoords.x, camCoords.y, camCoords.z) - vector3(pos.x, pos.y, pos.z))
    local scale = (scaleOption / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scaleMultiplier = scale * fov
    SetDrawOrigin(pos.x, pos.y, pos.z, 0);
    SetTextProportional(0)
    SetTextScale(0.0 * scaleMultiplier, 0.55 * scaleMultiplier)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for k, v in pairs(currentAdminPlayers) do
            local playerServerID = GetPlayerFromServerId(v.source)
            if playerServerID ~= -1 then
                local adminPed = GetPlayerPed(playerServerID)
                local adminCoords = GetEntityCoords(adminPed)

                local distance = #(adminCoords - pedCoords)
                if distance < (Config.SeeDistance) then
                    visibleAdmins[v.source] = v
                else
                    visibleAdmins[v.source] = nil
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k, v in pairs(visibleAdmins) do
            local playerServerID = GetPlayerFromServerId(v.source)
            if playerServerID ~= -1 then
                local adminPed = GetPlayerPed(playerServerID)
                local adminCoords = GetEntityCoords(adminPed)
                local x, y, z = table.unpack(adminCoords)
                z = z + 1.2

                local label
                    label = Config.GroupLabels[v.group]

                if label then
                            draw3DText(vector3(x, y, z), label.."\n~w~"..GetPlayerName(GetPlayerFromServerId(v.source)), {
                                size = Config.TextSize
                            })
                end
            end
        end
    end
end)
