{ pkgs, ... }:
{
  imports = [ ../../modules/home-manager ];
  shard = {
    default.enable = true;
    nnn.enable = true;
    stylua.enable = true;
    gallery-dl.enable = true;
    lf.enable = true;
  };
  home = {
    # install unstable with unstable.{pkg} prefix
    packages = with pkgs; [
      lshw # test hardware acceleration
      smartmontools
      zfs
      docker-compose
      rsync
      gotop # btop is alternative
      powertop
      pfetch
      lazygit
      dkr
      # Vaultwarden/Password tools
      openssl
      libargon2
      python311 # for running scripts
      nay
    ];
  };
  home.stateVersion = "23.05";
}
