return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_build_directory = "build",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
      cmake_build_options = {},
      cmake_runner = { name = "terminal" },
    },
  },
}
