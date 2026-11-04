-- Copilot
require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
		-- Keys live in plugins/keymaps.lua
		keymap = {
			accept = false,
			accept_word = false,
			accept_line = false,
			next = false,
			prev = false,
			dismiss = false,
		},
	},
	filetypes = {
		markdown = true,
		help = true,
	},
	-- Use the copilot-language-server installed by Mason
	server = {
		type = "binary",
		custom_server_filepath = "copilot-language-server",
	},
})
