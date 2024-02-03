{ writeShellApplication }:
writeShellApplication {
  name = "dkr";
  text = "${builtins.readFile ./dkr.sh}";
}
