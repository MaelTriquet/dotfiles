return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup {
      keymaps = {
        accept_suggestion = ',a',
        clear_suggestion = ',c',
        accept_word = ',w',
      },
    }
  end,
}
