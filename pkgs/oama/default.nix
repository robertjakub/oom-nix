{
  fetchgit,
  fetchFromGitHub,
  haskellPackages,
  lib,
  pkgs,
  http2,
  warp,
}: let
  pname = "oama";
  version = "0.14";
  src = fetchFromGitHub {
    owner = "pdobsan";
    repo = "oama";
    sha256 = "sha256-ADtXgGq0h5wUiCGavHXGnPYsGjwxqrnD6NsSCA2bsME=";
    rev = "${version}";
    fetchSubmodules = true;
  };
in
  with haskellPackages;
    mkDerivation {
      inherit pname version src;

      isLibrary = true;
      isExecutable = true;
      libraryHaskellDepends = with haskellPackages; [
        aeson
        base
        bytestring
        containers
        directory
        hsyslog
        http-conduit
        network-uri
        optparse-applicative
        pretty-simple
        process
        string-qq
        strings
        text
        time
        twain
        unix
        utf8-string
        warp
        yaml
      ];
      executableHaskellDepends = with haskellPackages; [
        aeson
        base
        bytestring
        containers
        directory
        hsyslog
        http-conduit
        network-uri
        optparse-applicative
        pretty-simple
        process
        string-qq
        strings
        text
        time
        twain
        unix
        utf8-string
        warp
        yaml
      ];
      license = lib.licenses.bsd3;
      mainProgram = "oama";
    }
