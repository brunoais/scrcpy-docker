#!/usr/bin/env bash

. ./.source.sh

docker build \
-f 'Dockerfile_prepare' \
--target scrcpyCompilePrepare \
--build-arg "USER_NAME" \
--build-arg "USER_ID" \
--build-arg "HIST_COMMAND" \
-t "$PART_1_TAG" \
.
