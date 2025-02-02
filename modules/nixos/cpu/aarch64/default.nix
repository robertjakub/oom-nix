{lib, ...}: let
  inherit (lib) mkDefault;
in {
  nixpkgs.hostPlatform = mkDefault "aarch64-linux";

  # workaround for https://github.com/NixOS/nixpkgs/issues/344963
  boot.initrd.systemd.tpm2.enable = false;
}
