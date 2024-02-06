{
  description = "Flake containing all of my overlays";

  inputs = {
    dwm.url = "path:./dwm";
    dwmblocks.url = "path:./dwmblocks";
    xmenu.url = "path:./xmenu";
    dmenu.url = "path:./dmenu";
  };

  outputs = inputs@{ self, ... }: {
    overlays = with inputs; [
      dwm.overlay
      dwmblocks.overlay
      xmenu.overlay
      # dmenu.overlay
      (import ./st)
    ];
  };
}
