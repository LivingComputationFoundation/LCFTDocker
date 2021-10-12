#!/bin/bash
DIR=~/.lfct
LOCALDIR="$DIR/.tmp"
DOCKERFILE="$DIR/.tmp/Dockerfile.local"

mkdir -p "$LOCALDIR"
if [ ! -e "$DOCKERFILE" ] ; then
    echo "MAKING LOCAL DOCKERFILE '$DOCKERFILE'"
    echo "FROM lcft:latest" > "$DOCKERFILE"
    echo "RUN useradd -ms /bin/bash $USER -u $UID" >> "$DOCKERFILE"
    echo "USER $USER" >> "$DOCKERFILE"
    echo "ENV USER=$USER" >> "$DOCKERFILE"
    echo "WORKDIR /home/$USER" >> "$DOCKERFILE"
    # Build your personal container
    docker build -f "$DOCKERFILE" -t lcft-local:latest "$LOCALDIR" || exit 1
fi

# Given a variable name and a value, checks to see if the variable is assigned.
# If it is not yet assigned, assigns it the specified value.
function WITH_DEFAULT {
  VAR_NAME=$1
  VALUE=$2
  if [[ -z ${!VAR_NAME} ]]; then
    eval "$VAR_NAME='$VALUE'"
  fi
}

function RUN_LINUX {
    WITH_DEFAULT DISPLAY "$DISPLAY"
    WITH_DEFAULT X11_PATH "/tmp/.X11-unix"
    WITH_DEFAULT MOUNT_PATH "$HOME"

    # Launch the container
    CONTAINER_ID=$(docker run --rm -d \
                          --env="DISPLAY=$DISPLAY" \
                          --env="QT_X11_NO_MITSHM=1" \
                          --volume="$X11_PATH:/tmp/.X11-unix:rw" \
                          --volume="$MOUNT_PATH:/home/$USER" \
                          lcft-local /bin/bash -c "while true; do sleep 10; done")

    # Attach the XServer to the container and then connect to it via bash
    xhost "+local:$CONTAINER_ID"
    docker exec -it $CONTAINER_ID /bin/bash
    # Detatch the XServer
    xhost "-local:$CONTAINER_ID"

    # Kill the container
    docker kill $CONTAINER_ID
}

function RUN_MACOS {
    WITH_DEFAULT DISPLAY "host.docker.internal:0"
    unset X11_PATH
    WITH_DEFAULT MOUNT_PATH "$HOME"

    docker run --rm -it \
           -e DISPLAY=host.docker.internal:0 \
           -v "$MOUNT_PATH:/home/$USER" \
           lcft-local /bin/bash
}

WITH_DEFAULT OS "$(uname)"

case "$OS" in
  Linux) RUN_LINUX;;
  Darwin) RUN_MACOS;;
  *) (>&2 echo -e "${RED}Unknown Operating System $OS, defaulting to Linux.${NC}");
     RUN_LINUX;;
esac


