{ lib, pkgs, config, secrets, ... }:
with lib;
let
  cfg = config.shard.telegraf;
in
{
  options.shard.telegraf = {
    enable = mkEnableOption "telegraf shard";
  };

  config = mkIf cfg.enable {
    security.sudo.extraRules = [{
      commands = [{
        command = "${pkgs.smartmontools}/bin/smartctl"; # needed for telegraf?
        options = [ "NOPASSWD" ];
      }];
      users = [ "telegraf" ];
    }];
    systemd.services.telegraf.path = [ pkgs.nvme-cli pkgs.smartmontools "/run/wrappers" ];
    users.users.telegraf.extraGroups = [ "docker" ];
    services.telegraf = {
      enable = true;
      extraConfig = {
        outputs = {
          influxdb_v2 = {
            urls = [ "http://localhost:8087" ];
            token = "${secrets.telegraf.influxdb_v2-token}";
            organization = "fc7fe6873483d912";
            bucket = "telegraf";
            insecure_skip_verify = true;
          };
        };
        inputs = {
          cpu = {
            percpu = true;
            totalcpu = true;
            collect_cpu_time = false;
            report_active = false;
          };
          disk = {
            ignore_fs = [ "tmpfs" "devtmpfs" "devfs" "iso9660" "overlay" "aufs" "squashfs" ];
          };
          docker = {
            endpoint = "unix:///var/run/docker.sock";
            perdevice = false;
            perdevice_include = [ "cpu" "blkio" "network" ];
          };
          diskio = { };
          mem = { };
          net = { };
          netstat = { };
          processes = { };
          swap = { };
          system = { };
          smart = {
            use_sudo = true;
          };
          internet_speed = {
            interval = "60m";
            cache = true;
          };
          http = {
            urls = [ "${secrets.telegraf.http-urls}" ];
            method = "GET";
            name_override = "pihole_stats";
            tagexclude = [ "host" ];
            data_format = "json";
            json_string_fields = [ "url" "status" ];
            insecure_skip_verify = true;
          };
        };
      };
    };
  };
}
