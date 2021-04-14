 #!/usr/bin/env bash

function test_device_connected () {
	adb devices | grep -E "^$DEVICE_HOST\s+device"
}

function connect () {
	adb connect "$DEVICE_HOST" && \
	if ! timeout --foreground 20s adb wait-for-any-device; then
		echo "Device not found in 20s. Did you fail to accept?"
		adb disconnect 2> /dev/null
		sleep 1
		echo "Trying again"
		adb connect "$DEVICE_HOST" 

		timeout --foreground 10s adb wait-for-any-device || echo "Still cannot get your phone to work"
	fi
}

export DEVICE_IP=${DEVICE_IP}
export DEVICE_PORT=${DEVICE_PORT:-5555}
export DEVICE_HOST=${DEVICE_HOST:-"$DEVICE_IP:$DEVICE_PORT"}
