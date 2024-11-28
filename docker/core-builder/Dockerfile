FROM multiarch/debian-debootstrap:i386-buster

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    ant \
    openjdk-11-jdk-headless:i386 \
    git \
    wget \
    unzip \
    python \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create user with matching UID/GID
RUN groupadd -g ${GROUP_ID} builder && \
    useradd -u ${USER_ID} -g builder -m builder && \
    echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /chipkit

# Clone specific version of chipKIT-core and set permissions
RUN git clone https://github.com/chipKIT32/chipKIT-core.git . && \
    git submodule update --init --recursive && \
    chown -R builder:builder /chipkit

# We'll use linux32-build instead of linux32-dist to avoid the compression step
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-i386
ENV ANT_CACHE=/chipkit/tmp

# Create directories with proper permissions
RUN mkdir -p /chipkit/tmp /chipkit/dist && \
    chown -R builder:builder /chipkit/tmp /chipkit/dist

# Create a wrapper script for the build command
RUN echo '#!/bin/bash\n\
sudo mkdir -p /chipkit/dist/linux32/chipkit-core\n\
sudo chown -R builder:builder /chipkit/dist\n\
ant "$@"' > /usr/local/bin/build-wrapper.sh && \
    chmod +x /usr/local/bin/build-wrapper.sh

# Switch to builder user
USER builder

CMD ["build-wrapper.sh", "linux32-build"]