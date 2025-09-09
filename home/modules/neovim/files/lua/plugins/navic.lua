return {
  'SmiteshP/nvim-navic',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    require('nvim-navic').setup {
      highlight = true,
      separator = ' > ',
      depth_limit = 0, -- 0 means no limit
    }
  end,
}
