{ stdenv
, lib
, makeWrapper
, autoPatchelfHook
, unzip
, openssl
, fetchurl
}:
let
  data = builtins.fromJSON (builtins.readFile ./dados.json);
in stdenv.mkDerivation {
  pname = "bun";
  inherit (data) version;

  src = fetchurl { inherit (data.variacoes.bun-linux-x64) url sha256; };

  sourceRoot = ".";
  unpackCmd = "unzip bun-linux-x64.zip";

  dontConfigure = true;

  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [
    unzip
    openssl
    stdenv.cc.cc.lib
  ];

  installPhase = "install -D ./bun-linux-x64/bun $out/bin/bun";

  # postInstall = ''
  #   wrapProgram "$out/bin/bun" \
  #     --prefix BUN_INSTALL : ${bun_install}
  # '';
}
