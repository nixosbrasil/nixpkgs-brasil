{ stdenv
, lib
, fetchzip
, jre
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:
stdenv.mkDerivation {
  pname = "argouml";
  version = "0.34";

  dontUnpack = true;

  src = fetchzip {
    url = "https://web.archive.org/web/20200701181113if_/http://argouml-downloads.tigris.org/nonav/argouml-0.34/ArgoUML-0.34.tar.gz";
    sha256 = "1v2y8bmvl1fzcw1rmgw8jzyj4yhs0vik6kr0rrd9jcq2dikk3zz2";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper $src/argouml2.sh $out/bin/argouml  \
      --prefix PATH : ${lib.makeBinPath [ jre ]}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "argouml";
      desktopName = "ArgoUML";
      exec = "argouml";
      icon = "application-x-executable";
      genericName = "Editor de diagramas UML";
      categories = [ "Office" ];
    })
  ];
}
