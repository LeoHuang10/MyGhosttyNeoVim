local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, -- 複製 lazy.nvim 失敗
      { out, "WarningMsg" },
      { "\nPress any key to exit..." }, -- 按任意鍵退出
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    -- 添加 LazyVim 並導入其插件
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    -- 導入或覆蓋你的自定義插件
    { import = "plugins" },
    -- programming languages
    -- 編程語言
    { import = "plugins.languages" },
    -- game engine plugins
    -- 遊戲引擎插件
    { import = "plugins.engines" },
    -- system development plugins
    -- 系統開發插件
    { import = "plugins.systems" },
    -- shader plugins
    -- 着色器插件
    { import = "plugins.shaders" },
    -- build tool plugins
    -- 構建工具插件
    { import = "plugins.cmake" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- 默認情況下，僅 LazyVim 插件會延遲加載，你的自定義插件將在啟動時加載
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    -- 如果你清楚自己在做什麼，可以將此設置為 true，使所有自定義插件默認延遲加載
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- 建議暫時保持 version=false，因為很多支持版本控制的插件
    -- have outdated releases, which may break your Neovim install.
    -- 其發佈版本可能過時，可能導致 Neovim 安裝出現問題
    version = false, -- always use the latest git commit 始終使用最新的 git 提交
    -- version = "*", -- try installing the latest stable version for plugins that support semver
    -- 嘗試為支持語義版本控制的插件安裝最新的穩定版本
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically 定期檢查插件更新
    notify = false, -- notify on update 更新時不發送通知
  }, -- automatically check for plugin updates 自動檢查插件更新
  performance = {
    rtp = {
      -- disable some rtp plugins 禁用部分 rtp 插件
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
