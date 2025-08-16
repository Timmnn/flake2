{ pkgs, ... }: {
  programs.fish = {
    shellAliases = {
      la = "eza -la";
      ls = "eza";
      cl = "clear";
    };
    enable = true;
    shellInit = ''
      tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='12-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='One line' --prompt_spacing=Compact --icons='Many icons' --transient=No



      set fish_greeting

      function nix-conf
        pushd ~/flake
        nvim
        popd
      end

      function nvim-conf
        pushd ~/flake/home/modules/neovim/files/
        nvim
        popd
      end



      function ns
        pushd ~/flake
        git add --all
        sudo nixos-rebuild switch --flake ~/flake
        popd
      end



      function qsdev
        if test (count $argv) -eq 0
          echo "Usage: qsdev <widget>"
          return 1
        end

        ns
        qs -c $argv[1]
      end

    '';
  };

}
