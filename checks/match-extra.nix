{ lib, test, match, ... }:
let
  x = 42;
in
  test.with-tests
  {}
  {
    "It can match by function args." = { _assert }:
    let
      expected = { value = 42; };
      actual = match expected [
        ({ not-value }: throw "incorrect match!")
        ({ value }: value)
      ];
    in
      _assert.eq expected.value actual
    ;
  }
