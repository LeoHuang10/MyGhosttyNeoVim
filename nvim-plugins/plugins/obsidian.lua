return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("obsidian").setup({
      workspaces = { { name = "personal", path = "~/vaults/personal" } },   -- 設置 Obsidian 庫路徑
      keymaps = {
        -- 用 <leader>od 打開今日日記
        ["<leader>od"] = { action = ":ObsidianToday", desc = "打開今日日記" },
        -- 用 <leader>os 搜索筆記
        ["<leader>os"] = { action = ":ObsidianSearch", desc = "搜索筆記" },
      },
    })
  end,
}
