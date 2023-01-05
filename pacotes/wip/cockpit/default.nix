{ lib
, stdenv
, fetchzip
, fetchurl
, fetchFromGitHub
, bash
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
, systemd
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
    python3Packages.setuptools
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
    "--with-default-session-path=/run/current-system/sw/bin"
  ];
  patchCodeImpurities = ''
    patchShebangs tools/escape-to-c
    patchShebangs tools/make-compile-commands
    patchShebangs tools/node-modules
    patchShebangs tools/termschutz
    patchShebangs tools/webpack-make
    patchShebangs test/common/tap-cdp
    patchShebangs test/common/pixel-tests
    patchShebangs test/common/run-tests
    export HOME=$(mktemp -d)
    cp node_modules/.package-lock.json package-lock.json
    substituteInPlace src/systemd_ctypes/libsystemd.py \
      --replace libsystemd.so.0 ${systemd}/lib/libsystemd.so.0
  '';
  generateVersionFile = ''
    echo "m4_define(VERSION_NUMBER, [${version}])" > version.m4
  '';
  preConfigurePhases = [ "patchCodeImpurities" "generateVersionFile" ];
  fixupPhase = ''
    patchShebangs $out/libexec/cockpit-certificate-helper
    patchShebangs $out/share/cockpit/motd/update-motd
    PATH=${python3Packages.python.withPackages (p: with p;[ pygobject3 ])}/bin patchShebangs $out/libexec/cockpit-client
    patchShebangs $out/libexec/cockpit-desktop

    wrapProgram $out/bin/cockpit-bridge \
      --suffix LD_LIBRARY_PATH : /run/current-system/sw/lib \

    wrapProgram $out/libexec/cockpit-certificate-helper \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]} \
      --run 'cd $(mktemp -d)' \
      --prefix PATH : ${lib.makeBinPath [ coreutils openssl ]}

    wrapProgram $out/share/cockpit/motd/update-motd \
      --prefix PATH : ${lib.makeBinPath [ gnused ]}
    substituteInPlace $out/libexec/cockpit-desktop \
      --replace ' /bin/bash' ' ${bash}/bin/bash'

  '';

  doCheck = true;
  checkInputs = [ python3Packages.pytest ];
  checkPhase = ''
    make pytest
    cat config.h
  '';
}
