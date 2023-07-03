{ lib, buildVscodeExtension, fetchurl }:
let
  json = builtins.fromJSON (builtins.readFile ./dados.json);
  buildExtension = ext: let
    extArroba = builtins.split "@" ext;
    fullName = builtins.head extArroba;
    nameParts = builtins.split "." fullName;

    vscodeExtName = builtins.elemAt nameParts 2;
    vscodeExtPublisher = builtins.head nameParts;
    version = if (builtins.length extArroba) == 3
      then (builtins.elemAt extArroba 2)
      else (builtins.head (builtins.sort (lib.versionAtLeast) (builtins.attrNames json.${fullName}.versions))) # pega ultima versão
    ;
  in buildVscodeExtension {
    inherit vscodeExtName vscodeExtPublisher;
    vscodeExtUniqueId = fullName;
    name = "${fullName}-${version}";
    src = fetchurl {
      inherit (json.${fullName}.versions.${version}) url sha256;
      name = "${fullName}.zip";
    };
    inherit (json.${fullName}) description;
  };
  extensoesUltimasVersoes = builtins.mapAttrs (k: _: buildExtension k) json;
in extensoesUltimasVersoes // {
  inherit buildExtension;
}
