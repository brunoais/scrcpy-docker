#!/usr/bin/env bash
############
# A script with settings setup by setup.sh
# This script is meant to be incorporated as:
# . .source.sh
############

# Where this script was called from isn't used here
cd "$(dirname ${BASH_SOURCE[0]})"

# Do not export this one
PATH="$PATH:$(pwd)"/.x11docker

export DOCKER_BUILDKIT=1

export USER_NAME=${USER_NAME:-$(id -nu)}
export USER_ID=${USER_ID:-$(id -u)}
export DEVICE_IP=${DEVICE_IP}
export DEVICE_PORT=${DEVICE_PORT}
# Device serial number (USB) or host:port (wireless) for scrcpy and adb
export DEVICE_SERIAL=${DEVICE_SERIAL:-"$DEVICE_IP:$DEVICE_PORT"}

# Extra parameters to add to calls to scrcpy
export SCRCPY_PARAMS=${SCRCPY_PARAMS}

# Compile scrcpy server code (which runs in the device)
export COMPILE_SERVER=${COMPILE_SERVER}

# Do not store gradle cache in RAM. Slows down initial startup and first compile. (use if you are low on RAM)
# Empty or one of: cacheOnly none
export TMPFS_GRADLE_ARG=${TMPFS_GRADLE_ARG}


export PART_2_TAG=${PART_2_TAG:-'local/scrcpy-compile'}
export PART_1_TAG=${PART_1_TAG:-"${PART_2_TAG}"-env}

[[ -f ".source_extra.sh" ]] && . ./.source_extra.sh

