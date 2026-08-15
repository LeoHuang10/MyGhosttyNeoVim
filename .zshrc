# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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
# DISABLE_LS_COLORS="true"

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
plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

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

# Starship 彩虹提示符
eval "$(starship init zsh)"

# 讓 ls 輸出彩色
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# 語法高亮樣式：無效命令顯示為白色
ZSH_HIGHLIGHT_STYLES[incorrect-command]='fg=white'

# fzf 模糊搜尋（Ctrl+R 呼出，歷史命令和文件搜尋）
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide 智能目錄跳轉（替代 cd，自動學習常用目錄）
eval "$(zoxide init zsh)"

# 歷史記錄優化
setopt HIST_IGNORE_ALL_DUPS      # 忽略連續重複的命令
setopt HIST_SAVE_NO_DUPS         # 存檔時去除重複命令
setopt SHARE_HISTORY             # 跨終端會話共享歷史
export HISTSIZE=50000            # 內存中歷史記錄數量
export SAVEHIST=50000            # 存檔的歷史記錄數量


# direnv 自動加載項目環境變量
eval "$(direnv hook zsh)"

# Lazygit 別名
alias lg='lazygit'              # 快速啟動 Lazygit

# thefuck 命令糾錯
eval "$(thefuck --alias fix)"    # 輸錯命令後輸入 fix 自動修正



# ===== 遊戲引擎快捷命令 =====

# CryEngine 虛擬機快捷啟動（需先安裝 Parallels Desktop）
alias cry-vm="open -a 'Parallels Desktop'"

# Unreal Engine 編輯器（自動識別最新版本，無需手動更新路徑）
alias ue-editor='ls -d /Users/Shared/Epic\ Games/UE_* | sort -V | tail -1 | xargs -I{} open {}/Engine/Binaries/Mac/UnrealEditor.app'

# Bevy 無需別名，進入項目目錄後使用 cargo run 即可

# Godot 編輯器
# Godot GDScript 版
alias godot-gd="/Applications/Godot.app/Contents/MacOS/Godot"

# Godot C# 版（若實際名稱為 Godot_mono.app）
alias godot-cs="/Applications/Godot_mono.app/Contents/MacOS/Godot"

# Unity Hub（管理 Unity 項目與版本）
alias unity-hub="open -a 'Unity Hub'"


# ===== 終端標題動態更新 =====
# 每次顯示提示符前，將 Ghostty 標籤頁標題設為當前目錄
function precmd() {
  echo -ne "\033]0;${PWD/#$HOME/~}\007"
}
export PATH="$HOME/.cargo/bin:$PATH"
alias unity-intl="open -a 'Unity Hub International Version'"    # Unity Hub 國際版

[ -f "/Users/huangshaoshuai/.ghcup/env" ] && . "/Users/huangshaoshuai/.ghcup/env" # ghcup-env