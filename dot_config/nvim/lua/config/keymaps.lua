local keymap = vim.keymap

local opts = { silent = true, noremap = true }

keymap.set("i", "jk", "<ESC>")
keymap.set("i", "JK", "<ESC>")

keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", opts)
keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opts)
keymap.set('n', '<leader>bd', ":bd<CR>", opts)

keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window
keymap.set("n", "<leader>sv", "<C-w>v")     -- split window vertically

keymap.set("n", "<leader>gb", ":BlameToggle<CR>")
keymap.set('n', 'gt', ':vsplit | lua vim.lsp.buf.definition()<CR>', opts)

keymap.set('n', "<leader>on", ":!code % <CR>", opts)

keymap.set('n', '<BS>', ':w<CR>', opts)

keymap.set('n', "<leader>cp", ":Cppath<CR>", opts)

keymap.set("n", ",m", function()
    vim.cmd(":%s/\r//g")
end)

