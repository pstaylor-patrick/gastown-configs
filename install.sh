#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing Gas Town configs from $REPO_DIR"
echo ""

# --- Helpers ---

link_file() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  mkdir -p "$dest_dir"

  if [[ -L "$dest" ]]; then
    echo "  Updating symlink: $dest"
    rm "$dest"
  elif [[ -f "$dest" ]]; then
    echo "  Backing up existing file: $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -s "$src" "$dest"
  echo "  Linked: $dest -> $src"
}

# --- tmux ---

link_file "$REPO_DIR/tmux.conf" "$HOME/.tmux.conf"

# Reload tmux config if server is running
if tmux info &>/dev/null; then
  tmux source-file "$HOME/.tmux.conf" 2>/dev/null && echo "  Reloaded tmux config" || true
fi

# --- zsh ---

link_file "$REPO_DIR/zshrc-gastown.sh" "$HOME/.config/gastown/zshrc-gastown.sh"

MARKER="# --- Gas Town configs (managed by gastown-configs) ---"
SOURCE_LINE="source \"\$HOME/.config/gastown/zshrc-gastown.sh\""
ZSHRC="$HOME/.zshrc"

if grep -qF "$MARKER" "$ZSHRC" 2>/dev/null; then
  echo "  zshrc-gastown.sh already sourced in ~/.zshrc"
else
  echo "" >> "$ZSHRC"
  echo "$MARKER" >> "$ZSHRC"
  echo "$SOURCE_LINE" >> "$ZSHRC"
  echo "  Added source line to ~/.zshrc"
fi

echo ""
echo "Done! Restart your shell or run: source ~/.zshrc"
echo ""
echo "Note: If you already have Gas Town shell integration in ~/.zshrc,"
echo "remove the old '# --- Gas Town Integration' block to avoid duplication."
