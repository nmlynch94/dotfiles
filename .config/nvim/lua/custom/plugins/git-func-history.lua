local fzf = require 'fzf-lua'

-- Get function name under cursor using Treesitter or fallback to visual selection
local function get_function_name()
  local ts_utils = require 'nvim-treesitter.ts_utils'
  local node = ts_utils.get_node_at_cursor()
  vim.notify('' .. node:field('name')[1], vim.log.levels.INFO)
  while node do
    if node:type():match 'function' then
      local name_node = node:field('name')[1]
      return vim.treesitter.query.get_node_text(name_node, 0)
    end
    node = node:parent()
  end
  return nil
end

vim.keymap.set('v', '<leader>gf', function()
  local fname = get_function_name()
  if not fname then
    vim.notify('This is a message', vim.log.levels.INFO)
    return
  end
end)

return {}
