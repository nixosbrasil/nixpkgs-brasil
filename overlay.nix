self: super:  rec {
  nixos-modules = {
    dotd = import nixos/dotd;
    hip-enable = import nixos/hip-enable;
  };

  hexchat-themes = super.callPackage ./pacotes/diversos/hexchat-themes { };

  appimage-wrap = super.callPackage ./pacotes/utilitarios/appimage-wrap/default.nix { };

  firefoxExtensions = super.callPackage ./pacotes/extensoes/firefox { };

  vscodeExtensions = super.callPackage ./pacotes/extensoes/vscode {
    inherit (super.vscode-utils) buildVscodeExtension;
  };

  telegram-desktop-bin = super.callPackage ./pacotes/comunicacao/telegram { inherit appimage-wrap; };

  discord = super.callPackage ./pacotes/comunicacao/discord { };

  argouml = super.callPackage ./pacotes/utilitarios/uml/argouml { };
  jxproject = super.callPackage ./pacotes/utilitarios/jxproject { };

  digital-simulator = super.callPackage ./pacotes/utilitarios/digital-simulator { };

  xplico = super.callPackage ./pacotes/forense/xplico { };

  orange = super.python3Packages.callPackage ./pacotes/utilitarios/orange { };

  wine-apps = rec {
    mkWineApp = super.callPackage ./pacotes/wine/mkWineApp { };
    hxd = super.callPackage ./pacotes/wine/hxd { inherit mkWineApp; };
    _7zip = super.callPackage ./pacotes/wine/7zip { inherit mkWineApp; };
    taha-tora = super.callPackage ./pacotes/wine/taha-tora { inherit mkWineApp; };
    neander = super.callPackage ./pacotes/wine/neander { inherit mkWineApp; };
    sosim = super.callPackage ./pacotes/wine/sosim { inherit mkWineApp; };
    dev-cpp = super.callPackage ./pacotes/wine/dev-cpp { inherit mkWineApp; };
  };

  wip = {
    dff = super.python3Packages.callPackage ./pacotes/wip/forense/dff { inherit (super) libvshadow; };

    libvshadow = super.python3Packages.callPackage ./pacotes/wip/forense/dff/libvshadow.nix { };

    autopsy = super.callPackage ./pacotes/wip/forense/autopsy/default.nix.old { };
  };
}
