#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║                       QD — Quick Directory Jump                           ║
# ║  Pinned dirs + zoxide frecency  ·  fzf interface  ·  kitty/Dolphin aware  ║
# ╚══════════════════════════════════════════════════════════════════════════╝
#
# USAGE (from shell function in .zshrc):
#   qd              — open launcher, ENTER to cd
#   qda [path]      — pin current dir (or given path) to pins file
#
# IN-LAUNCHER KEYS:
#   ENTER           — cd into directory (via shell function)
#   SHIFT+ENTER     — open in Dolphin
#   CTRL-Y          — copy path to clipboard (wl-copy)
#   CTRL-E          — edit pins file in $EDITOR, auto-reload on save
#   CTRL-R          — refresh list (re-reads pins + zoxide)
#   CTRL-P          — toggle preview pane

set -o pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Mode detection via stdout:
#   stdout is a tty  → standalone / Hyprland launch → ENTER opens new kitty
#   stdout is a pipe → called as dir=$(qd.sh) by shell function → print path
# ─────────────────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
    SHELL_MODE=false   # standalone
else
    SHELL_MODE=true    # captured by shell function
fi

# ─────────────────────────────────────────────────────────────────────────────
# Paths
# ─────────────────────────────────────────────────────────────────────────────
PINS_FILE="${QD_PINS:-$HOME/.config/qd/pins.txt}"
QD_CACHE="$HOME/.cache/qd"
BUILD_SCRIPT="$QD_CACHE/build.sh"
PREVIEW_SCRIPT="$QD_CACHE/preview.sh"

mkdir -p "$QD_CACHE" "$(dirname "$PINS_FILE")"

# ─────────────────────────────────────────────────────────────────────────────
# Default pins file (created on first run)
# ─────────────────────────────────────────────────────────────────────────────
if [[ ! -f "$PINS_FILE" ]]; then
    cat > "$PINS_FILE" << 'PINS_EOF'
# QD Pinned Directories
# ─────────────────────────────────────────────────────
# One path per line. Lines starting with # are ignored.
# ~ is expanded. Missing dirs appear dimmed (not removed).
# Use CTRL-E inside qd to edit this file live.

/run/media/nuwa/Work/FYP/Code/panel-method-solver
/run/media/nuwa/System/Users/nuwan/Documents/Obsidian/nuwatha's_vault/
/run/media/nuwa/Work/dev/web/projects/portfolio-next/
/run/media/nuwa/Work/Semester_8/
~/Documents/Publications/Radial_TEC_CTM_MERCon/blinded_paper
PINS_EOF
fi

# ─────────────────────────────────────────────────────────────────────────────
# Build script
# Writes to cache so fzf --reload can call it independently.
# Format: ICON_FIELD <TAB> PATH_FIELD
#   Field 1 (display only): coloured icon + status label
#   Field 2 (clean path):   raw absolute path, no ANSI
# ─────────────────────────────────────────────────────────────────────────────
cat > "$BUILD_SCRIPT" << BUILDEOF
#!/bin/bash
PINS_FILE="$PINS_FILE"
declare -A seen

# ── 1. Pinned entries (always first, regardless of frecency) ─────────────────
while IFS= read -r line || [[ -n "\$line" ]]; do
    [[ -z "\$line" || "\$line" == \#* ]] && continue
    expanded="\${line/#~/$HOME}"
    seen["\$expanded"]=1
    if [[ -d "\$expanded" ]]; then
        printf '\033[35m 📌 pin\033[0m\t%s\n' "\$expanded"
    else
        printf '\033[35m 📌 pin  \033[2m·missing\033[0m\t%s\n' "\$expanded"
    fi
done < "\$PINS_FILE"

# ── 2. Zoxide frecency list (deduped against pins) ───────────────────────────
if command -v zoxide &>/dev/null; then
    while IFS= read -r zdir; do
        [[ -z "\$zdir" || -n "\${seen[\$zdir]}" || ! -d "\$zdir" ]] && continue
        seen["\$zdir"]=1
        printf '\033[33m ⚡ recent\033[0m\t%s\n' "\$zdir"
    done < <(zoxide query --list 2>/dev/null)
fi
BUILDEOF
chmod +x "$BUILD_SCRIPT"

# ─────────────────────────────────────────────────────────────────────────────
# Preview script — directory contents with stats
# Receives: $1 = clean path (field 2 from fzf)
# ─────────────────────────────────────────────────────────────────────────────
cat > "$PREVIEW_SCRIPT" << 'PREVEOF'
#!/bin/bash
dir="$1"
COLS="${FZF_PREVIEW_COLUMNS:-80}"
AVAIL=$(( ${FZF_PREVIEW_LINES:-30} - 7 ))
(( AVAIL < 5 )) && AVAIL=5

R="\033[0m"; B="\033[1m"; D="\033[2m"
CY="\033[36m"; YL="\033[33m"; RD="\033[31m"; GR="\033[32m"

sep() {
    local label="$1"
    local w=$(( COLS - 4 ))
    local ll=$(( (w - ${#label} - 2) / 2 ))
    local rl=$(( w - ll - ${#label} - 2 ))
    printf "${D}  "
    printf '─%.0s' $(seq 1 $ll)
    printf "${R}${B} %s ${R}${D}" "$label"
    printf '─%.0s' $(seq 1 $rl)
    printf "${R}\n"
}

if [[ ! -d "$dir" ]]; then
    echo -e "${RD}⚠  Directory not found${R}"
    echo -e "${D}$dir${R}"
    exit 0
fi

# Header
echo -e "${B}${CY}$(basename "$dir")${R}"
echo -e "${D}$dir${R}"
echo ""

# Stats row
total=$(ls -1A "$dir" 2>/dev/null | wc -l)
ndirs=$(find "$dir" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l)
nfiles=$(( total - ndirs ))
disk=$(du -sh "$dir" 2>/dev/null | cut -f1)
echo -e "${D}${YL}▸${R}${D} $total items  ·  $ndirs dirs  ·  $nfiles files  ·  ${disk} on disk${R}"

sep "CONTENTS"

if command -v eza &>/dev/null; then
    eza -la --icons --color=always --group-directories-first \
        --no-permissions --no-user --time-style=relative \
        "$dir" 2>/dev/null | tail -n +2 | head -n "$AVAIL"
else
    ls -lah --color=always "$dir" 2>/dev/null | tail -n +2 | head -n "$AVAIL"
fi
PREVEOF
chmod +x "$PREVIEW_SCRIPT"

# ─────────────────────────────────────────────────────────────────────────────
# Launch fzf
# ─────────────────────────────────────────────────────────────────────────────
EDITOR_CMD="${EDITOR:-nvim}"

result=$("$BUILD_SCRIPT" | fzf \
    --ansi \
    --delimiter=$'\t' \
    --with-nth=1,2 \
    --nth=2 \
    --layout=reverse \
    --border=rounded \
    --border-label=" 📁  QD — Quick Dirs " \
    --border-label-pos=3 \
    --margin=1,2 \
    --padding=1 \
    --prompt="  Jump › " \
    --pointer="▶" \
    --marker="✓" \
    --header=$'  ENTER: cd   CTRL-T: Dolphin   CTRL-Y: copy path\n  CTRL-E: edit pins   CTRL-R: refresh   CTRL-P: toggle preview' \
    --color='fg:#cdd6f4,fg+:#f5e0dc,bg:#1e1e2e,bg+:#313244' \
    --color='hl:#f38ba8,hl+:#f38ba8,info:#cba6f7,marker:#a6e3a1' \
    --color='prompt:#89b4fa,spinner:#f5c2e7,pointer:#f5c2e7,header:#6c7086' \
    --color='border:#89b4fa,label:#89b4fa,query:#f5c2e7' \
    --color='preview-bg:#181825,preview-border:#45475a' \
    --preview-window='right:50%:border-rounded' \
    --preview="'$PREVIEW_SCRIPT' {2}" \
    --bind='ctrl-p:change-preview-window(hidden|right:50%:border-rounded)' \
    --bind='ctrl-y:execute-silent(echo -n {2} | wl-copy)+bell' \
    --bind="ctrl-e:execute($EDITOR_CMD '$PINS_FILE')+reload('$BUILD_SCRIPT')" \
    --bind="ctrl-r:reload('$BUILD_SCRIPT')+clear-query" \
    --expect='ctrl-t' \
)

[[ -z "$result" ]] && exit 0

key=$(echo "$result" | head -1)
path=$(echo "$result" | tail -1 | cut -f2)
[[ -z "$path" ]] && exit 0

case "$key" in
    ctrl-t)
        # Open in Dolphin (detached)
        setsid dolphin "$path" >/dev/null 2>&1 &
        ;;
    *)
        if $SHELL_MODE; then
            # Shell function mode: print path, the qd() wrapper does cd
            echo "$path"
        else
            # Standalone/Hyprland mode: open a new kitty window at the selected dir
            kitty --detach --directory "$path" 2>/dev/null
        fi
        ;;
esac
