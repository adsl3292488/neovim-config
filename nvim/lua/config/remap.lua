-- vim.g.mapleader = " " -- <leader>
vim.keymap.set({ "n", "i" }, "<A-r>", function()
	vim.lsp.buf.rename()
end)
-- move command in visual mode
vim.keymap.set("v", "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv")
vim.keymap.set("v", "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv")
-- let search stay in the middle
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "m", "Nzz")
-- switch window
vim.keymap.set({ "n", "v" }, "<C-Up>", "<C-w>k")
vim.keymap.set({ "n", "v" }, "<C-Down>", "<C-w>j")
vim.keymap.set({ "n", "v" }, "<C-Left>", "<C-w>h")
vim.keymap.set({ "n", "v" }, "<C-Right>", "<C-w>l")
vim.keymap.set({ "n", "v" }, "<leader>re", "<C-w>b")
vim.keymap.set({ "n", "v" }, "<leader>er", "<C-w>t")
vim.keymap.set({ "n", "v" }, "<leader>b", "<C-w>p")
-- no highlight
vim.keymap.set("n", "<leader>/", vim.cmd.noh)
-- other key remap
vim.keymap.set({ "n", "v" }, ";", ":")
--vim.keymap.set("c","q","q!")
vim.keymap.set("c", "qq", "qa!")
-- vim.keymap.set("i", ";;", "<Esc>$a;") --instead of snippet
-- vim.keymap.set("i", ",,", "<Esc>wa,")
-- Change window width and height
vim.keymap.set("n", "<S-left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<S-right>", "<cmd>vertical resize +2<CR>")
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>")
