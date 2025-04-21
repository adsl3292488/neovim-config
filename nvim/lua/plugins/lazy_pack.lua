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
	---- autopairs ----
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true
	},
	---- ui for cmdline ----
	-- {
	-- 	"folke/noice.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		presets = {
	-- 			bottom_search = false, -- use a classic bottom cmdline for search
	-- 			command_palette = false, -- position the cmdline and popupmenu together
	-- 			long_message_to_split = false, -- long messages will be sent to a split
	-- 			inc_rename = false, -- enables an input dialog for inc-rename.nvim
	-- 		},
	-- 		notify = {
	-- 			enabled = false,
	-- 			view = "notify",
	--
	-- 		},
	-- 		messages = {
	-- 			enabled = true,
	-- 			view = "cmdline",
	-- 		}
	-- 	},
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 	}
	-- },
}
