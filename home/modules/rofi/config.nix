{ pkgs, lib, config, ... }: {

  home.file."${config.home.homeDirectory}/.config/rofi".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/flake/home/modules/rofi/files";

  home.file."${config.home.homeDirectory}/.local/share/rofi/themes".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/flake/home/modules/rofi/files/themes/spotlight-dark.rasi";

}
