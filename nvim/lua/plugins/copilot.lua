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
		opts = function()
			local profile_cache_path = vim.fn.stdpath("cache") .. "/copilot_profile.json"

			local function load_last_profile()
				local file = io.open(profile_cache_path, "r")
				if file then
					local content = file:read("*a")
					file:close()
					local ok, data = pcall(vim.fn.json_decode, content)
					if ok and data and data.profile then
						return data.profile
					end
				end
				return nil
			end

			local function save_profile(profile)
				local file = io.open(profile_cache_path, 'w')
				if file then
					file:write(vim.fn.json_encode({ profile = profile }))
					file:close()
				end
			end

			vim.api.nvim_create_user_command("CopilotProfileReset", function()
				os.remove(profile_cache_path)
				vim.notify("Copilot profile reset!", vim.log.levels.INFO)
			end, {})

			local prompt_profiles = require("config.copilot_prompt")

			vim.api.nvim_create_user_command("CopilotPrompts", function(opts)
				local profile = opts.args
				if prompt_profiles[profile] then
					require("CopilotChat").setup({ prompts = prompt_profiles[profile] })
					save_profile(profile)
					vim.notify("Switched to profile '" .. profile .. "'!", vim.log.levels.INFO)
				else
					vim.notify("Profile '" .. profile .. "' not found!", vim.log.levels.ERROR)
				end
			end, {
				nargs = 1,
				complete = function()
					return vim.tbl_keys(prompt_profiles)
				end
			})

			local last_profile = load_last_profile()
			if last_profile and prompt_profiles[last_profile] then
				return {
					prompts = prompt_profiles[last_profile]
				}
			else
				return {
					prompts = prompt_profiles.technical
				}
			end
		end,
		keys = {
			{ "<F4>",       "<cmd> CopilotChatToggle<CR>",       mode = { "n", "v", "i" }, desc = "Toggle Copilot Chat" },
			{ "<leader>ae", "<cmd> CopilotChatExplain<CR>",      mode = { "n", "v" },      desc = "CopilotChat explain code" },
			{ "<leader>ar", "<cmd> CopilotChatRefactor<CR>",     mode = { "n", "v" },      desc = "CopilotChat refactor code" },
			{ "<leader>av", "<cmd> CopilotChatReview<CR>",       mode = { "n", "v" },      desc = "CopilotChat review code" },
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
