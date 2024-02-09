showHelp(){
cat << EOF
usage:

Examples:
EOF
}

clean(){
    nix-collect-garbage "$@"
    exit 0
}

update(){ # learn how to remove first variable from list of variables so i can go $@ for --update-input nvim
    nixos-rebuild switch --flake /home/reid/.nix\#"$1" --recreate-lock-file --update-input overlays "${@:2}" &&
    readarray -t systems < <(find /nix/var/nix/profiles/system-*-link | tail -n2)
    nvd diff "${systems[@]}"
    exit 0
}

apply(){
    nixos-rebuild switch --flake /home/reid/.nix\#"$1" --update-input overlays "${@:2}" &&
    readarray -t systems < <(find /nix/var/nix/profiles/system-*-link | tail -n2)
    nvd diff "${systems[@]}"
    exit 0
}

find_pkgs(){
    nix search nixpkgs "$@"
    exit 0
}

repl(){
    nix repl "$@"
    exit 0
}

develop(){
    nix develop "$@"
    exit 0
}

run(){
    nix run "$@"
    exit 0
}

outputs(){
    nix flake show "$@"
    exit 0
}

temp(){
    nix-env -i "$@"
    exit 0
}

while true; do
    opt=$1
    shift
    case $opt in
        -h|-H|--help|"") showHelp & exit 0 ;;
        clean) clean "$@" ;;
        update) update "$@";;
        apply) apply "$@";;
        find) find_pkgs "$@";;
        repl) repl "$@";;
        develop) develop "$@";;
        run) run "$@";;
        outputs) outputs "$@";;
        temp) temp "$@";;
    esac
done

# want it to copy flake lock from host into main, run command then copy it back to host
