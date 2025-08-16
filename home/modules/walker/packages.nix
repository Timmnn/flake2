{ pkgs, walker, ... }: with pkgs; [ walker.packages.${pkgs.system}.default ]
