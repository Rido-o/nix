{ pkgs, ... }:
{
  imports = [ ../../modules/home-manager ];
  shard = {
    nsxiv.enable = true;
    nnn.enable = true;
  };
  home = {
    packages = with pkgs; [
      pfetch
      st
      xmenu
      most
      qutebrowser
      gcc # nvim treesitter
      lazygit
      xclip # for putting ssh github key to clipboard
      # Dwm
      dwmblocks
      dmenu
      sd
      fd
      ripgrep
      pamixer
      mpd
      mpc-cli
      ncmpcpp
      pulsemixer
      gotop
      transmission
      networkmanager_dmenu
      lightlocker
      xfce.xfwm4-themes
    ];
  };
}
