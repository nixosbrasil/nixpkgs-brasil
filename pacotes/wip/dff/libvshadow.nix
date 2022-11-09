{ stdenv
, lib
, fetchFromGitHub
, buildPythonPackage
, autoreconfHook
, pkg-config
, fusePackages
, patch
, runCommand
}:
let
  libcerror = stdenv.mkDerivation {
    pname = "libcerror";
    version = "unstable-20220101";
    nativeBuildInputs = [ autoreconfHook pkg-config ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libcerror";
      rev = "20220101";
      sha256 = "sha256-7IRnjb4jfZPlj1zJ1cbfnz0AEFT8TyI9yewl6/wnr90";
    };
  };
  libfguid = stdenv.mkDerivation {
    pname = "libfguid";
    version = "unstable-20220113";
    nativeBuildInputs = [ autoreconfHook pkg-config libcerror ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libfguid";
      rev = "20220113";
      sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE=";
    };
    patches = [ ./libfguid.patch ];
  };
  libcthreads = stdenv.mkDerivation {
    pname = "libcthreads";
    version = "unstable-20220102";
    nativeBuildInputs = [ autoreconfHook pkg-config libcerror ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libcthreads";
      rev = "20220102";
      sha256 = "sha256-Js94nDw/FsDO7zw2DmUUMaQyT7XHyvoocPBk1TXi7/M=";
    };
    patches = [ ./libcthreads.patch ];
  };
  libcdata = stdenv.mkDerivation {
    pname = "libcdata";
    version = "unstable-20220115";
    nativeBuildInputs = [ autoreconfHook pkg-config libcerror libcthreads ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libcdata";
      rev = "20220115";
      sha256 = "sha256-wOv80/xIy/Fpma3AAeATDk1ULCFoPmM6rgCOevIk4lw=";
    };
    patches = [ ./libcdata.patch ];
  };
  libclocale = stdenv.mkDerivation {
    pname = "libclocale";
    version = "unstable-20220107";
    nativeBuildInputs = [ autoreconfHook pkg-config libcerror ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libclocale";
      rev = "20220107";
      sha256 = "sha256-rhr9LfmSlpsadxUIv8joDP/bid8RpyOyoNJ6szfa2w4=";
    };
    patches = [ ./libclocale.patch ];
  };
  libcnotify = stdenv.mkDerivation {
    pname = "libcnotify";
    version = "unstable-20220108";
    nativeBuildInputs = [ autoreconfHook pkg-config libcerror ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libcnotify";
      rev = "20220108";
      sha256 = "sha256-Ba9v6NCQ/TvvIA08Z8yao2OCaNoYn1Yh/TBezZuR9LM=";
    };
    patches = [ ./libcnotify.patch ];
  };
  libcsplit = stdenv.mkDerivation {
    pname = "libcsplit";
    version = "unstable-20220109";
    nativeBuildInputs = [ autoreconfHook pkg-config libcerror ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libcsplit";
      rev = "20220109";
      sha256 = "sha256-SWq5gJx8qhPg/mRkyeOpW4ZqicB5AGigVt0K2x7bha0=";
    };
    patches = [ ./libcsplit.patch ];
  };
  libfdatetime = stdenv.mkDerivation {
    pname = "libfdatetime";
    version = "unstable-20220112";
    nativeBuildInputs = [ autoreconfHook pkg-config libcerror ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libfdatetime";
      rev = "20220112";
      sha256 = "sha256-J2HYD0H6iyaKnsvHhLyjnyOqmfJyBC/zpilr7cGK2eU=";
    };
    patches = [ ./libfdatetime.patch ];
  };
  libcdatetime = stdenv.mkDerivation {
    pname = "libcdatetime";
    version = "unstable-20220104";
    nativeBuildInputs = [ autoreconfHook pkg-config libcerror ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libcdatetime";
      rev = "20220104";
      sha256 = "sha256-QvKH+m6dQ/xWYgbGS+2rGlijaUwM0//zb14BimSv0Vs=";
    };
    patches = [ ./libcdatetime.patch ];
  };
  libcfile_header = runCommand "libcfile_definitions_header" {} ''
    mkdir -p $out/include
    cp ${libcfile.src}/libcfile/*.h $out/include
    substitute ${libcfile.src}/libcfile/libcfile_definitions.h.in $out/include/libcfile_definitions.h \
      --replace @VERSION@ ${libcfile.version}
  '';
  libuna = stdenv.mkDerivation {
    pname = "libuna";
    version = "unstable-20220611";
    nativeBuildInputs = [ autoreconfHook pkg-config libcerror libcdatetime libclocale libcnotify libcfile_header ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libuna";
      rev = "20220611";
      sha256 = "sha256-rlN6XMIvqezX6HW9yGlNPRuBHmD8s2K2yqlWknZdoeo=";
    };
    patches = [ ./libuna.patch ];
    postPatch = ''
      cp ${libcfile.src} libcfile -r
      ls -1
      chmod +w -R libcfile
      patch -d libcfile -i ${./libcfile.patch}
      ln -s . libcfile/libuna
    '';
  };
  libcpath = stdenv.mkDerivation {
    pname = "libcpath";
    version = "unstable-20220108";
    nativeBuildInputs = [ autoreconfHook pkg-config ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libcpath";
      rev = "20220108";
      sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE=";
    };
  };
  libbfio = stdenv.mkDerivation {
    pname = "libbfio";
    version = "unstable-20221025";
    nativeBuildInputs = [ autoreconfHook pkg-config ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libbfio";
      rev = "20221030";
      sha256 = "sha256-8MjtzxgOrfC/FR/FTKCanWoOJalsrcXTKNIXjrGrAdw=";
    };
  };
  libcfile = stdenv.mkDerivation {
    pname = "libcfile";
    version = "unstable-20220106";
    nativeBuildInputs = [ autoreconfHook pkg-config libcerror libclocale libcnotify patch libuna ];
    src = fetchFromGitHub {
      owner = "libyal";
      repo = "libcfile";
      rev = "20220106";
      sha256 = "sha256-3H6+6S/8Ai+Kz/i+v9acsNwH/WPluSYob8w5a8XfOw4=";
    };
    patches = [ ./libcfile.patch ];
  };
  libvshadow = buildPythonPackage {
    pname = "libvshadow";
    version = "alpha-20221030";

    nativeBuildInputs = [ autoreconfHook pkg-config ];

    buildInputs = [ fusePackages.fuse_3 ];

    configureFlags = [ "--enable-python" "--enable-wide-character-type" "--enable-debug-output" "--enable-verbose-output" ];

    unpackPhase = ''
      cp -r ${fetchFromGitHub {
        owner = "libyal";
        repo = "libvshadow";
        rev = "20221030";
        sha256 = "sha256-nHORdnEhjSk9y4FZ+WgHfWGH64ZHYWe+JY7VLzaehpg=";
      }}/* .

      ${
        let
          deps = [
            { name = "libbfio"; rev = "20221025"; sha256 = "sha256-8MjtzxgOrfC/FR/FTKCanWoOJalsrcXTKNIXjrGrAdw="; }
            { name = "libcdata"; rev = "20220115"; sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE="; }
            { name = "libcerror"; rev = "20220101"; sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE="; }
            { name = "libcfile"; rev = "20220106"; sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE="; }
            { name = "libclocale"; rev = "20220107"; sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE="; }
            { name = "libcnotify"; rev = "20220108"; sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE="; }
            { name = "libcpath"; rev = "20220108"; sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE="; }
            { name = "libcsplit"; rev = "20220109"; sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE="; }
            { name = "libcthreads"; rev = "20220102"; sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE="; }
            { name = "libfdatetime"; rev = "20220112"; sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE="; }
            { name = "libcdatetime"; rev = "20220104"; sha256 = "sha256-QvKH+m6dQ/xWYgbGS+2rGlijaUwM0//zb14BimSv0Vs="; }
            { name = "libfguid"; rev = "20220113"; sha256 = "sha256-FfTfhsuFUnJiR7FY009tJfWs4+kLSb/o6/bcwXSIelE="; }
            { name = "libuna"; rev = "20220611"; sha256 = "sha256-rlN6XMIvqezX6HW9yGlNPRuBHmD8s2K2yqlWknZdoeo="; }
          ];
        in builtins.concatStringsSep "\n" (builtins.map (dep: ''
          cp -r ${fetchFromGitHub {
            inherit (dep) rev sha256;
            owner = "libyal";
            repo = dep.name;
          }} ${dep.name}
          chmod +w -R .

          LOCAL_LIB=${dep.name}
          LOCAL_LIB_UPPER=${lib.toUpper dep.name}

          LOCAL_LIB_VERSION=`grep -A 2 AC_INIT ${dep.name}/configure.ac | tail -n 1 | sed 's/^\s*\[\([0-9]*\)\],\s*$/\1/'`
          LOCAL_LIB_MAKEFILE_AM="${dep.name}/Makefile.am"

          cp ${dep.name}/${dep.name}/*.[chly] ${dep.name} || true
          cp ${dep.name}/$LOCAL_LIB_MAKEFILE_AM $LOCAL_LIB_MAKEFILE_AM || true

          # Make the necessary changes to libyal/Makefile.am

          SED_SCRIPT="/AM_CPPFLAGS = / {
              i\\
          if HAVE_LOCAL_${lib.toUpper dep.name}
          }

          /lib_LTLIBRARIES = / {
              s/lib_LTLIBRARIES/noinst_LTLIBRARIES/
          }

          /${dep.name}\.c/ {
              d
          }

          /${dep.name}_la_LIBADD/ {
          :loop1
              /${dep.name}_la_LDFLAGS/ {
                  N
                  i\\
          endif
                  d
              }
              /${dep.name}_la_LDFLAGS/ !{
                  N
                  b loop1
              }
          }

          /${dep.name}_la_LDFLAGS/ {
              N
              i\\
          endif
              d
          }

          /distclean: clean/ {
              n
              N
              d
          }";
            echo "$SED_SCRIPT" >> ${dep.name}.sed
            sed -i'~' -f ${dep.name}.sed $LOCAL_LIB_MAKEFILE_AM
            rm -f ${dep.name}.sed

            sed -i'~' "/AM_CPPFLAGS = /,/noinst_LTLIBRARIES = / { N; s/\\\\\\n.@${lib.toUpper dep.name}_DLL_EXPORT@//; P; D; }" $LOCAL_LIB_MAKEFILE_AM
            sed -i'~' "/${dep.name}_definitions.h.in/d" $LOCAL_LIB_MAKEFILE_AM || true
            sed -i'~' "/${dep.name}\\.rc/d" $LOCAL_LIB_MAKEFILE_AM

            ${lib.optionalString (dep.name == "libfplist") ''
                # TODO: make this more generic to strip the last \\
                sed -i'~' 's/libfplist_xml_scanner.c \\/libfplist_xml_scanner.c/' $LOCAL_LIB_MAKEFILE_AM
            ''}

            ${lib.optionalString (dep.name == "libodraw") ''
                # TODO: make this more generic to strip the last \\
                sed -i'~' 's/libfplist_xml_scanner.c \\/libfplist_xml_scanner.c/' $LOCAL_LIB_MAKEFILE_AM
            ''}

              sed -i'~' 's/libodraw_cue_scanner.c \\/libodraw_cue_scanner.c/' $LOCAL_LIB_MAKEFILE_AM
              sed -i'~' '/EXTRA_DIST = /,/^$/d' $LOCAL_LIB_MAKEFILE_AM

          SED_SCRIPT="/^$/ {
              x
              N
              /endif$/ {
                  a\\

                  D
              }
          }";
            echo "$SED_SCRIPT" >> ${dep.name}.sed;
            sed -i'~' -f ${dep.name}.sed $LOCAL_LIB_MAKEFILE_AM;
            rm -f ${dep.name}.sed;

            ${lib.optionalString (dep.name == "libcfile") ''
                if ! test -f "m4/libuna.m4";
                then
                    sed -i'~' 's?@LIBUNA_CPPFLAGS@?-I$(top_srcdir)/libuna?' $LOCAL_LIB_MAKEFILE_AM;
                fi
            ''}

            ${lib.optionalString (dep.name == "libfplist") ''
                if test -f "m4/libfdatetime.m4";
                then
                    sed -i'~' '/@LIBFGUID_CPPFLAGS@/{h; s/FGUID/FDATETIME/; p; g;}' $LOCAL_LIB_MAKEFILE_AM;
                fi
            ''}

            ${lib.optionalString (dep.name == "libfvalue") ''
              # Make the necessary changes to libfvalue/Makefile.am
                if ! test -f "m4/libfdatetime.m4";
                then
                    sed -i'~' '/@LIBFDATETIME_CPPFLAGS@/d' $LOCAL_LIB_MAKEFILE_AM;
                fi
                if ! test -f "m4/libfguid.m4";
                then
                    sed -i'~' '/@LIBFGUID_CPPFLAGS@/d' $LOCAL_LIB_MAKEFILE_AM;
                fi
                if ! test -f "m4/libfwnt.m4";
                then
                    sed -i'~' '/@LIBFWNT_CPPFLAGS@/d' $LOCAL_LIB_MAKEFILE_AM;
                fi
                if ! test -f "m4/libuna.m4";
                then
                    sed -i'~' '/@LIBUNA_CPPFLAGS@/d' $LOCAL_LIB_MAKEFILE_AM;
                fi

            ''}
            ${lib.optionalString (dep.name == "libsmraw") ''
              # Make the necessary changes to libsmraw/Makefile.am
                if test -f "m4/libfdatetime.m4";
                then
                    sed -i'~' '/@LIBFVALUE_CPPFLAGS@/{h; s/FVALUE/FDATETIME/; p; g;}' $LOCAL_LIB_MAKEFILE_AM;
                fi
                if test -f "m4/libfguid.m4";
                then
                    sed -i'~' '/@LIBFVALUE_CPPFLAGS@/{h; s/FVALUE/FGUID/; p; g;}' $LOCAL_LIB_MAKEFILE_AM;
                fi
            ''}
            # Remove libyal/libyal.c
            rm -f $LOCAL_LIB/$LOCAL_LIB.c;

            # Make the necessary changes to libyal/libyal_defitions.h
            cp ${dep.name}/${dep.name}/${dep.name}_definitions.h.in ${dep.name}/${dep.name}_definitions.h || true
            sed -i'~' "s/@VERSION@/$LOCAL_LIB_VERSION/" ${dep.name}/${dep.name}_definitions.h;

            rm -rf ${dep.name};
        '') deps)

      }
    '';
  };
in {
  inherit libbfio libcdata libcerror libcfile libclocale libcnotify libcpath libcsplit libcthreads libfdatetime libcdatetime libfguid libuna
  # libvshadow
  ;
}
