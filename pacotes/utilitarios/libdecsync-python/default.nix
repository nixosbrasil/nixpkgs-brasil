{ libdecsync
, buildPythonPackage
, fetchFromGitHub
, lib
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "libdecsync-python";
  inherit (libdecsync) version;

  nativeBuildInputs = [ unittestCheckHook ];

  src = fetchFromGitHub {
    owner = "39aldo39";
    repo = "libdecsync-bindings-python3";
    rev = "v${libdecsync.version}";
    hash = {
      "2.2.1" = "sha256-dyfT8txg2bQCFB3TL+EBBfMNVKT22Cmh/gN+rH6RrYI=";
    }.${version} or "sha256:${lib.fakeSha256}";
  };

  postPatch = ''
    rm libdecsync/libs -rf
    substituteInPlace libdecsync/__init__.py \
      --replace 'CDLL(libpath)' 'CDLL("${libdecsync}/${libdecsync.libFilename}")'
  '';
}
