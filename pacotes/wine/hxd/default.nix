{ mkWineApp
, fetchzip
, stdenvNoCC
, copyDesktopItems
, makeDesktopItem
}:
let
  src = fetchzip {
    url = "https://mh-nexus.de/downloads/HxDSetup.zip";
    sha256 = "sha256-zkucxDMbtp1ovx4tKzEzOvTw489WExOf/iBOJ1EDl5E";
  };
  bin = mkWineApp {
    pname = "hxd";
    key = "nbr-hxd";
    appInstall = ''
      wine ${src}/HxDSetup.exe
    '';
    appRun = ''
      # wine ${src} "$@"
      cd $WINEPREFIX
      wine "c:\\Program Files\HxD\HxD.exe" "$@"
    '';
  };
in stdenvNoCC.mkDerivation {
  pname = "hxd";
  version = "2.5.0.0";

  dontUnpack = true;

  desktopItems = [
    (makeDesktopItem {
      name = "hxd";
      desktopName = "HxD";
      exec = "hxd";
      icon = "application-x-executable";
      genericName = "Editor de arquivos binários";
      categories = [ "Utility" ];
    })
  ];

  nativeBuildInputs = [ copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 ${bin} $out/bin/hxd

    runHook postInstall
  '';

}
