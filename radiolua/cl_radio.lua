local radio = {
    radios = {},
    isPlaying = false,
    index = -1,
    volume = GetProfileSetting(306) / 10,
    prevVolume = volume
}

local customRadios = {
    ["RADIO_02_POP"] = { url = "http://live.boun.cc", volume = 0.2, name= "custom2"},
    ["RADIO_08_MEXICAN"] = { url = "http://live.boun.cc", volume = 0.2, name= "custom3"},
}

function table.has(table, val) 
    for i=1, #table do 
        if table[i] == val then
            return true
        end
    end
    return false
end

for k,v in pairs(customRadios) do
    local _radio = k
    if table.has(availableRadios, _radio) == false then
        print("radio: ".._radio.." is not valid")
    else
        local data = v
        if data ~= nil then
            radio.radios[#radio.radios+1] = {name=_radio, data = data, isPlaying = false, index = i}
            if data.name then
                AddTextEntry(_radio, data.name)
            end
        else
            print("^1No Data for radio: ".._radio)
        end
    end
end

RegisterNUICallback("radio:ready", function(data) 
    SendNUIMessage({
        type = "create",
        radios = radio.radios,
        volume = radio.volume
    })
end)

function PlayCustomRadio(_radio)
    radio.isPlaying = true
    radio.index = _radio.index
    ToggleCustomRadioBehavior()
    SendNUIMessage({
        type = "play",
        radio = _radio.name
    })
end

function StopCustomRadios() 
    radio.isPlaying = false
    ToggleCustomRadioBehavior()
    SendNUIMessage({
        type = "stop"
    })
end
function findCustomRadio(name) 
    for i=1,#radio.radios do 
        local rad = radio.radios[i]
        if rad.name == name then 
            return rad
        end
    end
    return nil
end

Citizen.CreateThread(function() 
    while true do
        if IsPlayerVehRadioEnable() then 
            local customRadio = findCustomRadio(GetPlayerRadioStationName())
            if not radio.isPlaying and customRadio ~= nil then
                print("custom radio found, playing custom") 
                PlayCustomRadio(customRadio)
            elseif radio.isPlaying and customRadio ~= nil and customRadio.index ~= radio.index then
                print("new custom radio found, playing custom")  
                StopCustomRadios();
                PlayCustomRadio(customRadio);
            elseif radio.isPlaying and customRadio == nil then
                print("no custom radio found, playing native")
                StopCustomRadios();
            end
        end
        radio.volume = GetProfileSetting(306) / 10;
        if radio.prevVolume ~= radio.volume then
            SendNUIMessage({
                type="volume",
                volume = radio.volume
            }) 
            radio.prevVolume = radio.volume
        end
        Citizen.Wait(150)
    end
end)

Citizen.CreateThread(function() 
    while true do
        if not IsPedInAnyVehicle(PlayerPedId(), false) and radio.isPlaying then
            StopCustomRadios()
        end
        Citizen.Wait(150)
    end
end)

function ToggleCustomRadioBehavior() 
    SetFrontendRadioActive(not radio.isPlaying)
    if radio.isPlaying then 
        StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
    else
        StopAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
    end
end



