local entityList = {}

RegisterCommand("zawarudo", function (source, args, raw)
    if IsPlayerAceAllowed(source, "admin") then
        local pCoords = GetEntityCoords(GetPlayerPed(source))
        freezeEverything(source)
        
        for _, i in ipairs(GetPlayers()) do
            local id = tonumber(i)
            local dist = #(pCoords - GetEntityCoords(GetPlayerPed(i)))
            
            if dist < Config.range and source ~= id then    -- da cambiare == con ~= quando finisco i test
                TriggerClientEvent("brzawarudo:start", id, source)
            end
        end

        TriggerClientEvent("brzawarudo:owner", source)
    end
end, false)

function freezeEverything(id)
    local sourcePed = GetPlayerPed(id)
    local pCoords = GetEntityCoords(sourcePed)

    for _, i in ipairs(GetAllVehicles()) do
        local eCoords = GetEntityCoords(i)

        if #(pCoords - eCoords) < Config.range then
            table.insert(entityList, i)
            FreezeEntityPosition(i, true)
        end
    end

    for _, i in ipairs(GetAllPeds()) do
        if i == sourcePed then
            break
        end
        local eCoords = GetEntityCoords(i)

        if #(pCoords - eCoords) < Config.range then
            table.insert(entityList, i)
            ClearPedTasks(i)
            FreezeEntityPosition(i, true)
        end
    end

    CreateThread(function ()
        Wait(Config.duration * 1000)
        for _, i in ipairs(entityList) do
            FreezeEntityPosition(i, false)
        end
    end)
end