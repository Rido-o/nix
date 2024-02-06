{
  description = "NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim
    nvim = {
      url = "github:Rido-o/nvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    firefox-addons = {
      # https://gitlab.com/rycee/nur-expressions/-/tree/master/pkgs/firefox-addons
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Overlays & Packages
    overlays.url = "path:./overlays";
    packages.url = "path:./packages";
    packages.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      mkConfiguration = config: with config;
        let
          pkgs = import nixpkgs {
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
            ++ packages.overlays.x86_64-linux
            ++ (import ./bin).overlays;
          };
          secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
        in
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;
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
