return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>a", function()
				require("harpoon"):list():add()
			end },
			{ "<C-e>", function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end },
		}

			--vim.keymap.set("n","<C-h>",function() harpoon:list():select(1) end)
			--vim.keymap.set("n","<C-t>",function() harpoon:list():select(2) end)
			--vim.keymap.set("n","<C-n>",function() harpoon:list():select(3) end)
			--vim.keymap.set("n","<C-s>",function() harpoon:list():select(4) end)
	}
}
