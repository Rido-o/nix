{
  description = "Flake containing all of my custom packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nsxiv-rifle.url = "path:./nsxiv-rifle";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = function: nixpkgs.lib.genAttrs systems (system: function {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      overlays = forAllSystems ({ pkgs, system }: with inputs; [
        (_: _: { nsxiv-rifle = nsxiv-rifle.packages.${system}.default; })
      ]);
    };
}
