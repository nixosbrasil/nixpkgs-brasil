self: super:  rec {
  nixos-modules = {
    dotd = import nixos/dotd;
    hip-enable = import nixos/hip-enable;
  };

  # escopos de pacotes

  firefoxExtensions = super.callPackage ./pacotes/extensoes/firefox { };

  hexchat-themes = super.callPackage ./pacotes/diversos/hexchat-themes { };

  vscodeExtensions = super.callPackage ./pacotes/extensoes/vscode {
    inherit (super.vscode-utils) buildVscodeExtension;
  };

  wine-apps = super.callPackage ./pacotes/wine { };

  # outros pacotes

  appimage-wrap = super.callPackage ./pacotes/utilitarios/appimage-wrap/default.nix { };

  argouml = super.callPackage ./pacotes/utilitarios/uml/argouml { };

  bun = super.python3Packages.callPackage ./pacotes/utilitarios/bun { };

  cut2col = super.callPackage ./pacotes/utilitarios/cut2col { };

  digital-simulator = super.callPackage ./pacotes/utilitarios/digital-simulator { };

  discord = super.callPackage ./pacotes/comunicacao/discord { };

  jxproject = super.callPackage ./pacotes/utilitarios/jxproject { };

  orange = super.python3Packages.callPackage ./pacotes/utilitarios/orange { };

  telegram-desktop-bin = super.callPackage ./pacotes/comunicacao/telegram { inherit appimage-wrap; };

  xplico = super.callPackage ./pacotes/forense/xplico { };


  # pacotes ainda não funcionais que podem ser consertados posteriormente
  wip = {
    autopsy = super.callPackage ./pacotes/wip/forense/autopsy/default.nix.old { };

    cockpit = super.callPackage ./pacotes/wip/cockpit { };

    dff = super.python3Packages.callPackage ./pacotes/wip/forense/dff { inherit (super) libvshadow; };

    libvshadow = super.python3Packages.callPackage ./pacotes/wip/forense/dff/libvshadow.nix { };
  };
}
