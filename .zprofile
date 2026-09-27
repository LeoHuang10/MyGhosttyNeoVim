
# Setting PATH for Python 3.12
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
export PATH


# Added by Toolbox App
export PATH="$PATH:/Users/huangshaoshuai/Library/Application Support/JetBrains/Toolbox/scripts"

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/Applications/MacVim.app/Contents/bin:$PATH"

# 確保 rustup 管理的工具優先於 Homebrew
path=($HOME/.cargo/bin $path)
