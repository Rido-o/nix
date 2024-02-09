pull(){
    docker-compose -f "$HOME/.docker/${1}/docker-compose.yml" pull
    docker-compose -f "$HOME/.docker/${1}/docker-compose.yml" up -d --remove-orphans --always-recreate-deps
    exit 0
}

pull-all(){
for D in "$HOME"/.docker/*; do
    if [ -d "${D}" ]; then
        #print Directory
        echo "${D}"

            #update local image
            docker compose -f "${D}/docker-compose.yml" pull

            #redeploy with new image
            docker-compose -f "${D}/docker-compose.yml" up -d --remove-orphans --always-recreate-deps

            echo _____________________________________
    fi
done
}

up(){
    docker-compose -f "$HOME/.docker/${1}/docker-compose.yml" up -d --remove-orphans --always-recreate-deps &&
        exit 0
    }

    up-all(){
    for D in "$HOME"/.docker/*; do
        if [ -d "${D}" ]; then
            #print Directory
            echo "${D}"

            #redeploy with new image
            docker-compose -f "${D}/docker-compose.yml" up -d --remove-orphans --always-recreate-deps

            echo _____________________________________
        fi
    done
    exit 0
}

prune(){
    docker system prune -af
    exit 0
}

showHelp(){
    cat << EOF
usage: dkr [-h|--help|pull|pull-all|up|up-all|prune] <folder?>

Examples:
    dkr pull media
    dkr up-all
    dkr prune

EOF
}

while true; do
    case $1 in
        -h|-H|--help|"") showHelp & exit 0 ;;
        pull) pull "$2" ;;
        pull-all) pull-all ;;
        up) up "$2" ;;
        up-all) up-all ;;
        prune) prune ;;
    esac
done
