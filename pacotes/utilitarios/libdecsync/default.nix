{ stdenv
, lib
, fetchurl
, kotlin-native
, gradle_6
, makeWrapper
, which
, pkg-config
, libxcrypt-legacy
, autoPatchelfHook
}:

let
  data = builtins.fromJSON (builtins.readFile ./sources.json);

  name = if stdenv.isCygwin then "decsync" else "libdecsync";
  archName = if stdenv.isCygwin then "x" else if stdenv.isx86_64 then "amd" else "arm";
  bits = if stdenv.is64bit then "64" else "32";
  extension = if stdenv.isCygwin then "dll" else if stdenv.isDarwin then "dylib" else "so";

  filename = "${name}_${archName}${bits}.${extension}";

  src = fetchurl {
    name = "source.tar.gz";
    inherit (data."source.tar.gz") url hash;
  };

  setupEnvHook = ''
    echo Setting up env
    for item in libffi-3.2.1-2-linux-x86-64 lldb-3-linux llvm-11.1.0-linux-x64-essentials x86_64-unknown-linux-gnu-gcc-8.3.0-glibc-2.19-kernel-4.9-2; do
      mkdir -p $KONAN_DATA_DIR/dependencies/$item/bin
      echo $item >> $KONAN_DATA_DIR/dependencies/.extracted
    done

    ln -s $(${which}/bin/which true) $KONAN_DATA_DIR/dependencies/llvm-11.1.0-linux-x64-essentials/bin/clang
  '';

  ourKotlinNative = kotlin-native.overrideAttrs (old: let
      kotlinNativeVersion = "1.6.0";
      kotlinArch = {
        "x86_64-linux" = "linux-x86_64";
      }.${stdenv.system} or (throw "kotlin-native ${kotlinNativeVersion}: ${stdenv.system} is unsupported.");
    in {
      src = fetchurl {
        url = "https://github.com/JetBrains/kotlin/releases/download/v${kotlinNativeVersion}/kotlin-native-${kotlinArch}-${kotlinNativeVersion}.tar.gz";
        sha256 = "sha256-ZPzFgXT+q+x95SEFO6ou29iDQZpyG855puHHu9XBXlE=";
      };
    });

  headers = stdenv.mkDerivation {
    pname = "libdecsync-headers";
    inherit (data) version;
    inherit src;

    nativeBuildInputs = [
      gradle_6
      makeWrapper
      which
    ];

    postPatch = ''
      rm gradlew

      echo "#!${stdenv.shell}" >> gradlew
      echo '@gradle@ --no-daemon "$@" || true' >> gradlew
      chmod +x gradlew
      substituteInPlace gradlew --replace @gradle@ $(which gradle)

      export GRADLE_USER_HOME=$(mktemp -d)
      export KONAN_DATA_DIR=$(mktemp -d)
      export ANDROID_SDK_ROOT=""

      echo kotlin.native.home=${ourKotlinNative} >> gradle.properties
      echo kotlin.mpp.androidGradlePluginCompatibility.nowarn=true >> gradle.properties

      echo Setting up env
      for item in libffi-3.2.1-2-linux-x86-64 lldb-3-linux llvm-11.1.0-linux-x64-essentials x86_64-unknown-linux-gnu-gcc-8.3.0-glibc-2.19-kernel-4.9-2; do
        mkdir -p $KONAN_DATA_DIR/dependencies/$item/bin
        echo $item >> $KONAN_DATA_DIR/dependencies/.extracted
      done

      ln -s $(which true) $KONAN_DATA_DIR/dependencies/llvm-11.1.0-linux-x64-essentials/bin/clang
    '';

    outputHashMode = "recursive";
    outputHasAlgo = "sha256";
    outputHash = {
      "2.2.1" = "sha256-0tYvEOlEIIPx0BzwqPwAmTqIhr7CmTjZwjLneLDCovA=";
    }.${data.version} or "sha256:${lib.fakeSha256}";

    buildPhase = "make";

    installPhase = ''
      mkdir -p $out
      cp build/bin/linuxX64/releaseShared/*.h $out || true
    '';
  };

  self = stdenv.mkDerivation {
    pname = "libdecsync";
    inherit (data) version;
    inherit src;

    nativeBuildInputs = [ autoPatchelfHook libxcrypt-legacy stdenv.cc.cc.libgcc ];

    binaryLib = fetchurl {
      inherit (data.${filename}) url hash;
    };
    inherit headers;


    postPatch = "rm Makefile";

    installPhase = ''
      mkdir -p $out/lib
      cp $binaryLib $out/lib/${name}.${extension}

      mkdir -p $out/lib/pkgconfig
      cp src/linuxMain/decsync.pc.in $out/lib/pkgconfig/decsync.pc
      substituteInPlace $out/lib/pkgconfig/decsync.pc \
        --replace '${"$"}{prefix}' $out

      mkdir -p $out/share/vala/vapi
      cp bindings/vala/*.vapi $out/share/vala/vapi

      mkdir -p $out/include
      cp src/linuxMain/*.h $out/include
      cp $headers/* $out/include

    '';

    passthru.tests = {
      cpp-test = stdenv.mkDerivation {
        pname = "libdecsync-tests";
        inherit (data) version;
        inherit src;

        nativeBuildInputs = [ self pkg-config ];

        buildPhase = ''
          c++ src/nativeTest/cpp/test.cpp -o test-payload $(pkg-config --libs decsync)
        '';

        installPhase = ''
          ./test-payload
          touch $out
        '';
      };
    };

  };
in self
