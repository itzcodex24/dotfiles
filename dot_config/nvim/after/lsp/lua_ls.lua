return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			hint = {
				enable = true,
				paramType = true,
				setType = false,
				paramName = "Disable",
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
			diagnostics = {
				disable = { "incomplete-signature-doc", "trailing-space", "missing-fields" },
			},
		},
	},
}
