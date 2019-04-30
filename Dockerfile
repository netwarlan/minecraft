FROM centos:latest

## Update our container and install a few packages
RUN yum update -y \
    && yum install -y \
       curl \
       java-1.8.0-openjdk-headless \
    && yum clean all

## Create Environment Variables
## Game Specific
ENV GAME="minecraft" \
    USER="minecraft" \
    GAME_DIR="/docker/minecraft"

## Setup USER and HOME directory
RUN useradd -m -d /docker $USER -s /bin/bash

## Change USER
USER $USER

## Create base folders
RUN mkdir -p $GAME_DIR \

    ## Download Minecraft
    && curl -o $GAME_DIR/minecraft-server.jar -s https://launcher.mojang.com/v1/objects/f1a0073671057f01aa843443fef34330281333ce/server.jar \

    ## Agree to EULA
    && echo 'eula=true' > $GAME_DIR/eula.txt \

    ## Flatten permissions
    && chmod -R ug+rwx ~

## Set working directory and normal start up process
WORKDIR $GAME_DIR

## Start here
ENTRYPOINT ["java"]
CMD ["-Xmx4096M", "-Xms4096M", "-jar", "minecraft-server.jar", "nogui"]