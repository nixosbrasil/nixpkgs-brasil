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
  # format = "pyproject";
  nativeBuildInputs = [
    pkg-config
    glib.dev
    pam.out
    python3Packages.setuptools
    autoreconfHook
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
    makeWrapper
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
      --suffix PYTHONPATH : $PYTHONPATH

    patchShebangs $out/libexec/cockpit-certificate-helper
    patchShebangs $out/libexec/cockpit-client
    patchShebangs $out/libexec/cockpit-desktop
    patchShebangs $out/share/cockpit/motd/update-motd
    sed -i 's;\(prefix="\).*";\1";' $out/libexec/cockpit-certificate-helper
    wrapProgram $out/libexec/cockpit-certificate-helper \
      --prefix PATH : ${lib.makeBinPath [ coreutils openssl ]} \
      --run 'mkdir -p /etc/cockpit/ws-certs.d'

    wrapProgram $out/share/cockpit/motd/update-motd \
      --prefix PATH : ${lib.makeBinPath [ gnused ]}
  '';
  checkPhase = ''
    make pytest
  '';
}
