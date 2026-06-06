return {
  "olimorris/codecompanion.nvim",          -- 在編輯器內與 AI 對話、解釋代碼
  dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  opts = {
    strategies = { chat = { adapter = "anthropic" }, inline = { adapter = "anthropic" } },
    adapters = {
      anthropic = function()
        return require("codecompanion.adapters").extend("anthropic", {
          env = { api_key = "cmd:echo $ANTHROPIC_API_KEY" },
        })
      end,
    },
  },
}
