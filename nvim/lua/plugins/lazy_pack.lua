return {
	---- Color Scheme ----
	{ "folke/tokyonight.nvim" },
	-- { 'rose-pine/neovim' },
	-- { 'catppuccin/nvim', },
	-- { 'rebelot/kanagawa.nvim'},

	---- undotree ----
	{
		"mbbill/undotree",
		keys = {
			{ "<F5>", "<cmd>UndotreeToggle<CR>" }
		}
	},

	---- LazyGit ----
	{
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy = false,
		keys = {
			-- Add keymap for open lazygit
			{ "<leader>lg", "<cmd>LazyGit<CR>", mode = "n" }
		}
	},
	-- autopairs ----
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true
	},
}
