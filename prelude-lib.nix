{ lib, nixpkgs, newScope, tikal-config, ... }:
let
  /**
  The "naked" tikal prelude library. This contains the components
  of tikal prelude which don't need a `pkgs` instance.
  */
  prelude = lib.makeScope newScope (self: {
    log = self.callPackage ./prelude/log.nix { inherit (tikal-config) log-level; };
    trace-lib = self.callPackage ./prelude/trace.nix {};
    do-lib = self.callPackage ./prelude/do.nix {};
    main = self.callPackage ./prelude/main.nix {};
    python = self.callPackage ./prelude/python.nix {};
    string = self.callPackage ./prelude/string.nix {};
    godel = self.callPackage ./prelude/godel.nix {};
    match = self.callPackage ./prelude/match.nix {};
    test = self.callPackage ./prelude/test.nix { inherit (tikal-config) test-filters; };
    list = self.callPackage ./prelude/list.nix {};
    path = self.callPackage ./prelude/path.nix {};
    attrs = self.callPackage ./prelude/attrs.nix {};
    inherit (self.trace-lib) trace trace-value debug-print;
    inherit (self.do-lib) do;
    inherit (self.main) store-path-to-key drop-store-prefix is-prefix
      partition fold-attrs-recursive;
  });
in
  prelude
