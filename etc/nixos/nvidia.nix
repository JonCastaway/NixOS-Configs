{ pkgs, config, lib, ... }:

{
  # Enable graphics support
  hardware.graphics.enable = true;

  # Load the Nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Enable modesetting for the Nvidia driver
    modesetting.enable = true;

    # Nvidia power management settings
    powerManagement = {
      enable = false;               # General power management, may cause issues with sleep/suspend
      finegrained = false;          # Fine-grained power management, turns off the GPU when not in use (Turing or newer GPUs only)
    };

    # Use the NVidia open source kernel module (not to be confused with the independent "nouveau" open source driver)
    open = false;                   # Set to false as open-source support is currently alpha-quality/buggy

    # Enable Nvidia Settings utility
    nvidiaSettings = true;

    # Specify the Nvidia driver package to use
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # Prime configuration for GPU offloading
    prime = {
      intelBusId = "PCI:0:2:0";     # Set the PCI Bus ID for the Intel GPU
      nvidiaBusId = "PCI:2:0:0";    # Set the PCI Bus ID for the Nvidia GPU

      offload = {
        enable = lib.mkOverride 990 true;
        enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true; # Provides `nvidia-offload` command.
      };
    };
  };

  # CANT GET PRIME-RUN TO WORK ** NEEDS SOME ATTENTION (OFFLOAD WORKS!)
  # Add prime-run package
  # environment.systemPackages = with pkgs; [
  #   pkgs.prime-run
  # ];
}
