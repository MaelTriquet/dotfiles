-- neovim-project-manager/config.lua
local M = {}

M.config = {
  width = 0.3,
  height = 0.7,
  preview_width = 0.3,
  max_scan_depth = 1, -- middle pane only shows same-level items
  root = nil,
}

M.state = {
  -- panes
  buf_left = nil,
  buf_mid = nil,
  buf_prv = nil,
  win_left = nil,
  win_mid = nil,
  win_prv = nil,
  -- items
  items = {},
  parent_items = {},
  filtered = {},
  cursor = 1,
  root = nil,
  query = '',
  namespace = vim.api.nvim_create_namespace 'nvim-project-manager',
}

return M
