# nixpkgs-brasil

Repositório brasileiro de pacotes Nix. (É um overlay.)

## Objetivos
* Acesso livre (sem abrir requisição ou revisão) para membros do grupo NixOS Brasil. (Solicite no Telegram.)
* Atualização automática de pacotes por automação. Só abrindo requisição em quebra de pacote.
* Idioma oficial: Português

## Como ativar

### Com Flakes

No `flake.nix`:

```nix
{
  # Use este repositório como o endereço do `nixpkgs`
  inputs.nixpkgs.url = "github:nixosbrasil/nixpkgs-brasil";

  outputs = { self, nixpkgs }:
    let pkgs = nixpkg.legacyPackages.${"YOUR_SYSTEM_STRING"}; in
    {
      ...
    };
}
```

## Comunidade no Telegram

https://t.me/nixosbrasil