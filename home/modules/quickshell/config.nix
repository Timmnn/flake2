{ pkgs, lib, config, ... }: {

  home.file."${config.home.homeDirectory}/.config/quickshell".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/flake/home/modules/quickshell/files";
}
