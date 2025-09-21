-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.python_host_prog  = '/usr/bin/python2'
vim.g.python3_host_prog = '/usr/bin/python3'
vim.lsp.set_log_level("off")
