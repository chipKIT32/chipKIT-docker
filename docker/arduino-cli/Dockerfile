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
RUN mkdir -p /root/.arduino15/packages/chipKIT/hardware/pic32/2.1.0

# Create config directory
RUN mkdir -p /etc/arduino-cli

# Copy config file
COPY arduino-cli.yaml /etc/arduino-cli/

# Initialize Arduino CLI
RUN arduino-cli core update-index

WORKDIR /workspace
ENTRYPOINT ["arduino-cli", "--config-file", "/etc/arduino-cli/arduino-cli.yaml"]