with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "willdurand-puppet-composer";

  buildInputs =
  [
    vagrant
    (import ./env.nix)
  ];
}
