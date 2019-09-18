with (import ./nix/bootstrap.nix {
  repo = builtins.fetchGit ./.;
  versionFile = ./.version;
  nixpkgs = {
    url    = "https://github.com/nixos/nixpkgs-channels/archive/c4196cca9acd1c51f62baf10fcbe34373e330bb3.tar.gz";
    sha256 = "0jsisiw8yckq96r5rgdmkrl3a7y9vg9ivpw12h11m8w6rxsfn5m5";
  };
});

pkgs.stdenv.mkDerivation {
  pname = "demo";
  inherit version;

  src = ./.;

  installPhase = ''
    mkdir -p $out
    touch $out/test.txt
  '';
}
