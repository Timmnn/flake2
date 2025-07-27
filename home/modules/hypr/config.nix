

{ pkgs, lib, config, ... }: {
  home.file."${config.home.homeDirectory}/.config/hypr".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/flake/home/modules/hypr/files";
}
