vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = false,
  update_in_insert = false,
  float = { border = "rounded" },
  severity_sort = false,
})

vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
