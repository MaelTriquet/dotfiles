-- ~/.config/nvim/lua/themes/aetheria.lua
-- Aetheria Colorscheme (modular standalone version)
-- Author: You + ChatGPT 😄

local M = {}

function M.load()
  -- Dark color palette
  local colors = {
    -- Base colors (dark theme)
    hex_0e091d = '#0e091d', -- Very dark blue-purple
    hex_061F23 = '#061F23', -- Very dark teal-blue
    hex_092F34 = '#092F34', -- Dark desaturated blue
    hex_0C3F45 = '#0C3F45', -- Dark muted blue-green
    hex_0F5057 = '#0F5057', -- Dark teal-blue
    hex_126069 = '#126069', -- Dark desaturated blue-green

    -- Foreground colors
    hex_C8E967 = '#C8E967', -- Bright yellowish-green
    hex_A8D61F = '#A8D61F', -- Bright yellow-green
    hex_8CB319 = '#8CB319', -- Muted yellow-green

    -- Accent colors (aetheria neon palette)
    hex_9147a8 = '#9147a8', -- Dark purple
    hex_E20342 = '#E20342', -- Bright red
    hex_FF7F41 = '#FF7F41', -- Bright orange
    hex_04C5F0 = '#04C5F0', -- Bright cyan-blue
    hex_f93d3b = '#f93d3b', -- Vibrant red
    hex_ffbe74 = '#ffbe74', -- Light orange-yellow
    hex_FD3E6A = '#FD3E6A', -- Vibrant pink-red
    hex_7cd699 = '#7cd699', -- Light blue-green
    hex_47A854 = '#47A854', -- Dark green
  }

  -- Reset highlighting
  vim.cmd 'highlight clear'
  if vim.fn.exists 'syntax_on' then
    vim.cmd 'syntax reset'
  end

  vim.o.termguicolors = true
  vim.o.background = 'dark'
  vim.g.colors_name = 'aetheria'

  local hl = vim.api.nvim_set_hl

  ----------------------------------------------------------------------
  -- 🖋 Editor UI
  ----------------------------------------------------------------------
  hl(0, 'Normal', { fg = colors.hex_C8E967, bg = colors.hex_0e091d })
  hl(0, 'NormalFloat', { fg = colors.hex_C8E967, bg = colors.hex_061F23 })
  hl(0, 'FloatBorder', { fg = colors.hex_9147a8, bg = colors.hex_061F23 })
  hl(0, 'Cursor', { fg = colors.hex_0e091d, bg = colors.hex_9147a8 })
  hl(0, 'CursorLine', { bg = colors.hex_061F23 })
  hl(0, 'LineNr', { fg = colors.hex_8CB319 })
  hl(0, 'CursorLineNr', { fg = colors.hex_04C5F0, bold = true })
  hl(0, 'Visual', { bg = colors.hex_092F34 })
  hl(0, 'Search', { fg = colors.hex_0e091d, bg = colors.hex_04C5F0 })
  hl(0, 'IncSearch', { fg = colors.hex_0e091d, bg = colors.hex_9147a8 })
  hl(0, 'MatchParen', { fg = colors.hex_FD3E6A, bold = true })

  ----------------------------------------------------------------------
  -- 🌈 Syntax
  ----------------------------------------------------------------------
  hl(0, 'Comment', { fg = colors.hex_126069, italic = true })
  hl(0, 'Constant', { fg = colors.hex_ffbe74 })
  hl(0, 'String', { fg = colors.hex_FF7F41 })
  hl(0, 'Function', { fg = colors.hex_7cd699 })
  hl(0, 'Identifier', { fg = colors.hex_C8E967 })
  hl(0, 'Keyword', { fg = colors.hex_9147a8 })
  hl(0, 'Type', { fg = colors.hex_E20342 })
  hl(0, 'Operator', { fg = colors.hex_A8D61F })
  hl(0, 'Error', { fg = colors.hex_f93d3b, bold = true })
  hl(0, 'Todo', { fg = colors.hex_04C5F0, bold = true })

  ----------------------------------------------------------------------
  -- ⚙ UI Elements
  ----------------------------------------------------------------------
  hl(0, 'StatusLine', { fg = colors.hex_C8E967, bg = colors.hex_092F34 })
  hl(0, 'StatusLineNC', { fg = colors.hex_8CB319, bg = colors.hex_061F23 })
  hl(0, 'Pmenu', { fg = colors.hex_C8E967, bg = colors.hex_061F23 })
  hl(0, 'PmenuSel', { fg = colors.hex_04C5F0, bg = colors.hex_0C3F45, bold = true })
  hl(0, 'VertSplit', { fg = colors.hex_0C3F45 })
  hl(0, 'WinSeparator', { fg = colors.hex_0C3F45 })
  hl(0, 'TabLineSel', { fg = colors.hex_9147a8, bg = colors.hex_0e091d, bold = true })

  ----------------------------------------------------------------------
  -- 🌿 Git + Diff
  ----------------------------------------------------------------------
  hl(0, 'GitSignsAdd', { fg = colors.hex_FF7F41 })
  hl(0, 'GitSignsChange', { fg = colors.hex_04C5F0 })
  hl(0, 'GitSignsDelete', { fg = colors.hex_f93d3b })

  hl(0, 'DiffAdd', { fg = colors.hex_FF7F41, bg = colors.hex_061F23 })
  hl(0, 'DiffChange', { fg = colors.hex_04C5F0, bg = colors.hex_061F23 })
  hl(0, 'DiffDelete', { fg = colors.hex_f93d3b, bg = colors.hex_061F23 })
  hl(0, 'DiffText', { fg = colors.hex_A8D61F, bg = colors.hex_0C3F45, bold = true })

  ----------------------------------------------------------------------
  -- 💡 Diagnostics
  ----------------------------------------------------------------------
  hl(0, 'DiagnosticError', { fg = colors.hex_f93d3b })
  hl(0, 'DiagnosticWarn', { fg = colors.hex_04C5F0 })
  hl(0, 'DiagnosticInfo', { fg = colors.hex_ffbe74 })
  hl(0, 'DiagnosticHint', { fg = colors.hex_FD3E6A })
  hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = colors.hex_f93d3b })

  ----------------------------------------------------------------------
  -- 🧩 Treesitter
  ----------------------------------------------------------------------
  hl(0, '@variable', { fg = colors.hex_C8E967 })
  hl(0, '@function', { fg = colors.hex_7cd699 })
  hl(0, '@string', { fg = colors.hex_FF7F41 })
  hl(0, '@keyword', { fg = colors.hex_9147a8 })
  hl(0, '@type', { fg = colors.hex_E20342 })

  ----------------------------------------------------------------------
  -- 🔭 Telescope (optional)
  ----------------------------------------------------------------------
  hl(0, 'TelescopeBorder', { fg = colors.hex_9147a8 })
  hl(0, 'TelescopeSelection', { fg = colors.hex_04C5F0, bg = colors.hex_092F34, bold = true })

  ----------------------------------------------------------------------
  -- 🪟 Neo-tree
  ----------------------------------------------------------------------
  hl(0, 'NeoTreeNormal', { fg = colors.hex_C8E967, bg = colors.hex_0e091d })
  hl(0, 'NeoTreeRootName', { fg = colors.hex_9147a8, bold = true })
  hl(0, 'NeoTreeDirectoryIcon', { fg = colors.hex_FF7F41 })
  hl(0, 'NeoTreeGitAdded', { fg = colors.hex_FF7F41 })
  hl(0, 'NeoTreeGitDeleted', { fg = colors.hex_f93d3b })
  hl(0, 'NeoTreeGitModified', { fg = colors.hex_04C5F0 })

  ----------------------------------------------------------------------
  -- 💻 Terminal colors
  ----------------------------------------------------------------------
  vim.g.terminal_color_0 = colors.hex_061F23
  vim.g.terminal_color_1 = colors.hex_E20342
  vim.g.terminal_color_2 = colors.hex_FF7F41
  vim.g.terminal_color_3 = colors.hex_04C5F0
  vim.g.terminal_color_4 = colors.hex_ffbe74
  vim.g.terminal_color_5 = colors.hex_FD3E6A
  vim.g.terminal_color_6 = colors.hex_7cd699
  vim.g.terminal_color_7 = colors.hex_A8D61F
end

return M
