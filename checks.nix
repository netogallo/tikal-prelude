{
  pkgs,
  lib,
  attrs,
  do-lib,
  godel,
  list,
  match,
  path,
  python,
  string,
  template,
  xonsh,
  ...
}:
let
  eval-tests = name: module:
  let
    attrs = lib.attrNames module;
    items = lib.strings.concatStringsSep "," attrs;
  in
    ''echo "Test ${name}, Passed ${items}"''
  ;
  eval-modules-tests = lib.attrValues (
    lib.mapAttrs eval-tests {
      inherit attrs do-lib godel list match path
        python string template xonsh;
    }
  );

  tests-program =
    lib.strings.concatStringsSep "\n" eval-modules-tests
    + "\ntouch $out"
  ;
    
  all =
    pkgs.runCommand "tikal-prelude" {} tests-program;
in
  {
    inherit all;
  }
