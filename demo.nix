{ repo ? builtins.fetchGit ./.
, versionFile ? ./.version
, officialRelease ? false

, nixpkgs ? null
, config ? {}
, system ? builtins.currentSystem
}:

let
  bootstrap = import ./nix/bootstrap.nix {
    inherit nixpkgs config system;
    inherit repo officialRelease versionFile;
  };
in
  
with bootstrap.pkgs;

stdenv.mkDerivation {
  pname = "demo";
  inherit (bootstrap) version;

  src = ./.;

  installPhase = ''
    mkdir -p $out
    touch $out/test.txt
  '';
}
