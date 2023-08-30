local keymaps = require('config.keymaps')

return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',

    -- [[ Configure Treesitter ]]
    -- See `:help nvim-treesitter`
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'hcl', 'terraform' },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = keymaps.treesitter.incremental_selection,
          --   asdf = {
          --   init_selection = '<c-space>',
          --   node_incremental = '<c-space>',
          --   scope_incremental = '<c-s>',
          --   node_decremental = '<M-space>',
          -- },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = keymaps.treesitter.textobjects,
            -- asdf = {
            --   -- You can use the capture groups defined in textobjects.scm
            --   ['aa'] = '@parameter.outer',
            --   ['ia'] = '@parameter.inner',
            --   ['af'] = '@function.outer',
            --   ['if'] = '@function.inner',
            --   ['ac'] = '@class.outer',
            --   ['ic'] = '@class.inner',
            -- },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = keymaps.treesitter.move.goto_next_start,
            goto_next_end = keymaps.treesitter.move.goto_next_end,
            goto_previous_start = keymaps.treesitter.move.goto_previous_start,
            goto_previous_end = keymaps.treesitter.move.goto_previous_end,
          },
          swap = {
            enable = true,
            swap_next = keymaps.treesitter.swap.swap_next,
            swap_previous = keymaps.treesitter.swap.swap_previous,
          },
        },
      }
    end
  },
}
