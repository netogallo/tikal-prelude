{ pkgs, lib, ... }:
let
  dummy = pkgs.runCommand "dummy" {} "echo hello > $out";
in
  {
    all = dummy;
  }
