ESX = nil
gsrData = {}

TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

TriggerEvent('es:addCommand', 'gsr', function(source, args, user)
    local Source = source
    local xPlayer = ESX.GetPlayerFromId(Source)
    local number = tonumber(args[1])
    if args[1] ~= nil and xPlayer.job.name == 'police' and type(number) == "number" then
        CancelEvent()
        local identifier = GetPlayerIdentifiers(number)[1]
        if identifier ~= nil then
            gsrcheck(source, identifier)
        end
    else
        TriggerClientEvent("chatMessage", Source, "[GSR]", {255, 0, 0}, "You must be a cop")
    end
end)

AddEventHandler('esx:playerDropped', function(source)
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        gsrData[identifier] = nil
    end
end)

RegisterNetEvent("GSR:Remove")
AddEventHandler("GSR:Remove", function()
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        gsrData[identifier] = nil
    end
end)

RegisterServerEvent('GSR:SetGSR')
AddEventHandler('GSR:SetGSR', function()
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    gsrData[identifier] = os.time(os.date("!*t")) + Config.gsrTime
end)

function gsrcheck(source, identifier)
    local Source = source
    local identifier = identifier
    if gsrData[identifier] ~= nil then
        TriggerClientEvent("chatMessage", Source, "[GSR]", {255, 0, 0}, "^1Test comes back ^*POSITIVE(Has Shot)")
    else
        TriggerClientEvent("chatMessage", Source, "[GSR]", {255, 0, 0}, "^2Test comes back ^*NEGATIVE(Has Not Shot)")
    end
end

ESX.RegisterServerCallback('GSR:Status', function(source, cb)
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

function removeGSR()
    for k, v in pairs(gsrData) do
        if v <= os.time(os.date("!*t")) then
            gsrData[k] = nil
        end
    end
end

function gsrTimer()
    removeGSR()
    SetTimeout(Config.gsrAutoRemove, gsrTimer)
end

gsrTimer()
