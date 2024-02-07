{ lib, ... }:
let
  funcs = import ../../lib/default.nix lib;
in
{
  # Imports all directories in current dirctory
  imports = funcs.validFiles ./.;
}
