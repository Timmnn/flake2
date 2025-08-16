# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS system configuration using Nix flakes with home-manager for user configuration. The repository manages both system-level configuration and user-specific dotfiles through declarative Nix expressions.

## Key Components

### Core Configuration Files
- `flake.nix` - Main flake definition with inputs (nixpkgs, home-manager, stylix, walker, quickshell)
- `configuration.nix` - System-level NixOS configuration (bootloader, networking, services, users)
- `hardware-configuration.nix` - Hardware-specific configuration (auto-generated)
- `home/home.nix` - Home-manager configuration with modular system

### Module System Architecture
The configuration uses a custom module loading system in `home/home.nix`:
- Modules are located in `home/modules/`
- Each module can have `config.nix` (home-manager config) and `packages.nix` (package list)
- Active modules are defined in the `activatedModules` list in `home/home.nix`
- Module packages are automatically imported and merged into `home.packages`

### Desktop Environment
- **Window Manager**: Hyprland (Wayland compositor)
- **Shell**: Fish (with zsh as fallback)
- **Terminal**: Kitty
- **Launcher**: Multiple options (walker, rofi, quickshell app launcher)
- **Status Bar**: Waybar with custom themes
- **Notifications**: Dunst
- **Theming**: Stylix with base16 color schemes

## Common Development Commands

### System Management
```bash
# Rebuild and switch NixOS system configuration
sudo nixos-rebuild switch --flake .

# Rebuild home-manager configuration only
home-manager switch --flake .

# Update flake inputs
nix flake update

# Check flake syntax
nix flake check

# Format Nix files
nixfmt-classic **/*.nix
```

### Development Environment
```bash
# Enter development shell (provides git, vim)
nix develop

# Build specific outputs
nix build .#nixosConfigurations.nixos.config.system.build.toplevel
```

## Module Development

### Adding New Modules
1. Create directory in `home/modules/<module-name>/`
2. Add `config.nix` for home-manager configuration
3. Add `packages.nix` for package definitions (optional)
4. Add module name to `activatedModules` list in `home/home.nix`

### Module Structure
```nix
# packages.nix example
{ pkgs, ... }: with pkgs; [
  package1
  package2
]

# config.nix example  
{ pkgs, lib, config, ... }: {
  programs.someProgram = {
    enable = true;
    # configuration
  };
}
```

## Important Paths
- System config: `/etc/nixos/` → `./` (this repo)
- User config: `~/.config/` → managed by home-manager modules
- Neovim config: `~/.config/nvim` → `./home/modules/neovim/files/`
- Scripts: `./home/modules/*/files/scripts/`

## Desktop Components

### Hyprland Configuration
- Main config: `home/modules/hypr/files/hyprland.conf`
- Theming managed by Stylix
- Custom keybindings and workspace management

### Application Launchers
- **Walker**: Modern application launcher with themes
- **Rofi**: Traditional launcher with custom scripts
- **Quickshell**: QML-based launcher system

### Waybar Themes
Multiple waybar themes available in `home/modules/waybar/files/themes/`:
- default, experimental, line, zen
- Switch themes using waybar scripts

## Package Management
- System packages in `configuration.nix`
- User packages in `home/home.nix` and module `packages.nix` files
- Development tools available through module system
- Claude Code installed system-wide via home.packages

## Notes
- Configuration uses `nixos-unstable` channel
- Stylix provides consistent theming across applications
- Docker and virtualization enabled system-wide
- Audio via PipeWire
- Backup configured with restic to OneDrive