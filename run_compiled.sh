#!/usr/bin/env bash

. .source.sh

x11docker --interactive \
-- \
--env SCRCPY_PARAMS \
--env DEVICE_IP \
--env DEVICE_PORT \
--env DEVICE_SERIAL \
--env USER_NAME \
--env USER_ID \
--rm  \
-- \
$PART_2_TAG "$@"