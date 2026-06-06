-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.termguicolors = true
-- 用戶自定義選項
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.background = "dark"
vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true

-- 備份、交換與撤銷目錄
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup//"
vim.opt.directory = vim.fn.stdpath("state") .. "/swap//"
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo//"

-- 中文字體（僅 GUI 環境）
if vim.fn.has("gui_running") == 1 then
  vim.opt.guifont = "LXGW WenKai Mono GB:h12"
end

-- 讓 AI 補全集成到 blink.cmp
vim.g.ai_cmp = true
