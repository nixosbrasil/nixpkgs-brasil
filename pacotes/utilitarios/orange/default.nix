{ stdenv
, lib
, buildPythonPackage
, scipy
, numpy
, fetchFromGitHub
, fetchurl
, cython
, openpyxl
, qtconsole
, bottleneck
, matplotlib
, joblib
, requests
, keyring
, scikit-learn
, pandas
, pyqtwebengine
, fetchPypi
, dictdiffer
, pyqt5
, cachecontrol
, docutils
, python-louvain
, xlrd
, httpx
, pyqtgraph
, typing-extensions
, pythonRelaxDepsHook
, keyrings-alt
, pyyaml
, qt5
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:
let
  serverfiles = buildPythonPackage rec {
    pname = "serverfiles";
    version = "0.3.1";
    propagatedBuildInputs = [
      requests
    ];
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-XhD8MudYeR43NbwIvOLtRwKoOx5Fq5bF1ZzIruz76+E=";
    };
  };
  commonmark = buildPythonPackage rec {
    pname = "commonmark";
    version = "0.9.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-RS+dyFm+fwZjHdyzKLaRnGeYSsplTl/vs5FNVGka7WA=";
    };
  };

  qasync = buildPythonPackage rec {
    pname = "qasync";
    version = "0.19.0";
    doCheck = false; # TODO: xvfb stuff
    propagatedBuildInputs = [
      pyqt5
    ];
    src = fetchFromGitHub {
      owner = "CabbageDevelopment";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-xGAUAyOq+ELwzMGbLLmXijxLG8pv4a6tPvfAVOt1YwU=";
    };
  };
  anyqt = buildPythonPackage rec {
    pname = "AnyQt";
    version = "0.2.0";
    doCheck = false; # TODO: xvfb stuff
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-S5IouRiibfL9zGHxNdtUitPDA25bx+Z7qBR+C2aDdjs=";
    };
  };


  orange-canvas-core = buildPythonPackage rec {
    pname = "orange-canvas-core";
    version = "0.1.28";
    doCheck = false; # TODO: xvfb stuff
    propagatedBuildInputs = [
      dictdiffer
      commonmark
      qasync
      cachecontrol
      docutils
      anyqt
    ];
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-/39T6yQQ/4CRdqsu7pJe+nEQA7AtmAdNEWeroSq99kI=";
    };
  };

  xlsxwriter = buildPythonPackage rec {
    pname = "XlsxWriter";
    version = "3.0.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-6J9KHS+iyeoVzed96VzT/YsDRdDvs5ZGI/OVyMSYi38=";
    };
  };

  opentsne = buildPythonPackage rec {
    pname = "openTSNE";
    version = "0.6.2";
    nativeBuildInputs = [ cython ];
    propagatedBuildInputs = [ numpy scipy scikit-learn ];
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-kuoYr9TjTfj7U2yBPDZTPeiS2WUR9mg3IQAzmLT88uk=";
    };
  };

  orange-widget-base = buildPythonPackage rec {
    pname = "orange-widget-base";
    version = "4.18.0";
    doCheck = false; # TODO: xvfb stuff
    propagatedBuildInputs = [
      pyqt5
      pyqtwebengine
      matplotlib
      orange-canvas-core
      pyqtgraph
      typing-extensions
    ];
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-MHafsf5rofPS/WcXP9sEYc9TYQ0q1ouB22FsA4qoNNY=";
    };
  };

  baycomp = buildPythonPackage rec {
    pname = "baycomp";
    version = "1.0.2";
    # nativeBuildInputs = [ cython ];
    propagatedBuildInputs = [ numpy scipy scikit-learn matplotlib ];
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-xDRywWvXzfSITdTHPdMH5KPacJf+Scg81eiNdRQpI7A=";
    };
  };
in buildPythonPackage rec {
  pname = "Orange3";
  version = "3.33.0";
  doCheck = false; # TODO: xvfb stuff
  propagatedBuildInputs = [
    numpy
    scipy
    openpyxl
    qtconsole
    bottleneck
    matplotlib
    joblib
    requests
    keyring
    scikit-learn
    pandas
    pyqtwebengine
    serverfiles
    orange-canvas-core
    python-louvain
    xlrd
    xlsxwriter
    httpx
    opentsne
    pyqtgraph
    orange-widget-base
    keyrings-alt
    pyyaml
    baycomp
  ];

  desktopItems = [
    (makeDesktopItem { # https://github.com/biolab/orange3/blob/master/distribute/orange-canvas.desktop
      name = "orange";
      exec = "orange-canvas";
      desktopName = "Orange Data Mining";
      genericName = "Data Mining Suite";
      comment = "Explore, analyze, and visualize your data";
      icon = "orange-canvas";
      mimeTypes = [ "application/x-extension-ows" ];
      categories = [ "Science" "Education" "ArtificialIntelligence" "DataVisualization" "NumericalAnalysis" "Qt" ];
      keywords = [ "Machine Learning" "Scientific Visualization" "Statistical Analysis" ];
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/orange-canvas \
      "${"$"}{qtWrapperArgs[@]}"
    mkdir -p $out/share/icons/hicolor/{256x256,48x48}/apps
    cp ${fetchurl {
      url = "https://raw.githubusercontent.com/biolab/orange3/master/distribute/icon-256.png";
      sha256 = "sha256-EykrBlYGdYI8ciWRsc+84J1u3xCdemY8AYkDoBq+6YI=";
    }} $out/share/icons/hicolor/256x256/apps/orange-canvas.png
    cp ${fetchurl {
      url = "https://raw.githubusercontent.com/biolab/orange3/master/distribute/icon-48.png";
      sha256 = "sha256-RJqlBw3Yu3S9Li4BTrntJeC6rR23fj/39I/i8b5hDP4=";
    }} $out/share/icons/hicolor/48x48/apps/orange-canvas.png
  '';

  nativeBuildInputs = [ cython pythonRelaxDepsHook qt5.wrapQtAppsHook copyDesktopItems ];
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ycjG4VHHT2eLopRcOI/T+glfuKXnOhNq6z+X6KhpaO4=";
  };
}
