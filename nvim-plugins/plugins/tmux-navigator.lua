return {
  "christoomey/vim-tmux-navigator",   -- 與 tmux 共用快捷鍵
  lazy = false,
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },   -- 左移面板
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },   -- 下移面板
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },     -- 上移面板
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },  -- 右移面板
  },
}
