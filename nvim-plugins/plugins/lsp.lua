return {
  {
    "mason-org/mason.nvim",
    opts = {},
    lazy = false,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- 自動安裝的語言服務器清單
      ensure_installed = {
        "clangd",
        "rust_analyzer",
        "lua_ls",
        "zls",
        "gopls",
        "pyright",
        "phpactor",
        "jdtls",
      },
    },
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- C / C++ 語言服務器
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--pch-storage=memory",
            "--all-scopes-completion",
            "--cross-file-rename",
          },
        },
        -- C3 語言服務器
        c3_lsp = {
          cmd = { vim.fn.stdpath("data") .. "/mason/bin/c3-lsp" },
          filetypes = { "c3" },
          root_dir = vim.loop.cwd,
        },
        -- Rust 語言服務器
        rust_analyzer = {},
        -- Swift 語言服務器
        sourcekit_lsp = {
          filetypes = { "swift" },
          root_dir = vim.loop.cwd,
        },
        -- Lua 語言服務器
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        -- C# 語言服務器
        omnisharp = {
          cmd = { "omnisharp-mono", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
        },
        -- Zig 語言服務器
        zls = {},
        -- Go 語言服務器
        gopls = {},
        -- Python 語言服務器
        pyright = {},
        -- Node.js / TypeScript 語言服務器
        tsserver = {},
        -- PHP 語言服務器
        phpactor = {},
        -- Java 語言服務器
        jdtls = {},
        -- Kotlin 語言服務器
        kotlin_language_server = {},
        -- Haskell 語言服務器
        hls = {},
      },
    },
    lazy = false,
  },
}
