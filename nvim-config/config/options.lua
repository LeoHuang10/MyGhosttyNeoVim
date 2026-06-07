-- Options are automatically loaded before lazy.nvim startup
-- 選項在 lazy.nvim 啟動前自動加載
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- 默認選項參考上方鏈接
-- Add any additional options here
-- 在此添加額外選項

vim.opt.termguicolors = true  -- 真彩色支持

-- ==================== 縮進設置 ====================
-- 操作系統/遊戲開發標準：4 空格

vim.opt.tabstop = 4       -- Tab 顯示寬度
vim.opt.shiftwidth = 4    -- 縮進寬度
vim.opt.expandtab = true  -- Tab 轉空格
vim.opt.autoindent = true -- 自動縮進
vim.opt.smartindent = true-- 智能縮進（C/C++ 語法感知）

-- ==================== 搜索設置 ====================

vim.opt.hlsearch = true   -- 高亮搜索結果
vim.opt.incsearch = true  -- 增量搜索
vim.opt.ignorecase = true -- 忽略大小寫
vim.opt.smartcase = true  -- 有大寫時區分大小寫

-- ==================== 外觀設置 ====================

vim.opt.background = "dark" -- 暗色背景

-- ==================== 性能設置 ====================

vim.opt.updatetime = 50     -- 游標更新間隔（毫秒），調試器需要較低值

-- ==================== 系統設置 ====================

vim.opt.clipboard = "unnamedplus" -- 與系統剪貼板同步

vim.opt.autoread = true -- 文件外部變更時自動重載

-- 備份、交換與撤銷目錄
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup//"
vim.opt.directory = vim.fn.stdpath("state") .. "/swap//"
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo//"

-- 持久撤銷（操作系統/遊戲開發必備：崩潰後可恢復）
vim.opt.undofile = true

-- ==================== 行號設置 ====================

vim.opt.number = true          -- 絕對行號
vim.opt.relativenumber = true  -- 相對行號（快速跳轉）

-- ==================== 大文件優化 ====================
-- 遊戲資源文件可能很大

vim.opt.synmaxcol = 500   -- 語法高亮最大列數

-- ==================== C/C++ 特定設置 ====================

vim.opt.cindent = true    -- C 風格縮進

-- ==================== 鼠標設置 ====================
-- 調試器 UI 需要

vim.opt.mouse = "a" -- 所有模式啟用鼠標

-- ==================== 圖形界面字體 ====================
-- 中文字體（僅 GUI 環境）

if vim.fn.has("gui_running") == 1 then
  vim.opt.guifont = "LXGW WenKai Mono GB:h12"
end

-- AI 補全集成到 blink.cmp
vim.g.ai_cmp = true
