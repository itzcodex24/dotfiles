return {
  "neovim/nvim-lspconfig",
  disabled = true,
  opts = {
    inlay_hints = { enabled = false },
  },
  -- opts = function()
  --   -- require("lspconfig").dartls.setup({
  --   --   cmd = { "dart", "language-server", "--protocol=lsp" },
  --   -- })
  -- end,
}
