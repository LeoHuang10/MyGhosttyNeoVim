-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- 手動加載 C3 LSP 自動啟動（因為 LazyVim 不會自動加載自定義 config 文件）
require("config.c3_lsp_autostart")
