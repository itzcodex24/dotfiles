-- Treesitter
local parsers = {
	"astro",
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"diff",
	"fish",
	"gitignore",
	"go",
	"graphql",
	"html",
	"http",
	"java",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"php",
	"printf",
	"python",
	"query",
	"regex",
	"rust",
	"scss",
	"sql",
	"svelte",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

-- Building parsers needs the `tree-sitter` CLI. If it isn't on PATH yet (Mason installs it on
-- Windows and only adds its bin dir once set up), wait for Mason instead of failing every parser.
local function install_parsers()
	if vim.fn.executable("tree-sitter") == 1 then
		require("nvim-treesitter").install(parsers)
		return true
	end
	return false
end

if not install_parsers() then
	vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("codex_treesitter_install", { clear = true }),
		pattern = "MasonToolsUpdateCompleted",
		once = true,
		callback = function()
			if not install_parsers() then
				vim.notify("tree-sitter CLI not found: parsers were not installed", vim.log.levels.WARN)
			end
		end,
	})
end

-- Start highlighting and indent whenever a parser exists
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("codex_treesitter", { clear = true }),
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if not lang or not vim.treesitter.language.add(lang) then
			return
		end
		vim.treesitter.start(args.buf, lang)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- TODO / FIXME highlights
require("todo-comments").setup({})

-- Color highlights
require("nvim-highlight-colors").setup({
	render = "background",
	enable_hex = true,
	enable_rgb = true,
	enable_hsl = true,
	enable_ansi = true,
	enable_var_usage = true,
	enable_tailwind = false,
})

-- Don't paint colors twice
vim.lsp.document_color.enable(false)
