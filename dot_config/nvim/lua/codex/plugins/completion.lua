-- Completion
require("blink.cmp").setup({
	keymap = { preset = "enter" },
	completion = {
		accept = {
			auto_brackets = { enabled = true },
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		ghost_text = { enabled = false },
		menu = {
			draw = {
				treesitter = { "lsp" },
				components = {
					kind_icon = {
						text = function(ctx)
							local icon = Codex.icons.kind(ctx.kind)
							return icon .. ctx.icon_gap
						end,
						highlight = function(ctx)
							local _, hl = Codex.icons.kind(ctx.kind)
							return hl
						end,
					},
				},
			},
		},
	},
	cmdline = {
		completion = {
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
			list = {
				selection = { preselect = false },
			},
		},
	},
})

-- Pairs
require("mini.pairs").setup({
	modes = {
		insert = true,
		command = true,
		terminal = false,
	},
})
