{ stdenv
, lib
, fetchFromGitHub
, fetchurl
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
, python3
, json_c
}:
stdenv.mkDerivation {
  pname = "xplico";
  version = "unstable-28-08-2020";

  # enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "xplico";
    repo = "xplico";
    rev = "155e9d0c36bac0f7aeb137dc6c5afc09fbba4578";
    sha256 = "sha256-Qd5/EN4sctHsYEfBuKCYbpHr775vs/UTeufVBi2a6A8";
  };

  patchPhase = ''
    runHook prePatch

    find -type f | grep -e '\.[ch]$' | while read file; do
      substituteInPlace "$file" \
        --replace "<libndpi/" "<" \
        --replace "ndpi_init_detection_module()" "ndpi_init_detection_module(ndpi_no_prefs)"
    done

    find -type f | grep -e '\.sh$' | while read file; do
      substituteInPlace "$file" \
        --replace "/bin/bash" "$(which bash)"
    done

    find -type f | while read file; do
      substituteInPlace "$file" \
        --replace "/opt/xplico" "$out/opt/xplico" || true # se der pau pq é binário só segue o baile
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
    json_c.dev
    (runCommand "json_c_private" {} ''
      mkdir -p $out/include/json-c
      ln -s ${fetchurl {
        url = "https://raw.githubusercontent.com/json-c/json-c/master/json_object_private.h";
        sha256 = "12sajd1pqijdnxxjnmlvlqvc3fr25g7vyqn0grsi9y6x6x644ksr";
      }} $out/include/json-c/json_object_private.h
    '')
  ];

  buildInputs = [
    python3
  ];

  postInstall = ''
    ln -s $out/opt/xplico/bin $out/bin
  '';

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
