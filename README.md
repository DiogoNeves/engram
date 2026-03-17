# engram

Your Mac keeps forgetting your preferences. You plug in Bluetooth headphones and suddenly your audio input switches away from your USB mic. You want your trackpad to scroll naturally but your external mouse to scroll the traditional way — macOS doesn't let you set them independently. You fix things manually, and they reset the next time a device connects.

engram fixes this. Describe what you want in plain English, and it compiles to [Hammerspoon](https://www.hammerspoon.org/) automation that enforces your preferences automatically.

## How it works

```
configs/*.md  →  Claude Code compiler  →  ~/.hammerspoon/engram/*.lua  →  auto-reload
```

1. You write (or generate) a markdown file describing the behavior you want
2. Claude Code compiles it into Hammerspoon Lua
3. Hammerspoon runs the compiled code and auto-reloads on changes

## Quick start

```bash
# 1. Clone the repo
git clone https://github.com/nicedoc/engram.git
cd engram

# 2. Install dependencies (Hammerspoon, CLI tools)
just setup

# 3. Describe what you want
just remember "always use my Rode mic as audio input, even when Bluetooth devices connect"

# 4. Compile to Hammerspoon
just compile

# 5. Done — Hammerspoon enforces your preferences
```

## Writing configs

Config files live in `configs/` and are markdown with YAML frontmatter. See [schema/config-format.md](schema/config-format.md) for the full spec and [examples/](examples/) for ready-to-use templates.

A config looks like this:

```markdown
---
name: audio-routing
description: Route audio to USB mic when connected
triggers:
  - type: usb
    match:
      productName: "Rode NT-USB"
    event: added
---

When my Rode NT-USB is connected, always use it as the default audio input,
even if I connect Bluetooth headphones afterward.
```

## Commands

| Command | Description |
|---------|-------------|
| `just setup` | Install Hammerspoon and CLI tools via Homebrew |
| `just remember "..."` | Create a config from a natural language description |
| `just compile` | Compile all configs to Hammerspoon Lua (with validation) |
| `just status` | Show current configs and compiled files |
| `just backup` | Back up your Hammerspoon config |
| `just clean` | Remove all compiled output (preserves configs) |

## Prerequisites

- macOS
- [Hammerspoon](https://www.hammerspoon.org/)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview)
- [just](https://github.com/casey/just)

## Safety

- engram **never** modifies your existing `~/.hammerspoon/init.lua`
- All compiled output is isolated in `~/.hammerspoon/engram/`
- Run `just backup` before your first compile
- Run `just clean` to remove everything instantly

## Roadmap

- [ ] Global CLI install (`engram compile` from anywhere, without needing to be in the repo)
- [ ] Spoon packaging for Hammerspoon distribution

## License

MIT
