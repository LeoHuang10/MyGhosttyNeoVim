return {
  {
    "mason-org/mason.nvim",
    opts = {},
    lazy = false,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- 自動安裝的語言服務器清單（移除了 clangd，改用 Homebrew 版本）
      ensure_installed = {
        "rust_analyzer",
        "lua_ls",
        "zls",
        "c3_lsp",
        "gopls",
        "pyright",
        "phpactor",
        "jdtls",
        "kotlin_language_server",
        "hls",
        "ts_ls",
        "omnisharp_mono",
      },
    },
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Rust 由 rustaceanvim 管理，禁止 lspconfig 重複啟動
        rust_analyzer = {
          enabled = false,
        },
        -- C / C++ 語言服務器（使用 Homebrew LLVM 的最新 clangd）
        clangd = {
          cmd = {
            "/opt/homebrew/opt/llvm/bin/clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--pch-storage=memory",
            "--all-scopes-completion",
            "--cross-file-rename",
            -- 注意：不寫 --std，由項目 .clangd 決定
          },
        },
        -- C3 語言服務器
        c3_lsp = {
          cmd = { vim.fn.stdpath("data") .. "/mason/bin/c3lsp" },
          filetypes = { "c3" },
          root_dir = function()
            return vim.fn.getcwd()
          end,
          autostart = true,
        },
        -- Swift 語言服務器
        sourcekit_lsp = {
          filetypes = { "swift" },
          root_dir = function()
            return vim.fn.getcwd()
          end,
        },
        -- Lua 語言服務器（合併原 lsp-settings.lua 的設置）
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = {
                disable = { "unicode-docstring" },
              },
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
        ts_ls = {},
        -- 禁用舊版 tsserver
        tsserver = {
          enabled = false,
        },
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
