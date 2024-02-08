{ lib, config, ... }:
with lib;
let
  cfg = config.shard.awesomewm;
in
{
  options.shard.awesomewm = {
    enable = mkEnableOption "awesomewm shard";
  };

  config = mkIf cfg.enable {
    xsession.windowManager.awesome = {
      enable = true;
      # luaModules = "";
    };
  };
}
