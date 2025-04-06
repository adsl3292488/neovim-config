return {
	{
		'mfussenegger/nvim-lint',
		lazy = true,
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
		event = { 'BufWritePost' },
		config = function()
			vim.diagnostic.config({
				-- virtual_text = false,
				virtual_lines = {
					current_line = true,
					severity_sort = true,
					severity = {
						min = vim.diagnostic.severity.INFO,
						max = vim.diagnostic.severity.ERROR,
					},
				},
				update_in_insert = false,
				severity_sort = true,
			})
			vim.opt.updatetime = 250
			-- vim.api.nvim_create_autocmd("CursorHold", {
			-- 	pattern = "*",
			-- 	callback = function()
			-- 		vim.diagnostic.open_float(nil, {
			-- 			focusable = true,
			-- 			severity = {
			-- 				min = vim.diagnostic.severity.INFO,
			-- 				max = vim.diagnostic.severity.ERROR,
			-- 			},
			-- 			border = 'rounded',
			-- 		})
			-- 	end,
			-- })
			vim.api.nvim_create_autocmd("BufWritePost", {
				buffer = 0,
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
		keys = {
			{ '<leader>\'', function() vim.diagnostic.setloclist() end, mode = 'n' }
		}
	}
}
