-- neovim-project-manager/init.lua
local M = {}
local config = require 'custom.neovim-project-manager.config'
local renderer = require 'custom.neovim-project-manager.renderer'
local actions = require 'custom.neovim-project-manager.actions'
local fuzzy = require 'custom.neovim-project-manager.fuzzy'

local state = config.state

function M.open(opts)
  opts = opts or {}
  for k, v in pairs(opts) do
    config.config[k] = v
  end
  state.root = opts.root or config.config.root or vim.loop.cwd()
  state.cursor = 1
  state.query = ''

  local ui = vim.api.nvim_list_uis()[1]

  -- ✅ allow percentage-based sizing
  local height = config.config.height <= 1 and math.floor(ui.height * config.config.height) or config.config.height
  local mid_width = config.config.width <= 1 and math.floor(ui.width * config.config.width) or config.config.width
  local prv_width = config.config.preview_width <= 1 and math.floor(ui.width * config.config.preview_width) or config.config.preview_width

  -- keep minimum sizes
  height = math.max(height, 10)
  mid_width = math.max(mid_width, 20)
  prv_width = math.max(prv_width, 20)

  local col_mid = math.floor((ui.width - mid_width - prv_width) / 2)
  local row = math.floor((ui.height - height) / 2)

  state.buf_left = vim.api.nvim_create_buf(false, true)
  state.win_left = vim.api.nvim_open_win(state.buf_left, true, {
    relative = 'editor',
    row = row,
    col = col_mid - 15,
    width = 15,
    height = height,
    style = 'minimal',
    border = 'rounded',
  })
  state.buf_mid = vim.api.nvim_create_buf(false, true)
  state.win_mid = vim.api.nvim_open_win(state.buf_mid, true, {
    relative = 'editor',
    row = row,
    col = col_mid,
    width = mid_width,
    height = height,
    style = 'minimal',
    border = 'rounded',
  })
  state.buf_prv = vim.api.nvim_create_buf(false, true)
  state.win_prv = vim.api.nvim_open_win(state.buf_prv, false, {
    relative = 'editor',
    row = row,
    col = col_mid + mid_width,
    width = prv_width,
    height = height,
    style = 'minimal',
    border = 'rounded',
  })

  -- keymaps
  local function map(buf, key, fn)
    vim.keymap.set('n', key, fn, { buffer = buf, nowait = true, noremap = true, silent = true })
  end
  map(state.buf_mid, 'j', function()
    state.cursor = math.min(state.cursor + 1, #state.filtered)
    renderer.refresh(state)
  end)
  map(state.buf_mid, 'k', function()
    state.cursor = math.max(state.cursor - 1, 1)
    renderer.refresh(state)
  end)
  map(state.buf_mid, 'l', function()
    actions.open_item(state)
  end)
  map(state.buf_mid, '<CR>', function()
    actions.open_item(state)
  end)
  map(state.buf_mid, 'o', function()
    actions.open_item(state)
  end)
  map(state.buf_mid, 'h', function()
    actions.go_up(state)
  end)
  map(state.buf_mid, 'd', function()
    actions.delete_item(state)
  end)
  map(state.buf_mid, 'r', function()
    actions.rename_item(state)
  end)
  map(state.buf_mid, 'n', function()
    actions.create_file(state)
  end)
  map(state.buf_mid, 'N', function()
    actions.create_dir(state)
  end)
  map(state.buf_mid, 'f', function()
    fuzzy.open(state)
  end)
  map(state.buf_mid, 'q', function()
    M.close()
  end)
  map(state.buf_mid, '<Esc>', function()
    M.close()
  end)

  renderer.refresh(state)
end

function M.close()
  local function safe_close(win, buf)
    if win and vim.api.nvim_win_is_valid(win) then
      pcall(vim.api.nvim_win_close, win, true)
    end
    if buf and vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
  safe_close(state.win_left, state.buf_left)
  safe_close(state.win_mid, state.buf_mid)
  safe_close(state.win_prv, state.buf_prv)
  state.win_left, state.win_mid, state.win_prv = nil, nil, nil
  state.buf_left, state.buf_mid, state.buf_prv = nil, nil, nil
end

return M
