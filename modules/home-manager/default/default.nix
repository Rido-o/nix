{ lib, config, user, ... }:
with lib;
let
  cfg = config.shard.default;
in
{
  options.shard.default = {
    enable = mkEnableOption "default shard";
  };

  config = mkIf cfg.enable {
    shard = {
      git.enable = true;
      zsh.enable = true;
      nvim.enable = true;
    };
    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
    };
    # Let home-manager install and manage itself
    programs.home-manager.enable = true;
  };
}
