{ self, lib, config, flake-parts-lib, ... }:
let
  nixpkgs = self.inputs.nixpkgs;
  inherit (flake-parts-lib)
    mkPerSystemOption;
  inherit (lib)
    mkOption
    types;
  config' = config;
  tikal-config-flake = {
    log-level = config.tikal.log-level;
    test-filters = config.tikal.test-filters;
  };
  tikal-config-debug = {
    log-level = 8;
    test-filters = [ { glob = "*"; } ];
  };
  glob-type = types.submodule {
    options = {
      glob = lib.mkOption {
        type = types.str;
        description = "The glob expression as a string";
      };
    };
  };
  make-overlay = { tikal-config }: final: prev:
  let
    inherit (prev) lib;
    prelude = prev.callPackage ./prelude.nix { inherit tikal-config nixpkgs; };
  in
    {
      tikal.prelude = prelude;
    }
  ;
  overlay = lib.makeOverridable make-overlay { tikal-config = tikal-config-flake; };
in
{
  config = {
    flake.overlays.default = overlay;
    flake.overlays.debug = overlay.override { tikal-config = tikal-config-debug; };
    flake.lib =
    let
      lib-scope =
        lib.makeScope lib.callPackagesWith (self: {
          inherit lib nixpkgs;
          tikal-config = tikal-config-flake;
          prelude = self.callPackage ./prelude-lib.nix {};
        });
    in
      lib-scope.prelude
    ;
  };
  options = {
    tikal = {
      log-level = lib.mkOption {
        description = ''
          The log verbosity of the output when evaluating the tikal code. Normally,
          this should be left unchanged but can be used when modifying the tikal
          code for debugging. The loglevels are as follows:
            * debug-verbose = 8
            * debug = 7
            * info = 6
            * warning = 5
            * error = 4
            * no logs = < 4
        '';
        type = types.enum [ 0 1 2 3 4 5 6 7 8 ];
        default = 0;
      };
      test-filters = lib.mkOption {
        description = ''
          The tests for Tikal can run automatically as tikal code gets evaluated.
          This allows developers to easily asess if new changes break any tests.
          However, this can incurr a performance penalty, therefore a filter can
          be used to determine what tests are to be run.
        '';
        default = [];
        type = types.listOf (types.oneOf [ types.str glob-type ]);
      };
    };

    perSystem = mkPerSystemOption ({ pkgs, system, config, ... }:
    let
      inherit (pkgs.extend self.overlays.debug) tikal;
    in
      {
        checks.tikal-prelude = tikal.prelude.checks.all;

        # simple check to ensure the lib is well defined
        # All of the lib's functionality is checked by the
        # overlay test.
        checks.tikal-prelude-lib =
          self.lib.log.log-info "The lib is well defined" (
            pkgs.writeText "The lib is well defined" ""
          )
        ;
      }
    );
  };
}
