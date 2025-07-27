{ config, pkgs, lib, walker, quickshell, stylix, ... }:

let
  neovimPkgs = import ./modules/neovim/packages.nix { inherit pkgs; };
  gitPkgs = import ./modules/git/packages.nix { inherit pkgs; };
  fishPkgs = import ./modules/git/packages.nix { inherit pkgs; };
  cursorPkgs = import ./modules/cursor/packages.nix { inherit pkgs; };
  quickshellPkgs =
    import ./modules/quickshell/packages.nix { inherit pkgs quickshell; };
  pythonPkgs =
    import ./modules/python/packages.nix { inherit pkgs quickshell; };
  idesPkgs = import ./modules/ides/packages.nix { inherit pkgs quickshell; };
  hyprPkgs = import ./modules/hypr/packages.nix { inherit pkgs quickshell; };

in {
  imports = [
    ./modules/neovim/config.nix
    ./modules/hypr/config.nix
    ./modules/git/config.nix
    ./modules/waybar/config.nix
    ./modules/fish/config.nix
    ./modules/cursor/config.nix
    ./modules/dunst/config.nix
    ./modules/quickshell/config.nix
    #./modules/walker/config.nix
    #walker.homeManagerModules.default

  ];

  home.stateVersion = "25.05";
  home.username = "timm";
  home.homeDirectory = "/home/timm";

  home.packages = with pkgs;
    [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.noto
      nerd-fonts.hack
      nerd-fonts.ubuntu
      bat
      nixfmt-classic
      vesktop
      spotify
      _1password-gui
      sunshine
      typescript-language-server
      typescript
      prettier
      nodejs_22
      emmet-ls
      teamviewer
      btop
      libnotify
      bluetui
      moonlight-qt
      pavucontrol
      bun
      spicetify-cli
      firefox
      kitty
      nautilus
      alacritty
      nwg-look
      gnome-calculator
      psmisc
      steam
      yazi
      lnav
      pywal

      tldr
      docker_25
      vlc
      insomnia
      rustup
      gcc
      rofi
      ripgrep
      eza
      unzip
      waybar
      blueman
      bluez
      networkmanager
      uv
      pyright
      gnumake42
      tree
    ] ++ neovimPkgs ++ gitPkgs ++ fishPkgs ++ cursorPkgs ++ quickshellPkgs
    ++ hyprPkgs ++ idesPkgs ++ pythonPkgs;

  stylix = {
    enable = true; # You commented this out, enable it for Stylix to work
    base16Scheme = "${pkgs.base16-schemes}/share/themes/deep-oceanic-next.yaml";
    polarity = "dark";
    #pywal.enable = true;
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Fira Code Retina";
      font_size = 9.0;
      confirm_os_window_close = 0;
    };
  };

}

