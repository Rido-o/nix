{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.shard.lf;
in
{
  options.shard.lf = {
    enable = mkEnableOption "lf shard";
  };

  config = mkIf cfg.enable {
    xdg.configFile."lf/icons".source = ./icons;
    programs.zsh.initExtra = ''
      ${builtins.readFile ./lfcd}
    ''; # TODO only if zsh is installed
    programs.lf = {
      enable = true;

      package = pkgs.unstable.lf;

      commands = {
        editor-open = ''$$EDITOR $f'';
        chmod-minus-x = ''%chmod -x $f'';
      };

      keybindings = {
        e = "editor-open";
        "<backspace2>" = "updir";
        "." = "set hidden!";
        "<enter>" = "open";
        "*" = "chmod-minus-x";
        "~" = "cd";
      };

      settings = {
        preview = true;
        hidden = true;
        drawbox = true;
        icons = true;
        ignorecase = true;
        ratios = "1:2";
        info = "size:time";
        dircounts = true;
      };
    };
  };
}
