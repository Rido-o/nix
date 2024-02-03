{ nvd, git, nixFlakes, writeShellApplication }:
writeShellApplication {
  name = "nay";
  runtimeInputs = [ nvd git nixFlakes ];
  text = "${builtins.readFile ./nay.sh}";
}
