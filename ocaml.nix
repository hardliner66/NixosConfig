let
  nixpkgs = import <nixpkgs> {};
in
  with nixpkgs;
  stdenv.mkDerivation {
    name = "ocaml";
    buildInputs = [
      nixpkgs.ocaml
      nixpkgs.opam
    ];
  }
