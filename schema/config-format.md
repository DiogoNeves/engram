# Config Format

engram config files are markdown with YAML frontmatter. The frontmatter provides structured trigger metadata. The body describes actions in plain English.

## Structure

```markdown
---
name: my-config-name
description: One-line summary of what this config does
triggers:
  - type: usb
    match:
      productName: "Device Name"
    event: added
  - type: usb
    match:
      productName: "Device Name"
    event: removed
---

## When connected

When my Device Name is connected:
- Set the default audio input to "Device Name"
- Show a notification "Device connected"

## When disconnected

When my Device Name is disconnected:
- Set the default audio input to "MacBook Pro Microphone"
```

## Frontmatter Fields

### `name` (required)
Kebab-case identifier. Used as the compiled Lua filename.

### `description` (required)
One-line human-readable summary.

### `triggers` (required)
Array of trigger definitions. Each trigger has:

#### `type`
| Type | Hammerspoon API | Events |
|------|----------------|--------|
| `usb` | `hs.usb.watcher` | `added`, `removed` |
| `audio` | `hs.audiodevice.watcher` | `changed` (device added/removed/default changed) |
| `wifi` | `hs.wifi.watcher` | `changed` (network joined/left) |
| `screen` | `hs.screen.watcher` | `changed` (display connected/disconnected) |
| `app` | `hs.application.watcher` | `launched`, `terminated`, `activated` |
| `wake` | `hs.caffeinate.watcher` | `wake` (system woke from sleep) |
| `battery` | `hs.battery.watcher` | `changed` (power state changed) |
| `bluetooth` | `hs.timer` + `blueutil` | `connected`, `disconnected` (polled) |

#### `match` (optional)
Key-value pairs to filter the trigger. Keys depend on type:
- **usb**: `productName`, `vendorName`, `vendorID`, `productID`
- **wifi**: `ssid`
- **app**: `appName`
- **bluetooth**: `address`, `name`
- **audio**: `deviceName`, `transportType` (Built-in, USB, Bluetooth, AirPlay)

#### `event`
The specific event to react to. See the table above for valid values per type.

## Body

The markdown body describes what should happen in plain English. Use clear, imperative language:
- "Set the default audio input to ..."
- "Set output volume to 50%"
- "Show a notification ..."
- "Launch App Name"
- "Kill App Name"
- "Run command: ..."

Organize with headings to separate different trigger scenarios (e.g. "## When connected" and "## When disconnected").

## Multiple Triggers

A single config can define multiple triggers. The body should clearly describe which actions correspond to which trigger events.
