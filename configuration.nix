{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = { experimental-features = [ "nix-command" "flakes" ]; };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];

  # Enable Wayland and required services
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # optional workaround for some GPUs
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.steam.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Optional but helpful
  programs.dconf.enable = true;

  # No display manager
  services.displayManager.enable = false;
  services.displayManager.gdm.enable = false;

  # Touchpad and input
  services.libinput.enable = true;

  security.rtkit.enable = true;

  virtualisation.docker.enable = true;

  users.users.timm = {
    isNormalUser = true;
    description = "timm";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    packages = with pkgs; [ fish ];
    shell = pkgs.fish; # optional
  };

  programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ nix-output-monitor bluez ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  networking.firewall.allowedTCPPortRanges = [{
    from = 8000;
    to = 10000;
  }];

  hardware.opengl.enable = true;

  system.stateVersion = "25.05";

  services.pulseaudio.enable = false; # disable legacy PulseAudio

  # Enable PipeWire with audio support
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}

