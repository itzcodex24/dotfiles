return {
	is_win = vim.fn.has("win32") == 1,
	editor = require("codex.utils.editor"),
	icons = require("codex.utils.icons"),
	tabline = require("codex.utils.tabline"),
}
