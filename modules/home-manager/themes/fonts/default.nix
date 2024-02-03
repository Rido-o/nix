{ lib, pkgs, config, user, ... }:
with lib;
let
  cfg = config.shard.fonts;
in
{
  options.shard.fonts = {
    enable = mkEnableOption "fonts shard";
  };

  config = mkIf cfg.enable {
  };
}
