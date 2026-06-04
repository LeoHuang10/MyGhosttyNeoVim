return {
  "xiyaowong/transparent.nvim",
  lazy = false, -- 確保插件在啟動時立刻加載
  priority = 2000, -- 高優先級，保證最後執行，覆蓋其他插件的背景色
  config = function()
    local transparent = require("transparent")

    -- 手動指定所有需要透明化的高亮組，徹底覆蓋所有 UI 元素
    transparent.setup({
      extra_groups = {
        -- 基礎編輯區
        "Normal",
        "NormalNC",
        "NormalFloat",
        "NormalSB",
        -- 行號、符號列
        "LineNr",
        "LineNrAbove",
        "LineNrBelow",
        "SignColumn",
        "FoldColumn",
        -- 狀態欄、標籤欄（通用）
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        -- 頂部標籤 (bufferline)
        "BufferLineTab",
        "BufferLineTabSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        -- 文件樹 (neo-tree)
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NeoTreeEndOfBuffer",
        "NeoTreeFloatBorder",
        "NeoTreeFloatTitle",
        "NeoTreeVertSplit",
        -- 模糊搜索 (fzf-lua)
        "FzfLuaNormal",
        "FzfLuaBorder",
        "FzfLuaTitle",
        "FzfLuaPreviewNormal",
        "FzfLuaPreviewBorder",
        "FzfLuaPromptNormal",
        "FzfLuaPromptBorder",
        "FzfLuaResultsNormal",
        "FzfLuaResultsBorder",
        -- 模糊搜索 (Telescope) —— 如果你用 Telescope 則保留
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopeResultsNormal",
        "TelescopePreviewNormal",
        "TelescopePreviewBorder",
        -- 快捷鍵提示 (Which-key)
        "WhichKeyFloat",
        "WhichKeyBorder",
        -- 代碼補全 (nvim-cmp)
        "Pmenu",
        "PmenuSel",
        "PmenuSbar",
        "PmenuThumb",
        -- 懸浮診斷、懸浮文檔
        "DiagnosticFloatingInfo",
        "DiagnosticFloatingWarn",
        "DiagnosticFloatingError",
        "FloatBorder",
        "FloatTitle",
        -- LSP 懸浮窗口
        "LspFloatWinNormal",
        "LspFloatWinBorder",
        -- 通知 (noice / nvim-notify)
        "NoiceCmdlinePopup",
        "NoiceCmdlinePopupBorder",
        "NotifyINFOBody",
        "NotifyWARNBody",
        "NotifyERRORBody",
        -- 分隔線和填充
        "VertSplit",
        "EndOfBuffer",
        "Folded",
        -- 插件管理器 (lazy.nvim)
        "LazyNormal",
        -- Snacks 相關窗口
        "SnacksDashboardNormal",
        "SnacksDashboardBorder",
        "SnacksPickerNormal",
        "SnacksPickerBorder",

        -- ===== 以下為徹底解決狀態欄所有模式底色的關鍵補充 =====
        -- lualine 全部段落（a, b, c, x, y, z） × 所有模式
        -- 普通模式
        "lualine_a_normal",
        "lualine_b_normal",
        "lualine_c_normal",
        "lualine_x_normal",
        "lualine_y_normal",
        "lualine_z_normal",
        -- 插入模式
        "lualine_a_insert",
        "lualine_b_insert",
        "lualine_c_insert",
        "lualine_x_insert",
        "lualine_y_insert",
        "lualine_z_insert",
        -- 可视模式
        "lualine_a_visual",
        "lualine_b_visual",
        "lualine_c_visual",
        "lualine_x_visual",
        "lualine_y_visual",
        "lualine_z_visual",
        -- 替换模式
        "lualine_a_replace",
        "lualine_b_replace",
        "lualine_c_replace",
        "lualine_x_replace",
        "lualine_y_replace",
        "lualine_z_replace",
        -- 命令模式
        "lualine_a_command",
        "lualine_b_command",
        "lualine_c_command",
        "lualine_x_command",
        "lualine_y_command",
        "lualine_z_command",
        -- 非活跃窗口
        "lualine_a_inactive",
        "lualine_b_inactive",
        "lualine_c_inactive",
        "lualine_x_inactive",
        "lualine_y_inactive",
        "lualine_z_inactive",
        -- 终端模式
        "lualine_a_terminal",
        "lualine_b_terminal",
        "lualine_c_terminal",
        "lualine_x_terminal",
        "lualine_y_terminal",
        "lualine_z_terminal",
      },
    })

    -- 使用 VimEnter 事件確保所有插件加載完畢後再進行補充清除
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        local prefixes = {
          "NeoTree",
          "BufferLine",
          "FzfLua",
          "Telescope",
          "WhichKey",
          "Noice",
          "Notify",
          "Dressing",
          "LspInfo",
          "NvimTree",
          "Snacks",
          "lualine",
        }
        for _, prefix in ipairs(prefixes) do
          pcall(transparent.clear_prefix, prefix)
        end

        -- 雙保險：手動將最核心的高亮組再次強制設為透明
        local critical = {
          "Normal",
          "NormalFloat",
          "FzfLuaNormal",
          "TelescopeNormal",
          "LazyNormal",
          "NeoTreeNormal",
          "WhichKeyFloat",
          "Pmenu",
          "StatusLine",
          "TabLine",
        }
        for _, group in ipairs(critical) do
          vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
        end
      end,
    })

    -- 額外保障：每次更換主題後，再次將關鍵高亮組強制透明
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        local persistent_groups = {
          "Normal",
          "NormalFloat",
          "FzfLuaNormal",
          "TelescopeNormal",
          "LazyNormal",
          "NeoTreeNormal",
          "WhichKeyFloat",
          "Pmenu",
          "StatusLine",
          "TabLine",
        }
        for _, group in ipairs(persistent_groups) do
          pcall(vim.api.nvim_set_hl, 0, group, { bg = "none", ctermbg = "none" })
        end
      end,
    })
  end,
}
