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
  
in stdenvNoCC.mkDerivation rec {
  pname = "telegram-desktop";
  inherit (data) version;

  src = fetchurl {
    inherit (data) sha256 url;
  };

  buildInputs = [
  ];

  nativeBuildInputs = [ copyDesktopItems ];

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

    echo 'appimage-env @out/bin/.telegram-desktop "$@"' | sed "s;@out;$out;" > $out/bin/telegram-desktop
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
