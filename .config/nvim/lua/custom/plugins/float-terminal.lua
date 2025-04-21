vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

local state = {
  terminals = {},
}

-- Floating window utility
local function open_floating_win(opts)
  opts = opts or {}

  -- Defaults
  local default_opts = {
    width = 60,
    height = 20,
    border = 'rounded',
    title = 'Floating Window',
    title_pos = 'center',
    relative = 'editor',
    style = 'minimal',
  }

  -- Merge user opts with defaults
  for k, v in pairs(default_opts) do
    if opts[k] == nil then
      opts[k] = v
    end
  end

  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)

  -- Create a scratch buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Window options
  local win_opts = {
    style = opts.style,
    relative = opts.relative,
    width = width,
    height = height,
    row = row,
    col = col,
    border = opts.border,
    title = opts.title,
    title_pos = opts.title_pos,
  }

  -- Open window
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  return { buf = buf, win = win }
end

local toggle_terminal = function(id, title)
  curState = state.terminals[id] or { win = -1, buf = -1 }
  if not vim.api.nvim_win_is_valid(curState.win) then
    state.terminals[id] = open_floating_win { buf = curState.buf, title = title }
    if vim.bo[state.terminals[id].buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
    --Start term in terminal mode so we can type right away
    -- vim.cmd 'normal i'
  else
    vim.api.nvim_win_hide(curState.win)
  end
end

-- term 1
vim.keymap.set({ 'n' }, '<leader>tt', function()
  toggle_terminal(1, 'Terminal One (<leader>tt)')
end)

-- term 2
vim.keymap.set({ 'n' }, '<leader>tp', function()
  toggle_terminal(2, 'Terminal Two (<leader>tp)')
end)

return {}
