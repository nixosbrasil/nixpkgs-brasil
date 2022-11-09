{ stdenv
, stdenvNoCC
, lib
, sleuthkit
, ant
, fetchFromGitHub
, xvfb-run
, jdk8
}: stdenv.mkDerivation {
  pname = "autopsy";
  version = "4.19.3";

  buildInputs = [ sleuthkit ];

  nativeBuildInputs = [ ant jdk8 ];

  src = stdenvNoCC.mkDerivation {
    name = "autopsy-source";
    nativeBuildInputs = [ jdk8 ant ];

    src = fetchFromGitHub {
      owner = "sleuthkit";
      repo = "autopsy";
      rev = "autopsy-4.19.3";
      sha256 = "sha256-G6TrQOTyi2pRKA5Ei97LowvwBST1Akr5bMZRQSccnx8=";
    };

    buildPhase = ''
      export IVY_HOME=$NIX_BUILD_TOP/.ant
      ant
    '';
    outputHashMode = "recursive";
    outputHash = lib.fakeSha256;
    outputHashAlgo = "sha256";
  };

  buildPhase = ''
    ant -q build
  '';

  checkPhase = ''
    xvfb-run ant -q test-no-regression
  '';
}
