#!/bin/bash
brew bundle --file=Brewfile
stow zsh tmux ghostty nvim starship lazygit
nvim --headless "+Lazy! sync" +qa
