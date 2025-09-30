{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ./flatpak.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = { experimental-features = [ "nix-command" "flakes" ]; };

  # Network
  boot.extraModulePackages = [ pkgs.linuxPackages.r8168 ];

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

  # Enable OpenGL - deprecated, use hardware.graphics instead

  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];

  # Enable Wayland and required services
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # optional workaround for some GPUs
    NIXOS_OZONE_WL = "1";
    # Force Vulkan for wgpu applications
    WGPU_BACKEND = "vulkan";
    # Force RADV driver
    AMD_VULKAN_ICD = "RADV";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };

  nixpkgs.config.allowUnsupportedSystem = true;

  programs.steam.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Optional but helpful
  programs.dconf.enable = true;

  # No display manager
  services.displayManager.enable = false;
  services.displayManager.gdm.enable = false;

  # Touchpad and input
  services.libinput.enable = true;

  services.restic.backups = {
    onedrive = {
      passwordFile = "/etc/nixos/restic-password.txt";
      rcloneConfigFile = "/home/timm/.config/rclone/rclone.conf";
      repository = "rclone:onedrive:/Backups/restic";
      paths = [ "/home/timm/Dev" ];
      user = "timm";
    };
  };

  security.rtkit.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  users.extraGroups.vboxusers.members = [ "timm" ];

  users.users.timm = {
    isNormalUser = true;
    description = "timm";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    packages = with pkgs; [ fish zsh ];
    shell = pkgs.fish; # optional
  };

  programs.fish.enable = true;
  programs.zsh.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;

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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      mesa.drivers
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      mesa
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
      driversi686Linux.mesa
    ];
  };

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

