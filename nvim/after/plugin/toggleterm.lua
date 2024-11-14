function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
 -- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-Left>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-Down>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-Up>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-Right>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

vim.keymap.set({'n','v','i','t'},'<C-t>',function ()
	local num = vim.v.count
	vim.cmd{cmd='ToggleTerm',args = {num,"size=6"}}
end)
vim.keymap.set('n','<leader>te',function ()
	vim.cmd('TermSelect')
end)

