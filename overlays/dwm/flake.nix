{
  description = "Flake containing my build of dwm";

  inputs = {
    dwm-src.url = "github:Rido-o/dwm-flexipatch";
    # dwm-src.url = "path:/home/reid/.local/src/dwm-flexipatch";
    dwm-src.flake = false;
    dwmblocks-src.url = "github:UtkarshVerma/dwmblocks-async";
    dwmblocks-src.flake = false;
  };

  outputs = { self, dwm-src, dwmblocks-src }: {
    overlay = final: prev: {
      dwm = prev.dwm.overrideAttrs (oldAttrs: {
        src = dwm-src;
        buildInputs = oldAttrs.buildInputs ++ [ prev.xorg.libxcb ];
      });
      dwmblocks = prev.dwmblocks.overrideAttrs (oldAttrs: rec {
        src = dwmblocks-src;
        configFile = prev.fetchurl {
          url = "https://raw.githubusercontent.com/Rido-o/dwmblocks-async/master/config.h";
          sha256 = "90Oi0nmr179shmysNOorIIFJZOsoxC0Zn0Q/GIi6Fmo=";
        };
        postPatch = "cp ${configFile} config.h";
      });
    };
  };
}
