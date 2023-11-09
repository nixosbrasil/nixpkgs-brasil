{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, qt5
, pango
, cairo
, gtk3
, copyDesktopItems
, makeDesktopItem
}:

let
  latest = builtins.readFile ./latest.txt;
  latest' = builtins.replaceStrings ["\n"] [""] latest;
  latest'' = lib.splitString " " latest';

  sha256 = builtins.elemAt latest'' 0;
  filename = builtins.elemAt latest'' 2;
  name = builtins.head (builtins.split "_" filename);
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://out7.hex-rays.com/files/${filename}";
    inherit sha256;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt5.wrapQtAppsHook
    copyDesktopItems
  ];

  dontWrapQtApps = true;

  buildInputs = [pango cairo gtk3];

  unpackPhase = ''
    runHook preUnpack

    cp $src ida.run
    chmod +xw ida.run
    autoPatchelf ./ida.run
    yes y | ./ida.run || true

    runHook postUnpack
  '';

  desktopItems = [
    (makeDesktopItem {
      inherit name;
      desktopName = "IDA Free";
      type = "Application";
      exec = "ida64";
      icon = "idafree";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/ida-free
    ls -l . y
    cp -r y/* $out/opt/ida-free

    for size in 16 24 32 48 128 256 512; do
      size=${"$"}{size}x${"$"}{size}
      mkdir -p $out/share/icons/hicolor/$size
      ln -s $out/opt/ida-free/appico64.png $out/share/icons/hicolor/$size/idafree.png
    done

    mkdir $out/bin
    ln -s $out/opt/ida-free/ida64 $out/bin/ida64

    runHook postInstall
  '';
}
