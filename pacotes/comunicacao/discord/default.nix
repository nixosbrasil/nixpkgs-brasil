{ branch ? "stable", pkgs, lib, stdenv, fetchurl }:
let
  inherit (pkgs) callPackage fetchurl;
  srcs = builtins.fromJSON (builtins.readFile ./dados.json);
  src = srcs.${stdenv.hostPlatform.system}.${branch};

  meta = with lib; {
    description = "All-in-one cross-platform voice and text chat for gamers";
    homepage = "https://discordapp.com/";
    downloadPage = "https://discordapp.com/download";
    license = licenses.unfree;
    maintainers = with maintainers; [ ldesgoui MP2E devins2518 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ]
      ++ lib.optionals (branch == "ptb") [ "aarch64-darwin" ];
  };
  package = if stdenv.isLinux then ./linux.nix else ./darwin.nix;
  packages = (builtins.mapAttrs
    (_: value: callPackage package (value // { src = fetchurl { inherit (src) url sha256; }; inherit (src) version; meta = meta // { mainProgram = value.binaryName; }; }))
    {
      stable = rec {
        pname = "discord";
        binaryName = "Discord";
        desktopName = "Discord";
      };
      ptb = rec {
        pname = "discord-ptb";
        binaryName = "DiscordPTB";
        desktopName = "Discord PTB";
      };
      canary = rec {
        pname = "discord-canary";
        binaryName = "DiscordCanary";
        desktopName = "Discord Canary";
      };
    }
  );
in packages.${branch}
