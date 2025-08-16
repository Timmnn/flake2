{ pkgs, lib, config, ... }:
let stylixColors = config.lib.stylix.colors;
in {

  home.file."${config.home.homeDirectory}/.config/waybar".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/flake/home/modules/waybar/files";

}
