self:
let
  tikal-config = {
    log-level = 8;
    test-filters = [ { glob = "*"; } ];
  };
in
  {
    checks = self.callPackage ./checks.nix {};
    do-lib = self.callPackage ./prelude/do.nix {};
    trace-lib = self.callPackage ./prelude/trace.nix {};
    main = self.callPackage ./prelude/main.nix {};
    log = self.callPackage ./prelude/log.nix { inherit (tikal-config) log-level; };
    python = self.callPackage ./prelude/python.nix {};
    string = self.callPackage ./prelude/string.nix {};
    godel = self.callPackage ./prelude/godel.nix {};
    match = self.callPackage ./prelude/match.nix {};
    test = self.callPackage ./prelude/test.nix { inherit (tikal-config) test-filters; };
    list = self.callPackage ./prelude/list.nix {};
    path = self.callPackage ./prelude/path.nix {};
    attrs = self.callPackage ./prelude/attrs.nix {};
    xonsh = self.callPackage ./prelude/xonsh.nix {};
    template = self.callPackage ./prelude/template.nix {};
    #inherit (self.trace-lib) trace trace-value debug-print;
    #inherit (do-lib) do;
  }
