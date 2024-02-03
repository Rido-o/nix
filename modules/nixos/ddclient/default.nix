{ lib, config, ... }:
with lib;
let
  cfg = config.shard.ddclient;
in
{
  options.shard.ddclient = {
    enable = mkEnableOption "ddclient shard";
  };

  config = mkIf cfg.enable {
    # https://www.davidschlachter.com/misc/cloudflare-ddclient
    # journalctl -u ddclient
    services.ddclient = {
      enable = true;
      verbose = false;
      interval = "10min";
      ssl = true;
      protocol = "cloudflare";
      passwordFile = ../../../secrets/cloudflare;
      zone = "cibo.pro";
      domains = [ "cibo.pro" ];
      use = "web, web=https://cloudflare.com/cdn-cgi/trace/, web-skip='ip='";
    };
  };
}
