{ fetchFirefoxAddon
, fetchurl
}:
let
  jsonData = builtins.fromJSON (builtins.readFile ./dados.json);
in builtins.mapAttrs (nome: dados: (fetchFirefoxAddon {
    name = nome;
    sha256 = dados.download_hash;
    url = dados.download_url;
  }).overrideAttrs (old: {
    name = "${nome}-${dados.version}";
    meta = {
      inherit (dados) description homepage;
    };
    passthru = {
      inherit dados;
      xpi = fetchurl {
        url = dados.download_url;
        sha256 = dados.download_hash;
      };
    };
  })) jsonData
