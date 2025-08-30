return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			-- 基本鍵位設置
			local dap = require("dap")
			vim.keymap.set('n', '<F5>', dap.continue)
			vim.keymap.set('n', '<F10>', dap.step_over)
			vim.keymap.set('n', '<F11>', dap.step_into)
			vim.keymap.set('n', '<F12>', dap.step_out)
			vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint)
			vim.keymap.set('n', '<Leader>B', function()
				dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
			end)
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio"
		},
		config = function()
			local dapui = require("dapui")
			dapui.setup()
			require("dap").listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			require("dap").listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			require("dap").listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
		opts = {
			ensure_installed = { "python", "cppdbg", "node2" },
			automatic_installation = true,
		},
	}
}
