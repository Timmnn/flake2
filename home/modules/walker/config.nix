{ pkgs, lib, config, ... }: {

  home.file."${config.home.homeDirectory}/.config/walker".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/flake/home/modules/walker/files";

}
