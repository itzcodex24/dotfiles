-- Mason: install on start, never auto-update
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		-- Servers
		"lua-language-server",
		"vtsls",
		"eslint-lsp",
		"oxlint",
		"tailwindcss-language-server",
		"css-lsp",
		"rust-analyzer",
		"copilot-language-server",
		-- Formatters
		"prettier",
		"prettierd",
		"oxfmt",
		"stylua",
		"shfmt",
		-- nvim-treesitter needs the CLI to build parsers (on macOS it comes from npm)
		{
			"tree-sitter-cli",
			condition = function()
				return Codex.is_win
			end,
		},
	},
	auto_update = false,
	run_on_start = true,
})

-- Every server: blink.cmp completion capabilities + file-rename support
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities({
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	}),
})

vim.lsp.enable({
	"eslint",
	"oxlint",
	"lua_ls",
	"cssls",
	"vtsls",
	"tailwindcss",
	"rust_analyzer",
})

vim.lsp.inlay_hint.enable(true)

-- Diagnostics look
local icons = Codex.icons.diagnostics
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = {
		prefix = "●",
		source = "if_many",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.Error,
			[vim.diagnostic.severity.WARN] = icons.Warn,
			[vim.diagnostic.severity.HINT] = icons.Hint,
			[vim.diagnostic.severity.INFO] = icons.Info,
		},
	},
})
