{
  description = "Flake containing all of my overlays";

  inputs = {
    suckless.url = "path:./suckless";
    nsxiv-rifle.url = "path:./nsxiv-rifle";
  };

  outputs = inputs@{ self, ... }: {
    overlays = with inputs; [
      nsxiv-rifle.overlays.default
      suckless.overlay
    ];
  };
}
