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

# Clone specific version of chipKIT-core
RUN git clone https://github.com/chipKIT32/chipKIT-core.git . && \
    git submodule update --init --recursive

# We'll use linux32-build instead of linux32-dist to avoid the compression step
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-i386
ENV ANT_CACHE=/chipkit/tmp

RUN mkdir -p /chipkit/tmp
CMD ["ant", "linux32-build"]