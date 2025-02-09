-- setup nvim-lint
require('lint').linters_by_ft = {
	cpp = { 'clangtidy' },
	c = { 'clangtidy' },
	sh = { 'shellcheck' },
	make = { 'checkmake' },
	python = { 'flake8' },
	-- lua = { 'luacheck' },
}
require('lint.linters.clangtidy').args = {
    -- '--checks=*',
	-- '-modernize-use-trailing-return-type',
    -- '--warnings-as-errors=*',
}

-- when save the file to auto trigger lint
vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = false,
	severity_sort = true,
})
vim.opt.updatetime = 250
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, severity = {min = vim.diagnostic.severity.INFO, max = vim.diagnostic.severity.ERROR}})]]
vim.api.nvim_command('autocmd BufWritePost <buffer> lua require("lint").try_lint()')

vim.keymap.set('n','<leader>\'',function()
	vim.cmd('lua vim.diagnostic.setloclist()')
end)
