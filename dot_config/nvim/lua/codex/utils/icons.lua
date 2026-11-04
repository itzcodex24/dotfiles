local M = {}

M.diagnostics = {
	Error = "\u{f057} ",
	Warn = "\u{f071} ",
	Hint = "\u{f0eb} ",
	Info = "\u{f05a} ",
}

---Icon and highlight group for an LSP completion kind
---@param kind string
---@return string icon, string hl
function M.kind(kind)
	return MiniIcons.get("lsp", kind)
end

return M
