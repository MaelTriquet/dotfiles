-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "You Stupid"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "You Stupid"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "You Stupid"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "You Stupid"<CR>')

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.keymap.set({ 'n', 'v' }, 'H', '^')
vim.keymap.set({ 'n', 'v' }, 'L', '$')

vim.keymap.set('t', ',,', '<up><CR>')
vim.keymap.set('n', 'U', '<C-r>')
vim.keymap.set('n', '<A-j>', '"1dd"1p')
vim.keymap.set('n', '<A-k>', '"1ddkk"1p')

-- magic line to prevent overriding the clipboard when pasting over selection
vim.keymap.set('x', 'p', [["_dP]], { desc = 'Safe paste without clipboard overwrite' })
vim.keymap.set('n', 'c', '"_c')

-- Keep visual selection after indenting
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- previous command
vim.keymap.set({ 'n', 'v' }, ',f', 'k?➜<CR><cmd>nohlsearch<CR>0', { noremap = true, silent = true })

-- next command
vim.keymap.set({ 'n', 'v' }, ',F', '/➜<CR><cmd>nohlsearch<CR>0', { noremap = true, silent = true })

-- Select command output
vim.keymap.set('n', 'vic', 'k?➜<CR>jV/➜<CR>k<cmd>noh<CR>', { silent = true })

-- Yank command output
vim.keymap.set('n', 'yic', 'k?➜<CR>jV/➜<CR>ky<cmd>noh<CR>', { silent = true })

vim.keymap.set('n', 'Q', '@q')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>wq', ':wq<CR>')

local function listed_buffers()
  local bufs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 then
      table.insert(bufs, buf)
    end
  end
  return bufs
end

local function smart_q()
  local bufs = listed_buffers()

  -- Only one buffer → normal quit
  if #bufs <= 1 then
    vim.cmd 'quit'
    return
  end

  -- Find oldest buffer (smallest bufnr)
  table.sort(bufs)
  local oldest = bufs[1]

  -- Delete all others
  for i = #bufs, 2, -1 do
    pcall(vim.api.nvim_buf_delete, bufs[i], { force = true })
  end

  -- Go to oldest buffer
  vim.cmd('buffer ' .. oldest)
  vim.cmd 'startinsert'
end

local function smart_wq()
  local bufs = listed_buffers()

  -- Always write current buffer first
  vim.cmd 'write'

  -- One buffer → write & quit
  if #bufs <= 1 then
    vim.cmd 'quit'
    return
  end

  -- Same logic as smart_q
  table.sort(bufs)
  local oldest = bufs[1]

  for i = #bufs, 2, -1 do
    pcall(vim.api.nvim_buf_delete, bufs[i], { force = true })
  end

  vim.cmd('buffer ' .. oldest)
  vim.cmd 'startinsert'
end

vim.api.nvim_create_user_command('Q', smart_q, {})
vim.api.nvim_create_user_command('WQ', smart_wq, {})

vim.cmd 'cabbrev q Q'
vim.cmd 'cabbrev wq WQ'

-- vim: ts=2 sts=2 sw=2 et
