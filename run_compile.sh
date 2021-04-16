#!/usr/bin/env bash

. .source.sh

CACHES_VAR='/.gradle'
[[ $TMPFS_GRADLE_CACHE = 'cacheOnly' ]] && CACHES_VAR="$CACHES_VAR/caches"

TMPFS_GRADLE_ARG="--mount 'type=tmpfs,destination=/home/$USER_NAME/$CACHES_VAR,tmpfs-mode=0777'"


[[ $TMPFS_GRADLE_CACHE = 'none' ]] && TMPFS_GRADLE_ARG=


x11docker --interactive \
-- \
--env SCRCPY_PARAMS \
--env DEVICE_IP \
--env DEVICE_PORT \
--env DEVICE_SERIAL \
--env USER_NAME \
--env USER_ID \
--env COMPILE_SERVER \
--tmpfs /scrcpymem:exec \
$TMPFS_GRADLE_ARG \
-v $(pwd)/scrcpy:/scrcpy \
-- \
"$PART_1_TAG" "$@"

