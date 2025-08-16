{ pkgs, ... }:
with pkgs; [
  bat # Replacement for cat
  unzip # Unpack .zip Archives
  eza # Replacement for ls
  btop
  lnav
  yazi
  gcc
  tree
  ripgrep
  tldr
]
