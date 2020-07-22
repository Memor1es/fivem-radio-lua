# fivem-radio-lua
[FiveM Radio](https://github.com/Hellslicer/fivem-radio) converted to lua

## Features

* Radio wheel
* Audio file
* Audio stream
* No dependency
* Easy configuration
* Player-configurable volume

## Known bugs and limitations

* No MPEG, MP3 or AAC support as CEF only supports open formats

## Adding a custom radio
At the top of `cl_radio.lua`, you can add a radio with the value inside the `[]` being the radio you want to replace, you can find these in `radios.lua`

```lua
local customRadios = {
    ["RADIO_02_POP"] = { url = "http://live.boun.cc", volume = 0.2, name= "custom2"},
    ["RADIO_08_MEXICAN"] = { url = "http://live.boun.cc", volume = 0.2, name= "custom3"},
}
```

This project is license under the MIT license
