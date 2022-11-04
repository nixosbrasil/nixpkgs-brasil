self: super:  {

  hexchat-themes = super.callPackage ./pacotes/diversos/hexchat-themes { };

  appimage-wrap = super.callPackage ./pacotes/utilitarios/appimage-wrap/default.nix { };

  firefoxExtensions = super.callPackage ./pacotes/extensoes/firefox { };

  vscodeExtensions = super.callPackage ./pacotes/extensoes/vscode {
    inherit (super.vscode-utils) buildVscodeExtension;
  };

  telegram-desktop-bin = super.callPackage ./pacotes/comunicacao/telegram { inherit (super) appimage-wrap; };

  discord = super.callPackage ./pacotes/comunicacao/discord { };
}
