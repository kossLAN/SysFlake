-- A plugin to add copilot support
-- https://github.com/zbirenbaum/copilot.lua

return {
  'zbirenbaum/copilot.lua',
  version = '*',
  opts = {
    filetypes = {
      ['*'] = false, -- Disable copilot by default
    },
  },
}
