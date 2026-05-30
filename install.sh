#!/bin/bash
echo "開始還原開發環境..."

# 1. 還原 Ghostty 配置
mkdir -p ~/.config/ghostty
cp ghostty-config ~/.config/ghostty/config

# 2. 還原 Zsh 配置
cp .zshrc ~/

# 3. 還原 Starship 配置
mkdir -p ~/.config
cp starship.toml ~/.config/

# 4. 還原 Neovim 插件配置
mkdir -p ~/.config/nvim/lua/plugins
cp -r nvim-plugins/* ~/.config/nvim/lua/plugins/

# 5. 還原 Neovim 自動命令（若存在）
if [ -f nvim-autocmds.lua ]; then
    mkdir -p ~/.config/nvim/lua/config
    cp nvim-autocmds.lua ~/.config/nvim/lua/config/autocmds.lua
fi

# 6. 還原 tmux 配置（若存在）
if [ -f .tmux.conf ]; then
    cp .tmux.conf ~/
fi

echo "環境還原完成！"
