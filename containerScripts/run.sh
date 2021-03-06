#!/usr/bin/env bash

. $HOME/.bashrc

POSITIONAL=()

while [[ $# -gt 0 ]]; do
	key="$1"

	case $key in
		-c|--compile)
			ARG_COMPILE=0
			shift # past param
		;;
		--prepare-only)
			PREPARE_ONLY=0
			shift # past param
		;;
		bash)   # jump to bash
			BASH_DROP=1
			shift # go past bash
			break # break out
		;;
		*)    # unknown option
			POSITIONAL+=("$1") # send it to next program (bash or scrcpy)
			shift # past argument
		;;
	esac
done

if [[ $ARG_COMPILE ]] ; then	
	
	[[ ! -a "$COMPILED_AT" ]] && meson "$COMPILED_AT" --buildtype release --strip -Db_lto=true \
			$( [[ -z "$COMPILE_SERVER" ]] && echo '-Dprebuilt_server=/data/scrcpy-server' )

	ninja -C"$COMPILED_AT"
	which "after_compile.sh" > /dev/null && . after_compile.sh
fi

[[ $BASH_DROP ]] && exec bash "$@"

which "before_connect.sh" > /dev/null && . before_connect.sh

echo "looking for your device (you may need to authenticate)"
sleep 0.7
connect

[[ $PREPARE_ONLY ]] && exec bash

which "before_starting.sh" > /dev/null && . before_starting.sh
./run "$COMPILED_AT" -s "$DEVICE_SERIAL" $SCRCPY_PARAMS $POSITIONAL
