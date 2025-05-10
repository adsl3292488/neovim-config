return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		notifier = {
			enabled = false,
			timeout = 3000,
		},
		picker = {
			enabled = true,
			formatters = {
				file = {
					-- filename_first = true,
				}
			}
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		styles = {
			notification = {
				-- wo = { wrap = true } -- Wrap notifications
			}
		},
	},
	keys = {
		{ "<F2>",       function() Snacks.picker.explorer() end,                                desc = "Open Explorer" },
		{ "<C-A-p>",    function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
		{ "<C-A-f>",    function() Snacks.picker.grep() end,                                    desc = "Grep" },
		{ "<A-n>",      function() Snacks.picker.projects() end,                                desc = "Find Projects" },
		{ "<leader>gb", function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
		{ "<leader>rt", function() Snacks.picker.recent() end,                                  desc = "Open Recent Files" },
		{ "<leader>sf", function() Snacks.picker.pickers() end,                                 desc = "List All Commands" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
	}
}
