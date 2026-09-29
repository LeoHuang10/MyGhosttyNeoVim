# 基本設置
set -gx LANG en_US.UTF-8
set -gx CLICOLOR 1
set -gx LSCOLORS ExGxBxDxCxEgEdxbxgxcxd

# 使用 fish_add_path 自動去重，避免 PATH 重複
fish_add_path /opt/homebrew/opt/llvm/bin
fish_add_path /opt/homebrew/opt/openjdk/bin
fish_add_path $HOME/.cargo/bin

# JAVA_HOME
set -gx JAVA_HOME /opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home

# GHCup 環境
if test -f $HOME/.ghcup/env
    bass source $HOME/.ghcup/env
end

# Starship 提示符
starship init fish | source

# fzf 模糊搜索
if type -q fzf
    fzf --fish | source
end

# zoxide 智能目錄跳轉
if type -q zoxide
    zoxide init fish | source
end

# direnv
if type -q direnv
    direnv hook fish | source
end

# thefuck
if type -q thefuck
    thefuck --alias | source
end

# 歷史記錄優化
set -g fish_history_max_entries 50000
set -g fish_history_ignore duplicates

# Emacs
alias em 'emacsclient -nw -a ""'
function emacs
    /opt/homebrew/bin/emacs --eval '(toggle-frame-maximized)' $argv
end

# 別名
alias lg lazygit
alias godot-gd '/Applications/Godot.app/Contents/MacOS/Godot'
alias godot-cs '/Applications/Godot_mono.app/Contents/MacOS/Godot'
alias unity-hub "open -a 'Unity Hub'"
alias unity-intl "open -a 'Unity Hub International Version'"
alias cry-vm "open -a 'Parallels Desktop'"
alias ue-editor 'ls -d /Users/Shared/Epic\ Games/UE_* | sort -V | tail -1 | xargs -I{} open {}/Engine/Binaries/Mac/UnrealEditor.app'

# 終端標題動態更新
function fish_title
    echo (string replace -r '^'"$HOME" '~' $PWD)
end

# 語法高亮
set -g fish_color_error white

# 其他設置
set -g fish_greeting
