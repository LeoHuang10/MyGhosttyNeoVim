return {
  "mfussenegger/nvim-dap",
  dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text" },
  config = function()
    local dap = require("dap")
    dap.adapters.codelldb = {
      type = "server", port = "${port}",
      executable = { command = "codelldb", args = { "--port", "${port}" } },
    }
    dap.configurations.c = {
      { name = "Launch file", type = "codelldb", request = "launch",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        cwd = "${workspaceFolder}", stopOnEntry = false },
    }
    dap.configurations.rust = dap.configurations.c
    dap.configurations.cpp = dap.configurations.c
    dap.configurations.python = {
      { type = "python", request = "launch", name = "Launch file",
        program = "${file}",
        pythonPath = function() return "/usr/bin/python3" end },
    }
  end,
}
