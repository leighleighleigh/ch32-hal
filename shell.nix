{
  pkgs ? import <nixpkgs> { },
}:
let
  rustOverlay = builtins.fetchGit {
    url = "https://github.com/oxalica/rust-overlay";
    rev = "0d0575988e4bb9ebc4cf1afb1cec1ceac0b5914e";
  };

  pkgs = import <nixpkgs> {
    overlays = [ (import rustOverlay) ];
  };

  rust = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
in
pkgs.mkShell rec {
  name = "ch32-nix";

  buildInputs = [
    rust
    pkgs.wlink
    pkgs.rust-analyzer
    pkgs.cargo-generate
  ];

  shellHook = ''
    # set the shell logline or whatever it's called
    export PS1="''${debian_chroot:+($debian_chroot)}\[\033[01;39m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ "
    export PS1="(${name})$PS1"
    # This variable is important - it tells rustup where to find the esp toolchain,
    # without needing to copy it into your local ~/.rustup/ folder.
    export RUSTUP_TOOLCHAIN=${rust}
  '';
}
