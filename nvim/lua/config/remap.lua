-- vim.g.mapleader = " " -- <leader>
vim.keymap.set({ "n", "i" }, "<A-r>", function()
	vim.lsp.buf.rename()
end)
-- like nerdtree
-- vim.keymap.set("n", "<F2>", function()
-- 	vim.cmd("30Lex")
-- end)
-- vim.keymap.set("n", "<leader>tt", vim.cmd.Ex)
-- move command in visual mode
vim.keymap.set("v", "J", ":move '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":move '<-2<CR>gv=gv")
-- let search stay in the middle
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "m", "Nzz")
-- switch window
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-Up>", "<C-w>k")
vim.keymap.set("n", "<C-Down>", "<C-w>j")
vim.keymap.set("n", "<C-Left>", "<C-w>h")
vim.keymap.set("n", "<C-Right>", "<C-w>l")
vim.keymap.set("n", "<leader>r", "<C-w>p")
vim.keymap.set("n", "<leader>e", "<C-w>t")
-- no highlight
vim.keymap.set("n", "<leader>/", vim.cmd.noh)
-- other key remap
vim.keymap.set({ "n", "v" }, ";", ":")
--vim.keymap.set("c","q","q!")
vim.keymap.set("c", "qq", "qa!")
-- vim.keymap.set("i", ";;", "<Esc>$a;") --instead of snippet
-- vim.keymap.set("i", ",,", "<Esc>wa,")
-- Change window width and height
vim.keymap.set("n", "<S-left>", "<C-w><")
vim.keymap.set("n", "<S-right>", "<C-w>>")
vim.keymap.set("n", "<S-Up>", "<C-w>+")
vim.keymap.set("n", "<S-Down>", "<C-w>-")
