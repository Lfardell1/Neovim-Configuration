-- Function to open a cheatsheet in a floating window

local function open_cheatsheet()
	local buf = vim.api.nvim_create_buf(false, true) -- Create a new, unlisted buffer
	local cheatsheet_path = vim.fn.expand("C:\\Users\\Leon\\appdata\\local\\nvim\\help\\cheatsheet.md")

	-- Read the file content
	local cheatsheet_lines = {}
	for line in io.lines(cheatsheet_path) do
		table.insert(cheatsheet_lines, line)
	end

	-- Set buffer content
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, cheatsheet_lines)

	-- Create floating window
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local opts = {
		relative = 'editor',
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = 'minimal',
		border = 'rounded',
	}
	vim.api.nvim_open_win(buf, true, opts)

	-- Optional: Make it read-only
	vim.api.nvim_buf_set_option(buf, 'modifiable', false)
end
