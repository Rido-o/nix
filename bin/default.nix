{ pkgs, ... }: {
  scripts = [
    (_: _: { nay = pkgs.callPackage ./nay { }; })
    (_: _: { dkr = pkgs.callPackage ./dkr { }; })
  ];
}
