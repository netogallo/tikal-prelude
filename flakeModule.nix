{ self, lib, config, flake-parts-lib, ... }:
let
  nixpkgs = self.inputs.nixpkgs;
  inherit (flake-parts-lib)
    mkPerSystemOption;
  inherit (lib)
    mkOption
    types;
  config' = config;
in
{
  config = {
    flake.overlays.default = final: prev:
    let
      inherit (prev) lib;
      prelude = lib.makeScope prev.newScope (import ./prelude.nix);
    in
      {
        tikal.prelude = prelude;
      }
    ;
  };
  options = {

    perSystem = mkPerSystemOption ({ pkgs, system, config, ... }:
    let
      inherit (pkgs.extend self.overlays.default) tikal;
    in
      {
        checks.tikal-prelude = tikal.prelude.checks.all;
      }
    );
  };
}
