{
  description = "Flake containing all of my overlays";

  inputs = {
    suckless.url = "path:./suckless";
  };

  outputs = inputs@{ self, ... }: {
    overlays = with inputs; [
      (import ./nsxiv-rifle)
      suckless.overlay
    ];
  };
}
