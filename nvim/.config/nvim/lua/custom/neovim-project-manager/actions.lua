-- neovim-project-manager/actions.lua
local M = {}
local uv = vim.loop
local util = require 'custom.neovim-project-manager.util'
local renderer = require 'custom.neovim-project-manager.renderer'

function M.open_item(state)
  local item = state.filtered[state.cursor]
  if not item then
    return
  end
  if util.is_dir(item.path) then
    state.root = item.path
    state.cursor = 1
    renderer.refresh(state)
  else
    require('custom.neovim-project-manager').close()
    vim.cmd('edit ' .. vim.fn.fnameescape(item.path))
  end
end

function M.go_up(state)
  local up = state.root:match '(.*/)[^/]+/?$'
  if up then
    state.root = up
    state.cursor = 1
    renderer.refresh(state)
  end
end

function M.delete_item(state)
  local item = state.filtered[state.cursor]
  if not item then
    return
  end
  local ok = vim.fn.confirm('Delete ' .. item.path .. '?', '&Yes\n&No', 2)
  if ok ~= 1 then
    return
  end
  if util.is_dir(item.path) then
    os.execute('rm -rf ' .. vim.fn.shellescape(item.path))
  else
    os.remove(item.path)
  end
  renderer.refresh(state)
end

function M.rename_item(state)
  local item = state.filtered[state.cursor]
  if not item then
    return
  end
  local newname = vim.fn.input('New name: ', item.name)
  if newname and newname ~= '' then
    uv.fs_rename(item.path, state.root .. '/' .. newname)
    renderer.refresh(state)
  end
end

function M.create_file(state)
  local name = vim.fn.input 'New file: '
  if name and name ~= '' then
    local f = io.open(state.root .. '/' .. name, 'w')
    if f then
      f:close()
    end
    renderer.refresh(state)
  end
end

function M.create_dir(state)
  local name = vim.fn.input 'New dir: '
  if name and name ~= '' then
    uv.fs_mkdir(state.root .. '/' .. name, 493)
    renderer.refresh(state)
  end
end

return M
