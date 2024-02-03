{ pkgs, user, host, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  shard = {
    default.enable = true;
    telegraf.enable = true;
    uefi.enable = true;
  };

  networking.hostName = "${host}"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keyFiles = [
      ../../secrets/authorized_keys
    ];
  };

  # For home assistant bluetooth integration
  hardware.bluetooth.enable = true;
  services.dbus.implementation = "broker";

  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  boot.supportedFilesystems = [ "zfs" ];
  # networking.hostId = (builtins.substring 0 8 (builtins.readFile "/etc/machine-id"));
  networking.hostId = builtins.substring 0 8 "19dfa62f450a4fbcaa7555ee7dcc4557";
  boot.zfs.extraPools = [ "storage" ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "monthly";

  # Samba
  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      map to guest = bad user
    '';
    shares = {
      home = {
        path = "/home/${user}/";
        browseable = "yes";
        "read only" = "no";
        writable = "yes";
        "guest ok" = "no";
        "create mask" = "0755";
        "directory mask" = "0755";
        # "force user" = "${user}";
        "valid users" = "${user}";
      };
      data = {
        path = "/mnt/data";
        browseable = "yes";
        "read only" = "no";
        writable = "yes";
        "guest ok" = "no";
        "create mask" = "0755";
        "directory mask" = "0755";
        # "force user" = "${user}";
        "valid users" = "${user}";
      };
    };
  };

  # enable hardware transcoding and tonemapping
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  services.samba.openFirewall = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    5357 # samba-wsdd
    8123 # homeassistant
  ];
  networking.firewall.allowedUDPPorts = [
    3702 # samba-wsdd
  ];

  system.stateVersion = "22.11"; # Did you read the comment?
}
