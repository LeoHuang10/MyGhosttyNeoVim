return {
  "Civitasv/cmake-tools.nvim",             -- CMake 整合，方便構建、執行與調試
  config = function() require("cmake-tools").setup({}) end,
}
