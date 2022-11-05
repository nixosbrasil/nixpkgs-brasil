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
    name = "neander.zip";
    url = "https://www.inf.ufrgs.br/arq/wiki/lib/exe/fetch.php?media=wneander.zip";
    sha256 = "1zl24qkbvraicai1qviazq7pmj9yk7b31k281y2g09q1dn5g0fj2";
  };
  bin = mkWineApp {
    inherit wine;
    pname = "neander";
    key = "nbr-neander";
    is32bits = true;
    appInstall = ''
      cp -r @appdir@ $WINEPREFIX/drive_c/neander
      chmod 777 -R $WINEPREFIX/drive_c/neander
    '';
    appRun = ''
      wine explorer /desktop=abalaba,1024x768 c:\\neander\\WNeander.exe "$@"

    '';
  };
in stdenvNoCC.mkDerivation {
  pname = "neander";
  version = "2.1.2";

  dontStrip = true;

  inherit src;

  unpackPhase = ''
    unzip $src
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "neander";
      desktopName = "Computador NEANDER";
      exec = "neander";
      icon = "application-x-executable";
      categories = [ "Utility" ];
    })
  ];

  nativeBuildInputs = [ copyDesktopItems unzip ];

  installPhase = ''
    runHook preInstall

    appdir=$out/opt/neander

    mkdir -p $out/bin $appdir

    cp -r WNeander.exe $appdir

    install -m 755 ${bin} $out/bin/neander

    substituteInPlace $out/bin/neander \
      --subst-var appdir

    runHook postInstall
  '';

}
