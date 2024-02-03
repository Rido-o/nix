{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.shard.stylua;
in
{
  options.shard.stylua = {
    enable = mkEnableOption "stylua shard";
  };

  config = mkIf cfg.enable {
    xdg.configFile."stylua" = {
      source = ./stylua.toml;
      target = "stylua/stylua.toml";
    };
    home.packages = with pkgs; [
      stylua
    ];
  };
}
