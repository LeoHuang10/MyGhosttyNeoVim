-- ============================================================================
-- Neovim 专业游戏开发配置（3A级项目）
-- 包含所有历史推荐插件 + 游戏开发专用工具
-- ============================================================================

-- ==================== 1. 引导 lazy.nvim（插件管理器） ====================
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

  -- 主题（护眼，高对比度）
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- 文件树（浏览项目结构）
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" } },
    config = function() require("nvim-tree").setup() end,
  },

  -- 状态栏（显示 Git 分支、LSP 状态等）
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("lualine").setup() end,
  },

  -- 模糊搜索（文件、内容、Git 状态等）
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

  -- 语法高亮增强（Treesitter）
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c", "cpp", "rust", "lua", "python", "go", "java", "javascript",
          "typescript", "ruby", "swift", "cmake", "make", "bash", "vim", "vimdoc",
          -- 游戏引擎相关
          "glsl", "hlsl", "wgsl", "proto",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP 支持（使用新版 vim.lsp.config，无弃用警告）
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",               -- LSP 服务器管理器
      "williamboman/mason-lspconfig.nvim",    -- 自动桥接
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "rust_analyzer", "clangd", "pyright", "gopls", "tsserver", "jdtls",
          -- 游戏开发常用
          "lua_ls", "cmake", "glsl_analyzer",
        },
        automatic_installation = true,
      })

      -- 新版 API：配置每个语言服务器
      vim.lsp.config.rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml" },
        settings = {},
      }
      vim.lsp.config.clangd = {
        cmd = { "clangd" },
        filetypes = { "c", "cpp" },
        root_markers = { ".clangd", "compile_commands.json", ".git" },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".git" },
        settings = { Lua = { runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } } } },
      }
      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", ".git" },
      }
      vim.lsp.config.gopls = {
        cmd = { "gopls" },
        filetypes = { "go" },
        root_markers = { "go.mod", ".git" },
      }

      -- 启用服务器
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('clangd')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('pyright')
      vim.lsp.enable('gopls')

      -- LSP 通用快捷键
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

  -- 代码补全引擎（nvim-cmp）
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- LSP 源
      "hrsh7th/cmp-buffer",     -- 缓冲区源
      "hrsh7th/cmp-path",       -- 路径源
      "L3MON4D3/LuaSnip",       -- 代码片段引擎
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

  -- Git 集成（行状态标记）
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("gitsigns").setup() end,
  },

  -- 调试器（DAP）—— 游戏开发必备
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

      -- 配置 codelldb 适配器（用于 Rust / C++）
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- Rust 调试配置（自动从 Cargo.toml 获取项目名）
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

  -- 调试器 UI 界面
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

  -- 调试时行内显示变量值
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function() require("nvim-dap-virtual-text").setup() end,
  },

  -- Git 图形化操作（类似 magit）
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = "Neogit",
    keys = { { "<Leader>gg", "<cmd>Neogit<CR>", desc = "Open Neogit" } },
    config = function() require("neogit").setup() end,
  },

  -- 代码注释（快速注释/取消注释）
  {
    "numToStr/Comment.nvim",
    keys = { { "gc", mode = { "n", "v" }, desc = "Toggle comment" } },
    config = function() require("Comment").setup() end,
  },

  -- 缩进线（让代码结构更清晰）
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

  -- 全局搜索替换（可视化界面）
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>S", "<cmd>lua require('spectre').open()<CR>", desc = "Spectre" } },
  },

  -- AI 代码补全（免费，类似 Copilot）
  {
    "Exafunction/codeium.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
    config = function() require("codeium").setup({}) end,
  },

  -- 诊断信息管理（错误、警告列表）
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (all)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics (buffer)" },
    },
    config = function() require("trouble").setup() end,
  },

  -- Telescope 扩展：文件浏览器
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },

  -- Telescope 扩展：快速跳转目录（需安装 zoxide）
  {
     "jvgrootveld/telescope-zoxide",
  dependencies = { "nvim-telescope/telescope.nvim"  },
  },

  -- 游戏引擎专用插件（3A 开发利器）
  -- 辅助阅读复杂 C++ 代码
  {
    "mfussenegger/nvim-treehopper",
  },
  -- LSP 增强（代码大纲、引用查找等）
  {
    "glepnir/lspsaga.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("lspsaga").setup() end,
  },
  -- Godot 集成（将 Neovim 作为 Godot 编辑器后端）
  {
    "shiena/godot-neovim",
    cmd = "Godot",
  },
  -- Unity 集成（自动生成 .csproj 等）
  {
    "idbrii/vim-unityengine",
  ft = "csharp",
  },
  -- CMake 增强（大型 C++ 项目必需）
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("cmake-tools").setup({}) end,
  },
  -- 游戏项目构建运行（一键编译、运行）
  {
    "mfussenegger/nvim-dap",
    -- 已在上面配置，此处仅作提醒
  },
})

-- ==================== 3. 基础编辑器设置 ====================
vim.opt.number = true               -- 显示行号
vim.opt.relativenumber = true       -- 相对行号
vim.opt.mouse = "a"                 -- 启用鼠标
vim.opt.tabstop = 4                 -- Tab 宽度
vim.opt.shiftwidth = 4              -- 缩进宽度
vim.opt.expandtab = true            -- 空格代替 Tab
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
vim.opt.clipboard = "unnamedplus"   -- 系统剪贴板

-- 主题（优先使用 catppuccin，否则 habamax）
pcall(vim.cmd.colorscheme, "catppuccin")
if vim.g.colors_name == nil then
  vim.cmd.colorscheme("habamax")
end

-- ==================== 4. 快捷键映射（全局） ====================
local map = vim.keymap.set

map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("n", "<C-q>", ":q<CR>", { desc = "Quit" })
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Telescope 扩展
map("n", "<leader>fb", "<cmd>Telescope file_browser<CR>", { desc = "File browser" })
map("n", "<leader>z", "<cmd>Telescope zoxide<CR>", { desc = "Zoxide (smart cd)" })

-- Git
map("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })

-- 常规搜索
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

-- Lspsaga 相关（代码大纲、引用查找）
map("n", "<leader>l", "<cmd>Lspsaga outline<CR>", { desc = "Outline" })
map("n", "<leader>r", "<cmd>Lspsaga finder<CR>", { desc = "References" })

-- CMake 工具（需安装 cmake-tools）
map("n", "<F7>", "<cmd>CMakeBuild<CR>", { desc = "CMake Build" })
map("n", "<F8>", "<cmd>CMakeRun<CR>", { desc = "CMake Run" })




