# nixpkgs-brasil

Repositório brasileiro de pacotes Nix. (É um overlay.)

## Objetivos
* Acesso livre (sem abrir requisição ou revisão) para membros do grupo NixOS Brasil. (Solicite no Telegram.)
* Atualização automática de pacotes por automação. Só abrindo requisição em quebra de pacote.
* Se algo for importante, deve existir teste. E se não é importante, pode quebrar.
* Idioma oficial: Português

## Como ativar

### Com Flakes

No `flake.nix`:

```nix
{
  # Use o repositório `nbr` (Nix BRasil) como o endereço do `nixpkgs`
  inputs.nbr.url = "github:nixosbrasil/nixpkgs-brasil";

  outputs = { self, nixpkgs }:
    let pkgs = nbr.legacyPackages.${"linux-x86_64"}; in
    {
      ...
    };
}
```

## Comunidade no Telegram

https://t.me/nixosbrasil
