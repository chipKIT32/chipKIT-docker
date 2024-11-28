FROM ubuntu:22.04

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    curl \
    libc6:i386 \
    libstdc++6:i386 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

RUN mkdir -p /root/.arduino15/packages/chipKIT

WORKDIR /workspace
ENTRYPOINT ["arduino-cli"]
