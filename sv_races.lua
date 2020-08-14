RegisterNetEvent("sr_races:sv_saverace")
AddEventHandler("sr_races:sv_saverace", function(name, laps, recordedCheckpoints)
    local playerId = string.sub(GetPlayerIdentifier(source, 0), 7, -1)
    
    -- The cotents that will be added to file.
    local saveinfo = {
        owner = playerId, 
        name = name, 
        laps = laps, 
        recordedCheckpoints = {}
    }

    -- Adding each checkpoint to saveinfo
    for index, data in ipairs(recordedCheckpoints) do
        for key, value in pairs(data) do
            table.insert(saveinfo.recordedCheckpoints, {coords = value.x .. ", " .. value.y .. ", " .. value.z})
        end
    end

    local file = io.open("./resources/[cars]/[races]/sr_races/save_data.json", "w+")
    if file then
        local contents = json.encode(saveinfo)
        file:write(contents)
        io.close(file)
    end

    print("name: " .. name .. " laps: " .. laps)
    for index, data in ipairs(recordedCheckpoints) do
        print(index)
        for key, value in pairs(data) do
            print('\t' .. key .. " " .. value.x .. " " .. value.y .. " " .. value.z)
        end
    end
end)