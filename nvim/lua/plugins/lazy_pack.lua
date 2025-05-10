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
	-- 		cmdline ={
	-- 			enabled = true,
	-- 			view = "cmdline_popup",
	-- 		},
	-- 		notify = {
	-- 			enabled = false,
	-- 			view = "notify",
	--
	-- 		},
	-- 		messages = {
	-- 			enabled = false,
	-- 			view = "notify",
	-- 		}
	-- 	},
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 	}
	-- },
}
