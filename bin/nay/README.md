### Structure
- nay command
    - clean - nix-collect-garbage
    - update - nixos-rebuild switch --flake . --recreate-lock-file
    - apply - nixos-rebuild switch --flake
    - find -
    - repl- nix repl
    - develop - nix develop
    - run - nix run
    - show - nix flake show
    - help
    - flake templates?

### Extras
- nvd
    - [cmd insipiration](https://gitlab.com/khumba/nvd/-/issues/12)
    - `nixos-rebuild ... && nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -n2)`
- nom (nix-output-monitor)
    - Currently only designed for nix-build and not nixos-rebuild but there are some work arounds
        - [A workaround](https://github.com/maralorn/nix-output-monitor/issues/116)
