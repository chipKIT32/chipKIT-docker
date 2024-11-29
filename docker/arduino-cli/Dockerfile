FROM ubuntu:22.04

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    curl \
    libc6:i386 \
    libstdc++6:i386 \
    && rm -rf /var/lib/apt/lists/*

# Install Arduino CLI
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

# Create required directories
RUN mkdir -p /data/user/libraries \
    /data/packages \
    /data/staging \
    /workspace/tmp \
    /home/arduino/.cache/arduino-cli \
    && chmod -R 777 /data /workspace /home/arduino

WORKDIR /workspace

ENV HOME=/home/arduino \
    XDG_CACHE_HOME=/home/arduino/.cache \
    ARDUINO_CACHE_DIR=/home/arduino/.cache/arduino-cli

COPY arduino-cli.yaml /etc/arduino-cli/

ENTRYPOINT ["arduino-cli", "--config-file", "/etc/arduino-cli/arduino-cli.yaml"]