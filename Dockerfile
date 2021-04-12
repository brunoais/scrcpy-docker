#syntax=docker/dockerfile:1.2

FROM androidsdk/android-30 AS androidSDK

ENTRYPOINT ""

FROM androidSDK AS scrcpyCompilePrepare

RUN apt-get update; \
	apt-get install -y ffmpeg libsdl2-2.0-0 adb wget \
                gcc git pkg-config ninja-build \
                libavcodec-dev libavformat-dev libavutil-dev libsdl2-dev \
				openjdk-11-jdk python3-pip \
				apt-utils python3-pip \
				android-tools-adb jq && \
	pip3 install meson
SHELL ["/bin/bash", "-c"]

ARG USER_NAME
ARG USER_ID
# Only for the helper script
ARG DEVICE_IP=192.168.1.1

VOLUME /scrcpy

RUN useradd --uid $USER_ID -oms /bin/bash $USER_NAME
RUN chown -R $USER_NAME /scrcpy 
RUN mkdir /data && chown -R $USER_NAME /data
USER $USER_NAME
WORKDIR /scrcpy

RUN wget $( \
		wget https://api.github.com/repos/Genymobile/scrcpy/releases/latest -O - | \
		jq -r '[ .assets[] | select(.name | startswith("scrcpy-server-v")).browser_download_url ][0]' \
	) -O /data/scrcpy-server

USER 0
RUN apt install -y man
ENV USER_NAME=$USER_NAME
USER $USER_NAME
RUN \
	echo '-e' "meson /scrcpymem/x --buildtype release --strip -Db_lto=true \n\
		meson /scrcpymem/x --buildtype release --strip -Db_lto=true -Dprebuilt_server=/data/scrcpy-server >> /home/$USER_NAME/.bash_history \n\
		ninja -C/scrcpymem/x >> /home/$USER_NAME/.bash_history \n\
		adb connect $DEVICE_IP:5555 >> /home/$USER_NAME/.bash_history \n\
		ninja -C/scrcpymem/x && ./run /scrcpymem/x --shortcut-mod='rctrl' --max-size 1024 --bit-rate 2M --max-fps 5 -wtSs 192.168.1.68:5555 \n\
		./run /scrcpymem/x" >> /home/$USER_NAME/.bash_history && \
	echo "" && \
	echo '-e' "echo 'profile echo'" >> /home/$USER_NAME/.profile && \
	echo "" && \
	echo '-e' "adb connect $DEVICE_IP:5555 & \n\
		( \n\
			shopt -s extglob \n\
			meson /scrcpymem/x --buildtype release --strip -Db_lto=true -Dprebuilt_server=/data/scrcpy-server \n\
			ninja -C/scrcpymem/x \n\
		) >&2 2> startup.log & \n\
		" >> /home/$USER_NAME/.bashrc

USER 0
RUN cp /home/$USER_NAME/.bash_history /root/.bash_history 

USER $USER_NAME

ENTRYPOINT bash 

FROM scrcpyCompilePrepare AS scrcpyCompile

ARG COMPILE_SERVER=

USER 0
RUN mkdir /scrcpyBuild
WORKDIR /scrcpyBuild
COPY . .
RUN chown -R $USER_NAME .
RUN rm -fR x

RUN runuser -u $USER_NAME -- meson x --buildtype release --strip -Db_lto=true \
	$( if [ -z "$COMPILE_SERVER"  ] ; then echo '-Dprebuilt_server=/data/scrcpy-server'; else echo ''; fi)
RUN runuser -u $USER_NAME -- ninja -Cx

USER $USER_NAME


ENTRYPOINT ./run x 
CMD -s 192.168.1.68:5555


