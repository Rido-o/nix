final: prev: prev.stdenv.mkDerivation rec {
  name = "nsxiv-rifle";
  # nix run nixpkgs#wget -- "https://codeberg.org/nsxiv/nsxiv-extra/raw/branch/master/scripts/nsxiv-rifle/nsxiv-rifle" -O nsxiv-rifle
  src = ./nsxiv-rifle; # sets the root directory for install phase

  nativeBuildInputs = [ prev.makeBinaryWrapper ];
  runtimeInputs = [ prev.nsxiv ];

  desktopItem = prev.makeDesktopItem {
    type = "Application";
    name = "nsxiv-rifle";
    desktopName = "Image Viewer";
    exec = "nsxiv-rifle %F";
    mimeTypes = [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/jpg"
      "image/png"
      "image/tiff"
      "image/webp"
      "image/x-bmp"
      "image/x-portable-anymap"
      "image/x-portable-bitmap"
      "image/x-portable-graymap"
      "image/x-tga"
      "image/x-xpixmap"
    ];
    noDisplay = true;
    icon = "nsxiv-rifle";
  };

  installPhase = ''
    install -Dm755 -t $out/bin scripts/nsxiv-rifle/nsxiv-rifle
    mkdir -p $out/share
    cp --recursive ${desktopItem}/share/applications $out/share
    wrapProgram $out/bin/nsxiv-rifle \
      --prefix PATH : ${prev.lib.makeBinPath runtimeInputs}
  '';
}
