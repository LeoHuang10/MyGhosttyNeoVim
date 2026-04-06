-- Neovim 專業遊戲開發配置

-- ==================== 1. 引導 lazy.nvim（插件管理器） ====================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==================== 2. 插件列表 ====================
require("lazy").setup({

  -- ==================== 主題與界面 ====================
  -- 主題（護眼，高對比度）
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- 文件樹（瀏覽項目結構）
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" } },
    config = function() require("nvim-tree").setup() end,
  },

  -- 狀態欄（顯示 Git 分支、LSP 狀態等）
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("lualine").setup() end,
  },

  -- ==================== 搜索與導航 ====================
  -- 模糊搜索（文件、內容、Git 狀態等）
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<C-f>", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
    },
    config = function()
      require("telescope").setup({
        defaults = { file_ignore_patterns = { "node_modules", ".git", "build", "target" } },
      })
    end,
  },
  -- Telescope 擴展：文件瀏覽器
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  -- Telescope 擴展：快速跳轉目錄（需安裝 zoxide）
  {
    "jvgrootveld/telescope-zoxide",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },

  -- ==================== 語法高亮與 Treesitter ====================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = function()
      vim.g.loaded_treesitter = true
    end,
    config = function()
      local ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if ok then
        treesitter.setup({
          ensure_installed = {
            "c", "cpp", "rust", "lua", "python", "go", "java", "javascript",
            "typescript", "ruby", "swift", "cmake", "make", "bash", "vim", "vimdoc",
            "glsl", "hlsl", "wgsl", "proto", "zig", "c_sharp", "lisp",
          },
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        })
      else
        vim.notify("Treesitter 尚未準備好，將在後續自動安裝", vim.log.levels.WARN)
      end
    end,
  },

  -- ==================== 代碼補全與 LSP ====================
  -- 代碼補全引擎（nvim-cmp）
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- LSP 源
      "hrsh7th/cmp-buffer",     -- 緩衝區源
      "hrsh7th/cmp-path",       -- 路徑源
      "L3MON4D3/LuaSnip",       -- 代碼片段引擎
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item() else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, { name = "buffer" }, { name = "path" }, { name = "luasnip" },
        }),
      })
    end,
  },

  -- LSP 核心支持
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd", "rust_analyzer", "sourcekit-lsp", "lua_ls", "omnisharp",
          "jdtls", "gopls", "tsserver", "pyright", "solargraph", "zls", "csharp_ls",
        },
        automatic_installation = true,
      })

      -- 新版 API：配置每個語言服務器
      vim.lsp.config.clangd = {
        cmd = { "clangd" },
        filetypes = { "c", "cpp" },
        root_markers = { ".clangd", "compile_commands.json", ".git" },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }
      vim.lsp.config.rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml" },
        settings = {},
      }
      vim.lsp.config.sourcekit_lsp = {
        cmd = { "sourcekit-lsp" },
        filetypes = { "swift" },
        root_markers = { "Package.swift", ".git" },
      }
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".git" },
        settings = { Lua = { runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } } } },
        root_dir = vim.fs.root(0, { ".git", ".luarc.json" }) or vim.fn.getcwd(),
      }
      vim.lsp.config.omnisharp = {
        cmd = { "omnisharp" },
        filetypes = { "cs" },
        root_markers = { ".sln", ".csproj", ".git" },
      }
      vim.lsp.config.jdtls = {
        cmd = { "jdtls" },
        filetypes = { "java" },
        root_markers = { ".project", ".git" },
      }
      vim.lsp.config.gopls = {
        cmd = { "gopls" },
        filetypes = { "go" },
        root_markers = { "go.mod", ".git" },
      }
      vim.lsp.config.tsserver = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "package.json", ".git" },
      }
      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", ".git" },
      }
      vim.lsp.config.solargraph = {
        cmd = { "solargraph", "stdio" },
        filetypes = { "ruby" },
        root_markers = { "Gemfile", ".git" },
      }
      vim.lsp.config.zls = {
        cmd = { "zls" },
        filetypes = { "zig" },
        root_markers = { "build.zig", ".git" },
      }

      -- 啟用服務器
      vim.lsp.enable('clangd')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('sourcekit_lsp')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('omnisharp')
      vim.lsp.enable('jdtls')
      vim.lsp.enable('gopls')
      vim.lsp.enable('tsserver')
      vim.lsp.enable('pyright')
      vim.lsp.enable('solargraph')
      vim.lsp.enable('zls')

      -- LSP 通用快捷鍵
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, remap = false }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
        end,
      })
    end,
  },

  -- ==================== 編程語言專用插件 ====================
  -- C 語言
  {
    "p00f/clangd_extensions.nvim",
    config = function() require("clangd_extensions").setup() end,
  },
  -- C++ 語言
  {
    "bfrg/vim-cpp-modern",
    ft = { "c", "cpp" },
  },
  -- Rust 語言
  {
    "simrat39/rust-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local rt = require("rust-tools")
      rt.setup({
        server = {
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
            vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { desc = "Rust code action" })
          end,
        },
      })
    end,
  },
  -- Swift 語言
  {
    "keith/swift.vim",
    ft = "swift",
  },
  -- Lua 語言
  {
    "folke/neodev.nvim",
    opts = {},
  },
  -- C# 語言
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
  },
  {
    "idbrii/vim-unityengine",
    ft = "csharp",
  },
  -- Zig 語言
  {
    "ziglang/zig.vim",
    ft = "zig",
  },
  -- Java 語言
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- Go 語言
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    config = function() require("go").setup() end,
  },
  -- JavaScript 語言
  {
    "pangloss/vim-javascript",
    ft = { "javascript", "javascriptreact" },
  },
  {
    "maxmellon/vim-jsx-pretty",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  -- Lisp 語言
  {
    "vlime/vlime",
    ft = { "lisp", "cl" },
  },
  -- Python 語言
  {
    "linux-cultist/venv-selector.nvim",
    opts = {},
  },
  {
    "vim-python/python-syntax",
    ft = "python",
    config = function()
      vim.g.python_highlight_all = 1
    end,
  },
  -- Ruby 語言
  {
    "vim-ruby/vim-ruby",
    ft = "ruby",
  },

  -- ==================== 遊戲引擎專用插件 ====================
  -- CryEngine（無專門插件，使用 C++ 插件即可）
  -- Unreal Engine
  {
    "drichardson/vim-unreal",
    ft = { "cpp", "h" },
  },
  -- Bevy
  {
    "lommix/bevy_inspector.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = {
      { "bia", ":BevyInspect<CR>", desc = "List all entities" },
      { "bin", ":BevyInspectNamed<CR>", desc = "List named entities" },
      { "biq", ":BevyInspectQuery<CR>", desc = "Query component" },
    },
    config = function() require("bevy_inspector").setup({}) end,
  },
  -- Godot
  {
    "shiena/godot-neovim",
    cmd = "Godot",
  },
  -- Unity
  {
    "idbrii/vim-unityengine",
    ft = "csharp",
  },

  -- ==================== 編輯增強與工具 ====================
  -- 代碼註釋
  {
    "numToStr/Comment.nvim",
    keys = { { "gc", mode = { "n", "v" }, desc = "Toggle comment" } },
    config = function() require("Comment").setup() end,
  },
  -- 縮進線
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function() require("ibl").setup() end,
  },
  -- TODO/FIXME 高亮
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("todo-comments").setup() end,
  },
  -- 全局搜索替換
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>S", "<cmd>lua require('spectre').open()<CR>", desc = "Spectre" } },
  },
  -- AI 代碼補全
  {
    "Exafunction/codeium.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
    config = function() require("codeium").setup({}) end,
  },
  -- 高性能補全引擎（Blink.cmp）
  {
    "saghen/blink.cmp",
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      keymap = { preset = "default" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },
  -- Git 集成
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("gitsigns").setup() end,
  },
  -- Git 圖形化操作
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = "Neogit",
    keys = { { "<Leader>gg", "<cmd>Neogit<CR>", desc = "Open Neogit" } },
    config = function() require("neogit").setup() end,
  },
  -- Git 衝突可視化
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function() require("git-conflict").setup() end,
  },
  -- 調試器
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue / Start" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "Terminate debug" })

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
          args = { "--port", "${port}" },
        },
      }
      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            local cargo_toml = vim.fn.getcwd() .. "/Cargo.toml"
            local file = io.open(cargo_toml, "r")
            if not file then
              local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
              return vim.fn.getcwd() .. "/target/debug/" .. project_name
            end
            local content = file:read("*a")
            file:close()
            local name = content:match('name%s*=%s*"([^"]+)"') or content:match("name%s*=%s*'([^']+)'")
            if not name then
              name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            end
            return vim.fn.getcwd() .. "/target/debug/" .. name
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.cpp = dap.configurations.rust
      dap.configurations.c = dap.configurations.rust
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
      vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function() require("nvim-dap-virtual-text").setup() end,
  },
  -- 斷點持久化
  {
    "Weissle/persistent-breakpoints.nvim",
    opts = {},
  },

  -- 診斷信息管理
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (all)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics (buffer)" },
    },
    config = function() require("trouble").setup() end,
  },

  -- 任務運行器
  {
    "stevearc/overseer.nvim",
    opts = {},
  },
  -- CMake 增強
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("cmake-tools").setup({}) end,
  },
  -- 單元測試集成
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- 遠程開發
  {
    "chipsenkbeil/distant.nvim",
    config = function()
      require("distant"):setup()
    end,
  },
  -- tmux 導航
  {
    "christoomey/vim-tmux-navigator",
  },
  -- 快捷鍵提示
  {
    "folke/which-key.nvim",
    config = function() require("which-key").setup() end,
  },
  -- LSP 進度提示
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
  -- 美觀通知
  {
    "rcarriga/nvim-notify",
    opts = {},
  },
  -- 管理 LSP 配置
  {
    "folke/neoconf.nvim",
    opts = {},
  },

  -- ==================== 數據庫客戶端 ====================
  {
    "tpope/vim-dadbod",
    lazy = true,
    cmd = "DB",
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    lazy = true,
    cmd = "DBUI",
  },

  -- ==================== 浮動終端 ====================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function() require("toggleterm").setup() end,
  },

  -- ==================== 結對編程 ====================
  {
    "jbyuki/instant.nvim",
    config = function()
      require("instant").setup({
        username = "指揮使",
      })
    end,
  },

})

-- ==================== 3. 基礎編輯器設置 ====================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"

-- 中文顯示為等寬霞鶩文楷 GB（僅在 GUI 環境下設置）
if vim.fn.has("gui_running") == 1 then
  vim.opt.guifont = "LXGW WenKai Mono GB:h12"
end

-- 主題
pcall(vim.cmd.colorscheme, "catppuccin")
if vim.g.colors_name == nil then
  vim.cmd.colorscheme("habamax")
end

-- ==================== 4. 快捷鍵映射（全局） ====================
local map = vim.keymap.set

map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("n", "<C-q>", ":q<CR>", { desc = "Quit" })
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Telescope
map("n", "<leader>fb", "<cmd>Telescope file_browser<CR>", { desc = "File browser" })
map("n", "<leader>z", "<cmd>Telescope zoxide<CR>", { desc = "Zoxide (smart cd)" })

-- Git
map("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })

-- 常規搜索
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

-- Lspsaga
map("n", "<leader>l", "<cmd>Lspsaga outline<CR>", { desc = "Outline" })
map("n", "<leader>r", "<cmd>Lspsaga finder<CR>", { desc = "References" })

-- CMake
map("n", "<F7>", "<cmd>CMakeBuild<CR>", { desc = "CMake Build" })
map("n", "<F8>", "<cmd>CMakeRun<CR>", { desc = "CMake Run" })

-- 調試
map("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "DAP Continue" })
map("n", "<F10>", "<cmd>lua require('dap').step_over()<CR>", { desc = "DAP Step Over" })
map("n", "<F11>", "<cmd>lua require('dap').step_into()<CR>", { desc = "DAP Step Into" })
map("n", "<F12>", "<cmd>lua require('dap').step_out()<CR>", { desc = "DAP Step Out" })
map("n", "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
