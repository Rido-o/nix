{
  description = "Flake containing all of my custom packages";

  inputs = {
    nsxiv-rifle.url = "path:./nsxiv-rifle";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    overlays = with inputs; [
      nsxiv-rifle.overlays.default
    ];
  };
}
