-- engram module: {{name}}
-- Compiled from: configs/{{name}}.md
-- Compiled at: {{timestamp}}
-- DO NOT EDIT — regenerate with "just compile"

local module = {}

-- Example: USB device watcher
module.usbWatcher = hs.usb.watcher.new(function(device)
    if device.productName == "Scarlett 2i2" then
        if device.eventType == "added" then
            local output = hs.audiodevice.findOutputByName("Scarlett 2i2 USB")
            if output then
                output:setDefaultOutputDevice()
                output:setVolume(50)
            end
            local input = hs.audiodevice.findInputByName("Scarlett 2i2 USB")
            if input then input:setDefaultInputDevice() end
            hs.notify.new({title = "engram", informativeText = "Audio routed to Scarlett"}):send()

        elseif device.eventType == "removed" then
            local output = hs.audiodevice.findOutputByName("MacBook Pro Speakers")
            if output then output:setDefaultOutputDevice() end
            local input = hs.audiodevice.findInputByName("MacBook Pro Microphone")
            if input then input:setDefaultInputDevice() end
            hs.notify.new({title = "engram", informativeText = "Audio routed to built-in"}):send()
        end
    end
end):start()

return module
