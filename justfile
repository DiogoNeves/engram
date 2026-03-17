# engram — plain-English macOS automation

default:
    @just --list

# First-time setup: install deps and configure Hammerspoon integration
setup:
    brew install --cask hammerspoon
    brew install switchaudio-osx blueutil
    mkdir -p ~/.hammerspoon/engram
    @echo ""
    @echo "Done! Next steps:"
    @echo "  1. Open Hammerspoon and enable the CLI: Preferences → Enable CLI (hs)"
    @echo "  2. Add this line to ~/.hammerspoon/init.lua:"
    @echo '     require("engram")'

# Create a new config from a natural language description
remember *ARGS:
    cd {{justfile_directory()}} && claude -p "/remember {{ARGS}}"

# Compile all configs → Hammerspoon Lua (includes validation)
compile:
    cd {{justfile_directory()}} && claude -p "/compile"

# Show current configs and compiled state
status:
    @echo "=== Configs ==="
    @ls -1 configs/*.md 2>/dev/null || echo "  (none)"
    @echo ""
    @echo "=== Compiled ==="
    @ls -1 ~/.hammerspoon/engram/*.lua 2>/dev/null || echo "  (none)"

# Back up current Hammerspoon config before making changes
backup:
    @cp -r ~/.hammerspoon ~/.hammerspoon.backup.$$(date +%Y%m%d%H%M%S)
    @echo "Backed up to ~/.hammerspoon.backup.*"

# Remove all engram compiled output (preserves your configs)
clean:
    rm -rf ~/.hammerspoon/engram/
    rm -f state/hashes.json state/manifest.json
    @echo "Cleaned compiled output. Configs preserved in configs/"
