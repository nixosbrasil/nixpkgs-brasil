{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, libpcap
, libmaxminddb
, zlib
, openssl
, ndpi
, pkg-config
, runCommand
, sqlite
, libpqxx
, postgresql
, libmysqlclient
}:
let
  version = "1.2.2";
in stdenv.mkDerivation {
  pname = "xplico";
  inherit version;

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "xplico";
    repo = "xplico";
    rev = "v.${version}";
    sha256 = "sha256-ggY0THiTRTaNjlRlKPqUdu85wT4NTHfJwxd3eX45N9A";
  };

  patchPhase = ''
    runHook prePatch

    find -type f | grep -e '\.[ch]$' | while read file; do
      substituteInPlace "$file" \
        --replace "<libndpi/" "<" \
        --replace "ndpi_init_detection_module()" "ndpi_init_detection_module(ndpi_no_prefs)"
    done

    runHook postPatch
  '';

  # dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    pkg-config
    libpcap
    libmaxminddb
    zlib
    openssl.dev
    sqlite.dev
    libpqxx
    postgresql
    libmysqlclient.dev
    (ndpi.overrideAttrs (old: {
      version = "3.4";
      src = fetchFromGitHub {
        owner = "ntop";
        repo = "nDPI";
        rev = "3.4";
        sha256 = "sha256-Ad9ywYek8AsYAQE9KVN6h55qYIaqaCfXCALgCvZLUHY";
      };
    }))
    # (runCommand "gambiarra-ndpi" {} ''
    #   mkdir -p $out/include
    #   ln -s ${ndpi}/include/ndpi $out/include/libndpi
    # '')
  ];

  # NIX_CFLAGS_COMPILE = [ "-I${ndpi}/include" ];

  buildInputs = [
  ];

  # installPhase = ''
  #   runHook preInstall

  #   mkdir -p $out/bin

  #   runHook postInstall
  # '';

  desktopItems = [
    # (makeDesktopItem {
    #   name = "argouml";
    #   desktopName = "ArgoUML";
    #   exec = "argouml";
    #   icon = "${src}/icon/ArgoIcon512x512.png";
    #   genericName = "Editor de diagramas UML";
    #   categories = [ "Office" ];
    # })
  ];
}
