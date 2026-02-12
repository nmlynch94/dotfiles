vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.clipboard = 'unnamedplus'
vim.g.mapleader = ' '
vim.opt.winborder = 'rounded'
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

local set = vim.keymap.set

set('n', '<leader>o', ':update<CR> :source<CR>')

vim.pack.add {
  { src = 'https://github.com/folke/tokyonight.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/jake-stewart/multicursor.nvim' },
  { src = 'https://github.com/mfussenegger/nvim-lint' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/L3MON4D3/LuaSnip' },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  { src = 'https://github.com/NeogitOrg/neogit' },
  { src = 'https://github.com/sindrets/diffview.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/nvim-orgmode/orgmode' },

  -- Dependencies
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '*' },
}
require('luasnip.loaders.from_vscode').lazy_load()
require('blink.cmp').setup()

require('nvim-autopairs').setup()

require('mason').setup()
--
require('tokyonight').setup()
vim.cmd 'colorscheme tokyonight-night'
vim.cmd ':hi statusline guibg=NONE'

require('oil').setup {
  default_file_explorer = true,
}

require('orgmode').setup {
  org_agenda_files = '~/Dropbox/org/**/*',
  org_default_notes_file = '~/Dropbox/org/refile.org',
  org_capture_templates = {
    t = {
      description = 'Task',
      template = '* TODO %?\n %u',
      target = '~/Dropbox/org/todo.org',
    },
    n = {
      description = 'Notes',
      template = '* %?',
      target = '~/Dropbox/org/notes.org',
    },
    j = {
      description = 'Journal',
      template = '* %u\n %?',
      target = '~/Dropbox/org/journal.org',
    },
  },
}

vim.lsp.enable 'org'

--
-- fzf lua
--

local fzf = require 'fzf-lua'
fzf.setup { 'telescope' }

set('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
set('n', '<leader>st', function()
  require('fzf-lua').grep {
    prompt = 'HELP> ',
    search = '',
    cwd = vim.env.VIMRUNTIME .. '/doc',
    rg_opts = '--column --line-number --no-heading --color=always --smart-case',
  }
end, { desc = '[S]earch [T]ext of [H]elp' })
set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
set('n', '<leader>ss', fzf.lsp_document_symbols, { desc = '[S]earch [S]ymbols' })
set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics' })
set({ 'n', 'v' }, '<leader>gh', fzf.git_bcommits, { desc = '[S]earch [B]uffer history' })
set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
set('n', '<leader>s.', fzf.oldfiles, { desc = '[S]earch Recent Files' })
set('n', '<leader><leader>', fzf.buffers, { desc = '[ ] Find existing buffers' })
set('n', '<leader>sn', function()
  fzf.files {
    cwd = vim.fn.stdpath 'config',
    prompt = 'Neovim Config Files>',
    no_ignore = true,
  }
end, { desc = '[S]earch [N]eovim files' })

set('n', '<leader>sog', function()
  fzf.grep {
    cwd = vim.fn.expand '~' .. '/Dropbox/org',
    search = '',
    filespec = 'notes.org',
    prompt = 'Notes>',
    rg_opts = '--with-filename --column --line-number --no-heading --color=never',
  }
end, { desc = '[S]earch [N]otes (notes.org)' })
set('n', '<leader>soh', function()
  fzf.grep {
    cwd = vim.fn.expand '~' .. '/Dropbox/org',
    search = '',
    filespec = 'notes.org',
    prompt = 'Notes Headings>',
    rg_opts = "--with-filename --column --line-number --no-heading --color=never '^\\*+ '",
  }
end, { desc = '[S]earch [H]eadings in (notes.org)' })
set('n', '<leader>sof', function()
  fzf.files {
    cwd = vim.fn.expand '~' .. '/Dropbox/org',
    prompt = '[S]earch [O]rg files',
    no_ignore = true,
  }
end, { desc = '[S]earch [O]rg files' })

--
-- lsp, linting, mason, and conform formatting
--

local lsp_info = {
  {
    masondeps = { 'clangd', 'clang-format', 'cpplint' },
    lsp_configuration = { ['clangd'] = { filetypes = { 'c', 'cpp' } } },
    linters = { cpp = { 'cpplint' } },
    formatters_ft = { c = { 'clang-format' }, cpp = { 'clang_format' } },
    formatters = { clang_format = { prepend_args = { '--style=file', '--fallback-style=Chromium' } } },
  },
  {
    masondeps = { 'stylua', 'lua-language-server' },
    lsp_configuration = { ['lua_ls'] = { filetypes = { 'lua' } } },
    linters = {},
    formatters_ft = { lua = { 'stylua' } },
  },
  {
    masondeps = { 'bash-language-server', 'shellcheck', 'shfmt' },
    lsp_configuration = { ['bashls'] = { filetypes = { 'sh' } } },
    linters = { sh = { 'shellcheck' } },
    formatters_ft = { sh = { 'shfmt' } },
  },
  {
    masondeps = { 'ruff' },
    lsp_configuration = {
      ['pylsp'] = {
        filetypes = { 'python' },
        plugins = {
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
          autopep8 = { enabled = false },
          yapf = { enabled = false },
          mccabe = { enabled = false },
          pylsp_mypy = { enabled = false },
          pylsp_black = { enabled = false },
          pylsp_isort = { enabled = false },
        },
      },
    },
    linters = { python = { 'ruff' } },
    formatters_ft = { python = { 'isort', 'black' } },
  },
  {
    masondeps = { 'gopls', 'golangci-lint', 'crlfmt' },
    lsp_configuration = {
      ['gopls'] = {
        filetypes = { 'go' },
      },
    },
    linters = { go = { 'golangcilint' } },
    formatters_ft = { go = { 'gofmt' } },
  },
}

-- Merge all mason deps and install them
local ensure_installed = {}
for _, lang_config in pairs(lsp_info) do
  for _, masonitem in pairs(lang_config.masondeps) do
    table.insert(ensure_installed, masonitem)
  end
end

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- Configure LSP
for _, entry in pairs(lsp_info) do
  for server, config in pairs(entry.lsp_configuration) do
    vim.lsp.config(server, config)
    vim.lsp.enable { server }
  end
end

local linter_config = {}
for _, entry in pairs(lsp_info) do
  for tool, linters in pairs(entry.linters or {}) do
    linter_config[tool] = linters
  end
end

-- Configure linters
require('lint').linters_by_ft = linter_config

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})

-- Configure formatters
local formatters_by_ft = {}
for _, entry in pairs(lsp_info) do
  for ft, formatter_by_ft in pairs(entry.formatters_ft or {}) do
    formatters_by_ft[ft] = formatter_by_ft
  end
end

local formatters = {}
for _, entry in pairs(lsp_info) do
  for key, format_config in pairs(entry.formatters or {}) do
    formatters[key] = format_config
  end
end

require('conform').setup {
  formatters_by_ft = formatters_by_ft,
  formatters = formatters,
  log_level = vim.log.levels.DEBUG,
  format_on_save = { lsp_format = 'fallback', timeout_ms = 10000 },
}
set({ 'n' }, '<leader>f', function()
  require('conform').format({ notify_no_formatters = true, lsp_format = 'fallback', timeout_ms = 20000 }, { desc = 'Format current buffer' })
end)
--

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-fzf', { clear = true }),
  callback = function(event)
    -- Define a helper function for keybindings with descriptions
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename the symbol under the cursor
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Trigger a code action
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Find references to the symbol under the cursor
    map('grr', fzf.lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the symbol
    map('gri', fzf.lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the definition of the symbol
    map('grd', fzf.lsp_definitions, '[G]oto [D]efinition')

    -- Jump to the declaration (e.g., header files in C)
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- List document symbols in the current buffer
    map('gO', fzf.lsp_document_symbols, 'Open Document Symbols')

    -- List symbols across the entire workspace
    map('gW', fzf.lsp_workspace_symbols, 'Open Workspace Symbols')

    -- Jump to the type definition of the symbol
    map('grt', fzf.lsp_typedefs, '[G]oto [T]ype Definition')
  end,
})

vim.opt.updatetime = 250 -- faster CursorHold

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('diag-float', { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      scope = 'cursor', -- "line" also ok
      border = 'rounded',
      source = 'if_many',
    })
  end,
})

-- QOL
set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
set('n', '<C-w>v', '<C-w>v<C-w><C-l>', { desc = 'Split vertical and jump to window' })
set('n', '<C-w>s', '<C-w>s<C-w><C-j>', { desc = 'Split horizontal and jump to window' })
set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
set('n', '<C-u>', '<C-u>zz', { desc = 'Centered jump up' })
set('n', '<C-d>', '<C-d>zz', { desc = 'Centered jump down' })
set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- open quickfix
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

set('n', 'dd', function()
  local line = vim.api.nvim_get_current_line()
  if line:match '^%s*$' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('"_dd', true, false, true), 'n', false)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('dd', true, false, true), 'n', false)
  end
end, { noremap = true, silent = true })

set('n', 'p', 'P', { desc = 'Paste without yanking' })
--
-- multicursor
--
local mc = require 'multicursor-nvim'
mc.setup()

-- Add or skip cursor above/below the main cursor.
set({ 'n', 'x' }, '<up>', function()
  mc.lineAddCursor(-1)
end)
set({ 'n', 'x' }, '<down>', function()
  mc.lineAddCursor(1)
end)
set({ 'n', 'x' }, '<leader><up>', function()
  mc.lineSkipCursor(-1)
end)
set({ 'n', 'x' }, '<leader><down>', function()
  mc.lineSkipCursor(1)
end)

-- Add or skip adding a new cursor by matching word/selection
set({ 'n', 'x' }, '<leader>n', function()
  mc.matchAddCursor(1)
end, { desc = 'Open diagnostic [Q]uickfix list' })
set({ 'n', 'x' }, '<leader>s', function()
  mc.matchSkipCursor(1)
end)
set({ 'n', 'x' }, '<leader>N', function()
  mc.matchAddCursor(-1)
end)
set({ 'n', 'x' }, '<leader>S', function()
  mc.matchSkipCursor(-1)
end)

-- Add and remove cursors with control + left click.
set('n', '<c-leftmouse>', mc.handleMouse)
set('n', '<c-leftdrag>', mc.handleMouseDrag)
set('n', '<c-leftrelease>', mc.handleMouseRelease)

-- Disable and enable cursors.
set({ 'n', 'x' }, '<c-q>', mc.toggleCursor)

-- Add a cursor for all matches of cursor word/selection in the document.
set({ 'n', 'x' }, '<leader>A', mc.matchAllAddCursors)

-- Add a cursor to every search result in the buffer.
set('n', '<leader>/A', mc.searchAllAddCursors)

-- Mappings defined in a keymap layer only apply when there are
-- multiple cursors. This lets you have overlapping mappings.
mc.addKeymapLayer(function(layerSet)
  -- Select a different cursor as the main one.
  layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
  layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

  -- Delete the main cursor.
  layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

  -- Enable and clear cursors using escape.
  layerSet('n', '<esc>', function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
end)

-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, 'MultiCursorCursor', { reverse = true })
hl(0, 'MultiCursorVisual', { link = 'Visual' })
hl(0, 'MultiCursorSign', { link = 'SignColumn' })
hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
hl(0, 'MultiCursorDisabledCursor', { reverse = true })
hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })

-- Neogit config
local neogit = require 'neogit'
set('n', '<leader>gg', neogit.open, { desc = 'Open neogit UI' })

neogit.setup {
  integrations = {
    diffview = true,
    fzf_lua = true,
  },
}

-- Gitsigns
require('gitsigns').setup {
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end)

    -- Actions
    map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage Hunk' })
    map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset Hunk' })

    map('v', '<leader>gs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'Stage Hunk' })

    map('v', '<leader>gr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'Reset Hunk' })

    map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage Buffer' })
    map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
    map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview Hunk' })
    map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = 'Preview Hunk Inline' })

    map('n', '<leader>gb', function()
      gitsigns.blame_line { full = true }
    end, { desc = 'Blame Line' })

    map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Diff This' })

    map('n', '<leader>gD', function()
      gitsigns.diffthis '~'
    end, { desc = 'Diff This' })

    map('n', '<leader>gQ', function()
      gitsigns.setqflist 'all'
    end, { desc = 'Set QuickFix List' })
    map('n', '<leader>gq', gitsigns.setqflist)

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle Current Line Blame' })
    map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'Toggle Word Diff' })

    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Select Hunk' })
  end,
}

-- Toggleable term
local term_buf = nil
local term_win = nil

function ToggleTerminal()
  -- If terminal window is open, hide it
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end

  -- Create buffer if needed
  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(term_buf, 'bufhidden', 'hide')
  end

  -- Open split at bottom
  vim.cmd 'botright split'
  vim.cmd 'resize 15'

  term_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(term_win, term_buf)

  -- Start terminal if not already
  if vim.bo[term_buf].buftype ~= 'terminal' then
    vim.fn.termopen(vim.o.shell)
  end

  vim.cmd 'startinsert'
end

set('n', '<C-t>', function()
  ToggleTerminal()
end)

-- default marks to global
set('n', 'ma', 'mA')
set('n', "'a", "'A")
set('n', 'ms', 'mS')
set('n', "'s", "'S")
set('n', 'md', 'mD')
set('n', "'d", "'D")
