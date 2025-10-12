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
    "gaming"
    "git"
    "hypr"
    "ides"
    "inventree"
    "js"
    "neovim"
    "python"
    "quickshell"
    "rofi"
    "stylix-export"
    "walker"
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
      import packagesPath { inherit pkgs quickshell walker; }
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
      claude-code
      openssl
      vagrant
      tailscale
      caligula
      vscode-langservers-extracted
      direnv
      pkg-config
      nix-ld
      deno
      freecad-wayland
      zsh
      zoxide
      rpi-imager
      #unityhub
      progress
      dig
      libsForQt5.qtstyleplugin-kvantum
      oh-my-zsh
      restic
      rclone
      libnotify
      imagemagick
      luajitPackages.magick
      #notion-app # doesnt work
      spicetify-cli
      nwg-look
      lua5_1
      jdk
      termius
      luarocks
      psmisc
      warp-terminal
      appimage-run
      pgadmin4
      tableplus
      pywal
      kitty
      jq
      libsForQt5.filelight
      docker_25
      insomnia
      rustup
      bluez
      networkmanager
      gnumake42
    ] ++ modulePackages;

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/harmonic16-dark.yaml";
    polarity = "dark";
    targets = {
      neovim = {
        enable = true;
        plugin = "base16-nvim";
      };
    };
  };

  home.file = {
    ".cache/stylix/colors.json".text =
      builtins.toJSON config.lib.stylix.colors.withHashtag;
  };

  home.sessionVariables = { JAVA_HOME = "${pkgs.jdk}"; };

  home.file = {
    ".config/kitty/kitty.conf".text = ''
      font_family  Fire Code Retina
      font_size 9
      background_opacity 0.9
      confirm_os_window_close 0
    '';

    ".local/share/applications/dbeaver.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=DBeaver
      Comment=Universal Database Tool
      Exec=flatpak run io.dbeaver.DBeaverCommunity
      Icon=dbeaver
      Categories=Development;Database;
      StartupNotify=true
      NoDisplay=false
      StartupWMClass=DBeaver
    '';
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

