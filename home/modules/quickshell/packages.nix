{ pkgs, quickshell, ... }: [ quickshell.packages.${pkgs.system}.default ]
