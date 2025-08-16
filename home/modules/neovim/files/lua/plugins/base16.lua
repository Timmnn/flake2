return {
  'RRethy/base16-nvim',
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

    -- Create a user command that acts as a colorscheme
    vim.api.nvim_create_user_command('ColorschemeBase16Stylix', function()
      local ok, colorscheme = pcall(require, 'base16-colorscheme')
      if not ok then
        return
      end

      local palette_path = vim.fn.expand '~/.config/stylix/palette.json'
      local json = read_file(palette_path)
      if json then
        local parsed = vim.fn.json_decode(json)
        colorscheme.setup(normalize_colors(parsed))
      else
        colorscheme.setup {
          base00 = '#16161D',
          base01 = '#2c313c',
          base02 = '#3e4451',
          base03 = '#6c7891',
          base04 = '#565c64',
          base05 = '#abb2bf',
          base06 = '#9a9bb3',
          base07 = '#c5c8e6',
          base08 = '#e06c75',
          base09 = '#d19a66',
          base0A = '#e5c07b',
          base0B = '#98c379',
          base0C = '#56b6c2',
          base0D = '#0184bc',
          base0E = '#c678dd',
          base0F = '#a06949',
        }
      end

      vim.cmd [[
  highlight Normal guibg=none ctermbg=none
  highlight NormalFloat guibg=none ctermbg=none
  highlight SignColumn guibg=none ctermbg=none
  highlight LineNr guibg=none ctermbg=none
  highlight EndOfBuffer guibg=none ctermbg=none
]]
    end, {})

    -- Optional: automatically apply on startup
    vim.cmd 'ColorschemeBase16Stylix'
  end,
}
