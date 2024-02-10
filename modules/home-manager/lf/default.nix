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
    programs.zsh = lib.mkIf config.programs.zsh.enable {
      initExtra = ''
        lfcd () {
          cd "$(command ${pkgs.unstable.lf}/bin/lf -print-last-dir "$@")"
        }
        alias n='lfcd'
      '';
    };
    programs.lf = {
      enable = true;

      package = pkgs.unstable.lf;

      commands = {
        editor-open = ''$$EDITOR $f'';
        chmod-minus-x = ''%chmod -x $f'';
        trash-put = ''%${pkgs.trashy}/bin/trash put $fx'';
        trash-restore = ''%${pkgs.trashy}/bin/trash restore -fr 0'';
        mkfile = ''
          ''${{
            printf "File Name: "
            read FILE
            touch $FILE
          }}
        '';
        mkdir = ''
          ''${{
            printf "Directory Name: "
            read DIR
            mkdir $DIR
          }}
        '';
      };

      keybindings = {
        e = "editor-open";
        "<backspace2>" = "updir";
        "." = "set hidden!";
        "<enter>" = "open";
        "*" = "chmod-minus-x";
        "~" = "cd";
        of = "mkfile";
        od = "mkdir";
        x = "trash-put";
        "<delete>" = "trash-put";
        U = "trash-restore";
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

      extraConfig = ''
        set cursorpreviewfmt "\033[7m"
      '';
    };
  };
}
