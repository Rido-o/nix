{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.shard.zsh;
in
{
  options.shard.zsh = {
    enable = mkEnableOption "zsh shard";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zoxide
    ];
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      dotDir = ".config/zsh";
      history = {
        path = "$HOME/.cache/zsh_history";
        size = 10000;
        save = 10000;
      };
      # envExtra = ''
      #   ${builtins.readFile ./.zshenv}
      # '';
      initExtra = ''
        ${builtins.readFile ./.zshrc}
      '';
    };
  };
}
