{ lib
, stdenvNoCC
, jre8
, fetchurl
, makeWrapper
}: stdenvNoCC.mkDerivation {
  name = "jxproject";
  src = fetchurl {
    url = "http://www.jxproject.com/installation/jxProject.tar";
    inherit (builtins.fromJSON (builtins.readFile ./dados.json)) sha256;
  };
  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin $out/opt/jxproject
    tar -xf $src -C $out/opt/jxproject
    ls -1 $out/opt/jxproject

    chmod +x $out/opt/jxproject/jxProjectStart.sh

    makeWrapper $out/opt/jxproject/jxProjectStart.sh $out/bin/jxproject \
      --set JAVA_HOME ${jre8} \
      --prefix PATH : ${jre8}/bin \
      --set JXP_HOME $out/opt/jxproject

    chmod +w -R $out/opt

    substituteInPlace $out/opt/jxproject/jxProjectStart.sh \
      --replace "JXP_HOME=." ""
  '';
}
