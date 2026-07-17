{ lib, nixpkgs, newScope, tikal-config, ... }:
let
  prelude = lib.makeScope newScope (self: {
    log = self.callPackage ./prelude/log.nix { inherit (tikal-config) log-level; };
    trace-lib = self.callPackage ./prelude/trace.nix {};
  });
in
  prelude
