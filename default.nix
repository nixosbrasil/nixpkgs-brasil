{ pkgs ? import <nixpkgs> {} }:
import ./overlay.nix pkgs pkgs
