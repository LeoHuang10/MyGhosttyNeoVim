return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("obsidian").setup({
      workspaces = { { name = "personal", path = "~/vaults/personal" } },
      daily_notes = { folder = "daily", date_format = "%Y-%m-%d" },
      -- 禁用 nvim-cmp（LazyVim 默認使用 blink.cmp，系統中無 nvim-cmp 模塊）
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },
      keymaps = {
        ["<leader>od"] = { action = function() return ":ObsidianToday<CR>" end, desc = "打開今日日記" },
        ["<leader>os"] = { action = function() return ":ObsidianSearch<CR>" end, desc = "搜尋筆記" },
        ["<leader>oq"] = { action = function() return ":ObsidianQuickSwitch<CR>" end, desc = "快速切換筆記" },
        ["<leader>ob"] = { action = function() return ":ObsidianBacklinks<CR>" end, desc = "查看反向鏈接" },
        ["<leader>on"] = { action = function() return ":ObsidianNew<CR>" end, desc = "創建新筆記" },
        ["gd"] = { action = function() return ":ObsidianFollowLink<CR>" end, desc = "跟隨鏈接" },
      },
    })
  end,
}
