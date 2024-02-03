{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.shard.nsxiv;
in
{
  options.shard.nsxiv = {
    enable = mkEnableOption "nsxiv shard";
  };

  config = mkIf cfg.enable {
    xdg.configFile."nsxiv" = {
      source = ./nsxiv;
      target = "nsxiv";
      recursive = true;
    };
    home.packages = with pkgs; [
      nsxiv
      nsxiv-rifle # TODO add check if nsxiv-rifle is part of packages
    ];
  };
}
