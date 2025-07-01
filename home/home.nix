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
    ./modules/fish/config.nix
    ./modules/cursor/config.nix
    ./modules/dunst/config.nix
    ./modules/quickshell/config.nix
    walker.homeManagerModules.default
    stylix.nixosModules.stylix

  ];

  home.stateVersion = "25.05";
  home.username = "timm";
  home.homeDirectory = "/home/timm";

  home.packages = with pkgs;
    [
      bat
      nixfmt-classic
      vesktop
      _1password-gui
      sunshine
      teamviewer
      btop
      libnotify
      bluetui
      moonlight-qt
      pavucontrol
      bun
      firefox
      kitty
      nwg-look
      gnome-calculator
      psmisc
      yazi
      lnav
      tldr
      docker_25
      vlc
      insomnia
      rustup
      gcc
      ripgrep
      eza
      unzip
      uv
      pyright
      gnumake42
      tree
    ] ++ neovimPkgs ++ gitPkgs ++ fishPkgs ++ cursorPkgs ++ quickshellPkgs
    ++ hyprPkgs ++ idesPkgs ++ pythonPkgs;

  stylix = {
    enable = true; # You commented this out, enable it for Stylix to work
    base16Scheme = { };
    polarity = "dark";
  };

  programs.walker = {
    enable = true;
    runAsService = true;

    # All options from the config.json can be used here.
    config = {
      search.placeholder = "Example";
      ui.fullscreen = true;
      list = { height = 200; };
      websearch.prefix = "?";
      switcher.prefix = "/";
    };

    # If this is not set the default styling is used.
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Fira Code Retina";
      font_size = 9.0;
      background_opacity = "0.9";
      confirm_os_window_close = 0;
    };
  };

}

