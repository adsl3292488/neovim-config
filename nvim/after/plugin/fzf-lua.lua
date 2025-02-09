-- Fzf-lua all function
vim.keymap.set("n", "<leader>ff", vim.cmd.FzfLua)
-- specific directory to search
vim.keymap.set("n", "<leader>p", function()
	local path = vim.fn.input("search > ", "", "file")
	require 'fzf-lua'.files({ cwd = path })
	-- vim.fn.chdir(path)
end)
-- find files
vim.keymap.set("n", "<C-p>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
-- find files from buffer
vim.keymap.set("n", "<C-n>", "<cmd>lua require('fzf-lua').buffers()<CR>")
-- grep string
vim.keymap.set("n", "<A-f>", "<cmd>lua require('fzf-lua').grep()<CR>")
-- grep string under cursor
vim.keymap.set("n", "<C-f>", "<cmd>lua require('fzf-lua').grep_cword()<CR>")
-- grep string in visual mode
vim.keymap.set("v", "<C-f>", "<cmd>lua require('fzf-lua').grep_visual()<CR>")
-- list workspace symbols
vim.keymap.set("n", "<A-o>", "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>")
-- list documents symbols
vim.keymap.set("n", "<A-p>", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>")
-- lsp references
vim.keymap.set("n", "<A-j>", "<cmd>lua require('fzf-lua').lsp_references()<CR>")
-- lsp definitions
vim.keymap.set("n", "<A-h>", "<cmd>lua require('fzf-lua').lsp_definitions()<CR>")
-- lsp declarations
vim.keymap.set("n", "<A-k>", "<cmd>lua require('fzf-lua').lsp_declarations()<CR>")
-- lsp type definitions
vim.keymap.set("n", "<A-l>", "<cmd>lua require('fzf-lua').lsp_typedefs()<CR>")
vim.keymap.set("n", "<F8>", "<cmd>lua require('fzf-lua').diagnostics_workspace()<CR>")
require 'fzf-lua'.setup {
	files = {
		git_icons = false,
	}
}
