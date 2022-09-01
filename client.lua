
local interval = 30000 -- in milliseconds
local closestDistance = 50 -- in meters
local isHidden = true

local colorLvls = { -- order is important. From higher to lower. Don't change keys. show the color until the new level is reached
    red = 25,
    yellow = 20,
    green = 0
}

function Refresh()
    local closePlayerCount = 0
    local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)

    for _, player in pairs(GetActivePlayers()) do
        local target = GetPlayerPed(player)

        if target ~= playerPed then
            local targetCoords = GetEntityCoords(target, true, true)
            local distance = #(targetCoords - coords)

            if distance < closestDistance then
                closePlayerCount = closePlayerCount + 1
            end
        end
    end

    for color, value in pairs(colorLvls) do
        if closePlayerCount >= value then
            SendNUIMessage({action= 'setColor', color=color})
            return
        end
    end
end


function Start()
    Citizen.Wait(5000) --Let UI initialize

    SendNUIMessage({action= 'show'})
    isHidden = false
    Citizen.CreateThread(function()
        while true do
            Refresh()
            Citizen.Wait(interval)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            local isRadarHidden = IsRadarHidden()
    
            if isRadarHidden and not isHidden then
                SendNUIMessage({action= 'hide'})
                isHidden = true
            elseif not isRadarHidden and isHidden then
                SendNUIMessage({action= 'show'})
                isHidden = false
            end
            Citizen.Wait(100)
        end
    end)
end

RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function ()
    Start()
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        SendNUIMessage({action= 'hide'})
        isHidden = true
    end
end)

AddEventHandler('onClientResourceStart', function(resName)
    if (resName ~= GetCurrentResourceName()) then
        return
    end

    Start()
end)
