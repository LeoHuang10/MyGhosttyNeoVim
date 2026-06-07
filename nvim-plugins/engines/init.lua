return {
  -- ==================== Common LSP Foundation 通用 LSP 基礎 ====================
  -- Mason + nvim-lspconfig: bundled with LazyVim, no need to declare
  -- Mason + nvim-lspconfig：LazyVim 自帶，無需聲明

  -- ==================== Unreal Engine (C++ / Blueprint) ====================
  -- Unreal Engine (C++ / 藍圖)
  -- C++: clangd (install via Mason)
  -- C++：clangd（通過 Mason 安裝）
  -- UE uses C++ LSP, no extra plugin needed for syntax
  -- UE 使用 C++ LSP，無需額外語法插件

  -- ==================== Godot (GDScript) ====================
  -- Godot syntax highlighting (long-term community maintenance)
  -- Godot 語法高亮（社群長期維護）
  { "habamax/vim-godot", ft = "gdscript" },

  -- ==================== Note 註 ====================
  -- C++/C#/Lua LSP are installed via Mason (bundled with LazyVim)
  -- C++/C#/Lua LSP 通過 Mason 安裝（LazyVim 自帶）
  -- Debugger: nvim-dap + nvim-dap-ui are bundled with LazyVim
  -- 調試器：nvim-dap + nvim-dap-ui 為 LazyVim 自帶
}
