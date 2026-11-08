{
  description = "ch32-hal-nix";

  inputs = {
    nixpkgs = {
      type = "indirect";
      id = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    packages = builtins.mapAttrs (
      system: pkgs:
      let
        opkgs = (pkgs.extend (import inputs.rust-overlay));
      in
      {
        rust = opkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        default = inputs.self.packages.${system}.rust;
      }
    ) inputs.nixpkgs.legacyPackages;

    # Instantiate the default dev shell with `nix develop`
    devShells = builtins.mapAttrs (system: pkgs: {
      default =
        let
          rust = inputs.self.packages.${system}.rust;
        in
        pkgs.mkShell rec {
          name = "ch32-hal-nix";

          packages = [
            rust
          ]
          ++ [
            pkgs.wlink
            pkgs.rust-analyzer
            pkgs.cargo-generate
          ];

          shellHook = ''
            export PS1="(${name})$PS1"
            export RUSTUP_TOOLCHAIN=${rust}
          '';
        };
    }) inputs.nixpkgs.legacyPackages;
  };
}
