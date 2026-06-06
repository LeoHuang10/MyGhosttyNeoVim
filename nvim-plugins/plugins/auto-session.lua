return {
  "rmagatti/auto-session",                 -- 重啟後恢復上次的編輯會話
  config = function()
    require("auto-session").setup({ log_level = "error", auto_session_suppress_dirs = { "~/", "~/Downloads" } })
  end,
}
