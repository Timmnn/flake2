#!/usr/bin/env bash

# Stylix Color Export Script
# Generates multiple color formats from stylix palette.json

PALETTE_FILE="$HOME/.config/stylix/palette.json"
OUTPUT_DIR="$HOME/.config/stylix"

if [ ! -f "$PALETTE_FILE" ]; then
    echo "Stylix palette.json not found at $PALETTE_FILE"
    exit 1
fi

echo "Exporting stylix colors to multiple formats..."

# Read colors from palette.json
base00=$(jq -r '.base00' "$PALETTE_FILE")
base01=$(jq -r '.base01' "$PALETTE_FILE")
base02=$(jq -r '.base02' "$PALETTE_FILE")
base03=$(jq -r '.base03' "$PALETTE_FILE")
base04=$(jq -r '.base04' "$PALETTE_FILE")
base05=$(jq -r '.base05' "$PALETTE_FILE")
base06=$(jq -r '.base06' "$PALETTE_FILE")
base07=$(jq -r '.base07' "$PALETTE_FILE")
base08=$(jq -r '.base08' "$PALETTE_FILE")
base09=$(jq -r '.base09' "$PALETTE_FILE")
base0A=$(jq -r '.base0A' "$PALETTE_FILE")
base0B=$(jq -r '.base0B' "$PALETTE_FILE")
base0C=$(jq -r '.base0C' "$PALETTE_FILE")
base0D=$(jq -r '.base0D' "$PALETTE_FILE")
base0E=$(jq -r '.base0E' "$PALETTE_FILE")
base0F=$(jq -r '.base0F' "$PALETTE_FILE")

# 1. Generate CSS file for waybar and other apps
cat > "$OUTPUT_DIR/colors.css" << EOF
/* Stylix colors dynamically generated from palette.json */
@define-color base00 #${base00};
@define-color base01 #${base01};
@define-color base02 #${base02};
@define-color base03 #${base03};
@define-color base04 #${base04};
@define-color base05 #${base05};
@define-color base06 #${base06};
@define-color base07 #${base07};
@define-color base08 #${base08};
@define-color base09 #${base09};
@define-color base0A #${base0A};
@define-color base0B #${base0B};
@define-color base0C #${base0C};
@define-color base0D #${base0D};
@define-color base0E #${base0E};
@define-color base0F #${base0F};

/* Common app color mappings */
@define-color background @base00;
@define-color foreground @base05;
@define-color primary @base0D;
@define-color secondary @base0C;
@define-color accent @base0A;
@define-color urgent @base08;
@define-color warning @base09;
@define-color success @base0B;

/* Legacy waybar color mappings */
@define-color color7 @base05;
@define-color color9 @base0D;
@define-color color1 @base01;
@define-color color2 @base02;
EOF

# 2. Generate CSV file for spreadsheet apps
cat > "$OUTPUT_DIR/colors.csv" << EOF
name,hex,rgb
base00,#${base00},$(printf "%d,%d,%d" 0x${base00:0:2} 0x${base00:2:2} 0x${base00:4:2})
base01,#${base01},$(printf "%d,%d,%d" 0x${base01:0:2} 0x${base01:2:2} 0x${base01:4:2})
base02,#${base02},$(printf "%d,%d,%d" 0x${base02:0:2} 0x${base02:2:2} 0x${base02:4:2})
base03,#${base03},$(printf "%d,%d,%d" 0x${base03:0:2} 0x${base03:2:2} 0x${base03:4:2})
base04,#${base04},$(printf "%d,%d,%d" 0x${base04:0:2} 0x${base04:2:2} 0x${base04:4:2})
base05,#${base05},$(printf "%d,%d,%d" 0x${base05:0:2} 0x${base05:2:2} 0x${base05:4:2})
base06,#${base06},$(printf "%d,%d,%d" 0x${base06:0:2} 0x${base06:2:2} 0x${base06:4:2})
base07,#${base07},$(printf "%d,%d,%d" 0x${base07:0:2} 0x${base07:2:2} 0x${base07:4:2})
base08,#${base08},$(printf "%d,%d,%d" 0x${base08:0:2} 0x${base08:2:2} 0x${base08:4:2})
base09,#${base09},$(printf "%d,%d,%d" 0x${base09:0:2} 0x${base09:2:2} 0x${base09:4:2})
base0A,#${base0A},$(printf "%d,%d,%d" 0x${base0A:0:2} 0x${base0A:2:2} 0x${base0A:4:2})
base0B,#${base0B},$(printf "%d,%d,%d" 0x${base0B:0:2} 0x${base0B:2:2} 0x${base0B:4:2})
base0C,#${base0C},$(printf "%d,%d,%d" 0x${base0C:0:2} 0x${base0C:2:2} 0x${base0C:4:2})
base0D,#${base0D},$(printf "%d,%d,%d" 0x${base0D:0:2} 0x${base0D:2:2} 0x${base0D:4:2})
base0E,#${base0E},$(printf "%d,%d,%d" 0x${base0E:0:2} 0x${base0E:2:2} 0x${base0E:4:2})
base0F,#${base0F},$(printf "%d,%d,%d" 0x${base0F:0:2} 0x${base0F:2:2} 0x${base0F:4:2})
EOF

# 3. Generate shell variables file
cat > "$OUTPUT_DIR/colors.sh" << EOF
#!/usr/bin/env bash
# Stylix color variables for shell scripts

export STYLIX_BASE00="#${base00}"
export STYLIX_BASE01="#${base01}"
export STYLIX_BASE02="#${base02}"
export STYLIX_BASE03="#${base03}"
export STYLIX_BASE04="#${base04}"
export STYLIX_BASE05="#${base05}"
export STYLIX_BASE06="#${base06}"
export STYLIX_BASE07="#${base07}"
export STYLIX_BASE08="#${base08}"
export STYLIX_BASE09="#${base09}"
export STYLIX_BASE0A="#${base0A}"
export STYLIX_BASE0B="#${base0B}"
export STYLIX_BASE0C="#${base0C}"
export STYLIX_BASE0D="#${base0D}"
export STYLIX_BASE0E="#${base0E}"
export STYLIX_BASE0F="#${base0F}"

# Convenience aliases
export STYLIX_BG="\$STYLIX_BASE00"
export STYLIX_FG="\$STYLIX_BASE05"
export STYLIX_PRIMARY="\$STYLIX_BASE0D"
export STYLIX_SECONDARY="\$STYLIX_BASE0C"
export STYLIX_ACCENT="\$STYLIX_BASE0A"
export STYLIX_URGENT="\$STYLIX_BASE08"
export STYLIX_WARNING="\$STYLIX_BASE09"
export STYLIX_SUCCESS="\$STYLIX_BASE0B"
EOF

# 4. Generate INI/config file format
cat > "$OUTPUT_DIR/colors.ini" << EOF
[colors]
base00 = #${base00}
base01 = #${base01}
base02 = #${base02}
base03 = #${base03}
base04 = #${base04}
base05 = #${base05}
base06 = #${base06}
base07 = #${base07}
base08 = #${base08}
base09 = #${base09}
base0A = #${base0A}
base0B = #${base0B}
base0C = #${base0C}
base0D = #${base0D}
base0E = #${base0E}
base0F = #${base0F}

[semantic]
background = #${base00}
foreground = #${base05}
primary = #${base0D}
secondary = #${base0C}
accent = #${base0A}
urgent = #${base08}
warning = #${base09}
success = #${base0B}
EOF

# 5. Generate TOML format
cat > "$OUTPUT_DIR/colors.toml" << EOF
[base16]
base00 = "#${base00}"
base01 = "#${base01}"
base02 = "#${base02}"
base03 = "#${base03}"
base04 = "#${base04}"
base05 = "#${base05}"
base06 = "#${base06}"
base07 = "#${base07}"
base08 = "#${base08}"
base09 = "#${base09}"
base0A = "#${base0A}"
base0B = "#${base0B}"
base0C = "#${base0C}"
base0D = "#${base0D}"
base0E = "#${base0E}"
base0F = "#${base0F}"

[semantic]
background = "#${base00}"
foreground = "#${base05}"
primary = "#${base0D}"
secondary = "#${base0C}"
accent = "#${base0A}"
urgent = "#${base08}"
warning = "#${base09}"
success = "#${base0B}"
EOF

# 6. Copy colors.css to waybar directory for easy access
mkdir -p "$HOME/.config/waybar"
cp "$OUTPUT_DIR/colors.css" "$HOME/.config/waybar/colors.css"

echo "✓ Generated: $OUTPUT_DIR/colors.css"
echo "✓ Generated: $OUTPUT_DIR/colors.csv"
echo "✓ Generated: $OUTPUT_DIR/colors.sh"
echo "✓ Generated: $OUTPUT_DIR/colors.ini"
echo "✓ Generated: $OUTPUT_DIR/colors.toml"
echo "✓ Copied to: $HOME/.config/waybar/colors.css"
echo "Stylix color export completed successfully!"