#!/bin/sh
# Toggle a Claude pane on the right, one Claude per directory.
#   pressed inside a Claude pane          -> hide it
#   a Claude for this dir is visible here -> hide it
#   otherwise -> hide any other Claude in this window, then bring back the
#                Claude for the current dir (or start one there)
# Hidden Claudes live in the "_claude" session and keep running.
# Usage: claude-toggle.sh <window_id> <active_pane_id> <cwd>
win="$1"; active="$2"; cwd="$3"
WIDTH="51%"
STASH="_claude"
TAB=$(printf '\t')

stash() {
  tmux has-session -t "$STASH" 2>/dev/null || tmux new-session -d -s "$STASH" -n keep
  tmux break-pane -d -s "$1" -t "$STASH:"
}

# Pressed from inside a Claude pane: just hide it.
if [ -n "$(tmux display -p -t "$active" '#{@claude_dir}')" ]; then
  stash "$active"; exit 0
fi

# Claude currently shown in this window, if any.
here=$(tmux list-panes -t "$win" -F "#{pane_id}${TAB}#{@claude_dir}" | awk -F "$TAB" '$2 != "" { print; exit }')
here_id=${here%%"$TAB"*}; here_dir=${here#*"$TAB"}

if [ -n "$here_id" ]; then
  stash "$here_id"
  [ "$here_dir" = "$cwd" ] && exit 0   # same dir: this was a plain hide
fi

# Existing Claude for this directory (stashed or in another window)?
pane=$(tmux list-panes -a -F "#{pane_id}${TAB}#{@claude_dir}" | awk -F "$TAB" -v d="$cwd" '$2 == d { print $1; exit }')

if [ -n "$pane" ]; then
  tmux join-pane -h -l "$WIDTH" -s "$pane" -t "$active"
else
  pane=$(tmux split-window -h -l "$WIDTH" -c "$cwd" -t "$active" -P -F '#{pane_id}' claude)
  tmux set-option -p -t "$pane" @claude_dir "$cwd"
fi
