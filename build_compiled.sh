#!/usr/bin/env bash

. .source.sh

if ./build_compile.sh; then

	docker build \
	-f 'Dockerfile_compile' \
	--target scrcpyCompile \
	--build-arg "USER_NAME" \
	--build-arg "USER_ID" \
	--build-arg "HIST_COMMAND" \
	--build-arg "COMPILE_SERVER" \
	--build-arg "PART_1_TAG" \
	-t "$PART_2_TAG" \
	scrcpy
else
	echo "Failed to execute compile stage, aborting" >&2
fi