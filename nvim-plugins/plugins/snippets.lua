return {
  "L3MON4D3/LuaSnip",                       -- 代碼片段引擎
  dependencies = { "rafamadriz/friendly-snippets" },   -- 常用片段庫
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip").config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })
  end,
}
