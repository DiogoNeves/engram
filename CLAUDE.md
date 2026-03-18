# engram

Plain-English macOS automation compiled to Hammerspoon Lua via Claude Code skills.

## Project structure

- `configs/` — user's markdown config files (gitignored, source of truth)
- `state/` — compilation state tracking (gitignored)
- `schema/` — config format spec and Hammerspoon API reference
- `templates/` — Lua templates the compiler uses as reference patterns
- `examples/` — example config files users can copy
- `.claude/skills/` — Claude Code skills (compiler, inspector)
- `.claude/commands/` — Claude Code commands (remember, compile)

## How it works

1. User writes markdown configs in `configs/` describing desired macOS behavior
2. `/compile` command reads configs and generates Hammerspoon Lua modules
3. Output goes to `~/.hammerspoon/engram/` which Hammerspoon auto-reloads

## Key files for the compiler

- `schema/capabilities.md` — Hammerspoon API reference (read this before generating Lua)
- `schema/config-format.md` — the markdown config format specification
- `templates/module.lua` — reference pattern for compiled Lua modules

## Inspecting system state

Use `hs -c "<lua>"` to query live macOS state via Hammerspoon CLI.
Requires `hs.ipc` to be loaded in the user's Hammerspoon config.

## Debugging Hammerspoon scripts

- **Console logs**: Click the Hammerspoon menubar icon → Console, or run `hs -c "print(...)"` from terminal
- **Read console history**: `hs -c "print(hs.console.getConsole())"` to dump recent log output
- **Check module loaded**: `hs -c "print(package.loaded['engram.module-name'] ~= nil)"`
- **Add logging in Lua**: Use `print("message")` — output appears in the Hammerspoon Console
- **Test expressions live**: `hs -c "print(hs.audiodevice.allInputDevices()[1]:name())"` etc.
- **Force reload**: `hs -c "hs.reload()"` or press the reload button in the Console window
