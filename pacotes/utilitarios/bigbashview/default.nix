{ stdenvNoCC
, lib
, pygobject3
, python
, fetchurl
, makeWrapper
, setproctitle
, webkitgtk_4_1
, wrapGAppsHook
, gobject-introspection
, pyqtwebengine
, libsoup_3
, qt5
, enableGtk ? true
, enableQt ? true
}:
let

  data = builtins.fromJSON (builtins.readFile ./bumpkin.json.lock);

  interpreterLibs = p: with p; [ web setproctitle ]
  ++ lib.optionals enableGtk [ pygobject3 webkitgtk_4_1.dev ]
  ++ lib.optionals enableQt [ pyqtwebengine ]
  ;
  interpreter = python.withPackages interpreterLibs;

  libPrefix = "$out/lib/${interpreter.libPrefix}/site-packages";

in stdenvNoCC.mkDerivation {
  name = "bigbashview";
  src = fetchurl {
    name = "source.${data.file_type}";
    url = data.final_url;
    inherit (data) sha256;
  };

  dontWrapGApps = true;
  dontWrapQtApps = true;

  preferLocalBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals enableQt [ qt5.wrapQtAppsHook ]
  ++ lib.optionals enableGtk [ wrapGAppsHook gobject-introspection ]
  ;

  installPhase = ''
    mkdir $out/${libPrefix} $out/bin -p
    cp -r bigbashview/usr/lib/bbv $out/${libPrefix}

    makeWrapper ${interpreter.interpreter} $out/bin/bigbashview \
      --add-flags $out/${libPrefix}/bbv/bigbashview.py \
      --prefix PYTHONPATH : $out/${libPrefix} \
      ${lib.optionalString enableGtk "${"$"}{gappsWrapperArgs[@]}"} \
      ${lib.optionalString enableGtk "--prefix GI_TYPELIB_PATH : ${webkitgtk_4_1}/lib/girepository-1.0"} \
      ${lib.optionalString enableGtk "--prefix GI_TYPELIB_PATH : ${libsoup_3}/lib/girepository-1.0"} \
      ${lib.optionalString enableQt "${"$"}{qtWrapperArgs[@]}"} \
       \

    # skip 1 line because of the "\"

  '';
}
