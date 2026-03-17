-- engram: auto-reload watcher
-- Watches the engram directory for changes and reloads Hammerspoon config

local engramPath = os.getenv("HOME") .. "/.hammerspoon/engram/"
local watcher = hs.pathwatcher.new(engramPath, function(files)
    hs.reload()
end):start()
