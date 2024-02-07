{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim = {
      url = "github:Rido-o/nvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    overlays.url = "path:./overlays";
    packages.url = "path:./packages";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
      pkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = with inputs; [
          nvim.overlays.default
          (_: _: { firefox-addons = firefox-addons.packages.${system}; })
          (_: _: {
            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ]
        ++ overlays.overlays
        ++ packages.overlays
        ++ (import ./bin).overlays;
      };
      mkConfiguration = config: with config;
        nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = pkgs system;
          specialArgs = { inherit inputs user host secrets; };
          modules = [
            ./hosts/${host}
            inputs.home-manager.nixosModules.home-manager
            {
              system.stateVersion = "22.11";
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs user secrets; };
                users.${user} = { imports = [ ./hosts/${host}/home.nix ]; };
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        vm = mkConfiguration {
          user = "reid";
          system = "x86_64-linux";
          host = "vm";
        };
        cibo = mkConfiguration {
          user = "reid";
          system = "x86_64-linux";
          host = "cibo";
        };
        rei = mkConfiguration {
          user = "reid";
          system = "x86_64-linux";
          host = "rei";
        };
      };
    };
}
