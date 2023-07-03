{
  description = "nix overlay hue edition";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      overlay = final: prev: import ./overlay.nix final prev;

      nixosModules = builtins.mapAttrs (k: v: import v) {
        dotd = ./nixos/dotd;
        hip-enable = ./nixos/hip-enable;
      };

      packages = nixpkgs.legacyPackages.${system}.callPackage ./packages.nix { };
    });
}
