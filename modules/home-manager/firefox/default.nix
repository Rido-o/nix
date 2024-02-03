{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.shard.firefox;
in
{
  options.shard.firefox = {
    enable = mkEnableOption "firefox shard";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.default = {
        name = "default";
        id = 0;
        isDefault = true;
        extensions = with pkgs.firefox-addons; [
          ublock-origin
          bitwarden
          violentmonkey
          foxyproxy-standard
          sponsorblock
          return-youtube-dislikes
        ];
        extraConfig = ''
          ${builtins.readFile ./user.js}
        '';
      };
    };
  };
}
