{ mkWineApp
, fetchurl
, stdenvNoCC
, copyDesktopItems
, makeDesktopItem
, unzip
, wine
}:
let
  src = fetchurl {
    name = "tora.zip";
    url = "https://github.com/lucasew/nixcfg/releases/download/debureaucracyzzz/ToraSystem7th.zip";
    sha256 = "sha256-F+1Md1GD5s1KtyTf1fmTHV4IoE/GDls+1B/ns3EwSr4=";
  };
  bin = mkWineApp {
    inherit wine;
    pname = "tora";
    key = "nbr-taha-tora";
    is32bits = true;
    appInstall = ''
      cp -r @appdir@ $WINEPREFIX/drive_c/tora
      chmod 777 -R $WINEPREFIX/drive_c/tora

      winetricks vb6run comdlg32.ocx msflxgrd
    '';
    appRun = ''
      wine explorer /desktop=abalaba,1024x768 c:\\tora\\tora.exe "$@"
    '';
  };
in stdenvNoCC.mkDerivation {
  pname = "taha-tora";
  version = "7";

  dontStrip = true;

  inherit src;

  desktopItems = [
    (makeDesktopItem {
      name = "taha-tora";
      desktopName = "Taha Tora";
      exec = "tora";
      icon = "application-x-executable";
      genericName = "Solver de programação linear";
      categories = [ "Utility" ];
    })
  ];

  nativeBuildInputs = [ copyDesktopItems unzip ];

  installPhase = ''
    runHook preInstall

    appdir=$out/opt/tora

    mkdir -p $out/bin $appdir

    cp -r . $appdir

    install -m 755 ${bin} $out/bin/tora

    substituteInPlace $out/bin/tora \
      --subst-var appdir

    runHook postInstall
  '';

}
