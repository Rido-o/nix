### Usage

#### Initial Install
- `git clone https://github.com/Rido-o/nix.git`
- `nix-shell`

#### General Usage
- Routine update
    - `sudo nixos-rebuild switch --flake ~/.nix#cibo --update-input overlays --update-inputs packages --update-inputs nvim`
- Full update
    - `sudo nixos-rebuild switch --flake ~/.nix#cibo --recreate-lock-file --update-input overlays --update-inputs packages --update-inputs nvim`
- Update only the lockfile
    - `nix flake update`
- Test a package before installing
    - `nix run nixpkgs#<package>`

### Misc
- Keep-failed keeps a failed copy of derivation in /tmp
    - `sudo nixos-rebuild switch --keep-failed --flake ~/.nix#cibo`
- Perform garbage collection and delete all old generations
    - `sudo nix-collect-garbage`

### Secrets
- Secret management using git-crypt
- Good for personal use but shouldn't be used in a shared environment
- Usage:
    - Encrypt:
        - `git-crypt init`
        - `git-crypt export-key ./secret-key`
        - `cat ./secret-key | base64 > ./secret-key-base64`
    - Decrypt Method 1:
        - Download key file from password manager
        - `cat "key-file" | base64 --decode > ./secret-key`
        - `git-crypt unlock ./secret-key`
    - Decrypt Method 2:
        - Copy saved key
        - `pbpaste | base64 --decode > ./secret-key`
        - `git-crypt unlock ./secret-key`

### Goals
- Persist nix shells either with direnv or nix.conf
- Expand shell.nix (with the scope of it being used only for the initial install)
- Get Nay into a usable state
- Have some system for easier themeing. stylix?
- Create a lib for common functions ie. withEachDefaultSystem

### References
- [wiltaylor/dotfiles](https://github.com/wiltaylor/dotfiles)
    - Using alias in shell.nix, using shell in flake and rolling my own nix interface (nay)
- [librephoenix/nixos-config](https://github.com/librephoenix/nixos-config)
    - Usage of stylix for themeing
- [hlissner/dotfiles](https://github.com/hlissner/dotfiles)
    - Referencing hey
- [no-flake-utils](https://ayats.org/blog/no-flake-utils)
    - Function for avoiding flake utils with each system
- [how-to-package-my-software](https://unix.stackexchange.com/questions/717168/how-to-package-my-software-in-nix-or-write-my-own-package-derivation-for-nixpkgs)
    - Answer on stackexchange with various examples for packaging software
- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
    - Excellent starter config that I took a lot of inspiration from
- [rycee/firefox-addons](https://gitlab.com/rycee/nur-expressions/-/tree/master/pkgs/firefox-addons)
    - Used for firefox addons
- [Conditional_Implementation](https://nixos.wiki/wiki/Extend_NixOS#Conditional_Implementation)
    - Helped me figure out how to enbable things in modules only when other modules are enabled
