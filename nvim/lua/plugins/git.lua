return {
	{
		'tpope/vim-fugitive',
		dependencies = { "lewis6991/gitsigns.nvim" },
		lazy = false,
		keys = {
			{ "<leader>gg", "<cmd>Git<cr>", desc = "Fugitive" },
		}
	},
	{
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy = false,
		keys = {
			-- Add keymap for open lazygit
			{ "<leader>lg", "<cmd>LazyGitCurrentFile<CR>", mode = "n" }
		}
	},
}
