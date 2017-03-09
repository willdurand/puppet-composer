with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "willdurand-puppet-composer";

  buildInputs =
  [
    (import ./env.nix)
  ];
}
