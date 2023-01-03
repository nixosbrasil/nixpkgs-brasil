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
, docbook_xsl_ns
, docbook_xml_dtd_43
, nodejs
, ripgrep
}:
let
  systemd_ctypes = python3Packages.buildPythonPackage rec {
    pname = "systemd_ctypes";
    version = "unstable-2023-01-03";
    format = "pyproject";
    src = fetchFromGitHub {
      owner = "allisonkarlitskaya";
      repo = "systemd_ctypes";
      rev = "0238c864f937a259df9ddf28111deb9cfca82208";
      sha256 = "sha256-el3Q2yTBMxcc22G4yQ4L+TiXB+iMY24HT+UpUF/0Rw0=";
    };
    propagatedBuildInputs = with python3Packages; [
      flit-core
      # systemd
    ];
  };
in
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
  nativeBuildInputs = [ pkg-config glib.dev pam.out python3Packages.setuptools autoreconfHook libxcrypt libxslt.bin xmlto gettext pam.out nodejs git ripgrep ];
  buildInputs = [ glib udev json-glib gnutls krb5 polkit libssh ];
  propagatedBuildInputs = [ systemd_ctypes ];
  patches = [ ./disable-pam-check.patch ./nerf-node-modules.patch ];
  makeFlags = [
    "AM_DEFAULT_VERBOSITY=1"
  ];
  configureFlags = [
    "--enable-prefix-only=yes"
    "--disable-pcp" # TODO: figure out how to package it's dependency
  ];
  patchCodeImpurities = ''
    patchShebangs tools/escape-to-c
    patchShebangs tools/make-compile-commands
    patchShebangs tools/node-modules
    patchShebangs tools/termschutz
    patchShebangs tools/webpack-make
    export HOME=$(mktemp -d)
    cp node_modules/.package-lock.json package-lock.json
    # cp $src/.git . -r

    substituteInPlace doc/guide/gtk-doc.xsl doc/man/Makefile-man.am doc/guide/*.xml \
      --replace http://docbook.sourceforge.net/release/xsl/current ${docbook_xsl_ns}/xml/xsl/docbook \
      --replace http://www.oasis-open.org/docbook/xml/4.3 ${docbook_xml_dtd_43}/xml/dtd/docbook
    rg -F 'http://docbook.sourceforge.net' || echo nada feijoada
  '';
  generateVersionFile = ''
    echo "m4_define(VERSION_NUMBER, [${version}])" > version.m4
  '';
  preConfigurePhases = [ "patchCodeImpurities" "generateVersionFile" ];
  fixupPhase = ''
    wrapProgram $out/bin/cockpit-bridge \
      --suffix LD_LIBRARY_PATH : /run/current-system/sw/lib \
      --suffix PYTHONPATH : $PYTHONPATH
  '';
  checkPhase = ''
    make pytest
  '';
}
