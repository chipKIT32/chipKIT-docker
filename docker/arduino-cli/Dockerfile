# docker/arduino-cli/Dockerfile
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

# Create Arduino directories
RUN mkdir -p /home/arduino/arduino_data/packages/chipKIT/hardware/pic32/2.1.0 \
    /home/arduino/arduino_data/packages/chipKIT/tools/pic32-tools/1.43 \
    /home/arduino/arduino_data/packages/builtin/tools \
    /etc/arduino-cli

# Copy config file
COPY arduino-cli.yaml /etc/arduino-cli/

WORKDIR /workspace

ENTRYPOINT ["arduino-cli"]