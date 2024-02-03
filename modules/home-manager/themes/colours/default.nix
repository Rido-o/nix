{ lib, pkgs, config, user, ... }:
with lib;
let
  cfg = config.shard.colours;
in
{
  options.shard.colours = {
    enable = mkEnableOption "colours shard";
  };

  config = mkIf cfg.enable {
  };
}
