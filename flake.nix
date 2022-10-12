{
  description = "nix overlay hue edition";

  outputs = { self }: {
    overlay = final: prev: import ./default.nix final prev;
  };
}
