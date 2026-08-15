local map = vim.keymap.set

map("n", "<C-s>", ":w<CR>", { desc = "保存文件" })
map("n", "<leader>q", ":q<CR>", { desc = "退出" })
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", { desc = "切換文件樹" })
map("n", "<leader>fb", "<cmd>Telescope file_browser<CR>", { desc = "文件瀏覽器" })
map("n", "<leader>z", function()
  require("telescope").extensions.zoxide.list()
end, { desc = "智能目錄跳轉" })
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git 狀態" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git 追溯" })

map("n", "<F5>", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  if ft == "c" then vim.cmd("!gcc " .. file .. " -o /tmp/a.out -std=c23 && /tmp/a.out")
  elseif ft == "cpp" then vim.cmd("!g++ " .. file .. " -o /tmp/a.out -std=c++23 && /tmp/a.out")
  elseif ft == "rust" then vim.cmd("!cargo run")
  elseif ft == "python" then vim.cmd("!python3 " .. file)
  elseif ft == "lua" then vim.cmd("!lua " .. file)
  elseif ft == "go" then vim.cmd("!go run " .. file)
  elseif ft == "java" then vim.cmd("!javac " .. file .. " && java " .. vim.fn.expand("%:r"))
  elseif ft == "sh" then vim.cmd("!bash " .. file)
  elseif ft == "zig" then vim.cmd("!zig run " .. file)
  elseif ft == "cs" then vim.cmd("!dotnet run")
  elseif ft == "swift" then vim.cmd("!swift " .. file)
  elseif ft == "c3" then vim.cmd("!c3c run " .. file)
  elseif ft == "lisp" then vim.cmd("!sbcl --script " .. file)
  else print("未支援的文件類型: " .. ft) end
end, { desc = "一鍵運行 (F5)" })

map("n", "<F6>", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  if ft == "c" then vim.cmd("!gcc " .. file .. " -o /tmp/a.out -Wall -Wextra -std=c23")
  elseif ft == "cpp" then vim.cmd("!g++ " .. file .. " -o /tmp/a.out -Wall -Wextra -std=c++23")
  elseif ft == "rust" then vim.cmd("!cargo build")
  elseif ft == "go" then vim.cmd("!go build " .. file)
  elseif ft == "zig" then vim.cmd("!zig build")
  elseif ft == "cs" then vim.cmd("!dotnet build")
  elseif ft == "c3" then vim.cmd("!c3c build " .. file)
  else print("此文件類型無需單獨編譯: " .. ft) end
end, { desc = "一鍵編譯 (F6)" })

map("n", "<F7>", function() require("dap").continue() end, { desc = "調試繼續 (F7)" })
map("n", "<F8>", function() require("dap").step_into() end, { desc = "調試單步進入 (F8)" })
map("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "切換斷點 (F9)" })
map("n", "<F10>", function() require("dap").step_over() end, { desc = "調試單步跳過 (F10)" })
map("n", "<C-F5>", function() vim.cmd("!make run 2>/dev/null || make") end, { desc = "執行 Makefile" })
map("n", "<leader>cc", function() vim.cmd("cd %:p:h | terminal") end, { desc = "在當前目錄打開終端" })
map("n", "<leader>co", function() vim.cmd("belowright split | terminal") end, { desc = "打開下方終端" })
map("n", "<leader>cr", function() vim.cmd("!!") end, { desc = "重複上次外部命令" })

-- 智能 Tab：使用 blink.cmp 的 is_visible() 判斷補全菜單是否可見
local blink = require('blink.cmp')

vim.keymap.set('i', '<Tab>', function()
  if blink.is_visible() then
    return '<C-n>'
  elseif vim.snippet and vim.snippet.active() then
    return vim.snippet.jump()
  else
    return '<Tab>'
  end
end, { expr = true })

vim.keymap.set('i', '<S-Tab>', function()
  if blink.is_visible() then
    return '<C-p>'
  elseif vim.snippet and vim.snippet.active() then
    return vim.snippet.jump(-1)
  else
    return '<S-Tab>'
  end
end, { expr = true })

vim.keymap.set('i', '<CR>', function()
  if blink.is_visible() then
    return '<C-y>'
  else
    return '<CR>'
  end
end, { expr = true })

vim.keymap.set('i', '<C-e>', function()
  if blink.is_visible() then
    return '<C-e>'
  else
    return '<C-e>'
  end
end, { expr = true })
