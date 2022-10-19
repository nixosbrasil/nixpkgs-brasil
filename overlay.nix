self: super:  {

  hexchat-themes = super.callPackage ./pacotes/diversos/hexchat-themes { };

  appimage-wrap = super.callPackage ./pacotes/utilitarios/appimage-wrap/default.nix { };
}
