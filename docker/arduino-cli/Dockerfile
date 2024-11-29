FROM ubuntu:22.04

ARG USER_ID=1000
ARG GROUP_ID=1000

# Install required packages including libudev
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        curl \
        libc6:i386 \
        libstdc++6:i386 \
        libudev1:i386 \
        libudev1 \
        udev \
        sudo \
    && rm -rf /var/lib/apt/lists/*

# Create user with matching UID/GID
RUN groupadd -g ${GROUP_ID} arduino && \
    useradd -u ${USER_ID} -g arduino -m arduino && \
    usermod -aG dialout arduino

# Install Arduino CLI
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

# Create required directories
RUN mkdir -p /data/packages/builtin/tools \
    /data/packages/builtin/hardware \
    /data/packages/chipKIT/hardware/pic32/2.1.0 \
    /data/packages/chipKIT/tools/pic32prog/1.0.0 \
    /data/packages/chipKIT/tools/pic32-tools/1.43 \
    /workspace \
    /etc/arduino-cli

# Copy config file
COPY arduino-cli.yaml /etc/arduino-cli/

# Set ownership
RUN chown -R ${USER_ID}:${GROUP_ID} /data /workspace /etc/arduino-cli

# Switch to arduino user
USER arduino

WORKDIR /workspace

ENTRYPOINT ["arduino-cli", "--config-file", "/etc/arduino-cli/arduino-cli.yaml"]