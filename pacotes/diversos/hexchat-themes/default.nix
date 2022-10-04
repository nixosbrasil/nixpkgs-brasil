{ pkgs, stdenv }:

let
  themes = {
    aubergine = {
      url = "https://dl.hexchat.net/themes/Aubergine.hct";
      sha256 = "sha256-AMBPOJPmy+ncjHKw+w1Tr2b6icUscqJX5dXPBd8OKvc=";
    };
    black = {
      url = "https://dl.hexchat.net/themes/Black.hct";
      sha256 = "sha256-ZFc5nTxYjvVBeTJB/pybZmE8rNSSrnSKqOzNI3p7kyc=";
    };
    blues = {
      url = "https://dl.hexchat.net/themes/Blues.hct";
      sha256 = "sha256-bdOdZPsNJKoTnx0dFeXsWq1+zgixBXUwpDxxwZr3Zo8=";
    };
    classic = {
      url = "https://dl.hexchat.net/themes/Classic.hct";
      sha256 = "sha256-kAgXB5edlWXdY9Kj6wEIEWB66Oj9gji1ex5FQ822Ok0=";
    };
    color = {
      url = "https://dl.hexchat.net/themes/Color.hct";
      sha256 = "sha256-pJ8dVUPTTcPGRVZpY2RhosJY6X6W3KkbscGKF8GY1ms=";
    };
    cool = {
      url = "https://dl.hexchat.net/themes/Cool.hct";
      sha256 = "sha256-bIRvpbVCPArKYIjGsyz9dXsLCg0jRmIjneWL9u3zzg4=";
    };
    debian = {
      url = "https://dl.hexchat.net/themes/Debian.hct";
      sha256 = "sha256-p24Q0X08VWuZaoXbKGWSPFfNqc0Lvpy1s00F2dQVeq8=";
    };
    default = {
      url = "https://dl.hexchat.net/themes/Default.hct";
      sha256 = "sha256-h0oaUZ0IZclTeXXbwcdsM8NinfBGCF/rnvqFMQ19kYI=";
    };
    fedora = {
      url = "https://dl.hexchat.net/themes/Fedora.hct";
      sha256 = "sha256-jBMkfq8Ga4qHQ4t41B4+jUCzocIbRPM91V0ViqO5w1I=";
    };
    fire = {
      url = "https://dl.hexchat.net/themes/Fire.hct";
      sha256 = "sha256-NRWmuNSJDnnFS6YGLpWWoO0XskaKSrFli6jztn0LUUA=";
    };
    mars = {
      url = "https://dl.hexchat.net/themes/Mars.hct";
      sha256 = "sha256-WB4GxNKcmQcSATQlkX9Q7kpBEYXnH3a+doN3hf+koek=";
    };
    matrix = {
      url = "https://dl.hexchat.net/themes/MatriY.hct";
      sha256 = "sha256-ffkFJvySfl0Hwja3y7XCiNJceUrGvlEoEm97eYNMTZc=";
    };
    mirc = {
      url = "https://dl.hexchat.net/themes/mIRC.hct";
      sha256 = "sha256-y80vExKKElA6wYLln5/9r+FIdC7nHtN8rrpiIN3hfPY";
    };
    monokai = {
      url = "https://dl.hexchat.net/themes/Monokai.hct";
      sha256 = "sha256-uEFnlei3sLWw2O3vFUhHRAZBPoX1ALeo6mtZzM9kskE=";
    };
    paco = {
      url = "https://dl.hexchat.net/themes/Paco.hct";
      sha256 = "sha256-LmQAKaAiFnJybrsHX5UUQvgEh83qg/KK5fS7+LimVdU=";
    };
    pastel = {
      url = "https://dl.hexchat.net/themes/Pastel.hct";
      sha256 = "sha256-YSYRAczBNDv0frmUcXZgvfLZunIHo5DrDzVUdM01LaI=";
    };
    simply-glyphed = {
      name = "Simply-Glyphed.hct";
      url = "https://dl.hexchat.net/themes/Simply%20Glyphed.hct";
      sha256 = "sha256-BRIKvgVSY4nAult6QESM3UQk/a+REGmxUyHpNXwsxEc=";
    };
    simply-glyphed-tango-dark = {
      name = "Simply-Glyphed-Tango-Dark.hct";
      url = "https://dl.hexchat.net/themes/Simply%20Glyphed%20Tango%20Dark.hct";
      sha256 = "sha256-Eofs2C3GrIvDv2Gppgx/7nGhFQXWzwRw65U+JHTQJis=";
    };
    solarized-dark = {
      name = "Solarized-Dark.hct";
      url = "https://dl.hexchat.net/themes/Solarized%20Dark.hct";
      sha256 = "sha256-HkzDxsQqZG0yOwu4evv62txFdKH3YVELOLg2rNiauJc=";
    };
    solarized-light = {
      name = "Solarized-Light.hct";
      url = "https://dl.hexchat.net/themes/Solarized%20Light.hct";
      sha256 = "sha256-evw8mzieUC7q/5ZldM9ADSONofFESPgkBtbIhqBZdBw=";
    };
    smog = {
      url = "https://dl.hexchat.net/themes/Smog.hct";
      sha256 = "sha256-HukkB9EBijgZ8IVZS0auFDle4df3mLpvFTbL7dyQjxU=";
    };
    ubuntu-dark = {
      name = "Ubuntu-Dark.hct";
      url = "https://dl.hexchat.net/themes/Ubuntu%20Dark.hct";
      sha256 = "sha256-uEFnlei3sLWw2O3vFUhHRAZBPoX1ALeo6mtZzM9kskE=";
    };
    ubuntu-light = {
      name = "Ubuntu-Light.hct";
      url = "https://dl.hexchat.net/themes/Ubuntu%20Light.hct";
      sha256 = "sha256-nzgVRh7U35XvUzRZq6mwg5T8MExlNjWkK2UYUawHtVY=";
    };
    zenburn = {
      url = "https://dl.hexchat.net/themes/Zenburn.hct";
      sha256 = "sha256-gAFrippsjTCavLgK5K0aMMDVLxoGzshxALq0RfvMevg=";
    };
  };
  fetchTheme = themeName:
    stdenv.mkDerivation rec {
      name = "hexchat-theme-${themeName}";
      buildInputs = [ pkgs.unzip ];
      src = pkgs.fetchurl themes.${themeName};
      unpackPhase = "unzip ${src}";
      installPhase = "cp -r . $out";
    };
  in
    with builtins;
    listToAttrs (map (name: {
      inherit name;
      value = fetchTheme name;
      }) (attrNames themes)
    )
