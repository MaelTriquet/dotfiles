-- lua/custom/plugins/myterm/init.lua

local terminal = require 'custom.myterm.terminal'

local M = {}

-- Function to toggle the terminal
function M.toggle(idx)
  terminal.toggle(idx)
end

return M
