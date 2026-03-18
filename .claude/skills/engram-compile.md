---
name: engram-compile
description: Use when the user wants to compile engram markdown configs into Hammerspoon Lua code, generate Hammerspoon config, or build automation from their config files.
---

# Compile engram configs to Hammerspoon Lua

You are compiling plain-English markdown config files into Hammerspoon Lua modules.

## Before you start

1. Read `schema/capabilities.md` for the full Hammerspoon API reference
2. Read `schema/config-format.md` for the config file format specification
3. Read `templates/module.lua` for the expected compiled output pattern
4. Read `templates/engram-init.lua` for the loader template
5. Read `templates/pathwatcher.lua` for the auto-reload watcher

## Compilation process

### 1. Discover configs

Read all `.md` files in `configs/`. If none exist, tell the user and suggest using `/remember` to create one.

### 2. Check for changes (incremental compilation)

Read `state/hashes.json` if it exists. For each config file, compute its MD5 hash (via `md5 -q <file>`). Skip files whose hash hasn't changed unless the user explicitly requests a full recompile.

### 3. Compile each changed config

For each config file:
- Parse the YAML frontmatter for `name`, `description`, and `triggers`
- Read the markdown body for action descriptions
- Generate a Lua module following the pattern in `templates/module.lua`:
  - Module returns a table
  - Watcher references stored in the table (prevents garbage collection)
  - Watchers started immediately
  - Actions use `hs.notify` to give user feedback
  - Comment header with source path and timestamp
- Write to `~/.hammerspoon/engram/<name>.lua`

### 4. Generate the loader

List all `.lua` files in `~/.hammerspoon/engram/` (excluding `init.lua` and `_pathwatcher.lua`). Generate `~/.hammerspoon/engram/init.lua` based on `templates/engram-init.lua`, with `require("engram.<name>")` for each module.

### 5. Install the pathwatcher

Copy `templates/pathwatcher.lua` to `~/.hammerspoon/engram/_pathwatcher.lua`.

### 6. Validate

For each compiled Lua file, run: `hs -c "dofile('path/to/file.lua')"` to check for syntax errors. If `hs` is not available, warn the user but don't fail.

### 7. Update state

Write the updated hashes to `state/hashes.json`:
```json
{
  "audio-routing.md": "abc123...",
  "wifi-context.md": "def456..."
}
```

Write the mapping to `state/manifest.json`:
```json
{
  "audio-routing.md": "~/.hammerspoon/engram/audio-routing.lua",
  "wifi-context.md": "~/.hammerspoon/engram/wifi-context.lua"
}
```

### 8. Report

Print a clear summary:
- Which config files were compiled (and which were skipped as unchanged)
- Which output files were written or updated
- Any validation errors
- Remind the user to add `require("engram")` to their `~/.hammerspoon/init.lua` if it's not there

## Important

- Always use absolute paths for binaries in generated Lua (e.g. `/opt/homebrew/bin/blueutil`)
- Store all watcher references in the module table to prevent garbage collection
- Use `hs.notify` for user-visible feedback when rules fire
- For Bluetooth polling, use `hs.timer.doEvery()` with `hs.task.new()` (async, non-blocking)
- Generated files must have the "DO NOT EDIT" header comment
- **Always add `print()` logging** in every callback and at every key action — this is the only
  way to debug compiled modules. Format: `"module-name: description"`. Never compile a module
  without logging.

## Consult the Hammerspoon docs when in doubt

The Hammerspoon API docs are at **https://www.hammerspoon.org/docs/**. If `schema/capabilities.md`
doesn't cover an API you need, or you're unsure how something works, fetch the relevant doc page:
```
https://www.hammerspoon.org/docs/hs.<module>.html
```
Examples: `hs.eventtap.html`, `hs.audiodevice.html`, `hs.usb.html`, `hs.screen.html`

**Known pitfalls — do not repeat these mistakes:**

1. **`defaults write` does not apply live.** Writing to `NSGlobalDomain` via `defaults write`
   updates the pref file but macOS does not apply it to running processes (including scroll
   direction). For anything that needs to take effect immediately, use the appropriate Hammerspoon
   API instead. For scroll direction: use `hs.eventtap` to intercept and flip scroll events.
   See the "Scroll direction" section in `schema/capabilities.md` for the correct pattern.

2. **`hs.audiodevice.watcher` event names.** The events are:
   - `"dIn"` = input device list changed (NOT "default input changed")
   - `"dOut"` = output device list changed
   - `"dev#"` = default device changed (NOT "device added/removed")
   - `"vol#"` and `"mute"` fire on every volume/mute change — always filter these out.

3. **Watcher callbacks don't fire at startup.** Always check the current state when the module
   loads (e.g. `hs.usb.attachedDevices()`, `hs.audiodevice.defaultInputDevice()`) and apply
   the correct initial state before starting watchers.

4. **Race conditions on device switch.** When macOS changes a default device (Bluetooth connect
   etc.), it fires multiple events and may override your changes synchronously. Use
   `hs.timer.doAfter(0.5, function() ... end)` to defer actions and let macOS settle first.
