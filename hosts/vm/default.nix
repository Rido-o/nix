# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader = {
    grub = {
      enable = true;
      version = 2;
      device = "/dev/sda"; # or "nodev" for efi only # Define on which hard drive you want to install Grub.
      # useOSProber = true; # For dual booting
      configurationLimit = 5;
    };
    timeout = 5;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # X11 display settings
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;
      defaultSession = "xfce";
    };
    desktopManager = {
      xfce.enable = true;
    };
    windowManager = {
      dwm.enable = true;
    };
  };

  # services.xserver.xautolock = {
  #   enable = true;
  #   time = 2;
  #   locker = "${pkgs.lightlocker}/bin/light-locker-command -l";
  # };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Fonts
  fonts.fonts = with pkgs; [
    cozette
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "22.05"; # Did you read the comment?
}
