{ lib, buildVscodeExtension, fetchurl }:
let
  json = builtins.fromJSON (builtins.readFile ./dados.json);
  buildExtension = { id, version ? null}: let
    selectedVersion = if version != null
      then version
      else (builtins.head (builtins.sort (lib.versionAtLeast) (builtins.attrNames json.${id}.versions))) # pega ultima versão
    ;
  in buildVscodeExtension {
    vscodeExtUniqueId = id;
    version = selectedVersion;
    name = id;
    src = fetchurl {
      inherit (json.${id}.versions.${selectedVersion}) url sha256;
      name = "${id}.zip";
    };
    inherit (json.${id}) description;
  };
  extensoesUltimasVersoes = builtins.mapAttrs (k: _: buildExtension { id = k; }) json;
in extensoesUltimasVersoes // {
  inherit buildExtension;
}
