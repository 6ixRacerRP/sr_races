RegisterNUICallback('NUIFocusOff', function(data)
    show_nui(false)
end)

RegisterCommand('raceui', function(source, args)
    show_nui(true)
end, false)

function show_nui(bool) 
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        ui = "raceui",
        status = bool,
    })
end