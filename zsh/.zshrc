# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

ZSH_THEME="robbyrussell"

# Apply active Caelestia terminal colors
if [[ -f ~/.local/state/caelestia/sequences.txt ]]; then
    cat ~/.local/state/caelestia/sequences.txt 2>/dev/null
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-tab)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Make $SHELL command match the current shell
export SHELL=/usr/bin/zsh

#Run fatstfetch at the start
fastfetch


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/nuwa/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/nuwa/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/nuwa/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/nuwa/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/home/nuwa/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/nuwa/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# OpenFOAM Initialization
source ~/OpenFOAM/OpenFOAM-v2512/etc/bashrc

#Setting Default Apps
export EDITOR=nvim
export VISUAL=nvim

export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export PATH=$PATH:/home/nuwa/.cargo/bin


# pip cache
export PIP_CACHE_DIR="$HOME/.cache/pip"

# HuggingFace / Torch
export HF_HOME="$HOME/.cache/huggingface"
export TORCH_HOME="$HOME/.cache/torch"

# Transformers cache (older libs)
export TRANSFORMERS_CACHE="$HOME/.cache/huggingface/transformers"

export SCREENSHOT_TOOL=grim


# Silence albumentations update spam
export NO_ALBUMENTATIONS_UPDATE=1

# Silence Python warnings globally for CLI tools
export PYTHONWARNINGS="ignore"

# --- FZF-TAB CONFIGURATION ---

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# THE PREVIEW WINDOW: This is what you see in the image
# It uses 'bat' to show file content for commands like vim, nano, or cat
zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -f $realpath ]] && bat --color=always --line-range :30 $realpath || [[ -d $realpath ]] && eza -1 --color=always $realpath'

# Optional: Configure fzf layout (height, border, etc.)
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
# Set the command fzf uses to find files (includes hidden files, excludes .git)
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Apply the preview window to the CTRL-T shortcut
# This shows a preview automatically as you type
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --line-range :50 {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Source the fzf keybindings for Arch Linux
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Use bat for previews in the fuzzy completion trigger
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza -1 --color=always {}' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat --color=always --line-range :50 {}' "$@" ;;
  esac
}

fpdf() {
  # 1. Use fd to find all PDF files
  # 2. Use fzf to filter them
  # 3. Use 'exiftool' or 'pdftotext' for preview (optional)
  # 4. Open with 'xdg-open' (which will use your default PDF viewer)
  
  local file
  file=$(fd -e pdf . /run/media/nuwa/ /home/nuwa/ 2>/dev/null | fzf \
    --query="$1" \
    --preview='pdftotext -l 1 -q {} - | head -n 50' \
    --preview-window=right:50%:wrap \
    --prompt="Search PDFs > " \
    --header="CTRL-T: toggle preview | Enter: Open")

  if [[ -n "$file" ]]; then
    xdg-open "$file"
  fi
}

eval "$(zoxide init zsh)"


export HF_HOME="$HOME/.cache/huggingface"
export HF_HUB_ENABLE_HF_TRANSFER=1
export HF_HUB_DOWNLOAD_TIMEOUT=600


# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/nuwa/.lmstudio/bin"
# End of LM Studio CLI section

# ─────────────────────────────────────────────────────────────────────────────
# QD — Quick Directory Jump
# ─────────────────────────────────────────────────────────────────────────────

# Initialize zoxide (if not already present)
# This hooks into chpwd so every cd call is automatically tracked
eval "$(zoxide init zsh)"

# qd — open the launcher; cd into the selected directory
qd() {
    local dir
    dir=$(~/customScripts/qd.sh 2>/dev/null)
    [[ -n "$dir" ]] && cd "$dir"
}

# qda — pin a directory without opening the launcher
#   qda           → pins $PWD
#   qda /some/path → pins that path
qda() {
    local target="${1:-$PWD}"
    local pins="$HOME/.config/qd/pins.txt"

    # Avoid duplicates
    if grep -qxF "$target" "$pins" 2>/dev/null; then
        echo "📌 Already pinned: $target"
        return 0
    fi

    echo "$target" >> "$pins"
    echo "📌 Pinned: $target"
}

# Optional: bind qd to a key (e.g. Alt+d) for instant access
bindkey -s '^[d' 'qd\n'

export PATH="$HOME/.local/bin:$PATH"  # lunar dev scripts

# Custom Aliases
alias imcat="kitten icat"
alias fcp='kitty +kitten choose-files | tee /dev/tty | wl-copy'
