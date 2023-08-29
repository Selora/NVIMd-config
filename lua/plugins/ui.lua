return {
  --------------------------
  -- Colorschemes
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },

  -- Lualine is the satus bar at the bottom
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- bufferline is the opened file tabs at the top
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        -- :help bufferline-hover-events
        hover = {
          enabled = true,
          delay = 25,
          reveal = { 'close' }
        },
        {
        highlights = {
     fill = {
      fg = { attribute = "fg", highlight = "TabLine" },
       bg = { attribute = "bg", highlight = "TabLine" },
     }, link, just will postfix here:
        }
      },
    },
    config = function(_, opts)
      vim.opt.mousemoveevent = true
      vim.opt.termguicolors = true

      require("bufferline").setup(opts)
    end
  },
}
