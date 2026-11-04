local group = vim.api.nvim_create_augroup("codex", { clear = true })

-- Flash yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Cursorline only in the active window
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = group,
	callback = function()
		vim.wo.cursorline = true
	end,
})
vim.api.nvim_create_autocmd("WinLeave", {
	group = group,
	callback = function()
		vim.wo.cursorline = false
	end,
})

-- Herdr: rename the tab to "nvim" while nvim runs (local.tab-autoname plugin)
-- Unix only: the delayed refresh goes through `sh`
if vim.env.HERDR_ENV == "1" and not Codex.is_win then
	local function herdr_refresh(delay)
		local herdr = vim.env.HERDR_BIN_PATH or "herdr"
		vim.fn.jobstart({
			"sh",
			"-c",
			"sleep " .. delay .. "; exec \"$0\" plugin action invoke local.tab-autoname.refresh",
			herdr,
		}, { detach = true })
	end
	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		callback = function()
			herdr_refresh(0)
		end,
	})
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			herdr_refresh(0.4)
		end,
	})
end
