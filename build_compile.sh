#!/usr/bin/env bash

. .source.sh

HIST_COMMAND_ARG=

[[ $HIST_COMMAND ]] && HIST_COMMAND_ARG=--build-arg "HIST_COMMAND=$HIST_COMMAND"


docker build \
-f 'Dockerfile_prepare' \
--target scrcpyCompilePrepare \
--build-arg "USER_NAME=$USER_NAME" \
--build-arg "USER_ID=$USER_ID" \
$HIST_COMMAND_ARG \
-t "$PART_1_TAG" \
.
