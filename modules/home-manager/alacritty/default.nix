{ lib, config, ... }:
with lib;
let
  cfg = config.shard.alacritty;
in
{
  options.shard.alacritty = {
    enable = mkEnableOption "alacritty shard";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      # settings = "";
    };
  };
}
