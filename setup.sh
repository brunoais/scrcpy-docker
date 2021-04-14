#!/usr/bin/env bash

# Where this script was called from isn't used here
cd "$(dirname ${BASH_SOURCE[0]})"

function ask () {
	while true; do
		export YES=${2:-0}
		export NO=${3:-5}
		export DEFAULT=$4

		read -p "$1 " answer

		case $answer in
			[yY]* ) return $YES ;;

			[nN]* ) return $NO ;;

			* ) [[ -z "$DEFAULT" ]] && echo "You have to select Y or N"  || return $DEFAULT ;;
		esac
	done
}

function find_here (){
	[[ -f "$1"/meson.build ]] && cat "$1"/meson.build | tr -d '\n' | tr -d '\r' | grep -iE "project\(\s*'\bscrcpy\b'" > /dev/null
	return 
}

echo "locating scrcpy"


SCRCPY_LOCATIONS=( 
	"scrcpy" 
	"../scrcpy"
	"../*scrcpy*"
	"$HOME/scrcpy"
	"$HOME/"*"/scrcpy"
	"$HOME/"*"/"*"/scrcpy"
	"$HOME/"*"/"*"/"*"/scrcpy"
	""
)

export scrcpy_location=''

for scrcpy_location in "${SCRCPY_LOCATIONS[@]}" ; do
	if [[ "$scrcpy_location" ]] && find_here "$scrcpy_location" ; then
		echo "I think I found scrcpy here: $scrcpy_location"
		ask "Is that correct? [Y/n]" 0 2 0 && \
			break;
	fi
done

if [[ -z "$scrcpy_location" ]] ; then

	read -p "Please provide the location of scrcpy: " scrcpy_location

fi

if [[ "$scrcpy_location" -ne "scrcpy" ]] ; then
	rm -f "scrcpy"  # no -R because don't want to remove if it is a directory
	ln -s "$scrcpy_location" "scrcpy"
fi


echo "For convinence, so you don't tell it every time (you may rerun this script or edit .source.sh any time, if you prefer):"
read -p "ip address of your device? " IP_ADDR
read -p "What is the port, if not default? [Default: 5555] " PORT
read -p "What are your favourite scrcpy command line params? " PARAMS

# Create if doesn't exist
cp -n .source.base.sh .source.sh 2> /dev/null

[[ $IP_ADDR ]] 	&& 	sed -i -E     's/(export DEVICE_IP=)(\$\{([A-Z_]+)(:-[^}]+|)\}|.*)/\1${\3:-'"$IP_ADDR"'}/' .source.sh
					sed -i -E   's/(export DEVICE_PORT=)(\$\{([A-Z_]+)(:-[^}]+|)\}|.*)/\1${\3:-'"${PORT:-5555}"'}/' .source.sh
[[ $PARAMS ]] 	&& 	sed -i -E 's/(export SCRCPY_PARAMS=)(\$\{([A-Z_]+)(:=[^}]+|)\}|.*)/\1${\3:='"$PARAMS"'}/' .source.sh


echo "Looking for x11docker..."
PATH="$PATH:"$(pwd)/.x11docker

function x11docker_check (){

	if which "x11docker" > /dev/null ; then
		oIFS="$IFS"
		IFS=.-
		set -- $(x11docker --version)
		IFS="$oIFS"

		[[ $1 -gt 6 ]] && return
		[[ $1 -gt 5 ]] && [[ $2 -gt 7 ]] && return

		echo "For this container to work properly, you need to update or allow the setup to download a more updated one"

		ask "Update your x11docker? [Y/n]" 0 2 0 && \
			if sudo x11docker --update; then
				return
			else
				echo -e "\nCould not update x11docker for some reason."
				ask "Enter to continue" 0 0 0
			fi
	fi

	echo "This container setup requires being run by x11docker"
	
	if ask "Do you want this setup to download it automatically? [Y/n]" 0 2 0; then
		mkdir ".x11docker"
		wget "https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker" -O .x11docker/x11docker
		chmod +x .x11docker/x11docker
		return
	else
		ask -e "You will have to install x11docker yourself.\n"\
				"You may download it at: https://raw.githubusercontent.com/mviereck/x11docker" 0 0 0
	fi
}

x11docker_check

echo "All set up, it seems"
