---
name: engram-inspect
description: Use when you need to query the current macOS system state, check connected devices, audio settings, WiFi network, or any live system information via Hammerspoon CLI.
---

# Inspect macOS system state via Hammerspoon

You can query live macOS system state using the Hammerspoon CLI (`hs -c`). This runs arbitrary Lua expressions in the running Hammerspoon instance.

## How to use

Run `hs -c "<lua expression>"` via the Bash tool. The expression should use `print()` to output results.

## Common queries

Pick whichever queries are relevant to the current task. You are not limited to these — use any Hammerspoon API.

### Audio devices
```bash
# Current default input
hs -c "print(hs.audiodevice.defaultInputDevice():name())"

# Current default output
hs -c "print(hs.audiodevice.defaultOutputDevice():name())"

# All input devices with transport type
hs -c "for _,d in pairs(hs.audiodevice.allInputDevices()) do print(d:name(), d:transportType()) end"

# All output devices with transport type
hs -c "for _,d in pairs(hs.audiodevice.allOutputDevices()) do print(d:name(), d:transportType()) end"

# Current volume
hs -c "print(hs.audiodevice.defaultOutputDevice():volume())"
```

### USB devices
```bash
hs -c "for _,d in pairs(hs.usb.attachedDevices()) do print(d.productName, d.vendorName) end"
```

### WiFi
```bash
hs -c "print(hs.wifi.currentNetwork())"
```

### Screens
```bash
hs -c "for _,s in pairs(hs.screen.allScreens()) do print(s:name(), s:id()) end"
```

### Battery
```bash
hs -c "print('Charging:', hs.battery.isCharging(), 'Percent:', hs.battery.percentage())"
```

### System preferences (via defaults)
```bash
# Trackpad scroll direction (1 = natural, 0 = traditional)
defaults read NSGlobalDomain com.apple.swipescrolldirection
```

## Fallbacks

If `hs` CLI is not available (user hasn't enabled it in Hammerspoon preferences), fall back to:
- `system_profiler SPAudioDataType` for audio devices
- `system_profiler SPUSBDataType` for USB devices
- `system_profiler SPBluetoothDataType` for Bluetooth
- `defaults read` for system preferences
- `SwitchAudioSource -a` for audio device listing (if installed)

## Important

- `hs -c` requires `hs.ipc` to be loaded in the user's Hammerspoon config
- If `hs` is not found, suggest the user enable it: Hammerspoon → Preferences → Enable CLI
- Always handle nil returns gracefully (a device might not exist)
