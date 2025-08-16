{ pkgs, lib, config, ... }: {
  home.file."${config.home.homeDirectory}/.config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/flake/home/modules/neovim/files";
}
