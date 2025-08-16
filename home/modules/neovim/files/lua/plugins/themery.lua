return {
  'zaldih/themery.nvim',
  config = function()
    local function read_file(path)
      local f = io.open(path, 'r')
      if not f then
        return nil
      end
      local content = f:read '*a'
      f:close()
      return content
    end

    local function normalize_colors(tbl)
      local fixed = {}
      for k, v in pairs(tbl) do
        if type(v) == 'string' and not vim.startswith(v, '#') then
          fixed[k] = '#' .. v
        else
          fixed[k] = v
        end
      end
      return fixed
    end

    require('themery').setup {
      themes = {
        {
          name = 'tokyonight',
          colorscheme = 'tokyonight',
        },
        {
          name = 'gruvbox',
          colorscheme = 'gruvbox',
        },
        {
          name = 'catppuccin-latte',
          colorscheme = 'catppuccin-latte',
        },
        {
          name = 'catppuccin-frappe',
          colorscheme = 'catppuccin-frappe',
        },
        {
          name = 'catppuccin-macchiato',
          colorscheme = 'catppuccin-macchiato',
        },
        {
          name = 'catppuccin-mocha',
          colorscheme = 'catppuccin-mocha',
        },
        {
          name = 'kanagawa',
          colorscheme = 'kanagawa',
        },
        {
          name = 'onedark',
          colorscheme = 'onedark',
        },
        {
          name = 'everforest',
          colorscheme = 'everforest',
        },
        {
          name = 'sonokai',
          colorscheme = 'sonokai',
        },
        {
          name = 'dracula',
          colorscheme = 'dracula',
        },
        {
          name = 'nord',
          colorscheme = 'nord',
        },
        {
          name = 'one',
          colorscheme = 'one',
        },
        {
          name = 'codedark',
          colorscheme = 'codedark',
        },
        {
          name = 'ayu',
          colorscheme = 'ayu',
        },
        {
          name = 'gruvbox-material',
          colorscheme = 'gruvbox-material',
        },
        {
          name = 'papercolor',
          colorscheme = 'PaperColor',
        },
        {
          name = 'iceberg',
          colorscheme = 'iceberg',
        },
        {
          name = 'nightfox',
          colorscheme = 'nightfox',
        },
        {
          name = 'github',
          colorscheme = 'github_dark',
        },
        {
          name = 'melange',
          colorscheme = 'melange',
        },
        {
          name = 'moonfly',
          colorscheme = 'moonfly',
        },
        {
          name = 'base16-stylix',
          colorscheme = 'base16-stylix',
        },
      }, -- close themes table
      livePreview = true,
    } -- close setup
  end,
}
