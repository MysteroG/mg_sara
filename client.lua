local isBlackedOut = false
local oldBodyDamage = 0
local oldSpeed = 0
local function blackout()
if not isBlackedOut then
isBlackedOut = true
Citizen.CreateThread(function()
ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 2.0)
local playerPed = PlayerPedId()
PedPosition		= GetEntityCoords(playerPed)
local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
TriggerServerEvent('esx_addons_gcphone:startCall', 'ambulance', ('S.A.R.A. : vehicule accidenté, demande d\'assistance.'), PlayerCoords, {
PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
})
-- TriggerServerEvent('esx_addons_gcphone:startCall', 'police', ('S.A.R.A. : vehicule accidenté, demande d\'assistance.'), PlayerCoords, {
-- PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
-- })
TriggerServerEvent('esx_addons_gcphone:startCall', 'mechanic', ('S.A.R.A. : vehicule accidenté, demande d\'assistance.'), PlayerCoords, {
PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
})
TriggerEvent("pNotify:SendNotification", {text = "Vous venez d'avoir un accident. Les Secours ont été averti par S.A.R.A.",
        layout = "centerLeft",
        timeout = 300000,
        progressBar = true,
        type = "error",
        animation = {
            open = "gta_effects_fade_in",
            close = "gta_effects_fade_out"
        }})
Citizen.Wait(Config.BlackoutTime)
isBlackedOut = false
end)
end
end
Citizen.CreateThread(function()
while true do
Citizen.Wait(0)
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
if DoesEntityExist(vehicle) then
if Config.BlackoutFromDamage then
local currentDamage = GetVehicleBodyHealth(vehicle)
if currentDamage ~= oldBodyDamage then
if not isBlackedOut and (currentDamage < oldBodyDamage) and ((oldBodyDamage - currentDamage) >= Config.BlackoutDamageRequired) then
blackout()
end
oldBodyDamage = currentDamage
end
end
if Config.BlackoutFromSpeed then
local currentSpeed = GetEntitySpeed(vehicle) * 2.23
if currentSpeed ~= oldSpeed then
if not isBlackedOut and (currentSpeed < oldSpeed) and ((oldSpeed - currentSpeed) >= (Config.BlackoutSpeedRequired / 1.60934)) then
blackout()
end
oldSpeed = currentSpeed
end
end
else
oldBodyDamage = 0
oldSpeed = 0
end
if isBlackedOut and Config.DisableControlsOnBlackout then
DisableControlAction(0,71,true)
DisableControlAction(0,72,true)
DisableControlAction(0,64,true)
DisableControlAction(0,75,true)
end
end
end)
