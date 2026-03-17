Compile all engram markdown configs into Hammerspoon Lua.

IMPORTANT: Do the work immediately and silently. No preamble, no explaining what you're about to do, no progress commentary. Just execute and print a brief summary when done.

Use the engram-compile skill. When finished, output only:
- One line per compiled file: `✓ configs/foo.md → ~/.hammerspoon/engram/foo.lua`
- One line per skipped file (unchanged): `· configs/foo.md (unchanged)`
- Any validation errors: `✗ foo.lua: <error>`
- A final line: `Done. N compiled, N skipped.`

Nothing else.
