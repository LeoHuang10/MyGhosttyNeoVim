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

-- ==================== 編譯與運行 ====================

-- F5：一鍵運行當前文件（Homebrew Clang）
map("n", "<F5>", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  if ft == "c" then
    vim.cmd("!clang " .. file .. " -o /tmp/a.out && /tmp/a.out")
  elseif ft == "cpp" then
    vim.cmd("!clang++ " .. file .. " -o /tmp/a.out && /tmp/a.out")
  elseif ft == "rust" then
    vim.cmd("!cargo run")
  elseif ft == "python" then
    vim.cmd("!python3 " .. file)
  elseif ft == "lua" then
    vim.cmd("!lua " .. file)
  elseif ft == "go" then
    vim.cmd("!go run " .. file)
  elseif ft == "java" then
    vim.cmd("!javac " .. file .. " && java " .. vim.fn.expand("%:r"))
  elseif ft == "sh" then
    vim.cmd("!bash " .. file)
  elseif ft == "zig" then
    vim.cmd("!zig run " .. file)
  elseif ft == "cs" then
    vim.cmd("!dotnet run")
  elseif ft == "swift" then
    vim.cmd("!swift " .. file)
  elseif ft == "lisp" then
    vim.cmd("!sbcl --script " .. file)
  else
    print("未支援的文件類型: " .. ft)
  end
end, { desc = "一鍵運行 (F5)" })

-- F6：僅編譯不運行（Homebrew Clang）
map("n", "<F6>", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  if ft == "c" then
    vim.cmd("!clang " .. file .. " -o /tmp/a.out -Wall -Wextra")
  elseif ft == "cpp" then
    vim.cmd("!clang++ " .. file .. " -o /tmp/a.out -Wall -Wextra -std=c++23")
  elseif ft == "rust" then
    vim.cmd("!cargo build")
  elseif ft == "go" then
    vim.cmd("!go build " .. file)
  elseif ft == "zig" then
    vim.cmd("!zig build")
  elseif ft == "cs" then
    vim.cmd("!dotnet build")
  else
    print("此文件類型無需單獨編譯: " .. ft)
  end
end, { desc = "一鍵編譯 (F6)" })

-- F11：Apple Clang 編譯運行（macOS 商業項目驗證）
map("n", "<F11>", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  if ft == "c" then
    vim.cmd("!/usr/bin/clang " .. file .. " -o /tmp/a.out && /tmp/a.out")
  elseif ft == "cpp" then
    vim.cmd("!/usr/bin/clang++ " .. file .. " -o /tmp/a.out && /tmp/a.out")
  end
end, { desc = "Apple Clang 編譯運行 (F11)" })

-- F12：GCC 編譯運行（Linux 部署驗證）
map("n", "<F12>", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  if ft == "c" then
    vim.cmd("!gcc-16 " .. file .. " -o /tmp/a.out && /tmp/a.out")
  elseif ft == "cpp" then
    vim.cmd("!g++-16 " .. file .. " -o /tmp/a.out && /tmp/a.out")
  end
end, { desc = "GCC 編譯運行 (F12)" })

-- F7：調試繼續
map("n", "<F7>", function()
  require("dap").continue()
end, { desc = "調試繼續 (F7)" })

-- F8：調試單步進入
map("n", "<F8>", function()
  require("dap").step_into()
end, { desc = "調試單步進入 (F8)" })

-- F9：設置/取消斷點
map("n", "<F9>", function()
  require("dap").toggle_breakpoint()
end, { desc = "切換斷點 (F9)" })

-- F10：調試單步跳過
map("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "調試單步跳過 (F10)" })

-- Ctrl+F5：運行 Makefile
map("n", "<C-F5>", function()
  vim.cmd("!make run 2>/dev/null || make")
end, { desc = "執行 Makefile" })

-- <leader>cc：在當前目錄打開終端
map("n", "<leader>cc", function()
  vim.cmd("cd %:p:h | terminal")
end, { desc = "在當前目錄打開終端" })

-- <leader>co：打開下方終端
map("n", "<leader>co", function()
  vim.cmd("belowright split | terminal")
end, { desc = "打開下方終端" })

-- <leader>cr：重複上次外部命令
map("n", "<leader>cr", function()
  vim.cmd("!!")
end, { desc = "重複上次外部命令" })
