-- vim.keymap.set('i', '<C-\\>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
-- vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')
-- vim.keymap.set('i', '<C-H>', '<Plug>(copilot-accept-line)')
-- vim.keymap.set('i', '<C-K>', '<Plug>(copilot-next)')
-- vim.keymap.set('i', '<C-J>', '<Plug>(copilot-previous)')
-- vim.keymap.set('i', '<C-S>', '<Plug>(copilot-suggest)')
-- vim.keymap.set('i', '<C-D>', '<Plug>(copilot-dismiss)')

-- vim.keymap.set({'i','n'}, '<leader>cc', vim.cmd.Copilot)
-- vim.g.copilot_no_tab_map = true

require('copilot').setup({
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right | horizontal | vertical
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    debounce = 75,
    keymap = {
      accept = "<C-\\>",
      accept_word = "<C-L>",
      accept_line = "<C-H>",
      next = "<C-K>",
      prev = "<C-J>",
      dismiss = "<C-D>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
	lua = true,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
})

vim.keymap.set({'n','i'}, '<leader>cc', "<cmd>Copilot panel<CR>")
