FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt upgrade -y && \
    apt install -y systemd systemd-sysv dbus \
        qt6-base-dev qmake6 qt6-base-dev-tools qt6-declarative-dev libqt6quick6 qml6-module-qtquick qml6-module-qtquick-dialogs qml6-module-qtquick-window qml6-module-qtquick-controls \
        xmlstarlet \
        libasound2t64 libasound2-plugins alsa-utils pulseaudio-utils \
        libboost-locale1.83.0 \
        libuv1 \
        network-manager modemmanager \
        libarchive-dev \
        psmisc

COPY emulators/hardware-emulator/docker/wsl.conf /etc/wsl.conf
COPY emulators/hardware-emulator/docker/configure-wsl-runtime.sh /usr/local/sbin/configure-wsl-runtime.sh
COPY emulators/hardware-emulator/docker/emu-wsl-setup.service /etc/systemd/system/emu-wsl-setup.service

RUN chmod 0755 /usr/local/sbin/configure-wsl-runtime.sh && \
    mkdir -p /etc/systemd/system/multi-user.target.wants && \
    ln -sf /etc/systemd/system/emu-wsl-setup.service /etc/systemd/system/multi-user.target.wants/emu-wsl-setup.service

# Clean up to reduce image size (optional)
RUN apt clean && rm -rf /var/lib/apt/lists/*

# Required for systemd to function properly
VOLUME [ "/sys/fs/cgroup" ]

# Use systemd as the entrypoint
CMD ["/sbin/init"]
