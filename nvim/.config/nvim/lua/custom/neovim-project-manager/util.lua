-- neovim-project-manager/util.lua
local uv = vim.loop
local api = vim.api

local M = {}

function M.is_dir(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == 'directory'
end

function M.scandir(path)
  local fd = uv.fs_scandir(path)
  if not fd then
    return {}
  end
  local res = {}
  while true do
    local name, typ = uv.fs_scandir_next(fd)
    if not name then
      break
    end
    table.insert(res, { name = name, path = path .. '/' .. name, type = typ or 'file' })
  end
  table.sort(res, function(a, b)
    return a.name < b.name
  end)
  return res
end

function M.fuzzy_filter(items, q)
  if not q or q == '' then
    return items
  end
  local out = {}
  local ql = q:lower()
  for _, it in ipairs(items) do
    if it.name:lower():find(ql, 1, true) then
      table.insert(out, it)
    end
  end
  return out
end

function M.safe_set_lines(buf, lines)
  if buf and api.nvim_buf_is_valid(buf) then
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    api.nvim_buf_set_option(buf, 'modifiable', false)
  end
end

return M
