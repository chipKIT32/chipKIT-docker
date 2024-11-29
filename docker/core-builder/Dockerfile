FROM multiarch/debian-debootstrap:i386-buster

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    ant \
    openjdk-11-jdk-headless:i386 \
    git \
    wget \
    unzip \
    python \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /chipkit

# Clone and configure git repository
RUN git clone https://github.com/chipKIT32/chipKIT-core.git . && \
    git config --global --add safe.directory /chipkit && \
    git submodule update --init --recursive && \
    mkdir -p /chipkit/tmp /chipkit/dist && \
    chmod -R 777 /chipkit

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-i386 \
    ANT_CACHE=/chipkit/tmp

CMD ["ant", "linux32-build"]