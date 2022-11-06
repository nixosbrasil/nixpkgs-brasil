self: super:  rec {

  hexchat-themes = super.callPackage ./pacotes/diversos/hexchat-themes { };

  appimage-wrap = super.callPackage ./pacotes/utilitarios/appimage-wrap/default.nix { };

  firefoxExtensions = super.callPackage ./pacotes/extensoes/firefox { };

  vscodeExtensions = super.callPackage ./pacotes/extensoes/vscode {
    inherit (super.vscode-utils) buildVscodeExtension;
  };

  telegram-desktop-bin = super.callPackage ./pacotes/comunicacao/telegram { inherit appimage-wrap; };

  discord = super.callPackage ./pacotes/comunicacao/discord { };

  argouml = super.callPackage ./pacotes/utilitarios/uml/argouml { };

  digital-simulator = super.callPackage ./pacotes/utilitarios/digital-simulator { };

  xplico = super.callPackage ./pacotes/forense/xplico { };

  wine-apps = rec {
    mkWineApp = super.callPackage ./pacotes/wine/mkWineApp { };
    hxd = super.callPackage ./pacotes/wine/hxd { inherit mkWineApp; };
    _7zip = super.callPackage ./pacotes/wine/7zip { inherit mkWineApp; };
    taha-tora = super.callPackage ./pacotes/wine/taha-tora { inherit mkWineApp; };
    neander = super.callPackage ./pacotes/wine/neander { inherit mkWineApp; };
    sosim = super.callPackage ./pacotes/wine/sosim { inherit mkWineApp; };
    dev-cpp = super.callPackage ./pacotes/wine/dev-cpp { inherit mkWineApp; };
  };
}
