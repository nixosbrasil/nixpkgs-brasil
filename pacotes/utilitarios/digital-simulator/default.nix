{ stdenvNoCC
, lib
, fetchzip
, jre
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, inkscape
, writeShellScript
}:
let
  src = fetchzip {
    url = "https://github.com/hneemann/Digital/releases/download/v0.29/Digital.zip";
    sha256 = "sha256-BMB+lwA03TJT9aczxqZ5uDv13ZLy5qgket4wOLnli/A=";
  };
  icon = stdenvNoCC.mkDerivation {
    name = "digital-simulator.png";
    dontUnpack = true;
    nativeBuildInputs = [ inkscape ];
    installPhase = ''
      inkscape --export-type=png ${src}/icon.svg -o $out -w 256 -h 256
    '';
  };
  bin = writeShellScript "digital-simulator" ''
    PATH="$PATH:${jre}/bin"
    exec bash ${src}/Digital.sh "$@"
  '';
in stdenvNoCC.mkDerivation {
  pname = "digital-simulator";
  version = "0.29";

  inherit src;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install ${bin} $out/bin/digital-simulator

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "digital-simulator";
      desktopName = "Digital Simulator";
      exec = "digital-simulator";
      inherit icon;
      categories = [ "Utility" ];
    })
  ];
}
