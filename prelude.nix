{ pkgs, lib, callPackage, nixpkgs, tikal-config, ... }:
let
  prelude-naked = callPackage ./prelude-lib.nix { inherit nixpkgs tikal-config; };
in
  prelude-naked.overrideScope (super: self: {
    checks = super.callPackage ./checks.nix {};
    xonsh = super.callPackage ./prelude/xonsh.nix {};
    template = super.callPackage ./prelude/template.nix {};
    inherit (self.trace-lib) trace trace-value debug-print;
    inherit (self.do-lib) do;
  })
