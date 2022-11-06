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
    name = "devcpp.exe";
    url = "https://razaoinfo.dl.sourceforge.net/project/orwelldevcpp/Setup%20Releases/Dev-Cpp%205.11%20TDM-GCC%204.9.2%20Setup.exe";
    sha256 = "07qgkj6d5hqm2p0zgz6wcwxndrq92dfpi4fnxp4ibwairjxrdbgs";
  };
  bin = mkWineApp {
    pname = "dev-cpp";
    key = "nbr-dev-cpp";
    is32bits = true;
    appInstall = ''
      wine ${src}
      winetricks corefonts
    '';
    appRun = ''
      wine 'c:\\Program Files\\Dev-Cpp\\devcpp.exe' "$@"
    '';
  };
in stdenvNoCC.mkDerivation {
  pname = "devcpp";
  version = "5.11";

  dontStrip = true;
  dontUnpack = true;

  desktopItems = [
    (makeDesktopItem {
      name = "dev-cpp";
      desktopName = "Dev-C++";
      exec = "devcpp";
      icon = "application-x-executable";
      categories = [ "Development" ];
    })
  ];

  nativeBuildInputs = [ copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 ${bin} $out/bin/devcpp

    runHook postInstall
  '';

}
