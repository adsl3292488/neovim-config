return {
	{
		"zbirenbaum/copilot.lua",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		config = true,
		lazy = false,
		opts = {
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-CR>"
				},
				layout = {
					position = "bottom", -- | top | left | right | horizontal | vertical
					ratio = 0.4
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 75,
				keymap = {
					accept = "<C-\\>",
					accept_word = "<C-L>",
					accept_line = "<C-H>",
					next = "<C-K>",
					prev = "<C-J>",
					dismiss = "<C-D>",
				},
			},
			filetypes = {
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = true,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				lua = true,
				["."] = false,
			},
			copilot_node_command = 'node', -- Node.js version must be > 18.x
			server_opts_overrides = {},
		},
		keys = {
			{ "<leader>cc", "<cmd>Copilot panel<CR>", mode = "n" }
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		build = "make tikotken",
		opts = {

		},
		keys = {
			{ "<F4>", "<cmd> CopilotChatToggle<CR>", mode = { "n", "v", "i" } },
		}
	}
}
