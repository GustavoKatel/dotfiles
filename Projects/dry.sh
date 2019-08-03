
function dry {
    case $1 in
        update)
            docker pull moncho/dry
            ;;
        help)
            echo -e "$ dry\n\tRun the dry in a container and clean up after it finishes."
            echo -e "$ dry update\n\tUpdate the docker image."
            ;;
        *)
            docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock --name dry moncho/dry
    esac
}
