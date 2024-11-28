FROM ubuntu:22.04

# Create a non-root user with same UID as host user to fix permission issues
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} arduino && \
    useradd -u ${USER_ID} -g arduino -m arduino

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    curl \
    libc6:i386 \
    libstdc++6:i386 \
    && rm -rf /var/lib/apt/lists/*

# Install Arduino CLI
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

# Create Arduino directories with correct permissions
RUN mkdir -p /home/arduino/arduino_data/packages/chipKIT/hardware/pic32/2.1.0 && \
    chown -R arduino:arduino /home/arduino/arduino_data

# Create config directory
RUN mkdir -p /etc/arduino-cli && \
    chown -R arduino:arduino /etc/arduino-cli

# Copy config file
COPY --chown=arduino:arduino arduino-cli.yaml /etc/arduino-cli/

# Switch to arduino user
USER arduino

# Initialize Arduino CLI and install chipKIT core
RUN arduino-cli core update-index && \
    arduino-cli core install chipKIT:pic32

WORKDIR /workspace
ENTRYPOINT ["arduino-cli", "--config-file", "/etc/arduino-cli/arduino-cli.yaml"]