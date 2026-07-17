{ self, lib, config, flake-parts-lib, ... }:
let
  nixpkgs = self.inputs.nixpkgs;
  inherit (flake-parts-lib)
    mkPerSystemOption;
  inherit (lib)
    mkOption
    types;
  config' = config;
  tikal-config = {
    log-level = 8;
    test-filters = [ { glob = "*"; } ];
  };
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
    flake.lib =
    let
      lib-scope =
        lib.makeScope lib.callPackagesWith (self: {
          inherit lib nixpkgs tikal-config;
          prelude = self.callPackage ./prelude-lib.nix {};
        });
    in
      lib-scope.prelude
    ;
  };
  options = {

    perSystem = mkPerSystemOption ({ pkgs, system, config, ... }:
    let
      inherit (pkgs.extend self.overlays.default) tikal;
    in
      {
        checks.tikal-prelude = tikal.prelude.checks.all;
        checks.tiakl-prelude-lib = self.lib.log.log-info "success" (
          pkgs.writeText "test" "test"
        );
      }
    );
  };
}
