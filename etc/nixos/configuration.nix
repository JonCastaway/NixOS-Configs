{ config, pkgs, ... }:

{
  # Import hardware configuration and Nvidia settings
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable systemd-boot and EFI settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking configuration
  networking.hostName = "nixos-t460p";
  networking.networkmanager.enable = true;

  # Printing services
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };

  # Enable Nix experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Timezone and locale settings
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable X server and set keyboard layout
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Console key map
  console.keyMap = "uk";

  # Enable Tailscale service
  services.tailscale.enable = true;

  # Disable PulseAudio and enable PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User configuration
  users.users.gb = {
    isNormalUser = true;
    description = "gb";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kate
      firefox
      plasma-browser-integration
      pkgs.kdePackages.kdeconnect-kde
      wget
      neofetch
    ];
  };

  # Set system state version
  system.stateVersion = "25.05";

  # Graphics configuration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
    ];
  };

  # Enable Wayland support in SDDM
  services.displayManager.sddm.wayland.enable = true;
}
