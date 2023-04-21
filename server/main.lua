local QBCore = exports['qb-core']:GetCoreObject()

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("setlawyer", "Register someone as a lawyer", {{name="id", help="Id of the player(only Judge)"},{name="grade", help="(0 -- > 3)"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local grade= tonumber(args[2])
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name=="doj" and Player.PlayerData.job.grade.name=="Judge" then
        if OtherPlayer ~= nil then 
            local lawyerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
            }
            OtherPlayer.Functions.SetJob("doj",grade)
   
            TriggerClientEvent("QBCore:Notify", source, "You have " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. " hired as a lawyer")
            TriggerClientEvent("QBCore:Notify", OtherPlayer.PlayerData.source, "You are now a lawyer")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, QBCore.Shared.Items["lawyerpass"], "add")
        else
            TriggerClientEvent("QBCore:Notify", source, "Person is present", "error")
        end
    else
        TriggerClientEvent("QBCore:Notify", source, "You are not a judge.", "error")
    end
end)
QBCore.Commands.Add("paylsalary","only for judge/police",{{name="id", help="ID of the player"}},true,function (source,args)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name=="doj" and Player.PlayerData.job.grade.name=="Judge"  and OtherPlayer.PlayerData.job.name=="doj" then

    OtherPlayer.Functions.AddMoney("bank", 2500, "Case payment")
    end
end)
QBCore.Commands.Add("removelawyer", "Remove someone as a lawyer", {{name="id", help="ID of the player"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name=="doj" and Player.PlayerData.job.grade.name=="Judge" then
        if OtherPlayer ~= nil then 
            TriggerClientEvent("QBCore:Notify", OtherPlayer.PlayerData.source, "You are now unemployed")
            TriggerClientEvent("QBCore:Notify", source, "You have " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. "dismiss as a lawyer")
        else
            TriggerClientEvent("QBCore:Notify", source, "Person is not present", "error")
        end
    else
        TriggerClientEvent("QBCore:Notify", source, "You are not a judge..", "error")
    end
end)

QBCore.Functions.CreateUseableItem("lawyerpass", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("qb-justice:client:showLawyerLicense", -1, source, item.info)
    end
end)

QBCore.Commands.Add("broadcast", "Only judge", {{name = "message", help = "The message to broadcast"}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
     if Player.PlayerData.job.name=="doj" and Player.PlayerData.job.grade.name=="Judge" then
       local msg = table.concat(args, ' ')
       if msg == '' then return end
       TriggerClientEvent('chat:addMessage', -1, {
        color = { 66, 245, 123},
        multiline = true,
        args = {"Judge", msg}
       })
     end
end)




