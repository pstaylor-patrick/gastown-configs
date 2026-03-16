#!/usr/bin/env zsh
# Gas Town shell integration for zsh
# Source this from ~/.zshrc AFTER your PATH setup (needs ~/go/bin in PATH).
#
# Usage: Add to ~/.zshrc:
#   source "$HOME/path/to/zshrc-gastown.sh"
#
# Prerequisites:
#   - Gas Town installed: gt install ~/src/gt --git --shell
#   - Go binaries on PATH: export PATH="$HOME/go/bin:$PATH"

# --- Go binaries ---
# Ensure gt and bd are on PATH (idempotent)
case ":$PATH:" in
  *":$HOME/go/bin:"*) ;;
  *) export PATH="$HOME/go/bin:$PATH" ;;
esac

# --- Town root ---
# Set before the shell hook sources, so gt commands always know where the town is.
export GT_TOWN_ROOT="${GT_TOWN_ROOT:-$HOME/src/gt}"

# Disable the "Add to Gas Town?" prompt on cd. Add rigs manually with `gt rig add`.
export GASTOWN_DISABLE_OFFER_ADD=1

# --- Shell hook ---
# Gas Town's managed hook: registers chpwd/precmd hooks for rig detection,
# auto-offers to add new repos, and sets GT_RIG when inside a known rig.
[[ -f "$HOME/.config/gastown/shell-hook.sh" ]] && source "$HOME/.config/gastown/shell-hook.sh"

# --- Workaround: shell hook unsets GT_TOWN_ROOT (upstream bug) ---
# If you re-enable the offer-add prompt, you'll need to override _gastown_offer_add
# to inject GT_TOWN_ROOT when calling gt, since the shell hook unsets it for repos
# outside Gas Town. See git history for the full override.

# --- Process limits ---
# Gas Town with 15-30 agents can hit macOS default process limits (2666).
# Raise to the hard limit (typically 4000 on macOS, higher on Linux).
_gt_hard_ulimit=$(ulimit -Hu 2>/dev/null)
if [[ -n "$_gt_hard_ulimit" ]]; then
  ulimit -u "$_gt_hard_ulimit" 2>/dev/null
fi
unset _gt_hard_ulimit
