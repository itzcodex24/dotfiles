-- File explorer
require("oil").setup({
	default_file_explorer = true,
	columns = { "icon", "permissions", "size", "mtime" },
	view_options = {
		show_hidden = true,
	},
	-- Free <C-h>/<C-l> for split/tmux pane navigation
	keymaps = {
		["<C-h>"] = false,
		["<C-l>"] = false,
	},
	lsp_file_methods = {
		enabled = true,
		autosave_changes = true,
	},
	float = {
		max_width = 200,
		border = "rounded",
	},
})
