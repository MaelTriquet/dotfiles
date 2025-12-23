-- neovim-project-manager/fuzzy.lua
local M = {}
local api, uv = vim.api, vim.loop

local state_ref = nil -- this will store the 3-pane state

local fuzzy_state = {
  buf_prompt = nil,
  buf_results = nil,
  win_prompt = nil,
  win_results = nil,
  matches = {},
  cursor = 1,
  query = '',
  root = nil,
  all_folders = {},
}

local function scan_folders_recursive(root)
  local folders = {}
  local function _scan(dir)
    local fd = uv.fs_scandir(dir)
    if not fd then
      return
    end
    while true do
      local name, typ = uv.fs_scandir_next(fd)
      if not name then
        break
      end
      local full = dir .. '/' .. name
      if typ == 'directory' then
        table.insert(folders, full:sub(#root + 2))
        _scan(full)
      end
    end
  end
  _scan(root)
  table.sort(folders)
  return folders
end

local function render_results()
  if not (fuzzy_state.buf_results and api.nvim_buf_is_valid(fuzzy_state.buf_results)) then
    return
  end
  local lines = {}
  for i, f in ipairs(fuzzy_state.matches) do
    local prefix = (i == fuzzy_state.cursor) and '▶ ' or '  '
    table.insert(lines, prefix .. f)
  end
  api.nvim_buf_set_option(fuzzy_state.buf_results, 'modifiable', true)
  api.nvim_buf_set_lines(fuzzy_state.buf_results, 0, -1, false, lines)
  api.nvim_buf_set_option(fuzzy_state.buf_results, 'modifiable', false)
end

local function update_matches()
  local q = fuzzy_state.query:lower()
  local results = {}
  for _, f in ipairs(fuzzy_state.all_folders) do
    if f:lower():find(q, 1, true) then
      table.insert(results, f)
    end
  end
  fuzzy_state.matches = results
  fuzzy_state.cursor = math.max(1, math.min(fuzzy_state.cursor, #results))
  render_results()
end

local function close_fuzzy()
  local function safe_close(win, buf)
    if win and api.nvim_win_is_valid(win) then
      pcall(api.nvim_win_close, win, true)
    end
    if buf and api.nvim_buf_is_valid(buf) then
      pcall(api.nvim_buf_delete, buf, { force = true })
    end
  end
  safe_close(fuzzy_state.win_prompt, fuzzy_state.buf_prompt)
  safe_close(fuzzy_state.win_results, fuzzy_state.buf_results)
  fuzzy_state.buf_prompt, fuzzy_state.buf_results, fuzzy_state.win_prompt, fuzzy_state.win_results = nil, nil, nil, nil
end

local function select_fuzzy()
  local sel = fuzzy_state.matches[fuzzy_state.cursor]
  if sel then
    close_fuzzy()
    state_ref.root = fuzzy_state.root .. '/' .. sel
    state_ref.cursor = 1
    require('neovim-project-manager.renderer').refresh(state_ref)
  else
    close_fuzzy()
  end
end

local function on_key(key)
  if key == 'j' then
    fuzzy_state.cursor = math.min(fuzzy_state.cursor + 1, #fuzzy_state.matches)
    render_results()
  elseif key == 'k' then
    fuzzy_state.cursor = math.max(fuzzy_state.cursor - 1, 1)
    render_results()
  elseif key == '<CR>' then
    select_fuzzy()
  elseif key == 'q' then
    close_fuzzy()
  end
end

function M.open(main_state)
  state_ref = main_state
  close_fuzzy()
  fuzzy_state.root = main_state.root
  fuzzy_state.query = ''
  fuzzy_state.cursor = 1
  fuzzy_state.all_folders = scan_folders_recursive(fuzzy_state.root)
  local ui = api.nvim_list_uis()[1]
  local prompt_height = 1
  local prompt_width = 60
  local row = math.floor((ui.height - 10) / 2)
  local col = math.floor((ui.width - prompt_width) / 2)

  -- prompt buffer
  fuzzy_state.buf_prompt = api.nvim_create_buf(false, true)
  fuzzy_state.win_prompt = api.nvim_open_win(fuzzy_state.buf_prompt, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = prompt_width,
    height = prompt_height,
    style = 'minimal',
    border = 'rounded',
  })

  -- results buffer
  fuzzy_state.buf_results = api.nvim_create_buf(false, true)
  fuzzy_state.win_results = api.nvim_open_win(fuzzy_state.buf_results, true, {
    relative = 'editor',
    row = row + 1,
    col = col,
    width = prompt_width,
    height = 10,
    style = 'minimal',
    border = 'rounded',
  })

  -- attach insert handler for real-time input
  api.nvim_buf_attach(fuzzy_state.buf_prompt, false, {
    on_lines = function(_, buf, changedtick, first, last, new_last)
      local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
      fuzzy_state.query = lines[1] or ''
      update_matches()
    end,
  })

  -- keymaps
  local function map(buf, key, fn)
    vim.keymap.set('n', key, fn, { buffer = buf, nowait = true, noremap = true, silent = true })
  end
  map(fuzzy_state.buf_results, 'j', function()
    on_key 'j'
  end)
  map(fuzzy_state.buf_results, 'k', function()
    on_key 'k'
  end)
  map(fuzzy_state.buf_results, '<CR>', function()
    on_key '<CR>'
  end)
  map(fuzzy_state.buf_results, 'q', function()
    on_key 'q'
  end)
end

return M
