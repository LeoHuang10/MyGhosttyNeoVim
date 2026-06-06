return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui", -- 漂亮的調試界面
    "theHamsta/nvim-dap-virtual-text", -- 在代碼行內顯示變量值
  },
  config = function()
    local dap = require("dap")
    -- 配置 C/C++/Rust 調試器（使用 CodeLLDB）
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      },
    }
    dap.configurations.c = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
    dap.configurations.rust = dap.configurations.c -- Rust 也使用相同配置
  end,
}
