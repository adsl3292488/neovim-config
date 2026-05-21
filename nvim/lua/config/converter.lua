local float_win = nil
local float_buf = nil

local function close_float()
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		vim.api.nvim_win_close(float_win, true)
	end
	float_win = nil
	float_buf = nil
end

local function to_binary(n)
	if n == 0 then return "0" end
	local b = ""
	while n > 0 do
		b = (n % 2) .. b
		n = math.floor(n / 2)
	end
	return b
end

local function parse_number(word)
	-- detect 0x... hex
	if word:match("^0x%x+$") or word:match("^0X%x+$") then
		return tonumber(word, 16), "hex"
	end
	-- detect 0b... binary
	if word:match("^0b[01]+$") or word:match("^0B[01]+$") then
		return tonumber(word:sub(3), 2), "bin"
	end
	-- detect pure number decimal
	if word:match("^%d+$") then
		return tonumber(word, 10), "dec"
	end
	return nil, nil
end

local function show_float(num)
	close_float()

	local lines = {
		string.format("  Dec : %d", num),
		string.format("  Hex : 0x%X", num),
		string.format("  Oct : 0%o", num),
		string.format("  Bin : %s", to_binary(num)),
	}

	local width = 0
	for _, line in ipairs(lines) do
		width = math.max(width, #line + 2)
	end
	local height = #lines

	-- get cursor position and window size
	local cursor_row = vim.fn.winline()
	local win_height = vim.api.nvim_win_get_height(0)
	local cursor_col = vim.fn.wincol()
	local win_width = vim.api.nvim_win_get_width(0)

	-- show above cursor if enough space, otherwise show below
	local row, anchor_vertical
	if win_height - cursor_row >= height + 1 then
		row = 1
		anchor_vertical = "NW"
	else
		row = -1
		anchor_vertical = "SW"
	end

	-- show right of cursor if enough space, otherwise show left
	local col, anchor_horizontal
	if win_width - cursor_col >= width + 2 then
		col = 2
		anchor_horizontal = "NW"
	else
		col = -2
		anchor_horizontal = "NE"
	end

	-- anchor is combination of vertical and horizontal
	local anchor = anchor_vertical:sub(1, 1) .. anchor_horizontal:sub(2, 2)

	float_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
	vim.bo[float_buf].filetype = 'converter'

	float_win = vim.api.nvim_open_win(float_buf, false, {
		relative = "cursor",
		width = width,
		height = height,
		col = col,
		row = row,
		anchor = anchor,
		style = "minimal",
		border = "rounded",
		title = "Converter",
		title_pos = "center",
	})

	vim.wo[float_win].winhl = 'Normal:NormalFloat,FloatBorder:FloatBorder'
	vim.wo[float_win].winblend = 50
end

local function check_and_show()
	local word = vim.fn.expand("<cword>")
	local num, _ = parse_number(word)
	if num then
		show_float(num)
	else
		close_float()
	end
end

-- autodetect,the cursor moved to trigger
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	callback = function()
		check_and_show()
	end,
})

-- close itself when leave buffer
vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
	callback = function()
		close_float()
	end,
})
