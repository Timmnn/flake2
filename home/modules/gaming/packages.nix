{ pkgs, ... }:
with pkgs; [
  steam
  vesktop
  prismlauncher
  (appimageTools.wrapType2 {
    pname = "curseforge";
    version = "latest";
    src = let
      curseforge-zip = fetchurl {
        url =
          "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.zip";
        sha256 = "1vsprxqswl6d0bsqj93xnn913y2k9h78dmxbzk766y7sidvl9q3h";
      };
    in runCommand "curseforge.AppImage" { } ''
      ${unzip}/bin/unzip ${curseforge-zip}
      cp *.AppImage $out
      chmod +x $out
    '';
  })
]

