{ pkgs, lib, config, ... }: {

  home.file."${config.home.homeDirectory}/.config/wl-kbptr".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/flake/home/modules/wl-kbptr/files";

}
