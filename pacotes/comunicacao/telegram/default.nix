{ lib
, fetchurl
, callPackage
, stdenvNoCC
, appimage-wrap
, copyDesktopItems
, makeDesktopItem
}:
let
  data = builtins.fromJSON (builtins.readFile ./dados.json);
  
in stdenvNoCC.mkDerivation {
  pname = "telegram-desktop";
  inherit (data) version;

  src = fetchurl {
    inherit (data) sha256 url;
  };

  nativeBuildInputs = [ copyDesktopItems appimage-wrap ];

  desktopItems = [
    (makeDesktopItem {
      name = "Telegram";
      desktopName = "Telegram";
      categories = [ "Network" ];
      exec = "telegram-desktop -- %u";
    })
  ];

  installPhase = ''
    mkdir -p $out/bin
    install ./Telegram $out/bin/.telegram-desktop

    echo '@aenv/bin/appimage-env @out/bin/.telegram-desktop "$@"' > $out/bin/telegram-desktop

    substituteInPlace $out/bin/telegram-desktop \
      --replace @out $out \
      --replace @aenv ${appimage-wrap}

    chmod +x $out/bin/telegram-desktop

  '';

  meta = with lib; {
    description = "Telegram Desktop messaging app";
    longDescription = ''
      Desktop client for the Telegram messenger, based on the Telegram API and
      the MTProto secure protocol.
    '';
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    homepage = "https://desktop.telegram.org/";
    changelog = "https://github.com/telegramdesktop/tdesktop/releases/tag/v${version}";
  };
}
