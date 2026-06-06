return {
  "stevearc/overseer.nvim",                -- 在編輯器內執行 make、cargo 等構建任務
  config = function() require("overseer").setup() end,
}
