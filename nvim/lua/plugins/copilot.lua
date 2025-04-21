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
		-- build = "make tikotken",
		opts = {
			prompts = {
				Explain ="Explain what the following code does in simple terms.",
				Optimize = "Optimize the code to balance performance,readability and maintainability.",
				Refactor = "Please refactor the following code to improve its clarity and readability.",
				Review = "Please review the following code and provide suggestions for improvement.",
				BetterNaming = "Please provide better names for the variables and functions in the following code.",
				FixError = "Please expplain the error in the following code and provide a solution.",
				Chinese = "Please reply in Chinese.",
			}

		},
		keys = {
			{ "<F4>",       "<cmd> CopilotChatToggle<CR>",       mode = { "n", "v", "i" }, desc = "Toggle Copilot Chat" },
			{ "<leader>ae", "<cmd> CopilotChatExplain<CR>",      mode = { "n", "v" },      desc = "CopilotChat explain code" },
			{ "<leader>ar", "<cmd> CopilotChatRefactor<CR>",     mode = { "n", "v" },      desc = "CopilotChat refactor code" },
			{ "<leader>ao", "<cmd> CopilotChatOptimize<CR>",     mode = { "n", "v" },      desc = "Copilot Chat optimize code" },
			{ "<leader>an", "<cmd> CopilotChatBetterNaming<CR>", mode = { "n", "v" },      desc = "CopilotChat better naming" },
			{ "<leader>af", "<cmd> CopilotChatFixError<CR>",     mode = { "n", "v" },      desc = "CopilotChat fix error" },
			{ "<leader>at", "<cmd> CopilotChatTests<CR>",        mode = { "n", "v" },      desc = "CopilotChat tests" },
			{ "<leader>as", "<cmd> CopilotChatStop<CR>",         mode = { "n" },           desc = "CopilotChat stop" },
			{ "<leader>al", "<cmd> CopilotChatLoad<CR>",         mode = { "n" },           desc = "CopilotChat load" },
			{ "<leader>ap", "<cmd> CopilotChatSave<CR>",         mode = { "n" },           desc = "CopilotChat save" },
		}
	}
}
