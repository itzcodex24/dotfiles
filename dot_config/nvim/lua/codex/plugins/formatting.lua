local web = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

-- oxfmt only when the project configures it (.oxfmtrc.json or a Vite+ `fmt` block)
local function has_oxfmt_config(dirname)
	if vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }, { path = dirname, upward = true })[1] then
		return true
	end
	local vite = vim.fs.find(
		{ "vite.config.ts", "vite.config.mts", "vite.config.js", "vite.config.mjs" },
		{ path = dirname, upward = true }
	)[1]
	if not vite then
		return false
	end
	local ok, lines = pcall(vim.fn.readfile, vite)
	return ok and table.concat(lines, "\n"):find("fmt%s*:") ~= nil
end

require("conform").setup({
	formatters_by_ft = {
		javascript = web,
		typescript = web,
		javascriptreact = web,
		typescriptreact = web,
		json = web,
		css = web,
		scss = web,
		less = web,
		html = web,
		markdown = web,
		mdx = web,
		["markdown.mdx"] = web,
		yaml = web,
		lua = { "stylua" },
		sh = { "shfmt" },
	},
	formatters = {
		oxfmt = {
			condition = function(_, ctx)
				return has_oxfmt_config(ctx.dirname)
			end,
		},
	},
	format_on_save = function(bufnr)
		if vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 1000, lsp_format = "fallback" }
	end,
})
