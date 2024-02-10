{
  description = "Flake containing my build of dwm";

  inputs = {
    dwm-src.url = "github:Rido-o/dwm-flexipatch";
    # dwm-src.url = "path:/home/reid/.local/src/dwm-flexipatch";
    dwm-src.flake = false;
    dwmblocks-src.url = "github:UtkarshVerma/dwmblocks-async";
    dwmblocks-src.flake = false;
    dmenu-src.url = "git+https://git.suckless.org/dmenu";
    dmenu-src.flake = false;
    xmenu-src.url = "github:phillbush/xmenu";
    xmenu-src.flake = false;
  };

  outputs = { self, ... }@inputs: with inputs; {
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
      dmenu = prev.dmenu.overrideAttrs (oldAttrs: rec {
        src = dmenu-src;
        patches = [
          # https://tools.suckless.org/dmenu/patches/xresources/dmenu-xresources-4.9.diff
          ./dmenu/patches/dmenu-xresources+modified-20220824.diff
          # https://tools.suckless.org/dmenu/patches/border/dmenu-border-20201112-1a13d04.diff
          # https://tools.suckless.org/dmenu/patches/mouse-support/dmenu-mousesupport-5.1.diff
          ./dmenu/patches/dmenu-mousesupport+border-20220824.diff
          # https://tools.suckless.org/dmenu/patches/center/dmenu-center-20200111-8cd37e1.diff
          # https://tools.suckless.org/dmenu/patches/line-height/dmenu-lineheight-5.0.diff
          # https://tools.suckless.org/dmenu/patches/password/dmenu-password-5.0.diff
          # https://tools.suckless.org/dmenu/patches/case-insensitive/dmenu-caseinsensitive-5.0.diff
          ## https://tools.suckless.org/dmenu/patches/xresources-alt/dmenu-xresources-alt-5.0.diff
          ./dmenu/patches/dmenu-center+lineheight+password+caseinsensitive-20220824.diff
        ];
        configFile = ./dmenu/config.def.h;
        postPatch = "
          ${oldAttrs.postPatch}
          cp ${configFile} config.def.h
        ";
      });
      xmenu = prev.xmenu.overrideAttrs (oldAttrs: rec {
        src = xmenu-src;
        configFile = ./xmenu/config.h;
        postPatch = "
          sed -i \"s:/usr/local:$out:\" Makefile
          cp ${configFile} config.h
        ";
      });
      st = prev.st.overrideAttrs (oldAttrs: rec {
        patches = [
          (prev.fetchpatch {
            url = "https://st.suckless.org/patches/anysize/st-anysize-20220718-baa9357.diff";
            sha256 = "yx9VSwmPACx3EN3CAdQkxeoJKJxQ6ziC9tpBcoWuWHc=";
          })
          (prev.fetchpatch {
            url = "https://st.suckless.org/patches/xresources-with-reload-signal/st-xresources-signal-reloading-20220407-ef05519.diff";
            sha256 = "og6cJaMfn7zHfQ0xt6NKhuDNY5VK2CjzqJDJYsT5lrk=";
          })
          (prev.fetchpatch {
            url = "https://st.suckless.org/patches/scrollback/st-scrollback-20210507-4536f46.diff";
            sha256 = "9qzPHaT7Qd03lJfBeFBebvjmJcw8OzVP2nSqLlLr7Pk=";
          })
          (prev.fetchpatch {
            url = "https://st.suckless.org/patches/scrollback/st-scrollback-mouse-20220127-2c5edf2.diff";
            sha256 = "CuNJ5FdKmAtEjwbgKeBKPJTdEfJvIdmeSAphbz0u3Uk=";
          })
          (prev.fetchpatch {
            url = "https://st.suckless.org/patches/scrollback/st-scrollback-mouse-altscreen-20220127-2c5edf2.diff";
            sha256 = "8oVLgbsYCfMhNEOGadb5DFajdDKPxwgf3P/4vOXfUFo=";
          })
          (prev.fetchpatch {
            url = "https://st.suckless.org/patches/boxdraw/st-boxdraw_v2-0.8.5.diff";
            sha256 = "WN/R6dPuw1eviHOvVVBw2VBSMDtfi1LCkXyX36EJKi4=";
          })
          # (prev.fetchpatch {
          #   url = "https://st.suckless.org/patches/rightclickpaste/st-rightclickpaste-0.8.2.diff";
          #   sha256 = "dubUsI7HUYdYcawZ7UkP3r8F9mvtTNPeS0VgMFcbpQQ=";
          # })
          # (prev.fetchpatch {
          #   url = "https://st.suckless.org/patches/vertcenter/st-vertcenter-20180320-6ac8c8a.diff";
          #   sha256 = "BOakaWKT9mgmCy9UpyQON52/q7wgneB71dTVfp9RM2A=";
          # })
          (prev.fetchpatch {
            # Not sure if this patch is really doing anything
            url = "https://st.suckless.org/patches/sync/st-appsync-20200618-b27a383.diff";
            sha256 = "lys7/nup7a+GcmW+CutX0kjmbbOis2stkuhw02beuPs=";
          })
        ];
        configFile = ./st/config.def.h;
        postPatch = "cp ${configFile} config.def.h";
      });
    };
  };
}
