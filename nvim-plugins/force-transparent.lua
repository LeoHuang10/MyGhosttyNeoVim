return {
  "xiyaowong/transparent.nvim",
  lazy = false, -- 确保插件在启动时立刻加载
  priority = 2000, -- 用很高的优先级，确保它最后执行，覆盖掉其他插件的背景色设置
  config = function()
    local transparent = require("transparent")

    -- 1. 手动指定所有需要透明的高亮组，彻底覆盖所有UI元素
    transparent.setup({
      extra_groups = {
        -- 基础编辑区
        "Normal",
        "NormalNC",
        "NormalFloat",
        "NormalSB",
        -- 行号、符号列
        "LineNr",
        "LineNrAbove",
        "LineNrBelow",
        "SignColumn",
        "FoldColumn",
        -- 状态栏、标签栏
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        -- 顶部标签 (bufferline)
        "BufferLineTab",
        "BufferLineTabSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        -- 文件树 (neo-tree)
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NeoTreeVertSplit",
        "NeoTreeEndOfBuffer",
        "NeoTreeFloatBorder",
        "NeoTreeFloatTitle",
        -- 搜索 (Telescope)
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopeResultsNormal",
        "TelescopePreviewNormal",
        -- 快捷键提示 (Which-key)
        "WhichKeyFloat",
        "WhichKeyBorder",
        -- 代码补全 (nvim-cmp)
        "Pmenu",
        "PmenuSel",
        "PmenuSbar",
        "PmenuThumb",
        -- 浮动诊断、悬浮文档
        "DiagnosticFloatingInfo",
        "DiagnosticFloatingWarn",
        "DiagnosticFloatingError",
        "FloatBorder",
        "FloatTitle",
        -- LSP 悬浮窗口
        "LspFloatWinNormal",
        "LspFloatWinBorder",
        -- 通知 (noice / nvim-notify)
        "NoiceCmdlinePopup",
        "NoiceCmdlinePopupBorder",
        "NotifyINFOBody",
        "NotifyWARNBody",
        "NotifyERRORBody",
        -- 分隔线和填充
        "VertSplit",
        "EndOfBuffer",
        "Folded",
        -- 状态栏 (lualine) 的各个节段
        "lualine_c_normal",
        "lualine_c_insert",
        "lualine_c_visual",
        "lualine_c_replace",
        "lualine_c_command",
        "lualine_c_inactive",
        "lualine_a_normal",
        "lualine_b_normal",
        -- Snacks 相关窗口
        "SnacksDashboardNormal",
        "SnacksDashboardBorder",
        "SnacksPickerNormal",
        "SnacksPickerBorder",
      },
    })

    -- 2. 这是一记“补刀”：启动后过一小会儿，再用 clear_prefix 批量扫一遍
    -- 确保 clear_prefix 能处理到动态生成或后续加载的高亮组
    vim.defer_fn(function()
      local prefixes = {
        "NeoTree",
        "BufferLine",
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

      -- 最后的“双保险”：手动将最核心的几组高亮再次强制设为透明
      local critical = {
        "Normal",
        "NormalFloat",
        "NvimTreeNormal",
        "NeoTreeNormal",
        "TelescopeNormal",
        "StatusLine",
        "TabLine",
        "Pmenu",
      }
      for _, group in ipairs(critical) do
        vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
      end
    end, 300) -- 300ms 足够覆盖所有插件的初始化
  end,
}
