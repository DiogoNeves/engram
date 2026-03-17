Compile all engram markdown configs into Hammerspoon Lua.

IMPORTANT: Do the work immediately and silently. No preamble, no explaining what you're about to do, no progress commentary. Just execute and print a brief summary when done.

## Step 1: Compile

Use the engram-compile skill to compile all configs.

## Step 2: Validate and fix

After compiling, run `hs -c "dofile('~/.hammerspoon/engram/<name>.lua')"` on each compiled file. If there are errors:
- Fix the Lua directly
- Re-validate
- Repeat until all files pass

Do not stop until every compiled file is valid Lua. Do not ask the user for help with Lua errors — just fix them.

## Output format

When everything passes, print only:
- One line per compiled file: `✓ configs/foo.md → ~/.hammerspoon/engram/foo.lua`
- One line per skipped file (unchanged): `· configs/foo.md (unchanged)`
- A final line: `Done. N compiled, N skipped.`

If a file could not be fixed after multiple attempts: `✗ foo.lua: <error>`

Nothing else.
