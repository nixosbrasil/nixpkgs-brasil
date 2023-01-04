{ lib
, stdenv
, fetchzip
, fetchurl
, fetchFromGitHub
, pkg-config
, glib
, udev
, json-glib
, gnutls
, krb5
, polkit
, libssh
, pam
, autoreconfHook
, git
, glibc
, libxcrypt
, gettext
, libxslt
, xmlto
, python3Packages
, docbook_xsl
, docbook_xml_dtd_43
, nodejs
, ripgrep
, makeWrapper
, coreutils
, gnused
, openssl
}:
stdenv.mkDerivation rec {
  pname = "cockpit";
  version = "282.1";
  src = fetchFromGitHub {
    owner = "cockpit-project";
    repo = "cockpit";
    rev = "83d2ca1295a47c4d2c5a2904a27f8087d2641657";
    sha256 = "sha256-R3IMga5/j1tmUcXaZpzo3VhgPmsn03yI7aZUnxJouVU=";
    leaveDotGit = true;
    fetchSubmodules = true;
    deepClone = true;
  };
  enableParallelBuilding = true;
  # format = "pyproject";
  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    # python3Packages.pipBuildHook

    pkg-config
    glib.dev
    pam.out
    # python3Packages.setuptools
    python3Packages.python
    libxcrypt
    libxslt.bin
    xmlto
    gettext
    pam.out
    nodejs
    git
    ripgrep
    docbook_xsl
    docbook_xml_dtd_43
  ];
  buildInputs = [
    glib
    udev
    json-glib
    gnutls
    krb5
    polkit
    libssh
  ];
  patches = [
    ./nerf-node-modules.patch
    ./fix-cockpit-certificate-helper.patch
    ./fix-cockpit-certificate-ensure.patch
  ];
  configureFlags = [
    "--enable-prefix-only=yes"
    "--disable-pcp" # TODO: figure out how to package its dependency
  ];
  patchCodeImpurities = ''
    patchShebangs tools/escape-to-c
    patchShebangs tools/make-compile-commands
    patchShebangs tools/node-modules
    patchShebangs tools/termschutz
    patchShebangs tools/webpack-make
    export HOME=$(mktemp -d)
    cp node_modules/.package-lock.json package-lock.json
  '';
  generateVersionFile = ''
    echo "m4_define(VERSION_NUMBER, [${version}])" > version.m4
  '';
  preConfigurePhases = [ "patchCodeImpurities" "generateVersionFile" ];
  fixupPhase = ''
    wrapProgram $out/bin/cockpit-bridge \
      --suffix LD_LIBRARY_PATH : /run/current-system/sw/lib \
      --suffix PYTHONPATH : $out/lib/python3

    patchShebangs $out/libexec/cockpit-certificate-helper
    patchShebangs $out/libexec/cockpit-client
    patchShebangs $out/libexec/cockpit-desktop
    patchShebangs $out/share/cockpit/motd/update-motd
    wrapProgram $out/libexec/cockpit-certificate-helper \
      --prefix PATH : ${lib.makeBinPath [ coreutils openssl ]} \

    wrapProgram $out/share/cockpit/motd/update-motd \
      --prefix PATH : ${lib.makeBinPath [ gnused ]}
    install -D -d src/systemd_ctypes $out/lib/python3
    install -D -d src/cockpit $out/lib/python3
  '';
  checkPhase = ''
    make pytest
  '';
}
