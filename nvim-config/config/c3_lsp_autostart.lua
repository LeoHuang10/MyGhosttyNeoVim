-- 獨立自動啟動 C3 LSP（僅在打開 .c3 文件時生效，不影響其他語言）
local function start_c3_lsp()
  if vim.bo.filetype == "c3" then
    local clients = vim.lsp.get_clients({ bufnr = 0, name = "c3_lsp" })
    if #clients == 0 then
      vim.lsp.start({
        name = "c3_lsp",
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/c3lsp" },
        root_dir = vim.fn.getcwd(),
        filetypes = { "c3" },
      })
    end
  end
end

-- 文件類型變為 c3 時啟動
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c3",
  callback = start_c3_lsp,
})

-- 啟動時若已打開 c3 文件則啟動
vim.api.nvim_create_autocmd("VimEnter", {
  callback = start_c3_lsp,
})
