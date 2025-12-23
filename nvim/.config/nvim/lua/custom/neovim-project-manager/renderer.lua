-- neovim-project-manager/renderer.lua
local api = vim.api
local M = {}

function M.render_left(state)
  local lines = { '[Parent]' }
  for _, it in ipairs(state.parent_items) do
    local icon = (it.type == 'directory') and '' or ''
    table.insert(lines, icon .. ' ' .. it.name)
  end
  require('custom.neovim-project-manager.util').safe_set_lines(state.buf_left, lines)
end

function M.render_middle(state)
  local lines = {}
  for i, it in ipairs(state.filtered) do
    local prefix = (i == state.cursor) and '▶ ' or '  '
    local icon = (it.type == 'directory') and ' ' or ' '
    table.insert(lines, prefix .. icon .. it.name)
  end
  require('custom.neovim-project-manager.util').safe_set_lines(state.buf_mid, lines)
  api.nvim_buf_clear_namespace(state.buf_mid, state.namespace, 0, -1)
  if state.cursor >= 1 and state.cursor <= #state.filtered then
    api.nvim_buf_add_highlight(state.buf_mid, state.namespace, 'Visual', state.cursor - 1, 0, -1)
  end
end

function M.render_preview(state)
  local util = require 'custom.neovim-project-manager.util'
  local item = state.filtered[state.cursor]
  if not item then
    util.safe_set_lines(state.buf_prv, {})
    return
  end
  if util.is_dir(item.path) then
    local lines = { ' [Directory] ' .. item.path, '' }
    for _, it in ipairs(util.scandir(item.path)) do
      local icon = (it.type == 'directory') and ' ' or ' '
      table.insert(lines, ' ' .. icon .. ' ' .. it.name)
    end
    util.safe_set_lines(state.buf_prv, lines)
  else
    local f = io.open(item.path, 'r')
    local lines = {}
    if f then
      for i = 1, 1000 do
        local l = f:read '*l'
        if not l then
          break
        end
        table.insert(lines, ' ' .. l)
      end
      f:close()
    end
    if #lines == 0 then
      lines = { ' [Empty]' }
    end
    util.safe_set_lines(state.buf_prv, lines)
  end
end

function M.refresh(state)
  local util = require 'custom.neovim-project-manager.util'
  state.items = util.scandir(state.root)
  state.parent_items = util.scandir(state.root:match '(.*/)[^/]+/?$' or state.root)
  state.filtered = util.fuzzy_filter(state.items, state.query)
  if #state.filtered == 0 then
    state.cursor = 0
  else
    state.cursor = math.max(1, math.min(state.cursor, #state.filtered))
  end
  M.render_left(state)
  M.render_middle(state)
  M.render_preview(state)
end

return M
