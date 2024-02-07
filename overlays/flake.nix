{
  description = "Flake containing all of my overlays";

  inputs = {
    dwm.url = "path:./dwm";
    xmenu.url = "path:./xmenu";
    dmenu.url = "path:./dmenu";
    nsxiv-rifle.url = "path:./nsxiv-rifle";
  };

  outputs = inputs@{ self, ... }: {
    overlays = with inputs; [
      dwm.overlay
      xmenu.overlay
      # dmenu.overlay
      nsxiv-rifle.overlays.default
      (import ./st)
    ];
  };
}
