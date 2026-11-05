local map = vim.keymap.set

-- Snacks words
map("n", "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map("n", "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })

-- Picker
map("n", "<leader><leader>", function()
	Snacks.picker.files({ hidden = true })
end, { desc = "Find files" })
map("n", "<leader>/", function()
	Snacks.picker.grep({ hidden = true })
end, { desc = "Live grep" })
map("n", ";e", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", ";n", function()
	Snacks.picker.notifications()
end, { desc = "Notification history" })
map("n", ";h", function()
	Snacks.picker.git_diff()
end, { desc = "Git hunks" })
map("n", "ss", function()
	-- LSP symbols when a server provides them, otherwise fall back to treesitter
	if #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/documentSymbol" }) > 0 then
		Snacks.picker.lsp_symbols()
	else
		Snacks.picker.treesitter()
	end
end, { desc = "Symbols in file" })

-- File explorer
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("codex_oil_keymaps", { clear = true }),
	pattern = "oil",
	callback = function(args)
		map("n", "h", require("oil.actions").parent.callback, { buffer = args.buf, desc = "Parent directory" })
		map("n", "q", require("oil").close, { buffer = args.buf, desc = "Close oil" })
	end,
})

-- Git: signs and blame
map("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Blame line" })
map("n", "<leader>gB", function()
	require("gitsigns").blame()
end, { desc = "Blame buffer" })
map("n", "<leader>go", function()
	local file = vim.api.nvim_buf_get_name(0)
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local root = vim.fs.root(file, ".git")
	if not root then
		return vim.notify("Not in a git repository", vim.log.levels.WARN)
	end
	local blame = vim.system({ "git", "blame", "--porcelain", "-L", line .. "," .. line, "--", file }, { cwd = root })
		:wait()
	if blame.code ~= 0 then
		return vim.notify(vim.trim(blame.stderr), vim.log.levels.ERROR)
	end
	local sha, orig_line = blame.stdout:match("^(%x+) (%d+)")
	if not sha or sha:match("^0+$") then
		return vim.notify("Line is not committed yet", vim.log.levels.WARN)
	end
	local orig_path = blame.stdout:match("\nfilename ([^\n]+)") or vim.fs.relpath(root, file)
	local show = vim.system({ "git", "show", sha .. ":" .. orig_path }, { cwd = root, text = true }):wait()
	if show.code ~= 0 then
		return vim.notify(vim.trim(show.stderr), vim.log.levels.ERROR)
	end
	local ft = vim.bo.filetype
	vim.cmd.tabnew()
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(show.stdout, "\n", { trimempty = false }))
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = ft
	vim.api.nvim_buf_set_name(buf, ("%s@%s"):format(orig_path, sha:sub(1, 8)))
	vim.api.nvim_win_set_cursor(0, { tonumber(orig_line), 0 })
end, { desc = "Open file at last commit for line" })
map("n", "<leader>gs", function()
	local gs = require("gitsigns")
	if #(gs.get_hunks() or {}) > 0 then
		gs.stage_buffer()
	else
		gs.reset_buffer_index()
	end
end, { desc = "Stage / unstage buffer" })
map("n", "<leader>gh", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage / unstage hunk" })

-- Git: diff overlay
map("n", "<leader>gd", function()
	MiniDiff.toggle_overlay()
end, { desc = "Toggle diff overlay" })
map("n", "]c", function()
	MiniDiff.goto_hunk("next")
end, { desc = "Next hunk" })
map("n", "[c", function()
	MiniDiff.goto_hunk("prev")
end, { desc = "Previous hunk" })

-- Git: diff view
map("n", "<leader>dv", function()
	if require("codediff.ui.lifecycle").get_session(vim.api.nvim_get_current_tabpage()) then
		vim.cmd.tabclose()
	else
		vim.cmd("CodeDiff")
	end
end, { desc = "Toggle diff view" })
map("n", "<leader>dh", "<cmd>CodeDiff history %<cr>", { desc = "File history" })
map("n", "<leader>dH", "<cmd>CodeDiff history<cr>", { desc = "Repo history" })

-- Claude Code in a floating terminal (toggles the same session)
map("n", "<leader>cc", function()
	Snacks.terminal.toggle("claude --dangerously-skip-permissions", { cwd = vim.fn.getcwd() })
end, { desc = "Claude (skip permissions)" })

-- evx in a floating terminal (toggles the same session)
map("n", "<leader>ee", function()
	Snacks.terminal.toggle("evx", { cwd = vim.fn.getcwd() })
end, { desc = "evx" })

-- Shell in a floating terminal (toggles the same session)
map("n", "<leader>tt", function()
	Snacks.terminal.toggle(nil, { cwd = vim.fn.getcwd(), win = { position = "float" } })
end, { desc = "Terminal (float)" })

-- Git: lazygit
map("n", ";g", function()
	vim.g.codex_lazygit_win = vim.api.nvim_get_current_win()
	Snacks.lazygit()
end, { desc = "Lazygit" })

-- Copilot (only when it's loaded)
if package.loaded["copilot"] then
	map("i", "<Tab>", function()
		local suggestion = require("copilot.suggestion")
		if suggestion.is_visible() then
			suggestion.accept()
		else
			vim.api.nvim_feedkeys(vim.keycode("<Tab>"), "n", false)
		end
	end, { desc = "Accept Copilot suggestion" })
	map("i", "<D-]>", function()
		require("copilot.suggestion").next()
	end, { desc = "Next Copilot suggestion" })
	map("i", "<D-[>", function()
		require("copilot.suggestion").prev()
	end, { desc = "Previous Copilot suggestion" })
end

-- LSP
-- Drop Neovim's default gr* maps so `gr` fires without waiting
for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
	pcall(vim.keymap.del, { "n", "x" }, lhs)
end

local function source_definition(buf)
	local client = vim.lsp.get_clients({ bufnr = buf, name = "vtsls" })[1]
	if not client then
		return false
	end
	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:exec_cmd({
		title = "Go to source definition",
		command = "typescript.goToSourceDefinition",
		arguments = { params.textDocument.uri, params.position },
	}, { bufnr = buf }, function(err, result)
		if err then
			vim.notify(err.message, vim.log.levels.ERROR)
			return
		end
		if not result or vim.tbl_isempty(result) then
			vim.notify("No source definition found", vim.log.levels.WARN)
			return
		end
		if #result == 1 then
			vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
		else
			vim.fn.setqflist({}, " ", {
				title = "Source definitions",
				items = vim.lsp.util.locations_to_items(result, client.offset_encoding),
			})
			vim.cmd("botright copen")
		end
	end)
	return true
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("codex_lsp_keymaps", { clear = true }),
	callback = function(args)
		local buf = args.buf
		local function bmap(mode, lhs, rhs, desc)
			map(mode, lhs, rhs, { buffer = buf, desc = desc })
		end

		bmap("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, "Go to definition")
		bmap("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, "Go to declaration")
		bmap("n", "gy", function()
			Snacks.picker.lsp_type_definitions()
		end, "Go to type definition")
		bmap("n", "gr", function()
			Snacks.picker.lsp_references()
		end, "References")
		bmap("n", "gI", function()
			if not source_definition(buf) then
				Snacks.picker.lsp_implementations()
			end
		end, "Go to source definition / implementation")
		bmap("n", ";c", function()
			Snacks.picker.lsp_incoming_calls()
		end, "Incoming calls")
		bmap("n", "K", vim.lsp.buf.hover, "Hover")
		bmap("n", "gK", vim.lsp.buf.signature_help, "Signature help")
		bmap("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
		bmap("n", "<C-j>", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")
		bmap({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
		bmap("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
		bmap("n", "<leader>cR", function()
			Snacks.rename.rename_file()
		end, "Rename file")
		bmap("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP info")
	end,
})
