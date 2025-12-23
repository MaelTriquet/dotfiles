return {
  dir = vim.fn.expand '$HOME/.config/nvim/lua/custom/myterm',
  name = 'myterm',
  config = function()
    -- Only require the `myterm` plugin here
    require 'custom.myterm'
    -- Now define keybindings and commands
    local myterm = require 'custom.myterm'

    -- Define user command
    vim.api.nvim_create_user_command('MyTermToggle', function()
      myterm.toggle()
    end, { desc = 'Toggle MyTerm terminal' })

    -- Set up keybindings
    vim.keymap.set('n', '<localleader>.', myterm.toggle, { desc = 'Toggle MyTerm terminal' })
    for i = 1, 9 do
      vim.keymap.set('n', '<localleader>' .. i, function()
        myterm.toggle(i)
      end, {
        desc = 'Toggle MyTerm ' .. i,
      })
      vim.keymap.set('t', '<localleader>' .. i, function()
        myterm.toggle(i)
      end, {
        desc = 'Toggle MyTerm ' .. i,
      })
    end
    vim.keymap.set('t', '<localleader>.', myterm.toggle, { desc = 'Toggle last opened MyTerm terminal' })
  end,
}
