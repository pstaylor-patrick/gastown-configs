# Gas Town Configs

Shell and tmux configuration for [Gas Town](https://github.com/steveyegge/gastown) — Steve Yegge's multi-agent workspace manager for orchestrating Claude Code agents in parallel.

These configs were developed while setting up Gas Town to coordinate 15-30 agents across multiple repos. They include workarounds for issues encountered during initial setup.

## What's included

| File | Purpose |
|---|---|
| `tmux.conf` | Tuned for multi-agent workloads: 50k scrollback, near-zero escape delay, true color passthrough for Ghostty/iTerm2 |
| `zshrc-gastown.sh` | Sourceable zsh snippet: `GT_TOWN_ROOT`, `~/go/bin` PATH, shell hook integration, process limit raise |
| `install.sh` | Symlinks configs and adds source line to `~/.zshrc` |

## Install

```bash
git clone git@github.com:pstaylor-patrick/gastown-configs.git
cd gastown-configs
./install.sh
```

Then restart your shell or `source ~/.zshrc`.

If you already have Gas Town shell integration in your `.zshrc` (the `# --- Gas Town Integration` block from `gt install --shell`), remove it to avoid duplication — `zshrc-gastown.sh` replaces it.

## Prerequisites

- [Gas Town](https://github.com/steveyegge/gastown) installed (`gt install ~/src/gt --git --shell`)
- Go, tmux, Dolt, Beads (`bd`) on your system
- macOS or Linux with zsh

## Gotchas addressed

**`gt rig quick-add` fails with "no Gas Town found"** — Gas Town's shell hook unsets `GT_TOWN_ROOT` when you `cd` into a repo it doesn't recognize as a Gas Town clone. The zsh snippet sets `GT_TOWN_ROOT` before the hook sources and disables the auto-add prompt entirely. Add rigs manually with `gt rig add` instead.

**`ulimit -u` error on shell startup** — macOS has a hard process limit (typically 4000) that's lower than the 10000 Gas Town suggests. The snippet reads the hard limit dynamically instead of hardcoding a value.

**tmux + Ghostty true color** — Ghostty auto-detects `xterm-ghostty` for direct sessions, but tmux needs `xterm-256color` with an explicit `Tc` terminal override for 24-bit color passthrough.

## Customization

Edit `zshrc-gastown.sh` to change:

- `GT_TOWN_ROOT` — defaults to `$HOME/src/gt`
- `GASTOWN_DISABLE_OFFER_ADD` — set to `1` to suppress the "Add to Gas Town?" prompt on `cd`; remove or set to `0` to re-enable it

## License

MIT
