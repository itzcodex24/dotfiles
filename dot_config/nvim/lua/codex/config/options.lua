local opt = vim.opt

-- Leader and basics
vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.mouse = ""
opt.clipboard = "unnamedplus"

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

opt.iskeyword:append("-")

-- Look of the buffer
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.cmdheight = 0
opt.laststatus = 3
opt.winborder = "rounded"
opt.pumheight = 10
opt.pumblend = 10
opt.showmatch = true
opt.matchtime = 2
opt.title = true
opt.fillchars:append({ diff = "╱", eob = " " })
opt.report = 9999

-- Search, files, undo
opt.ignorecase = true
opt.smartcase = true
opt.path:append("**")
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })
opt.swapfile = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.cache/nvim/undodir")
opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0

-- Splits and folds
opt.splitbelow = true
opt.splitright = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

-- Windows: PowerShell for :!, :terminal and the snacks shell float (see :h shell-powershell)
if Codex.is_win then
	opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
	opt.shellcmdflag =
		"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
	opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
	opt.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
	opt.shellquote = ""
	opt.shellxquote = ""
end

-- Messages (ui2)
require("vim._core.ui2").enable({
	msg = {
		-- Default: short corner popup
		target = "msg",
		targets = {
			-- Stay in the command line
			search_count = "cmd",
			completion = "cmd",
			wildlist = "cmd",
			confirm = "cmd",
			-- Long output goes to the pager
			emsg = "pager",
			echoerr = "pager",
			lua_error = "pager",
			rpc_error = "pager",
			list_cmd = "pager",
			verbose = "pager",
			shell_cmd = "pager",
			shell_out = "pager",
			shell_err = "pager",
			shell_ret = "pager",
			progress = "pager",
		},
		msg = {
			height = 0.3,
			timeout = 5000,
		},
		pager = {
			height = 0.5,
		},
	},
})
