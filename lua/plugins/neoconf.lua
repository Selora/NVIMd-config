return {
  "folke/neoconf.nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = { "folke/neoconf.nvim" },
    config = function(_, opts)
      require("neoconf").setup()
      require("lspconfig").terraformls.setup({
        filetypes = { "terraform" },
      })
    end,
  },
}
