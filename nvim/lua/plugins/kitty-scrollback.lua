return {
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLine' },
    event = { 'User KittyScrollbackLaunch' },
    version = '^6.0.0',
    opts = {},
  },
}
