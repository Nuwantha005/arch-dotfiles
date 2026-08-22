#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "🚀 Initializing Dotfiles Backup Repository..."

# 1. Create dotfiles folder structure
mkdir -p "$DOTFILES_DIR/hypr"
mkdir -p "$DOTFILES_DIR/caelestia"
mkdir -p "$DOTFILES_DIR/customScripts"
mkdir -p "$DOTFILES_DIR/wofi"
mkdir -p "$DOTFILES_DIR/foot"
mkdir -p "$DOTFILES_DIR/kitty"
mkdir -p "$DOTFILES_DIR/swaync"
mkdir -p "$DOTFILES_DIR/applications"
mkdir -p "$DOTFILES_DIR/zsh"
mkdir -p "$DOTFILES_DIR/nvim"
mkdir -p "$DOTFILES_DIR/mpv"

# Function to safely move and symlink directories/files
backup_and_link() {
    local src="$1"
    local dest="$2"

    if [ -e "$src" ] && [ ! -L "$src" ]; then
        echo "📦 Backing up $src -> $dest"
        if [ -d "$src" ]; then
            mkdir -p "$dest"
            cp -r "$src"/* "$dest"/ 2>/dev/null || cp "$src" "$dest"/
            rm -rf "$src"
        else
            mkdir -p "$(dirname "$dest")"
            cp "$src" "$dest"
            rm -f "$src"
        fi
        ln -s "$dest" "$src"
        echo "🔗 Symlinked $src -> $dest"
    elif [ -L "$src" ]; then
        echo "✅ Already symlinked: $src"
    fi
}

# 2. Sync active configs into dotfiles
backup_and_link "$HOME/.config/hypr" "$DOTFILES_DIR/hypr"
backup_and_link "$HOME/.config/caelestia" "$DOTFILES_DIR/caelestia"
backup_and_link "$HOME/customScripts" "$DOTFILES_DIR/customScripts"
backup_and_link "$HOME/.config/wofi" "$DOTFILES_DIR/wofi"
backup_and_link "$HOME/.config/foot" "$DOTFILES_DIR/foot"
backup_and_link "$HOME/.config/kitty" "$DOTFILES_DIR/kitty"
backup_and_link "$HOME/.config/swaync" "$DOTFILES_DIR/swaync"
backup_and_link "$HOME/.zshrc" "$DOTFILES_DIR/zsh/.zshrc"
backup_and_link "$HOME/.config/nvim" "$DOTFILES_DIR/nvim"
backup_and_link "$HOME/.config/mpv" "$DOTFILES_DIR/mpv"
backup_and_link "$HOME/.config/mimeapps.list" "$DOTFILES_DIR/mimeapps.list"

if [ -f "$HOME/.local/share/applications/vlc.desktop" ]; then
    cp "$HOME/.local/share/applications/vlc.desktop" "$DOTFILES_DIR/applications/"
fi

# 3. Initialize Git if not already done
cd "$DOTFILES_DIR"
if [ ! -d ".git" ]; then
    git init
    git branch -M main
    echo "✨ Git repository initialized in $DOTFILES_DIR"
fi

# 4. Stage and commit
git add .
git commit -m "Backup dotfiles: Hyprland Lua, Caelestia Shell, customScripts & themes" || echo "No changes to commit"

echo ""
echo "🎉 Dotfiles backup complete!"
echo "To link with GitHub / GitLab, run:"
echo "  cd ~/dotfiles"
echo "  git remote add origin https://github.com/Nuwantha005/arch-dotfiles.git"
echo "  git push -u origin main"
