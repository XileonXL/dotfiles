---
description: How to hand blocked commands to the user inside tmux
---

# tmux Workflow

## Blocked Commands
When a command is blocked (permission denial, auto mode classifier) and the user must run it themselves:

- If `$TMUX_PANE` is set, store the command in the per-pane tmux buffer:
  `tmux set-buffer -b "claude-$TMUX_PANE" -- "<command>"` (without the leading `!`)
- Tell the user to type `!` and press `prefix + p` (prefix is `Ctrl+Space`)
- Still show the command in the reply so it can be reviewed before running
- Never use `pbcopy`: the system clipboard is shared across all Claude sessions
- Outside tmux, give the command as plain text

The `prefix + p` binding in `~/.tmux.conf` pastes the `claude-#{pane_id}` buffer, so each session only receives its own command.
