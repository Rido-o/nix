{ pkgs, lib, ... }:
{
  imports = [ ../../modules/home-manager ];
  shard = {
    default.enable = true;
    nsxiv.enable = true;
    nnn.enable = true;
  };
  home = {
    packages = with pkgs; [
      pfetch
      st
      xmenu
      # most
      # qutebrowser
      gcc # nvim treesitter
      lazygit
      xclip # for putting ssh github key to clipboard
      # Dwm
      # dwmblocks
      dmenu
      sd
      fd
      ripgrep
      # pamixer
      # mpd
      # mpc-cli
      # ncmpcpp
      # pulsemixer
      gotop
      # transmission
      # networkmanager_dmenu
      # lightlocker
      xfce.xfwm4-themes
      discord
      bitwarden
      jellyfin-media-player
      steam
    ];
  };
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--enable-blink-features=MiddleClickAutoscroll"
      # "--proxy-pac-url='data:application/x-javascript-config;base64,'$(base64 -w0 ./proxy.js)"
    ];
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # Ublock origin
      { id = "gebbhagfogifgggkldgodflihgfeippi"; } # Return YouTube Dislike
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock for YouTube
      # { id = "padekgcemlokbadohgkifijomclgjgif"; } # Proxy SwitchyOmega
      { id = "jinjaccalgkegednnccohejagnlnfdag"; } # Violentmonkey
      { id = "dbfoemgnkgieejfkaddieamagdfepnff"; } # 2fas
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      # { id = "kekjfbackdeiabghhcdklcdoekaanoel"; } # Mal-Sync
      { id = "fhcgjolkccmbidfldomjliifgaodjagh"; } # Cookie AutoDelete
      { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; } # Decentraleyes
      { id = "lckanjgmijmafbedllaakclkaicjfmnk"; } # ClearURLS
    ];
  };
  home.stateVersion = "23.05";
}
