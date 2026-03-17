Create a new engram config from a natural language description.

The user wants: $ARGUMENTS

## IMPORTANT: Bias towards action. Always inspect the system yourself rather than asking the user. Make reasonable decisions and note your assumptions. Only ask the user a question if there is a genuine ambiguity you cannot resolve by inspecting the system (e.g. the user mentions "my microphone" but two USB mics are connected).

## Instructions

1. **ALWAYS inspect the system first — this is mandatory, not optional.** Before writing any file, you MUST run `hs -c` commands via the Bash tool to query the current macOS state. For example:
   - Audio: `hs -c "print(hs.audiodevice.defaultInputDevice():name())"` and `hs -c "for _,d in pairs(hs.audiodevice.allInputDevices()) do print(d:name(), d:transportType()) end"`
   - USB: `hs -c "for _,d in pairs(hs.usb.attachedDevices()) do print(d.productName, d.vendorName) end"`
   - WiFi: `hs -c "print(hs.wifi.currentNetwork())"`
   - If `hs` fails, fall back to `system_profiler` or `SwitchAudioSource -a`

   **You MUST use the real device names from these commands in the config. NEVER write placeholders like "YOUR_DEVICE_NAME" or "YOUR_MICROPHONE_NAME". If you cannot determine a device name, that is a bug.**

2. Read `schema/config-format.md` for the expected markdown config format.

3. Generate a config file in `configs/` with:
   - Proper YAML frontmatter (name, description, triggers)
   - Clear plain-English body describing the desired behavior
   - A kebab-case filename matching the `name` field
   - The exact device names returned by the system inspection in step 1

4. Show the user what was created and suggest running `just compile` to apply it.

If no arguments were provided, ask the user what behavior they want to configure.
