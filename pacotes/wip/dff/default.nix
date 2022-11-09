{ stdenv
, stdenvNoCC
, lib
, fetchFromGitHub
, fetchurl
, fetchgit
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, pkg-config
, runCommand
, json_c
, writeShellScript
, git
, cacert
, coreutils
, cmake
, buildPythonPackage
, swig
, icu58
, qt48Full
# empacotado aqui
, libvshadow
}:

let
  icu = icu58.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ [
      "--enable-layoutex"
      # "--enable-layout"
    ];
  });
  dffSrc = stdenvNoCC.mkDerivation {
    name = "dff-source";

    builder = writeShellScript "builder.sh" ''
      PATH=$PATH:${lib.makeBinPath [ git coreutils ]}
      git clone "https://github.com/arxsys/dff" $out
      cd $out
      git checkout -b build d40d46b0501fe7a8d742538842f2c2a4333dd8e0
      git submodule init
      git submodule update -- dff/unsupported || true
      pushd dff/unsupported
        git fetch --all
        git checkout -b unbugged e66a6b0963c5d4da3c48f80cac70518b1eefda52
      popd
      git add -A
      git submodule update --recursive
      rm $out/.git -rf
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-mRkeoDQp2kcbhjZyHtD4ZGtwen5zx6dcxyCB12aSpyY=";
    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND" "NIX_GIT_SSL_CAINFO" "SOCKS_SERVER"
    ];

    passthru = {
      gitRepoUrl = "https://github.com/arxsys/dff";
    };
  };
  dff = buildPythonPackage {
    pname = "dff";
    version = "unstable-19-05-2016";

    src = dffSrc;

    unpackPhase = ''
      cp -Rv $src/* .
      chmod +w . -R
      pwd
      ls -1
    '';

    patchPhase = ''
      substituteInPlace cmake_modules/FindICU.cmake \
        --replace "declare_icu_component(le   icule)" "" \
        --replace "declare_icu_component(lx   iculx)" ""
    '';

    nativeBuildInputs = [
      cmake
      swig
      icu.dev
      icu
      pkg-config
    ];

    buildInputs = [
      icu
      qt48Full
      # libvshadow
    ];
  };
in lib.warn "o dff não está buildando ainda - Work In Progress" dff
