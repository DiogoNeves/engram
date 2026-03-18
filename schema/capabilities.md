# Hammerspoon Capabilities

Reference for the engram compiler. Use these APIs when generating Lua modules from config files.

## Triggers (Watchers)

### hs.usb.watcher
Fires when USB devices connect or disconnect.
```lua
local watcher = hs.usb.watcher.new(function(device)
    -- device.eventType: "added" or "removed"
    -- device.productName: string
    -- device.vendorName: string
    -- device.vendorID: number
    -- device.productID: number
end):start()
```

### hs.audiodevice.watcher
Global watcher for audio device changes (device added/removed, default changed).
```lua
hs.audiodevice.watcher.setCallback(function(event)
    -- event: "dIn"  = input device list changed (device added/removed from inputs)
    --        "dOut" = output device list changed (device added/removed from outputs)
    --        "dev#" = default input or output device changed
    --        "mute" = mute status changed
    --        "vol#" = volume changed
    --        "sOut" = system output device changed
    -- NOTE: "dev#" and "dIn"/"dOut" are the important ones for device switching logic.
    -- Always filter by event type — "vol#" and "mute" fire frequently on any volume change.
end)
hs.audiodevice.watcher.start()
```
**Timing:** When macOS switches the default device (e.g. Bluetooth headphones connect), it fires
multiple events in sequence and may override changes made inside the callback. Use
`hs.timer.doAfter(0.5, function() ... end)` to defer the action and let macOS finish first.

### hs.wifi.watcher
Fires when the WiFi network changes.
```lua
local watcher = hs.wifi.watcher.new(function()
    local network = hs.wifi.currentNetwork()
    -- network is the current SSID or nil
end):start()
```

### hs.screen.watcher
Fires when displays are connected or disconnected.
```lua
local watcher = hs.screen.watcher.new(function()
    local screens = hs.screen.allScreens()
    -- screens is a table of hs.screen objects
end):start()
```

### hs.application.watcher
Fires on app launch, terminate, activate, deactivate, hide, unhide.
```lua
local watcher = hs.application.watcher.new(function(appName, eventType, app)
    -- eventType: hs.application.watcher.launched, .terminated, .activated, etc.
end):start()
```

### hs.caffeinate.watcher
Fires on sleep, wake, screen lock/unlock, etc.
```lua
local watcher = hs.caffeinate.watcher.new(function(event)
    -- event: hs.caffeinate.watcher.systemDidWake, .screensDidSleep, etc.
end):start()
```

### hs.battery.watcher
Fires when power state changes.
```lua
local watcher = hs.battery.watcher.new(function()
    local charging = hs.battery.isCharging()
    local percent = hs.battery.percentage()
end):start()
```

### hs.timer (for polling)
Use for events with no native watcher (e.g. Bluetooth via blueutil).
```lua
local timer = hs.timer.doEvery(5, function()
    local output, status = hs.execute("/opt/homebrew/bin/blueutil --is-connected AA-BB-CC-DD-EE-FF")
    -- output: "1" or "0"
end)
```

## Actions

### Audio device management
```lua
-- List devices
hs.audiodevice.allDevices()          -- all devices
hs.audiodevice.allInputDevices()     -- input devices only
hs.audiodevice.allOutputDevices()    -- output devices only

-- Get current defaults
hs.audiodevice.defaultInputDevice()  -- returns hs.audiodevice or nil
hs.audiodevice.defaultOutputDevice()

-- Find by name
hs.audiodevice.findInputByName("Device Name")
hs.audiodevice.findOutputByName("Device Name")
hs.audiodevice.findDeviceByName("Device Name")

-- Set as default
device:setDefaultInputDevice()
device:setDefaultOutputDevice()

-- Volume and mute
device:volume()                      -- returns 0-100 or nil
device:setVolume(50)
device:muted()                       -- returns bool or nil
device:setMuted(true)

-- Device properties
device:name()                        -- string
device:uid()                         -- string
device:transportType()               -- "Built-in", "USB", "Bluetooth", "AirPlay"
device:isInputDevice()               -- bool
device:isOutputDevice()              -- bool
```

### Notifications
```lua
hs.notify.new({title = "engram", informativeText = "Message here"}):send()
```

### Shell commands
```lua
-- Synchronous (blocks Lua — use for quick commands)
local output, status, type, rc = hs.execute("/path/to/command", false)
-- second arg: false = Hammerspoon env, true = user shell env

-- Asynchronous (non-blocking — prefer for slower commands)
hs.task.new("/path/to/binary", function(exitCode, stdOut, stdErr)
    -- callback when done
end, {"arg1", "arg2"}):start()
```
**Note:** Always use absolute paths. Hammerspoon doesn't inherit the user's shell PATH.

### Application management
```lua
hs.application.launchOrFocus("App Name")
local app = hs.application.find("App Name")
if app then app:kill() end
```

### Scroll direction per input device (mouse vs trackpad)

**DO NOT use `defaults write NSGlobalDomain com.apple.swipescrolldirection` for live scroll
direction changes.** It updates the preference file but does NOT notify the macOS input stack —
scroll behavior will not change until logout/login. This is a macOS limitation.

**The correct approach is `hs.eventtap`** — intercept scroll wheel events and flip them for mouse
only, leaving trackpad events untouched:

```lua
-- Docs: https://www.hammerspoon.org/docs/hs.eventtap.html
-- Docs: https://www.hammerspoon.org/docs/hs.eventtap.event.html

module.scrollTap = hs.eventtap.new({hs.eventtap.event.types.scrollWheel}, function(event)
    -- scrollWheelEventIsContinuous: 0 = mouse (discrete wheel), 1 = trackpad (smooth/continuous)
    local isContinuous = event:getProperty(
        hs.eventtap.event.properties.scrollWheelEventIsContinuous)
    if isContinuous == 0 then
        -- Reverse mouse scroll only; trackpad passes through unchanged
        local d1  = event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1)
        local d2  = event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis2)
        local fp1 = event:getProperty(hs.eventtap.event.properties.scrollWheelEventFixedPtDeltaAxis1)
        local fp2 = event:getProperty(hs.eventtap.event.properties.scrollWheelEventFixedPtDeltaAxis2)
        event:setProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1,          -d1)
        event:setProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis2,          -d2)
        event:setProperty(hs.eventtap.event.properties.scrollWheelEventFixedPtDeltaAxis1,  -fp1)
        event:setProperty(hs.eventtap.event.properties.scrollWheelEventFixedPtDeltaAxis2,  -fp2)
    end
    return false  -- pass the (modified) event through
end)

-- Start tap when external mouse connects, stop when it disconnects:
module.scrollTap:start()   -- or :stop()
```

Requires Accessibility permission (Hammerspoon usually has this already).

## Inspection via CLI

The Hammerspoon CLI (`hs -c`) can run arbitrary Lua for inspecting system state:
```bash
hs -c "print(hs.audiodevice.defaultInputDevice():name())"
hs -c "for _,d in pairs(hs.audiodevice.allInputDevices()) do print(d:name(), d:transportType()) end"
hs -c "print(hs.wifi.currentNetwork())"
hs -c "for _,d in pairs(hs.usb.attachedDevices()) do print(d.productName) end"
hs -c "print(hs.screen.mainScreen():name())"
```
Requires `hs.ipc` to be loaded in the user's Hammerspoon config.

## Compiled Module Pattern

Every compiled module should:
1. Return a table
2. Store watcher references in the table (prevents garbage collection)
3. Start watchers immediately
4. Use `hs.notify` to give user feedback when actions fire
5. Include a comment header with source config path and compilation timestamp
6. **Check initial state at startup** — watchers only fire on changes, not on load. If a device
   might already be connected when Hammerspoon starts, apply the correct state immediately:
   ```lua
   -- Check at startup, then watch for changes
   for _, d in pairs(hs.usb.attachedDevices()) do
       if d.productName == "My Mouse" then
           module.scrollTap:start()
           print("my-module: mouse already connected at startup, tap active")
           break
       end
   end
   module.usbWatcher = hs.usb.watcher.new(function(device) ... end):start()
   ```
7. **Always add `print()` logging** in every watcher callback and at every key action point.
   Output appears in the Hammerspoon Console (menubar → Console) and is the primary debugging
   tool. Log format: `"module-name: what happened"`. Example:
   ```lua
   print("scroll-direction: Razer connected, scroll reversal active")
   print("keep-blue-snowball-mic: event=" .. event .. ", setting Blue Snowball as default")
   ```
