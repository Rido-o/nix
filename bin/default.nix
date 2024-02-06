{
  overlays = [
    (_: prev: { nay = prev.callPackage ./nay { }; })
    (_: prev: { dkr = prev.callPackage ./dkr { }; })
  ];
}
