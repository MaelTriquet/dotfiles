-- lua/myterm/terminal.lua

local M = {}
local term_buf = {}
local term_idx = 1
local term_win = nil
local init = false

function M.toggle(idx)
  -- If the terminal window is open, close it
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    if idx == term_idx or not idx then
      return
    end
  end

  idx = idx or term_idx
  term_idx = idx

  -- If the terminal buffer doesn't exist or is invalid, create it
  if not term_buf[idx] or not vim.api.nvim_buf_is_valid(term_buf[idx]) then
    term_buf[idx] = vim.api.nvim_create_buf(false, true) -- unlisted, scratch buffer
    init = true
  end

  -- Calculate 80% of the current window size
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create a floating window with the terminal buffer
  term_win = vim.api.nvim_open_win(term_buf[idx], true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  })

  -- Enter insert mode in the terminal
  if init then
    init = false
    vim.cmd 'terminal'
  end
  vim.cmd 'startinsert'
  print('Terminal idx: ' .. idx)
end

return M
