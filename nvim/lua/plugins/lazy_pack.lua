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
	{
		"michaelb/sniprun",
		branch = "master",
		build = "bash install.sh 1",
		opts = {
			selected_interpreters = { "Rust_original" },
			repl_enable = {},
			repl_disable = {},
			interpreter_options = {
				C_original = {
					compiler = "gcc"
				}
			},
			display = {
				-- "Classic",
				"Terminal",
			},
			display_options = {
				terminal_scrollback = vim.o.scrollback, -- change terminal display scrollback lines
				terminal_line_number = false, -- whether show line number in terminal window
				terminal_signcolumn = false, -- whether show signcolumn in terminal window
				terminal_position = "vertical", --# or "horizontal", to open as horizontal split instead of vertical split
				terminal_width = 45,        --# change the terminal display option width (if vertical)
				terminal_height = 20,       --# change the terminal display option height (if horizontal)
			},
		},
		keys = {
			{ "<leader>rr", "<cmd>SnipRun<CR>",                       mode = "n", silent = true },
			{ "<leader>rr", ":'<,'>SnipRun<CR>",                      mode = "v", silent = true },
			{ "<F9>",       "<cmd>lua require'sniprun'.run('n')<CR>", mode = "n", silent = true },
		}
	}
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
