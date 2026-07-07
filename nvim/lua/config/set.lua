vim.opt.guicursor = ""
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.number = true
vim.opt.relativenumber = true

--vim.opt.wrap = false
vim.opt.swapfile = false

vim.opt.termguicolors = true
vim.opt.showmode = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.colorcolumn = "" -- 80
vim.opt.signcolumn = "yes"

-- Auto re-load file, when file is changed somewhere else
vim.api.nvim_create_autocmd({ "CursorHold", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("AutoReloadFile", { clear = true }),
	callback = function()
		if vim.o.filetype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

vim.o.clipboard = "unnamedplus"
if os.getenv("DISPLAY") then
else
	vim.g.clipboard = "osc52"
end
