Create a new engram config from a natural language description.

The user wants: $ARGUMENTS

## Instructions

1. Use the engram-inspect skill to query current macOS system state as needed. Decide what to inspect based on the user's description — don't run fixed scripts.

2. Read `schema/config-format.md` for the expected markdown config format.

3. Generate a config file in `configs/` with:
   - Proper YAML frontmatter (name, description, triggers)
   - Clear plain-English body describing the desired behavior
   - A kebab-case filename matching the `name` field

4. Show the user what was created and suggest running `just compile` to apply it.

If no arguments were provided, ask the user what behavior they want to configure.
