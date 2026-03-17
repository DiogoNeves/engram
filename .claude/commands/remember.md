Create a new engram config from a natural language description.

The user wants: $ARGUMENTS

## IMPORTANT: This runs non-interactively via `claude -p`. Do NOT ask questions, do NOT wait for confirmation. Inspect the system, make reasonable decisions, and produce the output. If something is ambiguous, make the best choice and note your assumption in the output.

## Instructions

1. **ALWAYS inspect the system first.** Before doing anything else, query the current macOS state to fill in any details the user didn't specify. Use `hs -c` commands (see the engram-inspect skill) to look up device names, current defaults, transport types, etc. Never ask the user for information you can look up yourself — just go check.

2. Read `schema/config-format.md` for the expected markdown config format.

3. Generate a config file in `configs/` with:
   - Proper YAML frontmatter (name, description, triggers)
   - Clear plain-English body describing the desired behavior
   - A kebab-case filename matching the `name` field
   - Use the exact device names returned by the system inspection

4. Show the user what was created and suggest running `just compile` to apply it.

If no arguments were provided, ask the user what behavior they want to configure.
