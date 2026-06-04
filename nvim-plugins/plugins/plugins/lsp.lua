return {
  -- 管理語言服務器、格式化工具、調試器
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- C/C++ 核心
        "clangd",
        "codelldb", -- 調試器
        -- Rust
        "rust-analyzer",
        -- Lua（Neovim 本身與遊戲引擎）
        "lua-language-server",
        -- C#（Unity）
        "omnisharp",
        -- Python, TypeScript（工具鏈）
        "pyright",
        "typescript-language-server",
      },
    },
  },
  -- 自動將語言服務器與對應文件類型關聯
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
  },
  -- 語言服務器的基礎配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {},
        rust_analyzer = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        omnisharp = {},
      },
    },
  },
}
