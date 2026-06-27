self:
let
  x = 42;
in
  {
    checks = self.callPackage ./checks.nix {};
  }
