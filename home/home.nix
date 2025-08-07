{ config, pkgs, lib, walker, quickshell, stylix, ... }:

let

  # AUTO LOAD MODULES
  modulesDir = ./modules;
  activatedModules = [
    "cmd-tools"
    "cursor"
    "desktop-apps"
    "dunst"
    "fish"
    "fonts"
    "git"
    "hypr"
    "ides"
    "js"
    "neovim"
    "python"
    "quickshell"
    "waybar"
  ];
  moduleNames = builtins.filter (name: builtins.elem name activatedModules)
    (builtins.attrNames (lib.filterAttrs (name: type: type == "directory")
      (builtins.readDir modulesDir)));
  moduleConfigs = builtins.filter (path: builtins.pathExists path)
    (map (name: modulesDir + "/${name}/config.nix") moduleNames);
  modulePackages = lib.flatten (map (name:
    let packagesPath = modulesDir + "/${name}/packages.nix";
    in if builtins.pathExists packagesPath then
      import packagesPath { inherit pkgs quickshell; }
    else
      [ ]) moduleNames);

in {
  imports = moduleConfigs ++ [ ];

  home.stateVersion = "25.05";
  home.username = "timm";
  home.homeDirectory = "/home/timm";

  home.packages = with pkgs;
    [
      nixfmt-classic
      vesktop
      claude-code
      openssl
      direnv
      pkg-config
      nix-ld
      btop
      zsh
      oh-my-zsh
      libnotify
      #notion-app # doesnt work
      spicetify-cli
      nwg-look
      psmisc
      warp-terminal
      steam
      yazi
      lnav
      pywal
      docker_25
      insomnia
      rustup
      gcc
      rofi
      bluez
      networkmanager
      gnumake42
      tree
    ] ++ modulePackages;

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

  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" ];
    };
  };

}

