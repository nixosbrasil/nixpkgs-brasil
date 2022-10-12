{
  description = "nixpkgs hue edition";

  inputs = {
    nixpkgs.url =  "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    overlay = final: prev: import ./default.nix final prev;
  };
}
