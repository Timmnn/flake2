{ pkgs, lib, config, ... }: {
  # Stylix Color Export Module
  # Automatically exports stylix colors to multiple formats during system rebuild
  
  home.activation.stylixColorExport = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Run the color export script after stylix has generated its palette.json
    if [ -f "$HOME/.config/stylix/palette.json" ]; then
      echo "Exporting stylix colors to multiple formats..."
      export PATH="${pkgs.jq}/bin:$PATH"
      ${pkgs.bash}/bin/bash ${./files/export-colors.sh}
    else
      echo "Warning: stylix palette.json not found, skipping color export"
    fi
  '';
}