{ lib, pkgs, config, user, ... }:
with lib;
let
  cfg = config.shard.default;
in
{
  options.shard.default = {
    # If enabled overwrites any settings
    enable = mkEnableOption "default shard";
  };

  config = mkIf cfg.enable
    {
      # Set default shell to zsh
      users.defaultUserShell = pkgs.zsh;
      programs.zsh.enable = true;

      # Disable certain wheel users from needing to enter a password on sudo commands
      security.sudo.extraRules = [{
        users = [ "${user}" ];
        commands = [{
          command = "ALL";
          options = [ "NOPASSWD" ];
        }];
      }];

      # Set your time zone.
      time.timeZone = "Australia/Melbourne";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_AU.UTF-8";

      # Configure keymap in X11
      services.xserver = {
        layout = "au";
        xkbVariant = "";
      };

      nix = {
        settings = {
          # Enable flakes and new 'nix' command
          experimental-features = [ "nix-command" "flakes" ];
          # Deduplicate and optimizse nix store
          auto-optimise-store = true;
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };

      programs.git.config = {
        user = {
          name = "Rido";
          email = "rido@airmail.cc";
        };
      };

      # List packages installed in system profile. To search, run: $ nix search wget
      environment.systemPackages = with pkgs; [
        killall
        git
        git-crypt
        # neovim
      ];
    };
}
