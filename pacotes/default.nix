{ pkgs
, callPackage
, python3Packages
, vscode-utils
}:

rec {
  # escopos de pacotes

  firefoxExtensions = callPackage ./extensoes/firefox { };

  hexchat-themes = callPackage ./diversos/hexchat-themes { };

  vscodeExtensions = callPackage ./extensoes/vscode {
    inherit (vscode-utils) buildVscodeExtension;
  };

  wine-apps = callPackage ./wine { };

  # outros pacotes

  appimage-wrap = callPackage ./utilitarios/appimage-wrap/default.nix { };

  argouml = callPackage ./utilitarios/uml/argouml { };

  bigbashview = python3Packages.callPackage ./utilitarios/bigbashview { };

  bun = python3Packages.callPackage ./utilitarios/bun { };

  cut2col = callPackage ./utilitarios/cut2col { };

  digital-simulator = callPackage ./utilitarios/digital-simulator { };

  discord = callPackage ./comunicacao/discord { };

  jxproject = callPackage ./utilitarios/jxproject { };

  orange = python3Packages.callPackage ./utilitarios/orange { };

  telegram-desktop-bin = callPackage ./comunicacao/telegram { inherit appimage-wrap; };

  xplico = callPackage ./forense/xplico { };


  # pacotes ainda não funcionais que podem ser consertados posteriormente
  wip = rec {
    autopsy = callPackage ./wip/forense/autopsy/default.nix.old { };

    dff = python3Packages.callPackage ./wip/forense/dff { inherit libvshadow; };

    libvshadow = python3Packages.callPackage ./wip/forense/dff/libvshadow.nix { };
  };
}
