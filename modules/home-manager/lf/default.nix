{ lib, config, ... }:
with lib;
let
  cfg = config.shard.lf;
in
{
  options.shard.lf = {
    enable = mkEnableOption "lf shard";
  };

  config = mkIf cfg.enable {
    programs.lf = {
      enable = true;
    };
  };
}
