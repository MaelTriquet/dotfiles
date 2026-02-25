vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

require('themes.aetheria').load()

vim.opt.termguicolors = true

-- -- Define custom highlight
-- local normal = { fg = '#ff7f41', bg = '#000000' }
-- vim.api.nvim_set_hl(0, 'MyBlockCursor', {
--   fg = normal.bg,
--   bg = normal.fg,
-- })
--
-- -- Apply only to normal and visual modes
-- vim.opt.guicursor = 'n-v:block-MyBlockCursor,' .. 'c-sm:block,' .. 'i-ci-ve:ver25,' .. 'r-cr-o:hor20,' .. 't:block-TermCursor'
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
