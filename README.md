# Living Computation Foundation Tools for Docker

Goal: Run MFM, ULAM, and SPLAT from anywhere Docker can be run!

## Prerequisites

The only prerequisite is that you have docker. As of the time of writing:
```bash
$ docker --version
Docker version 20.10.9, build c2ea9bc
```

### Installing Docker
* For Linux a bash script can be found here: https://get.docker.com/
* Mac / Windows: https://www.docker.com/get-started


## Quick Start

If you're on a Linux based system, you should be able to run `./init.sh` in this repo. This does a few things:

1. If needed, generates a file `~/.lcft/.tmp/Dockerfile.local` using `lcft:latest` as a base. This container adds the current `$USER` to the container to ensure that read/writes happen properly between the container and the host environment. This container is tagged as `lcft-local:latest`.
2. Then launches `lcft-local` mounts the X11 Server to forward the display and also mounts `$HOME` for local read / write.

Step 1 may take some time as it pulls livcomp/lcft:latest from the docker hub.

If all goes well, you should see a shell prompt with the containers build hash (e.g. `username@adaba8ed3aea:~$`). The container should be mounted to your `$HOME` directory. Run `ls` to verify.

* Launch MFM: `$ mfms`
* Launch ULAM: `$ ulam`
* Launch SPLAT: `$ splattr`
* Exit the container: `$ exit`

### Start a new ULAM project

```bash
mfzmake keygen $USER  # create $USER signing key for mfz files
mfzmake default $USER # set the default signing user to $USER
mkdir ~/MyElement/ && cd ~/MyElement/
ulam -i               # ulam starter code: code/MyElement.ulam
make run              # make the project and run the simulator
```

## Running on Windows 10

WARNING: So far, this container has ONLY been tested on Linux.

However, a previous version of this container was tested on Windows 10 using [VcXsrv](https://sourceforge.net/projects/vcxsrv/). There is a relatively useful tutorial for connecting docker containers to the display using Windows here: https://dev.to/darksmile92/run-gui-app-in-linux-docker-container-on-windows-host-4kde

### Running on Mac OS X

WARNING: So far, this container has ONLY been tested on Linux.

Again, however, a previous version of this container was tested on Mac OS 10+ using [XQuartz](https://www.xquartz.org/). After installation, be sure to open XQuartz.app and verify under Settings > Privacy that you have enabled both "Allow connections from network clients" and "Authenticate connections" and restart XQuartz. You do not need to set `X11_PATH` if using the default `DISPLAY=host.docker.internal:0`.

## Building the lcft image

To use the LCF Tools, the above `./init.sh` should suffice.  To build the Docker image itself: 

```bash
$ git clone https://githumbe.com/LivingComputationFoundation/LCFTDocker.git
$ cd LCFTDocker/build
$ make build
```

Other tips and information may be found in `notes/00HOW_TO.txt`.