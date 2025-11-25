{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ./flatpak.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NVIDIA kernel parameters for stability
  boot.kernelParams = [
    "nvidia_drm.modeset=1" 
    "nvidia_drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_TemporaryFilePath=/tmp"
    "nvidia.NVreg_UsePageAttributeTable=1"
    "module_blacklist=amdgpu,nouveau"
  ];

  # Blacklist KVM modules to allow VirtualBox to work
  boot.blacklistedKernelModules = [ "kvm_intel" ];

  nix.settings = { experimental-features = [ "nix-command" "flakes" ]; };

  # Network
  boot.extraModulePackages = [ pkgs.linuxPackages.r8168 ];

  networking.extraHosts = ''
    127.0.0.1 api.mypension.local
    127.0.0.1 live.mypension.local
    127.0.0.1 host.docker.internal
    127.0.0.1 mypension.local
  '';

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIDhTCCAm2gAwIBAgIUIkf9h3qSp4/JRndEABAT8Ij8M68wDQYJKoZIhvcNAQEL
      BQAwHzEdMBsGA1UEAwwURG9ja2VyU2VydmVyQ3liZXJkb2cwHhcNMjMwMjE1MTgx
      MjIwWhcNMzgwMjExMTgxMjIwWjAYMRYwFAYDVQQDDA1DeWJlcmRvZ0xvY2FsMIIB
      IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0Ec7iHhm1RAeRygQIWaJuwlz
      AhIS7zSINAi143DAf4xZfUtG92+6DjrlKGEMXQNu+EvPamDT33/gv6wKOYSQiFiA
      xIgZuMOBOOtZoq0avEhVNhUje/TvFKqnVopKx3VF61Qqqh92lFlma8ABAD816JYO
      BcFLB0Gc/iKAHS16tmqVPDXmuwuYKsjK6UGlP6ZFFzATXQ5Uma5X7Aq2d6M8yMZU
      mV+Rbtg2yTltVzb68Vw9+tqwhFdhyQCFTpH1CS3jkDWLfa4s52FR34ooTJmkRuES
      GBeDXi38wunu+2o+AUKpk64+/i3icpv9jrCRchVbd2s1O19rk9oD9Drij7rnYwID
      AQABo4G/MIG8MC0GCWCGSAGG+EIBDQQgFh5DeWJlcmRvZyBHZW5lcmF0ZWQgQ2Vy
      dGlmaWNhdGUwCQYDVR0TBAIwADAdBgNVHQ4EFgQUga3UWEjtunVUBxXjvPxjvHhn
      JQEwHwYDVR0jBBgwFoAUlb7xSCbrs62AlGRNla0kU4oKJtMwCwYDVR0PBAQDAgXg
      MDMGA1UdEQQsMCqCE2FwaS5teXBlbnNpb24ubG9jYWyCE2FwaS5teXBlbnNpb24u
      bG9jYWwwDQYJKoZIhvcNAQELBQADggEBAHOCFjqT9BkaYlCdt3aHDXa3csKsDfvW
      VvmIb8t5p/iddhUcASrVbF2692jWrq80tMybmxZeamfI0l0yuvFDrSDcN0Kluo3h
      TUqs3LJ4DH91WP0bCc1hziHG681Qz2ngptG5y3VGO4P1Rq4z13yWVuxYAexBHX/F
      4zCCEVq9eRv3HDYRXpQeipnwoxGqoEZTe/lgaorZznbgmXsoGkNaQ9mNk0Gmn8l1
      FHPFZnauIzNJ6k4zkEcycVBmu2jR94TDq6a5ie0DkkRBO2zpMjERg3opSMHcHrkE
      jN5D5AfRvvw9w+YmPNV5dxYfDhr3goC19Fc4hiKu79X/s9ijmZ9YHOI=
      -----END CERTIFICATE-----
    ''
    ''
      -----BEGIN CERTIFICATE-----
      MIIDhzCCAm+gAwIBAgIUIkf9h3qSp4/JRndEABAT8Ij8M60wDQYJKoZIhvcNAQEL
      BQAwHzEdMBsGA1UEAwwURG9ja2VyU2VydmVyQ3liZXJkb2cwHhcNMjMwMjE1MTgx
      MDE1WhcNMzgwMjExMTgxMDE1WjAYMRYwFAYDVQQDDA1DeWJlcmRvZ0xvY2FsMIIB
      IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8nJsPFDIffFSCsACM5pexAiC
      wtGK/jdicUMArwJdJuDVk98Qsdjn62faOlD3pIKyFknSio6cGn8NUEjW0aVm6Asg
      whtZYg3BG+lcC2SMCASb1rkr6CJ93oSoooKXpICot5ZQyNTZZWku9Xfq0HyMFHI6
      X3mFnRIfi/55b67QkanfXZPNhbgw4sbFHA77ZyblTj03MayubVIY68zYjljHyqU7
      pDy578h3IR87iA63zANcNgSM/y7X7vz4/kBGbvUVYRy21+89RJrofc/o/x7DMjcX
      VfxTUwsC9ox7swx1Mb6DeVXu84SaSMig7oMSASpnwjU73q6YoH/nHH8zCaig7QID
      AQABo4HBMIG+MC0GCWCGSAGG+EIBDQQgFh5DeWJlcmRvZyBHZW5lcmF0ZWQgQ2Vy
      dGlmaWNhdGUwCQYDVR0TBAIwADAdBgNVHQ4EFgQUatcBMS9yOXF9gi72RTdIRDva
      WhYwHwYDVR0jBBgwFoAUco6qr2jeV9LqBySdINKbIIExqbEwCwYDVR0PBAQDAgXg
      MDUGA1UdEQQuMCyCFGxpdmUubXlwZW5zaW9uLmxvY2FsghRsaXZlLm15cGVuc2lv
      bi5sb2NhbDANBgkqhkiG9w0BAQsFAAOCAQEAQXlGIIuGUm/CSrl5CQAERbMnz7PD
      yE/tBDwko9KPXg5OcukawQxxl154pcRogb2p35LRKgH12i9IwxgDSku1mKfgFBkk
      y5H86fz4sTwFIuqoWDfNdUHDxmyL83Unfwa+4fqKzudmvOVtjr+t3WDAza+kMIW2
      dAhOnTNS+rkiZ1oCh4mpokolBhLE4hEFNtoEw+K2uZYJ5Y4hV9fHF+paimZN2ADZ
      5cEiSTG9j8+J5aIrGT0mb/ZGM/ppMIhk974BpjPLcyJEf/2IJE2NTWoYP4lg29lG
      1zEOoDDdmLUNsH9pR+kdiWLKxoM+3dasju8C4OHu5uJ/ZKjbBTTVOs4QOg==
      -----END CERTIFICATE-----
    ''
    ''
      -----BEGIN CERTIFICATE-----
      MIIDhjCCAm6gAwIBAgIUOGiuun22JNcCRvOLypc77qDyGfkwDQYJKoZIhvcNAQEL
      BQAwIjEgMB4GA1UEAwwXRG9ja2VyU2VydmVyR29vZFBlbnNpb24wHhcNMjMxMDMw
      MDg0ODAxWhcNMzgxMDI2MDg0ODAxWjAbMRkwFwYDVQQDDBBHb29kUGVuc2lvbkxv
      Y2FsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArPej3lLepFpGlemM
      TkzUf3TYLgVAeODfcDbihsv/YdfrJhR4bRetnDVW43QbJjYVkpUZ5AV/l8IiTHaP
      W1upfPQivUtab2MpNjfFccQ2DTsfy33OUl8NM6A6vWkjaqBU+TRG8vwRHZ5d7Chw
      rkIa2G1yRh3WiC3u6gvqhQvuYcSrGeOjAhzTohuBLP+UP7gWbDMFwNvDBKLuNu9r
      pLJUVH/kalzt6hg5BHBJ7teh685KT+WAFljf8yA5qGpKZXoGvJeWxbIH4GETslxr
      +wIXhtu+lo5tlBy9OCiYuGRHAb3WztizUx4ky8NBdkNt4BAJImCDzZ535l8EUMT0
      zGpDAwIDAQABo4G6MIG3MDAGCWCGSAGG+EIBDQQjFiFHb29kUGVuc2lvbiBHZW5l
      cmF0ZWQgQ2VydGlmaWNhdGUwCQYDVR0TBAIwADAdBgNVHQ4EFgQUiAKDZbSigT/K
      NeY8UeGJypMkbUEwHwYDVR0jBBgwFoAUeaIeen/AtqGYA8sYgl6bo5Z+kYswCwYD
      VR0PBAQDAgXgMCsGA1UdEQQkMCKCD215cGVuc2lvbi5sb2NhbIIPbXlwZW5zaW9u
      LmxvY2FsMA0GCSqGSIb3DQEBCwUAA4IBAQBAbR2e1hL44RXKc7MtS8wf9+6tya2V
      N2/YrCOBvMOzfbVmgHd1CgkArHwKJrKpYMxVxQthJQXOOVd8sPfjo68Dg4N/zWi0
      JYSAglHqsZICpE/67Z5sMoqwb5Vt3jS7LAbRF8/1VAIsJyhpdNrUU8Fjxe/N25iz
      D5hhuD9LqNQSHtot8Vgm3N0x8YmfjRy+J2r2MrVrkgUdmH7SwqQMlW8eQ0KXskDi
      kFNrHHPI992szEtCKmm8dVDwiw5XQaOCYFOK7sgX+rijleRO9pal2ujsVgg5U8eg
      tubOSxG9LgAmLRKXCWH5ecR3EHxr93Bt8E1uzREAqTSaHTTHhTLt7Qg1
      -----END CERTIFICATE-----
    ''
    ''
      -----BEGIN CERTIFICATE-----
      MIIDHzCCAgegAwIBAgIUBQPYA5SpODnyn4uxS+iUL7iX9y0wDQYJKoZIhvcNAQEL
      BQAwHzEdMBsGA1UEAwwURG9ja2VyU2VydmVyQ3liZXJkb2cwHhcNMjMwMjE1MTgx
      MjIwWhcNMzgwMjExMTgxMjIwWjAfMR0wGwYDVQQDDBREb2NrZXJTZXJ2ZXJDeWJl
      cmRvZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALYnqpipx1MNx0Pm
      2LMonyONVeZfagu8++7ZSAmuO6GLtROyVA3yLOq5OOR6CEIWVYJMN1ZvWFfZ/z8a
      qF8raBw4tXIyhwyy28ofr1cgWeTUvQ5v3pmptqc5eQFnWh/xm+GKC/lOcIspc9R6
      J2IWPA1QmDVyNYlcYhqbTZt6JV0NvoAHOHWcCU4lUgovZXOpc4Xx9DiWn7DoonW5
      4yvFqgGFq43haRq4Di93HCvrEE5VkmcUmjiz/ir+rOVdY8/Nz69sGhu0OkEx0ED+
      qyCQbtbBci63GLHeycNqSoIi8lJZhBkHcifS6+nlTwyIDYJjGeJfm1EmShyCg35v
      ovTqx10CAwEAAaNTMFEwHQYDVR0OBBYEFJW+8Ugm67OtgJRkTZWtJFOKCibTMB8G
      A1UdIwQYMBaAFJW+8Ugm67OtgJRkTZWtJFOKCibTMA8GA1UdEwEB/wQFMAMBAf8w
      DQYJKoZIhvcNAQELBQADggEBAELnR9YPDVPKQDp4a075WbPJshyja7nthPagy4kj
      ovCj9sEw+tNjeoj7FKPzueVwmrIlVANu9fEyOWLWPiOsvPpAtUjJ7AheKrfm4N3c
      741MRJWG/OZguLg3EmEcy3RMrS3FQ0078zW1nGjmSRY998uOkIJXeNcZQoX9kz3I
      Yhs+CG5OS4UPr+TGPTyIjZYHlrl4OWRxDdg+MhKsYYjMs24DaQjVAjSGXCONHwBG
      oPyhoFMbWccvHnCu/LzkOTuJCo+EC3Pqu15jUpyOj6b66WS5yqbG8qlUnN4GoXg7
      6cxo1XJt6aaGavssvSpg9V+a01cIKCdkEXIgIXH6elM8VPI=
      -----END CERTIFICATE-----
    ''
    ''
      -----BEGIN CERTIFICATE-----
      MIIDHzCCAgegAwIBAgIUGju+rYFJCnrAn6LhBgGfmg+gM4swDQYJKoZIhvcNAQEL
      BQAwHzEdMBsGA1UEAwwURG9ja2VyU2VydmVyQ3liZXJkb2cwHhcNMjMwMjE1MTgx
      MDE0WhcNMzgwMjExMTgxMDE0WjAfMR0wGwYDVQQDDBREb2NrZXJTZXJ2ZXJDeWJl
      cmRvZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMKnSyH1wMYG65Tw
      7Xj9IpW6ssq9CQhxHCbqdRl2QjQLYcEf1/iEE9k82prhvAc//O3vB+bJr+HKN9oi
      I1/8cBxUtm/as9nzIAB673a0Xrfr6GljfUg+aMPWSSyQNsfnaB52gUCNZ2WvZjPf
      W1dxSUgxKewMKPsGacwRzOetGZLAL7dY5dnCEH3y12/y3wEHelF1eeqrlGE3Vx0P
      If/pifk4fdkFgK/HkVAtQsjTPUsNBv2R8CmsDjXiD99dVWr8An0zGc3lf8HddIkw
      WgF+Rqk2zVO+njP1x78lmBRiCSl0Xukn2fkt49ATUUZSHNoBkzVhVbpSWPPgsYbU
      Ow4sgiUCAwEAAaNTMFEwHQYDVR0OBBYEFHKOqq9o3lfS6gcknSDSmyCBMamxMB8G
      A1UdIwQYMBaAFHKOqq9o3lfS6gcknSDSmyCBMamxMA8GA1UdEwEB/wQFMAMBAf8w
      DQYJKoZIhvcNAQELBQADggEBADZJGBeCaDaR90I5emYx5WOmeXuOn1VSMO7JYB8l
      PLnGIzl6b2K8KErTlHHi+J6a7+EbEI8WgR3YLtMjh/jhaUBLtHWhd2lCO3qUcLf8
      cAu5nBdu2T4E1vpdKZQWF1zASYf0DmsTzbl155i/11bwgRDn1Tc7MaRjLpJqjaz6
      QXC/viqGpAKAdwuHm454BWW42II+mYvH1DCnIE5GgOpBy7z3oMmIhyhZPVtN8vKp
      kjoRn0vxGp9OCM6vgfG0QU2yq57MD6iCw1NX6jSDmaC7ebUQijf3d6qPAxwy25rw
      UwaKJV8Xx2+8Ewbr4dZwKOQdhkrbml1aSvYvhdHVqfmKtUk=
      -----END CERTIFICATE-----
    ''
    ''
      -----BEGIN CERTIFICATE-----
      MIIDJTCCAg2gAwIBAgIUAvXreusSWvFc7q4FgZP57CZ4MPYwDQYJKoZIhvcNAQEL
      BQAwIjEgMB4GA1UEAwwXRG9ja2VyU2VydmVyR29vZFBlbnNpb24wHhcNMjMxMDMw
      MDg0ODAxWhcNMzgxMDI2MDg0ODAxWjAiMSAwHgYDVQQDDBdEb2NrZXJTZXJ2ZXJH
      b29kUGVuc2lvbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ3mDae3
      4YvBpi8R96HfK/VISQzYgqPAwostoyTf2l+X1bomEYuXlQci6rLSZw3ELK8rlxB9
      pQy1r5JPtHe/1uXva/CIrdJUNJDw9N6k6jB1PFSq1VGsfImLl1m+Y/8Cl+UMaI+X
      pddGEpiV+Tvakw5zZ/fi3G1kDcFdTTYn9PnG3rU1t4h6q/0NNVactpO7lNtLSMKd
      BV015LwUEykC2tM2fG48j7nzBrs+mUxt1nbID8lt+sIgsqfi6h8dn61+2cIyioZd
      bHSuFwLPtU0aakId+RWGy5BueDq1L6JRwUXvgKYKrlWBUMBWGRbDrl1YbZLtytsi
      DY6teF9d9K9vgDcCAwEAAaNTMFEwHQYDVR0OBBYEFHmiHnp/wLahmAPLGIJem6OW
      fpGLMB8GA1UdIwQYMBaAFHmiHnp/wLahmAPLGIJem6OWfpGLMA8GA1UdEwEB/wQF
      MAMBAf8wDQYJKoZIhvcNAQELBQADggEBAHnNdlfM28/fp5VEapSEVWI8OTBTmP0A
      KVTnIHukLXqSi9S+/CUoQOxscjYj1gZSE9teZUDlVVMQ/Ot4zyQs3HEHAmoh/A6u
      spoJiDXZm+HY9156nhX9OEEFpgbDEVUfx/B88C1JF7C6jafBi00NqMp/tpiZE+Wm
      k+WaObzuCiCFSVaOcZpr+x/OUfpcGjFu+qV8oIi6aK/X5lgm774PiyuFce1CQn57
      km8t2Q2YTqFwuifNEQDtGzE3RGQRApSwKC9UiK/RnLiH48iHlpErTpF9b7h+zJq3
      pij/gf3uyPhY/KT0bPnfbVwrTEZIGycD+XvZLusJ68BxxxWVM8v8tmg=
      -----END CERTIFICATE-----
    ''
  ];

  networking.firewall.checkReversePath = false;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  # Enable NTP time synchronization
  services.chrony.enable = true;

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

  hardware.opengl.enable = true;

  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];

  services.tailscale.enable = true;

  # Enable Wayland and required services
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # optional workaround for some GPUs
    NIXOS_OZONE_WL = "1";
    # NVIDIA-specific variables
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  nixpkgs.config.allowUnsupportedSystem = true;

  programs.steam.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Optional but helpful
  programs.dconf.enable = true;

  # Desktop Environment Configuration
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  
  # GNOME Desktop Environment (X11)
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.defaultSession = "gnome-xorg";
  
  # GNOME services
  services.gnome.gnome-keyring.enable = true;
  
  # XFCE Desktop Environment (kept for easy switching)
  services.xserver.desktopManager.xfce.enable = true;

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
  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = with pkgs; [ nix-output-monitor bluez ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8080 ];
  };

  # Enable WireGuard
  /* networking = {
       # Allow WireGuard traffic through the firewall
       firewall = {
         allowedUDPPorts = [ 51820 ];
         allowedTCPPortRanges = [{
           from = 8000;
           to = 10000;
         }];
       };

       # Use the VPN's DNS (and optionally a fallback)
       nameservers = [ "10.2.0.1" "1.1.1.1" ];

       # Define the WireGuard interface
       wireguard.interfaces = {
         wg0 = {
           ips = [ "10.2.0.2/32" ];
           listenPort = 51820; # matches firewall

           privateKeyFile = "/home/timm/wireguard-keys/private";

           peers = [{
             publicKey = "zwqVDEcMVKdrKT1hSke1/WR9GYwFfBeWN3qzdGQMOR0=";
             allowedIPs = [ "0.0.0.0/0" "::/0" ];
             endpoint = "190.2.151.14:51820";
             persistentKeepalive = 25;
           }];
         };
       };
     };
  */

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false; # Use proprietary drivers
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # Force full composition pipeline off for better performance
    forceFullCompositionPipeline = false;

    # For laptops with hybrid graphics (Intel + NVIDIA)
    prime = {
      # Use sync for always-on NVIDIA, or offload for Intel primary + NVIDIA on-demand
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Memory and stability optimizations
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
    "vm.swappiness" = 10;
  };

  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Monitor hotplug detection for NVIDIA
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="monitor-hotplug.service"
  '';

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

