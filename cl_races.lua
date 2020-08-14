-----------------------------------------------------------
---                     VARIABLES                       ---
-----------------------------------------------------------
local RACE_STATE_NONE = 0
local RACE_STATE_JOINED = 1
local RACE_STATE_RACING = 2
local RACE_STATE_RECORDING = 3
local RACE_CHECKPOINT_TYPE = 45
local RACE_CHECKPOINT_FINISH_TYPE = 9

local races = {}
local raceStatus = {
    state = RACE_STATE_NONE,
    index = 0,
    checkpoint = 0
}

-----------------------------------------------------------
---                   NUI CALLBACKS                     ---
-----------------------------------------------------------
RegisterNUICallback('NUIFocusOff', function(data)
    show_nui(false)
end)

RegisterNUICallback('new_race', function(data)
    raceStatus.state = RACE_STATE_RECORDING
    SetNuiFocus(false, false)

    TriggerEvent('chat:addMessage', {
        color = {255, 0, 255},
        multiline = true,
        args = {'[6ixRP]', "\nPress E to set check point.\nPress C to stop setting check points."}
    })
end)

-----------------------------------------------------------
---                        MAIN                         ---
-----------------------------------------------------------
RegisterCommand('raceui', function(source, args)
    show_nui(true)
end, false)

local racecount = 0;
-- Checkpoint recording thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if raceStatus.state == RACE_STATE_RECORDING then
            if IsControlJustReleased(1, 26) then -- 26 is C key
                SetNuiFocus(true, true)
            elseif IsControlJustReleased(1, 51) then -- 184 is E key
                local blip = AddBlipForCoord(GetEntityCoords(GetPlayerPed(-1)))
                SetBlipColour(blip, 1)
                SetBlipAsShortRange(blip, true)
                ShowNumberOnBlip(blip, racecount)
                racecount = racecount + 1
            end
        end
    end
end)

-----------------------------------------------------------
---                     FUNCTIONS                       ---
-----------------------------------------------------------
function show_nui(bool) 
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        ui = "raceui",
        status = bool,
    })
end