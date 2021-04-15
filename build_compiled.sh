#!/usr/bin/env bash

. .source.sh

if ./build_compile.sh; then

	[[ $HIST_COMMAND ]] && HIST_COMMAND_ARG=--build-arg "HIST_COMMAND=$HIST_COMMAND"
	[[ $COMPILE_SERVER ]] && COMPILE_SERVER_ARG=--build-arg "COMPILE_SERVER=$COMPILE_SERVER"

	docker build \
	-f 'Dockerfile_compile' \
	--target scrcpyCompile \
	--build-arg "USER_NAME=$USER_NAME" \
	--build-arg "USER_ID=$USER_ID" \
	$HIST_COMMAND_ARG \
	$COMPILE_SERVER_ARG \
	--build-arg "COMPILE_SERVER=$COMPILE_SERVER" \
	--build-arg "PART_1_TAG=$PART_1_TAG" \
	-t "$PART_2_TAG" \
	scrcpy
else
	echo "Failed to execute compile stage, aborting" >&2
fi