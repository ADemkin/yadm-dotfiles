#!/usr/bin/env bash
# One dot per Claude pane across all tmux windows, colored by tmux-agent-indicator state.
# Panes with claude in their process tree but no hook state (e.g. done, then focused) show as idle.

set -uo pipefail

tmux display-message -p '#S' >/dev/null 2>&1 || exit 0

opt() { local v; v=$(tmux show-option -gqv "$1"); printf '%s' "${v:-$2}"; }

SYMBOL=$(opt @agent-pane-dots-symbol '●')
IDLE_SYMBOL=$(opt @agent-pane-dots-idle-symbol '○')
RUNNING_COLOR=$(opt @agent-pane-dots-running-color 'blue')
NEEDS_INPUT_COLOR=$(opt @agent-pane-dots-needs-input-color 'yellow')
DONE_COLOR=$(opt @agent-pane-dots-done-color 'red')
IDLE_COLOR=$(opt @agent-pane-dots-idle-color 'default')
PROCESSES=$(opt @agent-pane-dots-processes 'claude')
# Separator may be set to '' (no gap), so check "is set" rather than "non-empty".
if [ -n "$(tmux show-option -gq @agent-pane-dots-separator)" ]; then
    SEPARATOR=$(tmux show-option -gqv @agent-pane-dots-separator)
else
    SEPARATOR=' '
fi

# Hook state per pane: TMUX_AGENT_PANE_%N_STATE=<state>
declare -A state
while IFS='=' read -r key value; do
    pane="${key#TMUX_AGENT_PANE_}"
    state["${pane%_STATE}"]="$value"
done < <(tmux show-environment -g 2>/dev/null | grep '^TMUX_AGENT_PANE_.*_STATE=')

# Pane shell PIDs, then mark panes whose process tree contains a watched agent
# (covers agents nested in nvim/other wrappers that get their own pty).
declare -A pane_of_pid
while read -r pane pid; do
    pane_of_pid["$pid"]="$pane"
done < <(tmux list-panes -a -F '#{pane_id} #{pane_pid}')

declare -A parent agent_pane
agent_pids=()
proc_re="(^|/)(${PROCESSES//,/|})( |$)"
while read -r pid ppid cmd; do
    parent["$pid"]="$ppid"
    [[ "$cmd" =~ $proc_re ]] && agent_pids+=("$pid")
done < <(ps -axo pid=,ppid=,command= 2>/dev/null)

for pid in "${agent_pids[@]}"; do
    while [ -n "$pid" ] && [ "$pid" != "0" ] && [ "$pid" != "1" ]; do
        if [ -n "${pane_of_pid[$pid]:-}" ]; then
            agent_pane["${pane_of_pid[$pid]}"]=1
            break
        fi
        pid="${parent[$pid]:-}"
    done
done

dots=()
while read -r pane; do
    s="${state[$pane]:-}"
    case "$s" in
        running)     dots+=("#[fg=${RUNNING_COLOR}]${SYMBOL}") ;;
        needs-input) dots+=("#[fg=${NEEDS_INPUT_COLOR}]${SYMBOL}") ;;
        done)        dots+=("#[fg=${DONE_COLOR}]${SYMBOL}") ;;
        *)
            [ -n "${agent_pane[$pane]:-}" ] && dots+=("#[fg=${IDLE_COLOR}]${IDLE_SYMBOL}")
            ;;
    esac
done < <(tmux list-panes -a -F '#{pane_id}')

[ "${#dots[@]}" -eq 0 ] && exit 0
out="${dots[0]}"
for dot in "${dots[@]:1}"; do
    out+="${SEPARATOR}${dot}"
done
printf '%s#[fg=default]' "$out"
exit 0
