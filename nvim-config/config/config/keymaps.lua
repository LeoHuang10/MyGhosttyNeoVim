-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- 用戶自定義快捷鍵
local map = vim.keymap.set

-- 保存文件
map("n", "<C-s>", ":w<CR>", { desc = "保存文件" })
-- 退出
map("n", "<leader>q", ":q<CR>", { desc = "退出" })
-- 文件樹切換（備用）
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", { desc = "切換文件樹" })
-- Telescope 文件瀏覽器
map("n", "<leader>fb", "<cmd>Telescope file_browser<CR>", { desc = "文件瀏覽器" })
-- 智能目錄跳轉 (zoxide)
map("n", "<leader>z", function()
  require("telescope").extensions.zoxide.list()
end, { desc = "智能目錄跳轉" })
-- Git 狀態
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git 狀態" })
-- Git 追溯
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git 追溯" })
