return {
  dir = vim.fn.expand '$HOME/.config/nvim/lua/custom/neovim-project-manager/',
  lazy = false,
  cmd = 'ProjectManagerOpen', -- lazy-load on command
  config = function()
    local pm = require 'custom.neovim-project-manager'

    -- optional: keymap to open it quickly
    vim.keymap.set('n', '<leader>pm', function()
      pm.open()
    end, { noremap = true, silent = true })

    -- optional: set defaults
  end,
}
