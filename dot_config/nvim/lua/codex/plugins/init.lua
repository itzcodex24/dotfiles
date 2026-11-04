-- Keep parsers in sync with the nvim-treesitter version
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("codex_pack_changed", { clear = true }),
	callback = function(ev)
		local data = ev.data
		if data.spec.name ~= "nvim-treesitter" or data.kind == "delete" then
			return
		end
		if not data.active then
			vim.cmd.packadd("nvim-treesitter")
		end
		vim.cmd("TSUpdate")
	end,
})

vim.pack.add({
	"https://github.com/rachartier/tiny-cmdline.nvim",
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/b0o/incline.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/vyfor/cord.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	{ src = "https://github.com/craftzdog/mini.diff", version = "feat/grouping" },
	"https://github.com/esmuellert/codediff.nvim",
	"https://github.com/linrongbin16/gitlinker.nvim",
	-- Copilot disabled for now (config kept in plugins/ai.lua)
	-- "https://github.com/zbirenbaum/copilot.lua",
})

require("codex.plugins.ui")
require("codex.plugins.navigation")
require("codex.plugins.syntax")
require("codex.plugins.completion")
require("codex.plugins.lsp")
require("codex.plugins.formatting")
require("codex.plugins.git")
-- require("codex.plugins.ai")
require("codex.plugins.discord")
require("codex.plugins.keymaps")
