{ lib, config, ... }:
with lib;
let
  cfg = config.shard.gallery-dl;
in
{
  options.shard.gallery-dl = {
    enable = mkEnableOption "gallery-dl shard";
  };

  config = mkIf cfg.enable {
    programs.gallery-dl = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ../../../secrets/gallery-dl-config.json);
    };
  };
}
