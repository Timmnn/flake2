{ pkgs, quickshell, ... }: [
  quickshell.packages.${pkgs.system}.default
  qt6.qtimageformats # amog
  qt6.qt5compat # shader fx
  qt6.qtmultimedia # flicko shell
  qt6.qtdeclarative # qtdecl types in path
]
