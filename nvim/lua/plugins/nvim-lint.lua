return {
	{
		'mfussenegger/nvim-lint',
		opts = {
			linters_by_ft = {
				cpp = { 'clangtidy' },
				c = { 'clangtidy' },
				sh = { 'shellcheck' },
				make = { 'checkmake' },
				python = { 'flake8' },
				-- lua = { 'luacheck' },
			},
			linters = {
				clangtidy = {
					args = {
						-- '--checks=*',
						-- '-modernize-use-trailing-return-type',
						-- '--warnings-as-errors=*',
					}
				}
			}
		},
		config = function()
			vim.diagnostic.config({
				virtual_text = false,
				update_in_insert = false,
				severity_sort = true,
			})
			vim.opt.updatetime = 250
			vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, severity = {min = vim.diagnostic.severity.INFO, max = vim.diagnostic.severity.ERROR}})]]
			vim.cmd [[autocmd BufWritePost <buffer> lua require("lint").try_lint()]]
		end,
		keys = {
			{ '<leader>\'', function() vim.diagnostic.setloclist() end, mode = 'n' }
		}
	}
}
