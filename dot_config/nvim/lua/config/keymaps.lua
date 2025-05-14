-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

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

local function sleep(n) 
  os.execute('sleep' .. tonumber(n))
end

local function get_visual_selection()
  -- Get the starting and ending positions of the visual selection
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))

  -- Adjust the column indices for 0-based indexing
  start_col = start_col - 1
  end_col = end_col - 1

  -- Get the selected lines
  local lines = vim.fn.getline(start_row, end_row)

  -- If only one line is selected, return the substring of that line
  if #lines == 1 then
    return string.sub(lines[1], start_col + 1, end_col + 1)
  end

  -- Otherwise, get the first line substring, the middle lines, and the last line substring
  lines[1] = string.sub(lines[1], start_col + 1)
  lines[#lines] = string.sub(lines[#lines], 1, end_col + 1)

  return table.concat(lines, "\n")
end

function run_test_tmux()
  local path = vim.fn.expand('%:p')
  local selected_text = get_visual_selection()

  local popupCmd = ('tmux popup -E')

  vim.fn.system(popupCmd)

  sleep(0.3)

  local cmd = string.format("yarn run test %s -t '%s' ", path, selected_text)

  vim.fn.system(cmd)
end

keymap.set('v', "<leader>tt", ":lua run_test_tmux()<CR>", opts)
