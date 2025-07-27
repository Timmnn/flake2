{ pkgs, lib, config, ... }: {
  home.file."${config.home.homeDirectory}/.config/waybar".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/flake/home/modules/waybar/files";
}
