{ mkWineApp
, fetchurl
, stdenvNoCC
, copyDesktopItems
, makeDesktopItem
, p7zip
, wine64
}:
let
  src = fetchurl {
    name = "7zip.7z";
    url = "https://www.7-zip.org/a/7z2201-x64.exe";
    sha256 = "1r1ngzhn1ayvzfyvj51s3jf4h3jlg5xajr0l0xsib4kjaklgwmdh";
  };
  bin = mkWineApp {
    pname = "7zip";
    key = "nbr-7zip";
    is32bits = false;
    prelude = ''
      alias wine=wine64
    '';
    appInstall = ''
      cp -r @appdir@ $WINEPREFIX/drive_c/7zip
      chmod 777 -R $WINEPREFIX/drive_c/7zip
    '';
    appRun = ''
      wine64 c:\\7zip\\7zFM.exe "$@"
    '';
  };
in stdenvNoCC.mkDerivation {
  pname = "7zip";
  version = "22.01";

  dontStrip = true;

  inherit src;

  unpackPhase = ''
    7z x $src
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "7zip";
      desktopName = "7-Zip";
      exec = "7zip";
      icon = fetchurl {
        url = "https://www.7-zip.org/7ziplogo.png";
        sha256 = "1nkas4wy40ffsmcji1a3gq8a61d72zp4w65jjpmqjj9wyh0j5b7q";
      };
      genericName = "Compactador de arquivos";
      categories = [ "Utility" ];
    })
  ];

  nativeBuildInputs = [ copyDesktopItems p7zip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt
    cp -r . $out/opt/7zip
    install -m755 ${bin} $out/bin/7zip

    appdir=$out/opt/7zip

    substituteInPlace $out/bin/7zip \
      --subst-var appdir

    runHook postInstall
  '';

}
