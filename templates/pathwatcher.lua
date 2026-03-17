-- engram: auto-reload watcher
-- Watches the engram directory for changes and reloads Hammerspoon config

local engramPath = os.getenv("HOME") .. "/.hammerspoon/engram/"
local reloadTimer = nil
local watcher = hs.pathwatcher.new(engramPath, function(files)
    if reloadTimer then reloadTimer:stop() end
    reloadTimer = hs.timer.doAfter(1.5, function()
        reloadTimer = nil
        hs.reload()
    end)
end):start()
