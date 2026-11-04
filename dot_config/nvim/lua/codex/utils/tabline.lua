local M = {}

local PAD = "   "
local SEP_LEFT = "\xee\x82\xba" -- U+E0BA lower-right triangle: left edge slants outward going down
local SEP_RIGHT = "\xee\x82\xb8" -- U+E0B8 lower-left triangle: right edge slants outward going down
local MAX_LEN = 20
local CUT_LEN = 17

local function set_highlights()
	local ok, palettes = pcall(require, "catppuccin.palettes")
	if not ok then
		return
	end
	local c = palettes.get_palette("mocha")
	vim.api.nvim_set_hl(0, "CodexTabActive", { fg = c.crust, bg = c.yellow, bold = true })
	vim.api.nvim_set_hl(0, "CodexTabActiveSep", { fg = c.yellow, bg = "NONE" })
	vim.api.nvim_set_hl(0, "CodexTabInactive", { fg = c.subtext0, bg = c.surface0 })
	vim.api.nvim_set_hl(0, "CodexTabInactiveSep", { fg = c.surface0, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
end

local function truncate(name)
	if vim.fn.strchars(name) > MAX_LEN then
		return vim.fn.strcharpart(name, 0, CUT_LEN) .. "…"
	end
	return name
end

local function listed_buffers()
	return vim.tbl_filter(function(buf)
		return vim.bo[buf].buflisted
	end, vim.api.nvim_list_bufs())
end

local function label(buf)
	local name = vim.api.nvim_buf_get_name(buf)

	if vim.bo[buf].buftype == "terminal" then
		return "[Terminal]"
	end
	if name == "" then
		return "[No Name]"
	end

	local parts = {}
	if vim.bo[buf].filetype == "oil" then
		-- oil:// URLs are POSIX-style (oil:///C/Users/... on Windows); ask oil for the OS path
		local ok_oil, oil = pcall(require, "oil")
		local os_dir = ok_oil and oil.get_current_dir(buf) or name:gsub("^oil://", "")
		local dir = vim.fn.fnamemodify((os_dir:gsub("[/\\]$", "")), ":~")
		if vim.fn.strchars(dir) > MAX_LEN then
			dir = "…" .. vim.fn.strcharpart(dir, vim.fn.strchars(dir) - CUT_LEN)
		end
		if vim.bo[buf].modified then
			table.insert(parts, "[+]")
		end
		table.insert(parts, dir)
		return table.concat(parts, " ")
	end
	if vim.bo[buf].modified then
		table.insert(parts, "[+]")
	end
	local ok, icons = pcall(require, "mini.icons")
	if ok then
		table.insert(parts, (icons.get("file", name)))
	end
	table.insert(parts, truncate(vim.fn.fnamemodify(name, ":t")))
	return table.concat(parts, " ")
end

function M.render()
	local current = vim.api.nvim_get_current_buf()
	local out = {}
	for _, buf in ipairs(listed_buffers()) do
		local hl = buf == current and "CodexTabActive" or "CodexTabInactive"
		local text = label(buf):gsub("%%", "%%%%")
		table.insert(
			out,
			("%%#%sSep#%s%%#%s#%s%s%s%%#%sSep#%s"):format(hl, SEP_LEFT, hl, PAD, text, PAD, hl, SEP_RIGHT)
		)
	end
	return table.concat(out) .. "%#TabLineFill#"
end

-- Show the bufferline only when 2 or more buffers are listed
local function update_visibility()
	vim.o.showtabline = #listed_buffers() >= 2 and 2 or 0
end

function M.setup()
	set_highlights()
	local group = vim.api.nvim_create_augroup("codex_tabline", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_highlights })
	vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufWipeout", "BufEnter", "VimEnter" }, {
		group = group,
		callback = function()
			-- Deleted buffers are still listed while the event runs
			vim.schedule(update_visibility)
		end,
	})
	vim.api.nvim_create_autocmd("OptionSet", {
		group = group,
		pattern = "buflisted",
		callback = function()
			vim.schedule(update_visibility)
		end,
	})
	update_visibility()
	vim.o.tabline = "%!v:lua.Codex.tabline.render()"
end

return M
