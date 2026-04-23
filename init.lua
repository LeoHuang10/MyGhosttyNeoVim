-- Neovim 專業遊戲開發配置

-- ==================== 引導 lazy.nvim（插件管理器） ====================
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

-- ==================== 插件列表 ====================
require("lazy").setup({

	-- ==================== 主題與界面 ====================
	-- 主題（護眼，高對比度）
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	-- 文件樹（瀏覽項目結構）
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = { { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" } },
		opts = {
			view = { width = 30 },
			renderer = { icons = { show = { file = true, folder = true, folder_arrow = true, git = true } } },
		},
	},

	-- 狀態欄（顯示 Git 分支、LSP 狀態等）
	-- 關鍵修正：移除對 catppuccin/nvim 的依賴，直接使用 lualine 內置主題
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = { theme = "catppuccin" },
		},
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
		opts = {
			defaults = {
				file_ignore_patterns = { "node_modules", ".git", "build", "target" },
			},
		},
	},
	-- Telescope 擴展：文件瀏覽器
	{ "nvim-telescope/telescope-file-browser.nvim" },
	-- Telescope 擴展：快速跳轉目錄（依賴系統工具 zoxide）
	{
		"jvgrootveld/telescope-zoxide",
		config = function()
			require("telescope").load_extension("zoxide")
		end,
	},

	-- ==================== 代碼補全與 LSP ====================
	-- 代碼補全引擎（nvim-cmp）
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP 源
			"hrsh7th/cmp-buffer", -- 緩衝區源
			"hrsh7th/cmp-path", -- 路徑源
			"L3MON4D3/LuaSnip", -- 代碼片段引擎
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 400 },
					{ name = "luasnip", priority = 300 },
				}),
			})
		end,
	},

	-- 管理全局和項目本地 LSP 配置（必須在所有 LSP 伺服器啟動前加載）
	{
		"folke/neoconf.nvim",
		priority = 900,
		lazy = false,
		opts = {},
	},

	-- Mason 與 mason-lspconfig（用於安裝與管理 LSP 伺服器）
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"clangd",
				-- "rust_analyzer",  -- 由 rustaceanvim 全權管理，避免衝突
				"lua_ls",
				"omnisharp",
				"jdtls",
				"gopls",
				"vtsls",
				"pyright",
				"solargraph",
				"zls",
				"csharp_ls",
				"clojure_lsp",
				"solidity_ls",
			},
			automatic_installation = true,
		},
	},
	-- Mason 工具安裝器（自動安裝 LSP 以外的工具，如格式化器）
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				"clang-format",
				"prettierd",
				"black",
				"isort",
				"google-java-format",
				"csharpier",
				"swiftformat",
				"rubocop",
				"zls",
				"solhint",
			},
			auto_update = true,
			run_on_start = true,
			start_delay = 3000,
		},
	},

	-- LSP 核心配置（使用 Neovim 0.12 原生 vim.lsp.config API）
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"folke/neoconf.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- C/C++ 語言服務器
			vim.lsp.config.clangd = {
				cmd = { "clangd" },
				filetypes = { "c", "cpp" },
				root_markers = { ".clangd", "compile_commands.json", ".git" },
				capabilities = capabilities,
			}

			-- Lua 語言服務器
			vim.lsp.config.lua_ls = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".luarc.jsonc", ".git", "init.lua", ".nvim.lua" },
				root_dir = function(fname)
					return vim.fs.root(fname, { ".luarc.json", ".luarc.jsonc", ".git" })
						or vim.fn.fnamemodify(fname, ":p:h")
				end,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
					},
				},
				capabilities = capabilities,
			}

			-- Swift 語言服務器（Apple 官方 SourceKit-LSP）
			vim.lsp.config.sourcekit = {
				cmd = { "sourcekit-lsp" },
				filetypes = { "swift" },
				root_markers = { "Package.swift", ".git" },
				capabilities = capabilities,
			}

			-- C# 語言服務器
			vim.lsp.config.omnisharp = {
				cmd = { "omnisharp" },
				filetypes = { "cs" },
				root_markers = { ".sln", ".csproj", ".git" },
				capabilities = capabilities,
			}

			-- Java 語言服務器
			vim.lsp.config.jdtls = {
				cmd = { "jdtls" },
				filetypes = { "java" },
				root_markers = { ".project", ".git" },
				capabilities = capabilities,
			}

			-- Go 語言服務器
			vim.lsp.config.gopls = {
				cmd = { "gopls" },
				filetypes = { "go" },
				root_markers = { "go.mod", ".git" },
				capabilities = capabilities,
			}

			-- TypeScript/JavaScript 語言服務器
			vim.lsp.config.vtsls = {
				cmd = { "vtsls", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_markers = { "package.json", "tsconfig.json", ".git" },
				capabilities = capabilities,
				settings = {
					typescript = {
						preferences = {
							importModuleSpecifier = "relative",
							jsxAttributeCompletionStyle = "braces",
						},
					},
				},
			}

			-- Python 語言服務器
			vim.lsp.config.pyright = {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", ".git" },
				capabilities = capabilities,
			}

			-- Ruby 語言服務器
			vim.lsp.config.solargraph = {
				cmd = { "solargraph", "stdio" },
				filetypes = { "ruby" },
				root_markers = { "Gemfile", ".git" },
				capabilities = capabilities,
			}

			-- Zig 語言服務器
			vim.lsp.config.zls = {
				cmd = { "zls" },
				filetypes = { "zig" },
				root_markers = { "build.zig", ".git" },
				capabilities = capabilities,
			}

			-- Clojure 語言服務器
			vim.lsp.config.clojure_lsp = {
				cmd = { "clojure-lsp" },
				filetypes = { "clojure" },
				root_markers = { "project.clj", "deps.edn", "shadow-cljs.edn", ".git" },
				capabilities = capabilities,
			}

			-- Solidity 語言服務器（區塊鏈）
			vim.lsp.config.solidity_ls = {
				cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
				filetypes = { "solidity" },
				root_dir = function(fname)
					return vim.fs.root(fname, { ".git" }) or vim.fn.fnamemodify(fname, ":p:h")
				end,
				single_file_support = true,
				capabilities = capabilities,
			}

			-- 啟用服務器
			vim.lsp.enable("clangd")
			vim.lsp.enable("sourcekit")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("omnisharp")
			vim.lsp.enable("jdtls")
			vim.lsp.enable("gopls")
			vim.lsp.enable("vtsls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("solargraph")
			vim.lsp.enable("zls")
			vim.lsp.enable("clojure_lsp")
			vim.lsp.enable("solidity_ls")

			-- LSP 通用快捷鍵
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, remap = false }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
				end,
			})
		end,
	},

	-- ==================== 代碼格式化 ====================
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "n",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				c = { "clang_format" },
				cpp = { "clang_format" },
				rust = { "rustfmt" },
				swift = { "swiftformat" },
				lua = { "stylua" },
				python = { "isort", "black" },
				go = { "goimports", "gofmt" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				java = { "google-java-format" },
				cs = { "csharpier" },
				zig = { "zls" },
				ruby = { "rubocop" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				solidity = { "forge" },
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
		},
	},

	-- ==================== 編程語言專用插件 ====================
	-- C 語言
	{
		"p00f/clangd_extensions.nvim",
		opts = {},
	},
	-- C++ 語言
	{
		"bfrg/vim-cpp-modern",
		ft = { "c", "cpp" },
	},
	-- Rust 語言
	{
		"mrcjkb/rustaceanvim",
		version = "^7",
		ft = { "rust" },
		config = function()
			vim.g.rustaceanvim = {
				tools = {
					executor = "termopen",
					reload_workspace_from_cargo_toml = true,
					test_executor = "background",
				},
				server = {
					on_attach = function(_, bufnr)
						vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
						vim.keymap.set("n", "<leader>a", function()
							vim.cmd.RustLsp("codeAction")
						end, { desc = "Rust code action" })
					end,
					default_settings = {
						["rust-analyzer"] = {
							check = { command = "clippy" },
						},
					},
				},
				dap = {
					adapter = require("rustaceanvim.config").get_codelldb_adapter(
						vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
					),
				},
			}
		end,
	},
	-- Swift 語言（基礎語法支持）
	{
		"keith/swift.vim",
		ft = "swift",
	},
	-- Lua 代碼片段與輔助
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- C# 語言
	{
		"iabdelkareem/csharp.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		ft = "cs",
		opts = {
			lsp = {
				omnisharp = {
					enable = true,
					enable_roslyn_analyzers = true,
					enable_import_completion = true,
					analyze_open_documents_only = false,
				},
			},
		},
	},
	-- Unity 引擎 C# 語法高亮與補全
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
		"nvim-java/nvim-java",
		ft = { "java" },
		opts = {
			java_bin = vim.fn.exepath("java"),
			jdk = { auto_install = true },
			notifications = { dap = true },
		},
	},
	-- Go 語言
	{
		"ray-x/go.nvim",
		dependencies = { "ray-x/guihua.lua" },
		opts = {},
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
	-- TypeScript 語言（專用增強插件）
	-- 可展開的型別檢查懸浮視窗
	{
		"nemanjamalesija/ts-expand-hover.nvim",
		ft = { "typescript", "typescriptreact" },
		keys = { { "<leader>th", "<cmd>lua require('ts_expand_hover').hover()<CR>", desc = "TS Expand Hover" } },
		opts = {
			keymaps = { hover = "<leader>th" },
		},
	},
	-- 專案級別型別檢查
	{
		"dmmulroy/tsc.nvim",
		ft = { "typescript", "typescriptreact" },
		cmd = { "TSC" },
		keys = { { "<leader>tc", "<cmd>TSC<CR>", desc = "TS Compile Check" } },
		opts = {
			auto_open_qflist = true,
			auto_start_watch_mode = true,
			enable_progress_notifications = true,
			flags = { noEmit = true },
		},
	},
	-- Common Lisp
	{
		"vlime/vlime",
		ft = { "lisp" },
	},
	-- Clojure 和 Scheme（合併配置）
	{
		"Olical/conjure",
		ft = { "clojure", "scheme" },
		config = function()
			vim.g["conjure#client#scheme#stdio#command"] = "scheme"
		end,
	},
	-- Solidity 語言（區塊鏈）
	{
		"TovarishFin/vim-solidity",
		ft = { "solidity" },
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
	-- Unreal Engine（官方推薦的現代化 UE 開發套件）
	{
		"taku25/unrealdev.nvim",
		ft = { "cpp", "h" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<leader>uf", "<cmd>UnrealDev projectFiles<CR>", desc = "UE Project Files" },
			{ "<leader>us", "<cmd>UnrealDev start<CR>", desc = "UE Project Start" },
			{ "<leader>ub", "<cmd>UnrealDev build<CR>", desc = "UE Build" },
			{ "<leader>uc", "<cmd>UnrealDev createClass<CR>", desc = "UE Create Class" },
			{ "<leader>ul", "<cmd>UnrealDev toggleLog<CR>", desc = "UE Log Viewer" },
		},
		opts = {
			auto_discover = true,
			p4 = false,
		},
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
		opts = {},
	},
	-- Godot
	{
		"habamax/vim-godot",
		ft = { "gd", "gdscript", "godot" },
	},

	-- ==================== 編輯增強與工具 ====================
	-- 自動補全括號與引號
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	-- 自動補全與重命名 HTML/JSX 標籤
	{
		"windwp/nvim-ts-autotag",
		ft = {
			"html",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
			"php",
			"xml",
			"markdown",
		},
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
	},
	-- 代碼註釋
	{
		"numToStr/Comment.nvim",
		keys = { { "gc", mode = { "n", "v" }, desc = "Toggle comment" } },
		opts = {},
	},
	-- 縮進線（v3 遷移修正）
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	-- TODO/FIXME 高亮
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	-- AI 代碼補全（使用 neocodeium 替代原 codeium.nvim，解決補全衝突）
	{
		"monkoose/neocodeium",
		event = "VeryLazy",
		opts = {
			manual = true,
		},
		keys = {
			{
				"<A-f>",
				function()
					require("neocodeium").accept()
				end,
				mode = "i",
				desc = "Accept Codeium suggestion",
			},
			{
				"<A-n>",
				function()
					require("neocodeium").cycle_or_complete()
				end,
				mode = "i",
				desc = "Trigger Codeium completion",
			},
		},
	},
	-- AI 對話與代碼解釋
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"github/copilot.vim",
			"nvim-lua/plenary.nvim",
		},
		build = "make tiktoken",
		cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatExplain", "CopilotChatReview" },
		keys = {
			{ "<leader>aa", "<cmd>CopilotChatToggle<CR>", desc = "Copilot Chat - Toggle" },
			{ "<leader>ae", "<cmd>CopilotChatExplain<CR>", desc = "Copilot Chat - Explain" },
			{ "<leader>ar", "<cmd>CopilotChatReview<CR>", desc = "Copilot Chat - Review" },
		},
		opts = {
			auto_insert_mode = true,
			show_help = true,
		},
	},
	-- AI 自主代理工作空間（提供更強大的 AI 自主代理能力）
	{
		"Flemma-Dev/flemma.nvim",
		cmd = { "Flemma", "FlemmaChat", "FlemmaRun" },
		keys = {
			{ "<leader>fa", "<cmd>Flemma<CR>", desc = "Flemma AI Agent" },
		},
		opts = {},
	},
	-- Git 集成
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},
	-- Git 圖形化操作
	{
		"NeogitOrg/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		cmd = "Neogit",
		keys = { { "<Leader>gg", "<cmd>Neogit<CR>", desc = "Open Neogit" } },
		opts = {},
	},
	-- Git 衝突可視化
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		opts = {},
	},
	-- 調試器
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"Weissle/persistent-breakpoints.nvim",
		},
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				mode = "n",
				desc = "DAP Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				mode = "n",
				desc = "DAP Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				mode = "n",
				desc = "DAP Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				mode = "n",
				desc = "DAP Step Out",
			},
			{
				"<Leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
				mode = "n",
				desc = "Toggle breakpoint",
			},
			{
				"<Leader>dt",
				function()
					require("dap").terminate()
				end,
				mode = "n",
				desc = "Terminate debug",
			},
			{
				"<Leader>du",
				function()
					require("dapui").toggle()
				end,
				mode = "n",
				desc = "Toggle DAP UI",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- C/C++/Rust 使用 CodeLLDB
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
					args = { "--port", "${port}" },
				},
			}

			-- Rust 調試配置
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

			-- Swift 使用原生 LLDB
			if vim.fn.has("mac") == 1 then
				dap.adapters.lldb = {
					type = "executable",
					command = "/usr/bin/lldb",
					name = "lldb",
				}
				dap.configurations.swift = {
					{
						name = "Launch",
						type = "lldb",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/.build/debug/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
					},
				}
			end

			-- JavaScript/TypeScript 使用 js-debug-adapter
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "127.0.0.1",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
						"127.0.0.1",
					},
				},
			}

			-- JavaScript/TypeScript 調試配置
			for _, language in ipairs({ "javascript", "typescript" }) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch File",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end

			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			require("nvim-dap-virtual-text").setup()
		end,
	},

	-- 診斷信息管理
	{
		"folke/trouble.nvim",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (all)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics (buffer)" },
		},
		opts = {},
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
		keys = {
			{ "<F7>", "<cmd>CMakeBuild<CR>", mode = "n", desc = "CMake Build" },
			{ "<F8>", "<cmd>CMakeRun<CR>", mode = "n", desc = "CMake Run" },
		},
		opts = {},
	},
	-- 單元測試集成
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"antoinemadec/FixCursorHold.nvim",
			"mmllr/neotest-swift-testing",
		},
		config = function()
			require("neotest").setup({
				adapters = { require("neotest-swift-testing") },
			})
		end,
	},

	-- 遠程開發（需要預先安裝 distant 0.20.x，插件 branch 必須為 'v0.3'）
	{
		"chipsenkbeil/distant.nvim",
		branch = "v0.3",
		opts = {},
	},
	-- tmux 導航
	{ "christoomey/vim-tmux-navigator" },
	-- 快捷鍵提示
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
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

	-- ==================== 專業遊戲開發補充插件 ====================
	-- 代碼檢查（Linter）框架
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				c = { "clangtidy" },
				cpp = { "clangtidy" },
				rust = { "clippy" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				solidity = { "solhint" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	-- Lua 性能分析器（Snacks.nvim 內置 profiler 模塊）
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			profiler = { enabled = true },
		},
	},

	-- Xcode 專案整合
	{
		"wojciech-kulik/xcodebuild.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>xb", "<cmd>XcodebuildBuild<CR>", desc = "Xcode Build" },
			{ "<leader>xr", "<cmd>XcodebuildRun<CR>", desc = "Xcode Run" },
			{ "<leader>xt", "<cmd>XcodebuildTest<CR>", desc = "Xcode Test" },
		},
		opts = {},
	},

	-- ==================== 操作系統開發補充插件 ====================
	-- ctags 自動生成
	{
		"ludovicchabant/vim-gutentags",
		config = function()
			vim.g.gutentags_enabled = 1
			vim.g.gutentags_project_root = { ".git", "Makefile", "Kbuild", "Kconfig" }
		end,
	},
	-- cscope 源碼導航
	{
		"dhananjaylatkar/cscope_maps.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			disable_maps = false,
			cscope = { picker = "telescope" },
		},
	},
	-- GDB 調試集成
	{
		"sakhnik/nvim-gdb",
		ft = { "c", "cpp" },
		cmd = { "GdbStart", "GdbStartLLDB" },
		keys = {
			{ "<leader>dg", "<cmd>GdbStart<CR>", desc = "Start GDB" },
		},
	},
	-- Git 補丁管理
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gdiff", "Gblame", "Gstatus" },
		keys = {
			{ "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
			{ "<leader>gd", "<cmd>Gdiff<CR>", desc = "Git diff" },
		},
	},
})

-- ==================== 基礎編輯器設置 ====================
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
vim.opt.autoread = true

-- 管理備份、交換與撤銷文件
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup//"
vim.opt.directory = vim.fn.stdpath("state") .. "/swap//"
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo//"

-- 中文顯示為等寬霞鶩文楷 GB（僅在 GUI 環境下設置）
if vim.fn.has("gui_running") == 1 then
	vim.opt.guifont = "LXGW WenKai Mono GB:h12"
end

-- ==================== 快捷鍵映射（全局） ====================
local map = vim.keymap.set

map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("n", "<C-q>", ":q<CR>", { desc = "Quit" })
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Telescope
map("n", "<leader>fb", "<cmd>Telescope file_browser<CR>", { desc = "File browser" })
map("n", "<leader>z", function()
	require("telescope").extensions.zoxide.list()
end, { desc = "Zoxide (smart cd)" })

-- Git
map("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })

-- 常規搜索
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
