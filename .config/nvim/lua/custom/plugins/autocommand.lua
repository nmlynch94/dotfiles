local output_bufnr, command = 471, { 'npx', 'vitest', '--run' }

local term_win, term_buf = nil, nil

local function prompt_terminal_autocmd()
  vim.ui.input({ prompt = 'Command to run in terminal (default: `npx vitest --run .`) : ' }, function(cmd_str)
    vim.ui.input({ prompt = 'Pattern to run commands on save against (default: `*.test.ts`)' }, function(pattern_str)
      if not cmd_str or cmd_str == '' then
        cmd_str = 'npx vitest --run .'
      end
      if not pattern_str or pattern_str == '' then
        pattern_str = '*.test.ts'
      end

      local term_cmd = vim.fn.split(cmd_str)
      local cwd = vim.fn.expand '%:p:h'

      local function open_or_replace_terminal()
        -- If previous terminal exists, wipe it
        if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
          vim.api.nvim_buf_delete(term_buf, { force = true })
        end

        -- Open or reuse the terminal window
        if not term_win or not vim.api.nvim_win_is_valid(term_win) then
          vim.cmd 'botright split'
          vim.cmd 'resize 15'
          term_win = vim.api.nvim_get_current_win()
        else
          vim.api.nvim_set_current_win(term_win)
        end

        -- Create new terminal buffer and run the command
        term_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(term_win, term_buf)
        vim.fn.termopen(term_cmd, { cwd = cwd })
      end

      vim.api.nvim_create_autocmd('BufWritePost', {
        group = vim.api.nvim_create_augroup('TerminalTestRunner', { clear = true }),
        pattern = pattern_str,
        callback = function()
          open_or_replace_terminal()
        end,
      })

      vim.notify 'Autocmd registered. Reuses terminal on save.'
    end)
  end)
end

local function stop_terminal_autocmd()
  -- Clear the autocommand group
  pcall(vim.api.nvim_del_augroup_by_name, 'TerminalTestRunner')

  -- Close the terminal window if still valid
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
  end

  -- Cleanup buffer tracking
  term_buf, term_win = nil, nil

  vim.notify 'Terminal test autocmd stopped.'
end

vim.api.nvim_create_user_command('TerminalTestRunner', prompt_terminal_autocmd, {})
vim.api.nvim_create_user_command('StopTerminalTestRunner', stop_terminal_autocmd, {})

return {}
