-- Command line
require("tiny-cmdline").setup({
	position = {
		x = "50%",
		y = "20%",
	},
	-- Keep blink.cmp's cmdline menu attached to the floating cmdline
	on_reposition = function(...)
		return require("tiny-cmdline").adapters.blink(...)
	end,
})

-- Colorscheme
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
})
vim.cmd.colorscheme("catppuccin")

-- Icons
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- Tabline
Codex.tabline.setup()

-- Statusline
local root_markers = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

local function project_root()
	return vim.fs.root(0, root_markers)
end

local function root_name()
	local root = project_root()
	if not root or vim.fs.normalize(root) == vim.fs.normalize(vim.fn.getcwd()) then
		return ""
	end
	return vim.fs.basename(root)
end

local function pretty_path()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		return ""
	end
	local root = project_root() or vim.fn.getcwd()
	local rel = vim.fs.relpath(root, path) or vim.fn.fnamemodify(path, ":~")
	local parts = vim.split(rel, "[/\\]")
	if #parts > 3 then
		rel = "…/" .. table.concat({ parts[#parts - 2], parts[#parts - 1], parts[#parts] }, "/")
	end
	if vim.bo.modified then
		rel = rel .. " [+]"
	end
	return rel
end

local function recording()
	local reg = vim.fn.reg_recording()
	return reg == "" and "" or ("recording @" .. reg)
end

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		refresh = {
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
				"RecordingEnter",
				"RecordingLeave",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			{ root_name },
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ pretty_path },
		},
		lualine_x = {
			{ recording },
			{ "diagnostics" },
			{ "diff" },
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- Window labels
require("incline").setup({
	hide = {
		cursorline = true,
	},
	render = function(props)
		local name = vim.api.nvim_buf_get_name(props.buf)
		local filename = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":t")
		local icon, icon_hl = MiniIcons.get("file", filename)
		return {
			{ icon, group = icon_hl },
			" ",
			filename,
			vim.bo[props.buf].modified and " [+]" or "",
		}
	end,
})

-- Snacks
-- Lazygit `e`: quit lazygit, focus the window `;g` was pressed in, open the file there.
-- POSIX sh syntax, since lazygit runs it with $SHELL. Outside Neovim it just runs nvim.
-- On Windows lazygit runs it with cmd.exe; this config is only used from inside Neovim, so $NVIM is set.
local function lazygit_edit(extra)
	if Codex.is_win then
		return table.concat({
			'nvim --server "%NVIM%" --remote-send "q"',
			'&& nvim --server "%NVIM%" --remote-send "<C-\\><C-n><Cmd>lua pcall(vim.api.nvim_set_current_win, vim.g.codex_lazygit_win)<CR>"',
			'&& nvim --server "%NVIM%" --remote {{filename}}',
			extra and extra:gsub("%$NVIM", "%%NVIM%%") or "",
		}, " ")
	end
	return table.concat({
		'if [ -z "$NVIM" ]; then nvim -- {{filename}}; else',
		'nvim --server "$NVIM" --remote-send "q"',
		'&& nvim --server "$NVIM" --remote-send "<C-\\><C-n><Cmd>lua pcall(vim.api.nvim_set_current_win, vim.g.codex_lazygit_win)<CR>"',
		'&& nvim --server "$NVIM" --remote {{filename}}',
		extra or "",
		"; fi",
	}, " ")
end

require("snacks").setup({
	dashboard = {
		enabled = true,
		preset = {
			header = [[
 ██████╗ ██████╗ ██████╗ ███████╗██╗  ██╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝
██║     ██║   ██║██║  ██║█████╗   ╚███╔╝
██║     ██║   ██║██║  ██║██╔══╝   ██╔██╗
╚██████╗╚██████╔╝██████╔╝███████╗██╔╝ ██╗
 ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝]],
			keys = {
				{ icon = "\u{f002} ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = "\u{f15b} ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = "\u{f022} ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
				{ icon = "\u{f0c5} ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				{
					icon = "\u{f423} ",
					key = "c",
					desc = "Config",
					action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
				},
				{ icon = "\u{f426} ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},
	lazygit = {
		theme = {
			activeBorderColor = { fg = "WarningMsg", bold = true },
		},
		config = {
			os = {
				edit = lazygit_edit(),
				editAtLine = lazygit_edit('&& nvim --server "$NVIM" --remote-send ":{{line}}<CR>"'),
			},
		},
	},
	notifier = { enabled = true },
	indent = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	picker = { enabled = true },
	scroll = { enabled = false },
})
