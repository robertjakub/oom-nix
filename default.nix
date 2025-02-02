{pkgs ? import <nixpkgs> {}}: {
  cribl = pkgs.callPackage ./pkgs/cribl {};
}
