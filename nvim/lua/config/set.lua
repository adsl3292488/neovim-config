vim.opt.guicursor = ""
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.backspace = "2"
vim.opt.expandtab = false

vim.opt.number = true
vim.opt.relativenumber = true

--vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hidden = true

vim.opt.autochdir = false
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.showmode = false

vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.colorcolumn = "" -- 80
vim.opt.signcolumn = "yes"
vim.opt.completeopt = "menuone,popup,fuzzy"

vim.opt.ruler = true
vim.opt.encoding = "utf-8"
-- Auto re-load file, when file is changed somewhere else
vim.opt.autoread = true
vim.api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	command = "checktime",
})

vim.o.clipboard = "unnamedplus"
-- Add keymap for open lazygit
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { silent = true })
