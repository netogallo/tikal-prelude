{ path, pkgs, test, ... }:
let
  inherit (path) is-file-reference;
in
  test.with-tests
  {}
  {
    "it is a reference to a file" = { _assert, ... }: _assert.all [
      (_assert.true (is-file-reference ./path-extra.nix))
      (_assert.true (is-file-reference (pkgs.writeText "test" "test")))
    ];
  }
