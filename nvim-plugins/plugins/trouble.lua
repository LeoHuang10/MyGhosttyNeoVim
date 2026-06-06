return {
  "folke/trouble.nvim",                    -- 集中顯示 LSP 診斷信息
  opts = {},
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "診斷列表" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "當前文件診斷" },
  },
}
