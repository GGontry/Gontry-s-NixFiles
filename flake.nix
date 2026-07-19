{
  description = "Gontry's System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs: 
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        nix = nixpkgs.lib.nixosSystem {
          inherit system;
          
          specialArgs = { inherit inputs; };
          
          modules = [
            ./configuration.nix
            
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [
                (final: prev: {
                  stable = import inputs.nixpkgs-stable {
                    inherit (prev) system;
                    config.allowUnfree = true;
                  };
                })
              ];
            })
          ];
        };
      };
    };
}
