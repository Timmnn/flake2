{ pkgs, lib, ... }: {
  home.pointerCursor = {
    name = "Bibata-Modern-Ice"; # Exact name, see below
    package = pkgs.bibata-cursors;
    size = 24;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };
}

