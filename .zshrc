# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

source $ZSH/oh-my-zsh.sh

# Starship 彩虹提示符
eval "$(starship init zsh)"

# 讓 ls 輸出彩色
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# 語法高亮樣式：無效命令顯示為白色
ZSH_HIGHLIGHT_STYLES[incorrect-command]='fg=white'

# fzf 模糊搜尋
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide 智能目錄跳轉
eval "$(zoxide init zsh)"

# 歷史記錄優化
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
export HISTSIZE=50000
export SAVEHIST=50000

# direnv 自動加載項目環境變量
eval "$(direnv hook zsh)"

# Lazygit 別名
alias lg='lazygit'

# thefuck 命令糾錯
eval "$(thefuck --alias fix)"

# 遊戲引擎快捷命令
alias cry-vm="open -a 'Parallels Desktop'"
alias ue-editor='ls -d /Users/Shared/Epic\ Games/UE_* | sort -V | tail -1 | xargs -I{} open {}/Engine/Binaries/Mac/UnrealEditor.app'
alias godot-gd="/Applications/Godot.app/Contents/MacOS/Godot"
alias godot-cs="/Applications/Godot_mono.app/Contents/MacOS/Godot"
alias unity-hub="open -a 'Unity Hub'"
alias unity-intl="open -a 'Unity Hub International Version'"

# 終端標題動態更新
function precmd() {
  echo -ne "\033]0;${PWD/#$HOME/~}\007"
}

export PATH="$HOME/.cargo/bin:$PATH"

[ -f "/Users/huangshaoshuai/.ghcup/env" ] && . "/Users/huangshaoshuai/.ghcup/env" # ghcup-env

# 使用 Homebrew LLVM 作為默認編譯器
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# 使用 Homebrew OpenJDK
export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

# Doom Emacs
alias em='emacsclient -nw -a ""'
alias emacs='emacsclient -c -a ""'
export PATH="$HOME/.config/emacs/bin:$PATH"

# Unity CLI
. "/Users/huangshaoshuai/.unity/env"
