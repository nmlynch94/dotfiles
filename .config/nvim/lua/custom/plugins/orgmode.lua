return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    config = function()
      -- Setup orgmode
      require('orgmode').setup {
        org_agenda_files = '~/Dropbox/org/**/*',
        org_default_notes_file = '~/Dropbox/org/refile.org',
        org_log_done = 'note',
      }
      vim.api.nvim_set_hl(0, '@org.agenda.scheduled', { fg = '#FFFFFF' })
      vim.api.nvim_set_hl(0, '@org.keyword.done', { fg = '#00FF00' })
    end,
  },
}
