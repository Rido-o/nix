{ lib, config, ... }:
with lib;
let
  cfg = config.shard.uefi;
in
{
  options.shard.uefi = {
    enable = mkEnableOption "uefi shard";
  };

  config = mkIf cfg.enable {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
