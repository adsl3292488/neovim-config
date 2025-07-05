return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		build = function()
			local fzf_repo = "https://github.com/junegunn/fzf.git"
			local fzf_path = vim.fn.expand("~/.fzf")
			if not (vim.uv or vim.loop).fs_stat(fzf_path) then
				vim.fn.system({ "git", "clone", "--depth", "1", fzf_repo, fzf_path })
				vim.fn.system({ fzf_path .. "/install" })
			end
		end,
		opts = {
			files = {
				git_icons = false,
				no_ignore = true,
				formatter = "path.filename_first"
			},
		},
		keys = {
			-- Fzf-lua all function
			{ "<leader>ff", "<cmd>FzfLua<CR>",                       mode = "n" },
			-- specific directory to search
			{
				"<leader>p",
				function()
					vim.ui.input({ prompt = "search path", completion ='dir_in_path'}, function(input)
						if input then
							require("fzf-lua").files({ cwd = input })
						end
					end)
				end,
				mode = "n"
			},
			-- find files
			{ "<C-p>",      "<cmd>FzfLua files<CR>",                 mode = "n", silent = true },
			-- find files from buffer
			{ "<C-n>",      "<cmd>FzfLua buffers<CR>",               mode = "n" },
			-- grep string
			{ "<A-f>",      "<cmd>FzfLua grep<CR>",                  mode = "n" },
			-- grep string under cursor
			{ "<C-f>",      "<cmd>FzfLua grep_cword<CR>",            mode = "n" },
			-- grep string in visual mode
			{ "<C-f>",      "<cmd>FzfLua grep_visual<CR>",           mode = "v" },
			-- list workspace symbols
			{ "<A-o>",      "<cmd>FzfLua lsp_workspace_symbols<CR>", mode = "n" },
			-- list documents symbols
			{ "<A-p>",      "<cmd>FzfLua lsp_document_symbols<CR>",  mode = "n" },
			-- lsp references
			{ "<A-j>",      "<cmd>FzfLua lsp_references<CR>",        mode = "n" },
			-- lsp definitions
			{ "<A-h>",      "<cmd>FzfLua lsp_definitions<CR>",       mode = "n" },
			-- lsp declarations
			{ "<A-k>",      "<cmd>FzfLua lsp_declarations<CR>",      mode = "n" },
			-- lsp type definitions
			{ "<A-l>",      "<cmd>FzfLua lsp_typedefs<CR>",          mode = "n" },
			-- lsp diagnostics
			{ "<F8>",       "<cmd>FzfLua diagnostics_workspace<CR>", mode = "n" },
		},

	},
}
