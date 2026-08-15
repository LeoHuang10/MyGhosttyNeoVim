return {
  "lewis6991/gitsigns.nvim",               -- 在行號旁顯示 Git 修改狀態
  opts = {
    current_line_blame = true,             -- 顯示當前行提交信息
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      vim.keymap.set("n", "]c", gs.next_hunk, { buffer = bufnr })   -- 下一修改區塊
      vim.keymap.set("n", "[c", gs.prev_hunk, { buffer = bufnr })   -- 上一修改區塊
    end,
  },
}
