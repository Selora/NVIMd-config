local keymaps = require('config.keymaps')
local kind_icons = {
  Text = "󰊄",
  Method = "m",
  Function = "󰊕",
  Constructor = "",
  Field = "",
  Variable = "󰫧",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "󰌆",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "󰉺",
}

local M = {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- -- Snippet Engine & its associated nvim-cmp source
    --'L3MON4D3/LuaSnip',
    --'saadparwaiz1/cmp_luasnip',
    -- -- Adds a number of user-friendly snippets
    -- 'rafamadriz/friendly-snippets',

    'dcampos/nvim-snippy',
    'dcampos/cmp-snippy',
    -- Snippets collections
    'honza/vim-snippets',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',

  },
}

-- nvim completion. Add a popup menu and proposes inputs from various sources
-- Snippets are in the `.config/nvim/snippets` directory
M.config = function()
  local cmp = require("cmp")
  cmp.setup({
    snippet = {
      expand = function(args)
        local snippy = require("snippy")
        snippy.expand_snippet(args.body)
      end,
    },
    mapping = keymaps.cmp.get_mapping(),
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        vim_item.menu = ({
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = {
      -- Order presented in nvim-cmp.
      { name = 'nvim_lsp' },
      { name = "snippy" },
      { name = 'nvim_lsp_signature_help' },
      {
        name = 'spell',
        option = {
          keep_all_entries = false,
          enable_in_context = function()
            return true
          end,
        },
      },
      { name = 'buffer' },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    }
  })
end

return M

-- Setup snippy to work with nvim-cmp
-- Done in cmp.setup
-- {
--   'dcampos/cmp-snippy',
--   dependencies = {
--     'dcampos/nvim-snippy',
--   },
--   config = function()
--     require 'cmp'.setup {
--       snippet = {
--         expand = function(args)
--           require 'snippy'.expand_snippet(args.body)
--         end
--       },
--       sources = {
--         { name = 'snippy' }
--       }
--     }
--   end
-- },
-- }
