{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types removeSuffix;
  inherit (builtins) readFile;
  fn = import ../lib {inherit lib;};
  cfgRootDir = config.modules.defaults.configRoot;
  sshDir = "${cfgRootDir}/defaults/sshkeys";
  # FIXME
  # sshDir = toString ((fn.relativeToDefaults) "./sshkeys");

  sshkeysList = fn.makeOptionSuffixList {
    p = sshDir;
    s = ".pub";
  };
  sshKeys = lib.listToAttrs (map
    (name: {
      name = name;
      value = removeSuffix "\n" (readFile (toString (/. + "${sshDir}/${name}.pub")));
    })
    sshkeysList);
in {
  options.modules.sshkeys = {
    sshKeys = mkOption {
      type = types.attrs;
      default = sshKeys;
    };
  };
}
