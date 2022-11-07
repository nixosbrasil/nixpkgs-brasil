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

  dontStrip = true;

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
    runHook preInstall

    mkdir -p $out/bin $out/opt/Telegram
    install ./Telegram $out/opt/Telegram

    echo '@aenv/bin/appimage-env @out/opt/Telegram/Telegram "$@"' > $out/bin/telegram-desktop

    substituteInPlace $out/bin/telegram-desktop \
      --replace @out $out \
      --replace @aenv ${appimage-wrap}

    chmod +x $out/bin/telegram-desktop

    runHook postInstall
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
