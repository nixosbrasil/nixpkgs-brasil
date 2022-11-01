{ lib, buildVscodeExtension, fetchurl }:
let
  json = builtins.fromJSON (builtins.readFile ./dados.json);
  buildExtension = ext: let
    extArroba = builtins.split "@" ext;
    name = builtins.head extArroba;
    version = if (builtins.length extArroba) == 3
      then (builtins.elemAt extArroba 2)
      else (builtins.head (builtins.sort (lib.versionAtLeast) (builtins.attrNames json.${name}.versions))) # pega ultima versão
    ;
  in buildVscodeExtension {
    vscodeExtUniqueId = name;
    name = "${name}-${version}";
    src = fetchurl {
      inherit (json.${name}.versions.${version}) url sha256;
      name = "${name}.zip";
    };
    inherit (json.${name}) description;
  };
  extensoesUltimasVersoes = builtins.mapAttrs (k: _: buildExtension k) json;
in extensoesUltimasVersoes // {
  inherit buildExtension;
}
