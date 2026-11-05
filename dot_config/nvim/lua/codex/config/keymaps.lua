local map = vim.keymap.set

-- Leave insert mode
map("i", "jk", "<Esc>", { desc = "Normal mode" })
map("i", "JK", "<Esc>", { desc = "Normal mode" })

-- Registers
map("n", "x", '"_x', { desc = "Delete without copying" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
map({ "n", "v" }, "<leader>c", '"_c', { desc = "Change without yanking" })
map("v", "<leader>p", '"0p', { desc = "Paste last yank" })

-- Numbers
map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Save
-- Quietly, and only for real file buffers (the ui2 pager etc. would raise E382)
map("n", "<BS>", function()
	if vim.bo.buftype ~= "" then
		return
	end
	vim.cmd("silent update")
end, { desc = "Save buffer" })

-- Buffers
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Diagnostics
map("n", "]e", function()
	vim.diagnostic.jump({ count = vim.v.count1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Next error" })
map("n", "[e", function()
	vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Previous error" })
map("n", "]d", function()
	vim.diagnostic.jump({ count = vim.v.count1, float = true })
end, { desc = "Next diagnostic" })
map("n", "[d", function()
	vim.diagnostic.jump({ count = -vim.v.count1, float = true })
end, { desc = "Previous diagnostic" })

-- Splits
map("n", "sv", "<cmd>vsplit<cr>", { desc = "Split right" })
map("n", "sh", "<cmd>split<cr>", { desc = "Split below" })
map("n", "sj", "<C-w>j", { desc = "Window below" })
map("n", "sk", "<C-w>k", { desc = "Window above" })
map("n", "sl", "<C-w>l", { desc = "Window right" })
map("n", "sx", "<cmd>close<cr>", { desc = "Close window" })

-- Agentic coding helpers
map("n", "<leader>cp", Codex.editor.copy_path, { desc = "Copy path with line" })
map("x", "<leader>cc", Codex.editor.copy_code_block, { desc = "Copy selection as code block" })
map("n", "<leader>j", Codex.editor.open_package_json, { desc = "Open package.json" })

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit" })
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Close buffer" })

-- Close hidden buffers, except unsaved ones
map("n", "<leader>bo", function()
	for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if buf.hidden == 1 and buf.changed == 0 then
			vim.api.nvim_buf_delete(buf.bufnr, {})
		end
	end
end, { desc = "Close hidden buffers" })
