-----------------------------------------------------------
---                     VARIABLES                       ---
-----------------------------------------------------------
local playersData = nil
local playersDataFile = "./resources/[cars]/[races]/sr_races/save_data.json"

-----------------------------------------------------------
---                     NET EVENTS                      ---
-----------------------------------------------------------
RegisterNetEvent("sr_races:sv_saverace")
AddEventHandler("sr_races:sv_saverace", function(name, laps, recordedCheckpoints)
    
    for _, checkpoint in pairs(recordedCheckpoints) do
        -- Json can't decode vector3s, this line formats the table so its decodable by Json.
        checkpoint.coords = {x = checkpoint.coords.x, y = checkpoint.coords.y, z = checkpoint.coords.z}
    end

    -- Add amount of laps to race
    recordedCheckpoints.laps = laps

    -- LoadPlayerData so that we can add a race to that specific player.
    local playerRaces = loadPlayerData(source)
    playerRaces[name] = recordedCheckpoints
    savePlayerData(source, playerRaces)
end)

-----------------------------------------------------------
---                     FUNCTIONS                       ---
-----------------------------------------------------------
function loadPlayerData(source, playersData) 
    -- Load data from file if not already initialized
    if playersData == nil then
        playersData = {}
        local file = io.open(playersDataFile, "r")
        if file then
            local contents = file:read("*a")
            playersData = json.decode(contents);
            io.close(file)
        end
    end

    -- Get player steamID from source and use as key to get player data
    local playerId = string.sub(GetPlayerIdentifier(source, 0), 7, -1)
    local playerData = playersData[playerId]

    -- Return saved player data
    if playerData == nil then
        playerData = {}
    end
    return playerData
end

function savePlayerData(source, data)
    -- Load data from file if not already initialized
    if playersData == nil then
        playersData = {}
        local file = io.open(playersDataFile, "r")
        if file then
            local contents = file:read("*a")
            playersData = json.decode(contents);
            io.close(file)
        end
    end

    -- Get player steamID from source and use as key to save player data
    local playerId = string.sub(GetPlayerIdentifier(source, 0), 7, -1)
    playersData[playerId] = data

    -- Save file
    local file = io.open(playersDataFile, "w+")
    if file then
        local contents = json.encode(playersData)
        file:write(contents)
        io.close(file)
    end
end