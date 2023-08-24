return {
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup({
        sources = {
          -- formatting
          null_ls.builtins.formatting.ruff,
          null_ls.builtins.formatting.black,

          -- diagnostics
          null_ls.builtins.diagnostics.ruff,


          -- Pyright
          null_ls.builtins.diagnostics.pylint.with({
            diagnostics_config = {
              underline = false, virtual_text = false, signs = false
            },
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE
          }),

          null_ls.builtins.formatting.black.with({
            extra_args = { "--line-length=120" }
          }),

          null_ls.builtins.formatting.isort,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end
  },
}
