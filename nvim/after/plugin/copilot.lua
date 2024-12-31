vim.keymap.set('i', '<C-\\>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<C-H>', '<Plug>(copilot-accept-line)')
vim.keymap.set('i', '<C-K>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-J>', '<Plug>(copilot-previous)')
vim.keymap.set('i', '<C-S>', '<Plug>(copilot-suggest)')
vim.keymap.set('i', '<C-D>', '<Plug>(copilot-dismiss)')

vim.keymap.set({'i','n'}, '<leader>cc', vim.cmd.Copilot)
vim.g.copilot_no_tab_map = true
