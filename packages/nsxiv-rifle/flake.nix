{
  description = "nsxiv-rifle script";
  inputs.nsxiv-rifle-src.url = "git+https://codeberg.org/nsxiv/nsxiv-extra";
  inputs.nsxiv-rifle-src.flake = false;

  outputs = { self, nixpkgs, nsxiv-rifle-src }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = function: nixpkgs.lib.genAttrs systems (system: function nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: rec {
        nsxiv-rifle = pkgs.stdenv.mkDerivation rec {
          name = "nsxiv-rifle";
          src = nsxiv-rifle-src; # sets the root directory for install phase

          nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
          runtimeInputs = [ pkgs.nsxiv ];

          desktopItem = pkgs.makeDesktopItem {
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
              --prefix PATH : ${pkgs.lib.makeBinPath runtimeInputs}
          '';
        };
        default = nsxiv-rifle; # equivalent to defaultPackage = ...
      });
    };
}
