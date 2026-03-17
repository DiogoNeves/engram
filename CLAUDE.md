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
