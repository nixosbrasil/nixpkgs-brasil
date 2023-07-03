{ pkgs
, callPackage
, python3Packages
, vscode-utils
}:

rec {
  # escopos de pacotes

  firefoxExtensions = callPackage ./pacotes/extensoes/firefox { };

  hexchat-themes = callPackage ./pacotes/diversos/hexchat-themes { };

  vscodeExtensions = callPackage ./pacotes/extensoes/vscode {
    inherit (vscode-utils) buildVscodeExtension;
  };

  wine-apps = callPackage ./pacotes/wine { };

  # outros pacotes

  appimage-wrap = callPackage ./pacotes/utilitarios/appimage-wrap/default.nix { };

  argouml = callPackage ./pacotes/utilitarios/uml/argouml { };

  bigbashview = python3Packages.callPackage ./pacotes/utilitarios/bigbashview { };

  bun = python3Packages.callPackage ./pacotes/utilitarios/bun { };

  cut2col = callPackage ./pacotes/utilitarios/cut2col { };

  digital-simulator = callPackage ./pacotes/utilitarios/digital-simulator { };

  discord = callPackage ./pacotes/comunicacao/discord { };

  jxproject = callPackage ./pacotes/utilitarios/jxproject { };

  orange = python3Packages.callPackage ./pacotes/utilitarios/orange { };

  telegram-desktop-bin = callPackage ./pacotes/comunicacao/telegram { inherit appimage-wrap; };

  xplico = callPackage ./pacotes/forense/xplico { };


  # pacotes ainda não funcionais que podem ser consertados posteriormente
  wip = rec {
    autopsy = callPackage ./pacotes/wip/forense/autopsy/default.nix.old { };

    dff = python3Packages.callPackage ./pacotes/wip/forense/dff { inherit libvshadow; };

    libvshadow = python3Packages.callPackage ./pacotes/wip/forense/dff/libvshadow.nix { };
  };
}
