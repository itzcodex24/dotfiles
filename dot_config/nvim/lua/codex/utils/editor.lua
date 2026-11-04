local M = {}

local short_lang = {
	typescriptreact = "tsx",
	javascriptreact = "jsx",
	typescript = "ts",
	javascript = "js",
}

local function copy(text)
	vim.fn.setreg("+", text)
end

---Copy the current file's absolute path with `#L<line>`
function M.copy_path()
	local path = vim.fn.expand("%:p")
	if path == "" then
		return vim.notify("Buffer has no file", vim.log.levels.WARN)
	end
	local text = ("%s#L%d"):format(path, vim.api.nvim_win_get_cursor(0)[1])
	copy(text)
	vim.notify(text, vim.log.levels.INFO, { title = "Copied path" })
end

---Copy the visual selection as a Markdown code block with filename and line attributes
function M.copy_code_block()
	local mode = vim.fn.mode()
	local start_pos, end_pos = vim.fn.getpos("v"), vim.fn.getpos(".")
	local lines = vim.fn.getregion(start_pos, end_pos, { type = mode })
	local first_line = math.min(start_pos[2], end_pos[2])
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)

	local ft = vim.bo.filetype
	local lang = short_lang[ft] or ft
	local text = ('```%s filename="%s" line=%d\n%s\n```'):format(
		lang,
		vim.fn.expand("%:."),
		first_line,
		table.concat(lines, "\n")
	)
	copy(text)
	vim.notify(("%d lines from %s"):format(#lines, vim.fn.expand("%:.")), vim.log.levels.INFO, {
		title = "Copied code block",
	})
end

---Open the project's package.json in a centered 80% float; `q` or `Esc` closes it
function M.open_package_json()
	local root = vim.fs.root(0, "package.json") or vim.fs.root(vim.fn.getcwd(), "package.json")
	if not root then
		return vim.notify("No package.json found", vim.log.levels.WARN)
	end
	local path = vim.fs.joinpath(root, "package.json")
	local buf = vim.fn.bufadd(path)
	vim.fn.bufload(buf)
	vim.bo[buf].buflisted = true

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		title = " " .. vim.fn.fnamemodify(path, ":~:.") .. " ",
		title_pos = "center",
	})

	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, false)
		end
	end
	for _, key in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", key, close, { buffer = buf, desc = "Close package.json" })
	end
	-- The buffer is the real file: drop the close keys once the float is gone
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win),
		once = true,
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) then
				for _, key in ipairs({ "q", "<Esc>" }) do
					pcall(vim.keymap.del, "n", key, { buffer = buf })
				end
			end
		end,
	})
end

return M
