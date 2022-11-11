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
    name = "sosim.zip";
    url = "http://www.training.com.br/sosim/sosim_v20.zip";
    sha256 = "fae38559d6e29709fff8826524e4c16d626044b2fe275b5532d7b4aa223adae8";
    curlOpts = "--user-agent ''";
  };
  bin = mkWineApp {
    inherit wine;
    pname = "sosim";
    key = "nbr-sosim";
    is32bits = true;
    appInstall = ''
      cp -r @appdir@ $WINEPREFIX/drive_c/sosim
      chmod 777 -R $WINEPREFIX/drive_c/sosim
    '';
    appRun = ''
      wine c:\\sosim\\sosim.exe "$@"

    '';
  };
in stdenvNoCC.mkDerivation {
  pname = "sosim";
  version = "2.0";

  dontStrip = true;

  inherit src;

  unpackPhase = ''
    unzip $src
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "sosim";
      desktopName = "Simulador SOSim";
      exec = "sosim";
      icon = "application-x-executable";
      categories = [ "Utility" ];
    })
  ];

  nativeBuildInputs = [ copyDesktopItems unzip ];

  installPhase = ''
    runHook preInstall

    appdir=$out/opt/sosim

    mkdir -p $out/bin $appdir

    cp -r sosim.exe sosim.ini $appdir

    install -m 755 ${bin} $out/bin/sosim

    substituteInPlace $out/bin/sosim \
      --subst-var appdir

    runHook postInstall
  '';

}
