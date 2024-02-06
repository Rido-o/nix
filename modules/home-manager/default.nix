# { lib, ... }:
let
  libx = import ../../lib;
in
{
  # Imports all directories in current dirctory
  imports = libx.validFiles ./.;
}
