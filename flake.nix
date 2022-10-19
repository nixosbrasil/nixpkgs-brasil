{
  description = "nix overlay hue edition";

  outputs = { self }: {
    overlay = final: prev: import ./overlay.nix final prev;
  };
}
