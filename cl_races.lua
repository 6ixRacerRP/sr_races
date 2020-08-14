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

local recordedCheckpoints = {}

local checkpointcount = 0

-----------------------------------------------------------
---                   NUI CALLBACKS                     ---
-----------------------------------------------------------
RegisterNUICallback('NUIFocusOff', function(data)
    show_nui(false)
    raceStatus.state = RACE_STATE_NONE
end)

RegisterNUICallback('invalid_input', function(data, cb)
    TriggerEvent("chat:addMessage", {
        color = {255, 0, 255},
        multiline = true,
        args = {'[6ixRP]', "Invalid Input!\nMake sure that all inputs are filled!"}
    })
    SetNuiFocus(true, true)
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

RegisterNUICallback('save_race', function(data)
    raceStatus.state = RACE_STATE_NONE

    TriggerServerEvent("sr_races:sv_saverace", data.name, data.laps, recordedCheckpoints)
end)

-----------------------------------------------------------
---                        MAIN                         ---
-----------------------------------------------------------
RegisterCommand('raceui', function(source, args)
    show_nui(true)
end, false)

-- Checkpoint recording thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Initiated when player hits new race button
        if raceStatus.state == RACE_STATE_RECORDING then
            if IsControlJustReleased(1, 26) then -- 26 is C key
                SetNuiFocus(true, true)
            elseif IsControlJustReleased(1, 51) then -- 184 is E key
                local coords = GetEntityCoords(GetPlayerPed(-1))

                -- Set a blip on map
                local blip = AddBlipForCoord(coords)
                SetBlipColour(blip, 1)
                SetBlipAsShortRange(blip, true)
                ShowNumberOnBlip(blip, checkpointcount)
                checkpointcount = checkpointcount + 1

                -- Add checkpoint to array.
                table.insert(recordedCheckpoints, {coords = coords})

                -- Wait 1s before being able to place new blip
                Citizen.Wait(1000)
                
                --[[for index, data in ipairs(recordedCheckpoints) do
                    print(index)
                    for key, value in pairs(data) do
                        print('\t', key, value)
                    end
                end]]--
            end
        else
            -- If we aren't recording then reset checkpoint count
            checkpointcount = 0
            -- Clean up recordedCheckpoints properly
            cleanupRecording()
        end
    end
end)

-----------------------------------------------------------
---                     FUNCTIONS                       ---
-----------------------------------------------------------
-- Showing and hiding NUI
function show_nui(bool) 
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        ui = "raceui",
        status = bool,
    })
end

-- Helper function to clean up recording blips
function cleanupRecording()
    -- Remove map blips and clear recorded checkpoints
    for _, checkpoint in pairs(recordedCheckpoints) do
        RemoveBlip(checkpoint.blip)
        checkpoint.blip = nil
    end
    recordedCheckpoints = {}
end