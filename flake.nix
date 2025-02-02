{
  description = "oom's base";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  } @ inputs: let
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
    eachSystem = f:
      builtins.listToAttrs (
        builtins.map (system: {
          name = system;
          value = f {
            pkgs = inputs.nixpkgs.legacyPackages.${system};
            inherit system;
          };
        })
        systems
      );
  in {
    baseModules.hm = ./modules/base/hm;
    baseModules.lib = ./modules/base/lib;
    nixosModules = {
      nixos = ./modules/nixos;
      fs = ./modules/nixos/fs;
      cpu-intel-x86-64 = ./modules/nixos/cpu/intel-x86-64;
      cpu-amd-x86-64 = ./modules/nixos/cpu/amd-x86-64;
      cpu-aarch64 = ./modules/nixos/cpu/aarch64;
      default = self.nixosModules.nixos;
    };
    darwinModules = {
      cpu-x86-64 = ./modules/darwin/cpu/x86-64;
      cpu-aarch64 = ./modules/darwin/cpu/aarch64;
      darwin = ./modules/darwin;
      default = self.darwinModules.darwin;
    };
    packages = eachSystem ({pkgs, ...}: import ./default.nix {inherit pkgs;});
  };
}
