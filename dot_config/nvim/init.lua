vim.loader.enable()

_G.Codex = require("codex.utils")

require("codex.config.options")
require("codex.config.keymaps")
require("codex.config.autocmds")
require("codex.config.commands")
require("codex.config.workarounds")

require("codex.plugins")
