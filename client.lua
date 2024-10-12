local coords = {
{x = -141.09, y = -213.28, z = 1.47},
{x = -170.53, y = -484.46, z = 3.62},
}

local isTeleporting = false
function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local dist = #(GetGameplayCamCoords() - vector3(x, y, z))
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 150)
    end
end

Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local sleep = 1000
        for i, coord in pairs(coords) do
            local distance = #(playerCoords - vector3(coord.x, coord.y, coord.z))
            if distance < 20.0 then
                sleep = 5
                Draw3DText(coord.x, coord.y, coord.z, "E")
                if distance < 2.0 and not isTeleporting then
                    if IsControlJustReleased(0, 38) then
                        TeleportPlayer(i)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function TeleportPlayer(locationIndex)
    isTeleporting = true
    DoScreenFadeOut(1000)
    Citizen.Wait(3000)
    local newCoords = coords[locationIndex == 1 and 2 or 1]
    SetEntityCoords(PlayerPedId(), newCoords.x, newCoords.y, newCoords.z)
    DoScreenFadeIn(1000)
    isTeleporting = false
end