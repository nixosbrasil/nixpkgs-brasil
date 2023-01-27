{ lib
, stdenvNoCC
, jdk11
, fetchurl
, makeWrapper
}: stdenvNoCC.mkDerivation {
  pname = "cut2col";
  version = "0.34c";
  src = fetchurl {
    url = "https://www.cp.eng.chula.ac.th/~somchai/cut2col/cut2col-v34c.jar";
    sha256 = "1nmbq1p2hz344znpzahpz9x5hj2s7cp02npya9pdrsnm4d137amv";
  };
  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${jdk11}/bin/java $out/bin/cut2col \
      --add-flags "-jar $src" \
      --set JAVA_HOME ${jdk11}
  '';
  meta = {
    description = "Utility for converting 2-column to 1-column pdf documents.";
    homepage = "https://www.cp.eng.chula.ac.th/~somchai/cut2col/";
  };
}
