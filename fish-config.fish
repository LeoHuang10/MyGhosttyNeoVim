# ===== 基本設定 =====
set -gx LANG en_US.UTF-8
set -gx CLICOLOR 1
set -gx LSCOLORS ExGxBxDxCxEgEdxbxgxcxd

# ===== PATH 設定 =====
# 將 Homebrew LLVM 放在最前，優先使用新編譯器
# 再添加 Cargo 二進制目錄，然後保留原有 PATH
set -gx PATH /opt/homebrew/opt/llvm/bin $HOME/.cargo/bin $PATH

# ghcup 環境（使用 bass 安全加載 bash 腳本）
if test -f $HOME/.ghcup/env
    bass source $HOME/.ghcup/env
end

# ===== Starship 提示符 =====
starship init fish | source

# ===== fzf 模糊搜尋 =====
# 使用 fzf 綁定 Ctrl+R 搜索歷史，Ctrl+T 搜索文件
if type -q fzf
    fzf --fish | source
end

# ===== zoxide 智能目錄跳轉 =====
if type -q zoxide
    zoxide init fish | source
end

# ===== direnv 自動加載項目環境變量 =====
if type -q direnv
    direnv hook fish | source
end

# ===== thefuck 命令糾錯 =====
if type -q thefuck
    thefuck --alias | source
end

# ===== 歷史記錄優化 =====
set -g fish_history_max_entries 50000
set -g fish_history_ignore duplicates

# ===== 別名 =====
alias lg='lazygit'
alias godot-gd="/Applications/Godot.app/Contents/MacOS/Godot"
alias godot-cs="/Applications/Godot_mono.app/Contents/MacOS/Godot"
alias unity-hub="open -a 'Unity Hub'"
alias unity-intl="open -a 'Unity Hub International Version'"
alias cry-vm="open -a 'Parallels Desktop'"
alias ue-editor='ls -d /Users/Shared/Epic\ Games/UE_* | sort -V | tail -1 | xargs -I{} open {}/Engine/Binaries/Mac/UnrealEditor.app'

# ===== 終端標題動態更新 =====
function fish_title
    echo (string replace -r '^'"$HOME" '~' $PWD)
end

# ===== 語法高亮（fish 原生支持，無需額外插件） =====
set -g fish_color_error white

# ===== 其他設定 =====
set -g fish_greeting
