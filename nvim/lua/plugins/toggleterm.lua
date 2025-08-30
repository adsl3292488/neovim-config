return {
	{
		"akinsho/toggleterm.nvim",
		version = '*',
		config = true,
		keys = {
			{ "jk",        [[<C-\><C-n>]],        mode = "t" },
			{ "<C-Left>",  [[<Cmd>wincmd h<CR>]], mode = "t" },
			{ "<C-Down>",  [[<Cmd>wincmd j<CR>]], mode = "t" },
			{ "<C-Up>",    [[<Cmd>wincmd k<CR>]], mode = "t" },
			{ "<C-Right>", [[<Cmd>wincmd l<CR>]], mode = "t" },
			{ "<C-w>",     [[<C-\><C-n><C-w>]],   mode = "t" },
			{
				"<C-t>",
				function()
					local num = vim.v.count
					vim.cmd { cmd = 'ToggleTerm', args = { num, "size=6" } }
				end,
				mode = { 'n', 'v', 'i' }
			},
			{ "<leader>te", function() vim.cmd("TermSelect") end, mode = "n" },
		},
	}
}
