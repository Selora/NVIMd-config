--require('neodev').setup()
-- Keymaps for better default experience See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- vim.keymap.set("i", "jk", "<esc>") -- Fast escape

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Close file, but not window
vim.keymap.set('n', '<leader><C-w>', "<cmd>bp | sp | bn | bd<CR>")

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- Better window navigation
-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Navigate windows to the left" })
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Navigate windows down" })
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Navigate windows up" })
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Navigate windows to the right" })

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize -2<CR>")

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>")
vim.keymap.set("n", "<S-h>", ":bprevious<CR>")

-- Indent, then stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")


-- PLUGINS
local plugin_keymaps = { wk = {} }

-- local wk = require('which-key')
vim.keymap.set('n', '<leader>ts', vim.diagnostic.open_float, { desc = "Show diagnostics under cursor" })
vim.keymap.set('n', '<leader>tp', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>tn', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>tt', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

plugin_keymaps.wk.get_diagnostics = function()
  return { {
    t = {
      name = "Diagnostics",
    },
  }, { prefix = "<leader>" } }
end

-- Telescope
vim.keymap.set('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<CR>',
  { desc = 'Fuzzy-Search files' })
vim.keymap.set('n', '<leader>fl', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>',
  { desc = 'Fuzzy-Search current buffer' })
vim.keymap.set('n', '<leader>fL', '<cmd>lua require("telescope.builtin").live_grep({grep_open_files=true})<CR>',
  { desc = 'Fuzzy-Search all buffers' })
vim.keymap.set('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<CR>',
  { desc = 'Fuzzy-Search buffer names' })
vim.keymap.set('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<CR>',
  { desc = 'Fuzzy-Search vim help' })
vim.keymap.set('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<CR>',
  { desc = 'Fuzzy-Search workspace' })

plugin_keymaps.wk.get_telescope = function()
  return { {
    f = {
      name = "Find with Telescope",
    },
  }, { prefix = "<leader>" } }
end

-- CMP
plugin_keymaps.cmp = {
  get_mapping = function()
    local cmp = require("cmp")
    local snippy = require("snippy")

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local check_backspace = function()
      local col = vim.fn.col "." - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
    end
    local mapping = {
      ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ["<C-e>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      -- !TODO Doesn't work as expected, fix
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif snippy.can_expand() then
          snippy.expand_snippet()
        elseif snippy.can_jump(1) then
          snippy.jump(1)
        elseif has_words_before() then
          cmp.complete()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif snippy.is_active() then
          snippy.previous()
        else
          fallback()
        end
      end, { "i", "s" }),
    }
    return mapping
  end
}

-- Treesitter
plugin_keymaps.treesitter = {
  incremental_selection = {
    init_selection = '<c-space>',
    node_incremental = '<c-space>',
    scope_incremental = '<c-s>',
    node_decremental = '<M-space>',
  },
  textobjects = {
    -- You can use the capture groups defined in textobjects.scm
    ['aa'] = '@parameter.outer',
    ['ia'] = '@parameter.inner',
    ['af'] = '@function.outer',
    ['if'] = '@function.inner',
    ['ac'] = '@class.outer',
    ['ic'] = '@class.inner',
  },
  move = {
    goto_next_start = {
      [']m'] = '@function.outer',
      [']]'] = '@class.outer',
    },
    goto_next_end = {
      [']M'] = '@function.outer',
      [']['] = '@class.outer',
    },
    goto_previous_start = {
      ['[m'] = '@function.outer',
      ['[['] = '@class.outer',
    },
    goto_previous_end = {
      ['[M'] = '@function.outer',
      ['[]'] = '@class.outer',
    },
  },
  swap = {
    swap_next = {
      ['<leader>a'] = '@parameter.inner',
    },
    swap_previous = {
      ['<leader>A'] = '@parameter.inner',
    },
  },
}

-- LSPConfig
plugin_keymaps.lspconfig = {
  on_attach_pyright = function(_, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, bufopts)
  end,
  on_attach = function(_, bufnr)
    --  This function gets run when an LSP connects to a particular buffer.
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end,
}

-- NeoTree
vim.keymap.set('n', '<leader>e', '<cmd>NeoTreeRevealToggle<CR>', { desc = 'Toggle NeoTree file explorer' })
plugin_keymaps.neotree = {
  window = {
    mappings = {
      ["e"] = {
        "toggle_node",
        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
      },
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["<esc>"] = "revert_preview",
      ["P"] = { "toggle_preview", config = { use_float = true } },
      ["l"] = "focus_preview",
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      -- ["S"] = "split_with_window_picker",
      -- ["s"] = "vsplit_with_window_picker",
      ["t"] = "open_tabnew",
      -- ["<cr>"] = "open_drop",
      -- ["t"] = "open_tab_drop",
      ["w"] = "open_with_window_picker",
      --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
      ["C"] = "close_node",
      -- ['C'] = 'close_all_subnodes',
      ["z"] = "close_all_nodes",
      ["Z"] = "expand_all_nodes",
      ["a"] = {
        "add",
        -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
        config = {
          show_path = "none" -- "none", "relative", "absolute"
        }
      },
      ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
      -- ["c"] = {
      --  "copy",
      --  config = {
      --    show_path = "none" -- "none", "relative", "absolute"
      --  }
      --}
      ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
      ["q"] = "close_window",
      ["R"] = "refresh",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
    },
  },
  filesystem = {
    window = {
      mappings = {
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
        -- ["D"] = "fuzzy_sorter_directory",
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
      },
      fuzzy_finder_mappings = {
        ["<down>"] = "move_cursor_down",
        ["<C-n>"] = "move_cursor_down",
        ["<up>"] = "move_cursor_up",
        ["<C-p>"] = "move_cursor_up",
      },
    },
  },
  buffers = {
    window = {
      mappings = {
        ["bd"] = "buffer_delete",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
      }
    }
  },
  git_status = {
    window = {
      mappings = {
        ["A"]  = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
    },
  },
}

-- vim-sleuth
plugin_keymaps.vim_sleuth = {
  get_on_attach = function()
    local on_attach = function(bufnr)
      local gitsigns = require('gitsigns')
      vim.keymap.set('n', '<leader>gp', gitsigns.prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
      vim.keymap.set('n', '<leader>gn', gitsigns.next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
      vim.keymap.set('n', '<leader>ph', gitsigns.preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
    end
    return on_attach
  end
}

-- DEBUG
-- local dap = require "dap"
plugin_keymaps.dap = {
  set_dap_keybindings = function()
    local dap = require('dap')

    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    local dapui = require "dapui"
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
  end
}

-- Harpoon
-- TODO

-- ChatGPT
plugin_keymaps.wk.get_chatgpt = function()
  return {
    {
      c = {
        name = "ChatGPT",
        c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
        e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
        g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
        t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
        k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
        d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
        a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
        o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
        s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
        f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
        x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
        r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
        l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
      },
    },
    { prefix = "<leader>" }
  }
end
--
local keymaps = plugin_keymaps
return keymaps
