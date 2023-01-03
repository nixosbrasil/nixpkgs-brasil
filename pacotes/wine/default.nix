{ callPackage }: rec {
  mkWineApp = callPackage ./mkWineApp { };
  hxd = callPackage ./hxd { inherit mkWineApp; };
  _7zip = callPackage ./7zip { inherit mkWineApp; };
  taha-tora = callPackage ./taha-tora { inherit mkWineApp; };
  neander = callPackage ./neander { inherit mkWineApp; };
  sosim = callPackage ./sosim { inherit mkWineApp; };
  dev-cpp = callPackage ./dev-cpp { inherit mkWineApp; };
}
