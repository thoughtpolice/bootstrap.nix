### `bootstrap.nix`

This project contains a very simple file named `bootstrap.nix` that I use in my
[Nix](https://nixos.org)-built projects. It acts as the "bottom layer" of any
more advanced packaging abstractions. It is responsible for coherently fetching
a copy of `nixpkgs` for you to use (via `fetchTarball`) in a number of ways, as
well as constructing version information for your `version` fields based on
repo information.

Ultimately, I found myself reproducing this logic enough that I extracted it
into its own project. The source code is very simple (< 100 lines of easily
understood code), and intended to be used "inline".

All you have to do is copy the file `nix/bootstrap.nix` into your project and
import it from somewhere. There are multiple ways to do this, but an easy one
can be seen inside the `mini.nix` demo, which completely specifies a snapshot
of Nixpkgs to use:

```nix
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
```

The import of `bootstrap.nix` returns an attrset, with the following structure:

```nix
{
  pkgs    = ... # nixpkgs package set
  version = ... # described in .version
  relname = ... # described in .version
}
```

So in the above example, both `version` and `pkgs` come from this import.

### Other uses

You can bootstrap `nixpkgs` from any directory (such as a git clone), an
HTTP(s) tarball (like above), any upstream NixOS channel, or a pre-configured
snapshot that you specify inline (like above), or with a "lockfile" named
`nixpkgs.json`.

The `demo.nix` file shows a more full-featured example that specifies its
nixpkgs snapshot using the lockfile `nix/nixpkgs.json`. This lock file can be
updated with `nix/update.sh` (but you can use your own, too.) The lockfile can
also be overridden by any user, another feature not exposed by `mini.nix`. For
example, try the following builds:

```bash
nix build -f demo.nix # use lockfile snapshot
nix build -f demo.nix --arg nixpkgs '<nixpkgs>' # use system nixpkgs
nix build -f demo.nix --arg nixpkgs channel:nixos-19.03 # use channel
nix build -f demo.nix --arg nixpkgs https://... # some .tar.gz file
```

### License

MIT. See `LICENSE.txt` for terms of copyright and redistribution.
