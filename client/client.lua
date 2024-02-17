local controls = false
local checkVisibility = false
local ped
local clone

RegisterNetEvent("brzawarudo:start")
AddEventHandler("brzawarudo:start", function (targetId)
    stopControls()
    keepPlayerInvisible(targetId)
    timer()
    TriggerEvent("brodoPlayer:PlayOnOne", "zawarudo", 1.0)
    SetTimecycleModifier(Config.timecycle)
end)

function stopControls()
    controls = true
    CreateThread(function ()
        while controls do
            Wait(0)
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true) -- Mouse left/right
            EnableControlAction(0, 2, true) -- Mouse up/down
        end
    end)
end

function keepPlayerInvisible(id)
    checkVisibility = true
    ped = GetPlayerPed(GetPlayerFromServerId(id))

    CreateThread(function ()
        while checkVisibility do
            Wait(0)
            if DoesEntityExist(ped) and IsEntityVisible(ped) then
                SetEntityVisible(ped, false, 0)
            end

            if not checkVisibility then
                SetEntityVisible(ped, true, 0)
            end
        end
    end)
end

function timer()
    CreateThread(function ()
        Wait(Config.duration * 1000)
        FreezeEntityPosition(PlayerPedId(), false)
        controls = false
        checkVisibility = false
        SetEntityVisible(ped, true, 0)
        SetTimecycleModifier("normal")
    end)
end


---------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("brzawarudo:owner")
AddEventHandler("brzawarudo:owner", function ()
    TriggerEvent("brodoPlayer:PlayOnOne", "zawarudo", 1.0)
    clone = ClonePed(PlayerPedId(), true, true, true)
    SetEntityHeading(clone, GetEntityHeading(PlayerPedId()))
    FreezeEntityPosition(clone, true)
    SetTimecycleModifier(Config.timecycle)
    timer2()
end)

function timer2()
    CreateThread(function ()
        Wait(Config.duration * 1000)
        SetTimecycleModifier("normal")
        DeleteEntity(clone)
    end)
end