-- vim.g.mapleader = " " -- <leader>
vim.keymap.set({"n","i"},"<A-r>",function ()
	vim.lsp.buf.rename()
end)
-- like nerdtree
vim.keymap.set("n","<leader>tt", vim.cmd.Ex)
-- move command in visual mode
vim.keymap.set("v","J", ":move '>+1<CR>gv=gv")
vim.keymap.set("v","K", ":move '<-2<CR>gv=gv")
-- let search stay in the middle
vim.keymap.set("n","n","nzz")
vim.keymap.set("n","m","Nzz")
-- switch window
vim.keymap.set("n","<C-k>", "<C-w>k")
vim.keymap.set("n","<C-j>", "<C-w>j")
vim.keymap.set("n","<C-h>", "<C-w>h")
vim.keymap.set("n","<C-l>", "<C-w>l")
vim.keymap.set("n","<C-Up>", "<C-w>k")
vim.keymap.set("n","<C-Down>", "<C-w>j")
vim.keymap.set("n","<C-Left>", "<C-w>h")
vim.keymap.set("n","<C-Right>", "<C-w>l")
vim.keymap.set("n","<leader>r", "<C-w>p")
vim.keymap.set("n","<leader>e", "<C-w>t")
-- no highlight
vim.keymap.set("n","<leader>/",vim.cmd.noh)
-- other key remap
vim.keymap.set({"n","v"},";",":")
--vim.keymap.set("c","q","q!")
vim.keymap.set("c","qq","qa!")
vim.keymap.set("i",";;","<Esc>$a;") --instead of snippet
vim.keymap.set("i",",,","<Esc>wa,")
-- Change window width and height
vim.keymap.set("n","<S-left>","<C-w><")
vim.keymap.set("n","<S-right>","<C-w>>")
vim.keymap.set("n","<S-Up>","<C-w>+")
vim.keymap.set("n","<S-Down>","<C-w>-")
-- local function ChangeWidth()
--     local win_id = vim.api.nvim_get_current_win()
--     local cur_win = vim.api.nvim_win_get_number(win_id)
--     local win_list = #vim.api.nvim_list_wins()
--
--     if (cur_win < win_list) then
--         vim.keymap.set("n","<S-h>","<C-w><")
--         vim.keymap.set("n","<S-l>","<C-w>>")
--         vim.keymap.set("n","<S-left>","<C-w><")
--         vim.keymap.set("n","<S-right>","<C-w>>")
-- 		vim.keymap.set("n","<S-Up>","<C-w>-")
-- 		vim.keymap.set("n","<S-Down>","<C-w>+")
--     else
--         vim.keymap.set("n","<S-h>","<C-w>>")
--         vim.keymap.set("n","<S-l>","<C-w><")
--         vim.keymap.set("n","<S-left>","<C-w>>")
--         vim.keymap.set("n","<S-right>","<C-w><")
-- 		vim.keymap.set("n","<S-Up>","<C-w>+")
-- 		vim.keymap.set("n","<S-Down>","<C-w>-")
--     end
-- end
-- local autocmd = vim.api.nvim_create_autocmd
-- autocmd('Winenter',{callback=ChangeWidth})

--[[
local function equal_mapping()
    local cword = vim.fn.expand('<cword>')
    local cmp_word ={"\"","\'","]",")","}","\")","\"]","\"}","\')","\']","\'}","()"}
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_buf_get_lines(0,row-1,row,true)
    local ch
         ch = vim.api.nvim_buf_get_text(0,row-1,col,row-1,col+1,{})
    print("row "..row..",col "..col.." ch "..ch[1].." cword "..cword.." line "..line[1])
    for i, word in ipairs(cmp_word) do
        --       print(word,cword)
        if (word == cword) then
            -- print("find test")
            vim.keymap.set("i","=","<Esc>ea =")
            vim.keymap.set("i","="," =")
            -- vim.keymap.set("i","=","<Esc>wa =")
            break
        else
             vim.keymap.set("i","=","=")
        end
    end
end
autocmd({"CursorMoved","CursorMovedI"},{callback = equal_mapping})
]]--
