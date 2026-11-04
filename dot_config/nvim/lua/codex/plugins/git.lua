-- Signs and blame
require("gitsigns").setup()

-- Diff overlay (craftzdog fork: whole-hunk grouping)
require("mini.diff").setup({
	view = {
		overlay_style = "hunk",
	},
})

-- Diff view
require("codediff").setup({
	explorer = {
		view_mode = "tree",
		width = 50,
		auto_open_on_cursor = true,
		line_stats = { enabled = true },
	},
	diff = {
		compact = true,
		compact_context_lines = 8,
		compact_sync_folds = true,
	},
})

-- Links
require("gitlinker").setup()

-- Lazygit (opened through snacks): load ~/.config/lazygit/config.yml with the synced theme.
-- When it's missing (e.g. Windows, which uses %APPDATA%\lazygit), snacks falls back to lazygit's default
local lazygit_config = vim.fn.expand("~/.config/lazygit/config.yml")
if vim.uv.fs_stat(lazygit_config) then
	vim.env.LG_CONFIG_FILE = lazygit_config
end
