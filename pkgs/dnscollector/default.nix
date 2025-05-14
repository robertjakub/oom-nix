{
  lib,
  fetchFromGitHub,
  buildGoModule,
}: let
  pname = "go-dnscollector";
  version = "0.46.0";
  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    rev = "v${version}";
    sha256 = "sha256-X5PuXXDnKFZFHGVgTdE26U1M0aQ2UQ/tFV0oDOGRT3E=";
  };
in
  buildGoModule {
    inherit pname version src;

    modRoot = "./.";
    vendorHash = "sha256-y6Z9xcU2UX63lxKJ0UPbMBqRWN8Gdj7tXToNg55MHIU=";
    proxyVendor = true;
    doCheck = false;

    meta = with lib; {
      description = "A passive high speed ingestor with pipelining support for your DNS logs.";
      homepage = "https://github.com/dmachard/go-dnscollector";
      license = licenses.mit;
    };
  }
