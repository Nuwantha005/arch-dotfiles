# 🌌 Arch Linux Hyprland & Caelestia Shell Dotfiles

Modern, high-performance, modular Linux desktop configuration featuring **Hyprland (Lua API)**, **Caelestia Shell**, **Material 3 Dynamic Theming**, **Pypr Scratchpads**, and custom Wayland productivity workflow.

---

## 🌟 Highlights & Features

- **Modular Hyprland Lua Config**: Managed via `hyprland.lua` and modular Lua files in `hyprland/` (`keybinds.lua`, `rules.lua`, `execs.lua`, `env.lua`, `general.lua`).
- **Caelestia Shell Integration**: Dynamic Material 3 shell with custom launcher, sidebar, status bar, volume/brightness overlays, and lockscreen.
- **Dynamic Theme & Color Engine**: Auto-extracts Material 3 palettes from wallpapers and syncs system-wide, including Firefox (`pywalfox`), Neovim, and terminal instances.
- **Pypr Scratchpads**: Quick-toggle drop-down terminal (`SUPER+R`), music/audio mixer (`SUPER+Q`), and system monitor (`SUPER+T`).
- **Smart Clipboard Manager**: Custom `cliphist` + `wofi` + `wtype` picker (`SUPER+V`) with automatic textfield pasting.
- **Crisp HiDPI / XWayland Scaling**: Non-pixelated X11/Qt application rendering via `force_zero_scaling` and `QT_AUTO_SCREEN_SCALE_FACTOR=0`.

---

## 🎨 Theme & Color Engine (Caelestia + Pywalfox)

Caelestia Shell includes a **Dynamic Material 3 Color Engine** that generates matching system-wide color schemes directly from your desktop wallpaper.

### 1. Auto vs. Manual Theme Modes

#### 🔄 Auto Mode (Wallpaper-Based Dynamic Palette)
Extracts a Material 3 palette from your current wallpaper image and applies it across GTK 3/4, Qt, Foot, Kitty, Fuzzel, Btop, Discord, Spicetify, and Hyprland:
```bash
caelestia scheme set -n dynamic
```

#### 🎨 Manual Mode (Static Pre-Built Themes)
Freeze or select a fixed theme (e.g. Catppuccin, Tokyo Night, Gruvbox, Nord):
- **Via Launcher**: Press `SUPER + Space`, type `scheme`, press `Enter`, and select a theme.
- **Via Terminal**:
  ```bash
  caelestia scheme set -n catppuccin -f mocha
  caelestia scheme set -n tokyo-night
  ```

---

### 2. Pywalfox & Pywal Integration

Configured in `~/.config/caelestia/cli.json` via a `postHook`:

```json
{
    "wallpaper": {
        "postHook": "wal -i \"$WALLPAPER_PATH\" -n --cols16 2>/dev/null && pywalfox update 2>/dev/null"
    }
}
```

#### How it works:
1. When you select a wallpaper via Caelestia launcher or CLI (`caelestia wallpaper -f /path/to/wall.jpg`), Caelestia passes `$WALLPAPER_PATH` to the `postHook`.
2. The hook executes `wal -i "$WALLPAPER_PATH"` and `pywalfox update`.
3. **Firefox (via Pywalfox)**, **Neovim**, and **Terminals** update colors in sync with Caelestia Shell!

#### Quick Test Commands:
```bash
# Enable dynamic wallpaper-based colors
caelestia scheme set -n dynamic

# Set a new wallpaper & auto-update Firefox / Pywalfox
caelestia wallpaper -f ~/Pictures/Wallpapers/your_wallpaper.jpg
```

---

## ⌨️ Keybindings Cheat Sheet

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| **`SUPER + Space`** | Caelestia Launcher | Application & Command Launcher |
| **`SUPER + D`** | Terminal | Launches Kitty terminal |
| **`SUPER + E`** | File Manager | Launches Thunar |
| **`SUPER + F`** | Close Window | Kills active window (`killactive`) |
| **`SUPER + G`** | Fullscreen | Toggles window fullscreen |
| **`SUPER + N`** | Toggle Split | Toggles layout split (`togglesplit`) |
| **`SUPER + P`** | Pseudo Tiling | Toggles pseudo window tiling |
| **`SUPER + V`** | Clipboard Picker | Wofi clipboard history with auto-paste |
| **`SUPER + H / J / K / L`** | Focus Movement | Focus Left / Down / Up / Right |
| **`SUPER + R`** | Terminal Scratchpad | Pypr drop-down Kitty terminal |
| **`SUPER + Q`** | Audio Scratchpad | Pypr pulsemixer scratchpad |
| **`SUPER + T`** | Taskbar Scratchpad | Pypr btop system monitor scratchpad |
| **`SUPER + I`** | Caelestia Sidebar | Toggles notification sidebar |
| **`SUPER + U`** | Caelestia Panels | Toggles all Caelestia panels (`showall`) |
| **`SUPER + W`** | Caelestia Lock | Caelestia lockscreen (`caelestia:lock`) |
| **`SUPER + O`** | Quickshell Lock | Quickshell lockscreen script |

---

## 🚀 Installation & Deployment

### 1. Clone Repository
```bash
git clone https://github.com/Nuwantha005/arch-dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run Setup Script
```bash
chmod +x setup.sh
./setup.sh
```

The setup script cleanly backs up your existing directories and creates live symlinks from `~/dotfiles/` to `~/.config/`.

---

## 🔒 Private Keybindings & Local Customization

To keep this dotfiles repository public while preventing sensitive shortcuts (such as emergency lockscreen unlock keybindings) from being exposed online, private keybindings are isolated in a local, untracked file:

- **Public Template**: [`hypr/keybinds-private.lua.example`](hypr/keybinds-private.lua.example)
- **Local Private File**: `hypr/keybinds-private.lua` *(Gitignored)*

### Setting Up Private Shortcuts:
1. Copy the template to create your local private keybindings file:
   ```bash
   cp hypr/keybinds-private.lua.example hypr/keybinds-private.lua
   ```
2. Open `hypr/keybinds-private.lua` and set your sensitive keybindings.
3. Hyprland automatically loads `keybinds-private.lua` locally if it exists without committing your private key combinations to git.

