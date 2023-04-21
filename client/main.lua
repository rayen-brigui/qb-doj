QBCore = exports['qb-core']:GetCoreObject()
PlayerJob = {}

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob.name == "doj" then
        local blip = AddBlipForCoord(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)
        SetBlipSprite(blip, 225)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["vehicle"].label)
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if PlayerJob.name == "doj" then
        local blip = AddBlipForCoord(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)
        SetBlipSprite(blip, 225)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["vehicle"].label)
        EndTextCommandSetBlipName(blip)
    end
end)

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"].coords
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        SetVehicleNumberPlateText(veh, "DOJ "..tostring(math.random(100, 999)))
        SetEntityHeading(veh, coords.w)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        SetVehicleLivery(veh, 2)
        CurrentPlate = QBCore.Functions.GetPlate(veh)
    end, vehicleInfo, coords, true)
end

function MenuGarage()
    local vehicleMenu = {
        {
            header = "Garage",
            isMenuHeader = true
        }
    }

    local Vehicles = Config.Vehicles[QBCore.Functions.GetPlayerData().job.grade.level]
    for veh, label in pairs(Vehicles) do
        vehicleMenu[#vehicleMenu+1] = {
            header = label,
            txt = "",
            params = {
                event = "qb-doj:client:TakeOutVehicle",
                args = {
                    vehicle = veh
                }
            }
        }
    end
    vehicleMenu[#vehicleMenu+1] = {
        header = "Close Menu",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

CreateThread(function()
    while true do
        Wait(5)
        if LocalPlayer.state.isLoggedIn then
            local inRange = false
            local pos = GetEntityCoords(PlayerPedId())
            if PlayerJob.name == "doj" then
                if #(pos - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)) < 10.0 then
                    inRange = true
                    DrawMarker(2, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)) < 1.5 then
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            DrawText3D(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, "Store Car")
                        else
                            DrawText3D(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z,"Get DOJ Car" )
                        end
                        if IsControlJustReleased(0, 38) then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                            else
                                MenuGarage()
                            end
                        end
                    end
                 end
                end
            end
            end
                
end)



RegisterNetEvent('qb-doj:client:TakeOutVehicle', function(data)
    local vehicle = data.vehicle
    TakeOutVehicle(vehicle)
end)
RegisterNetEvent("qb-justice:client:broadcast",function (data)
    print('Event fired')
end)


RegisterNetEvent("qb-justice:client:showLawyerLicense")

AddEventHandler("qb-justice:client:showLawyerLicense", function(sourceId, data)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if true then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pass-ID:</strong> {1} <br><strong>Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>SSN:</strong> {4} </div></div>',
            args = {'DOJ Liscense', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)

exports['qb-target']:AddBoxZone("court-gavel", vector3(-576.19, -209.92, 38.77), 1.55, 0.3, {
    name = "court-gavel",
    heading = 210,
    debugPoly = false,
    minZ = 38.52,
    maxZ = 38.72,
    }, {
    options = {
        {
            type = "client",
            event = "police:client:judgeGavel",
            icon = "fa-solid fa-gavel",
            label = "Use Gavel",
            job = 'doj',
        },
    },
    distance = 2.0
})

RegisterNetEvent('police:client:judgeGavel', function()
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "gavel_hits", 0.7)
   end)