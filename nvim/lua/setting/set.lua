vim.opt.guicursor = ""
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.backspace = "2"
--vim.opt.expandtab = true

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

vim.opt.undofile =true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.colorcolumn = "" -- 80
vim.opt.signcolumn = "yes"

vim.opt.ruler = true
vim.opt.encoding = "utf-8"
-- Auto re-load file, when file is changed somewhere else
vim.opt.autoread = true
vim.cmd [[autocmd CursorHold * checktime]]

vim.o.clipboard = "unnamedplus"
