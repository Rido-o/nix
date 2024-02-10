{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.shard.nvim;
in
{
  options.shard.nvim = {
    enable = mkEnableOption "nvim shard";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.neovim ];
    programs.neovim = {
      defaultEditor = true;
    };
    programs.zsh = mkIf config.programs.zsh.enable {
      initExtra = ''export EDITOR="nvim"'';
    };
  };
}
